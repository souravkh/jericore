[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [ValidateNotNullOrEmpty()]
    [string]$InputPath,

    [string]$OutputPath,

    [ValidateRange(0, 2147483647)]
    [double]$StartTime = 0,

    [ValidateRange(0, 2147483647)]
    [double]$Duration = 0,

    [ValidateRange(1, 16384)]
    [int]$Width = 640,

    [ValidateRange(1, 120)]
    [int]$Fps = 12
)

function Resolve-MediaTool {
    param([Parameter(Mandatory = $true)][string]$Name)

    $command = Get-Command -Name $Name -CommandType Application -ErrorAction SilentlyContinue |
        Select-Object -First 1
    if ($command) {
        return $command.Source
    }

    $pathValues = @(
        $env:Path
        [Environment]::GetEnvironmentVariable('Path', 'User')
        [Environment]::GetEnvironmentVariable('Path', 'Machine')
    )
    foreach ($directory in (($pathValues -join ';') -split ';' | Select-Object -Unique)) {
        if ([string]::IsNullOrWhiteSpace($directory)) {
            continue
        }

        $candidate = Join-Path $directory "$Name.exe"
        if (Test-Path -LiteralPath $candidate -PathType Leaf) {
            return $candidate
        }
    }

    throw "Required executable '$Name' was not found on PATH. Install FFmpeg and make sure ffmpeg.exe and ffprobe.exe are available."
}

function Ensure-FFmpeg {
    $ffmpeg = Resolve-MediaTool -Name 'ffmpeg'
    $ffprobe = Resolve-MediaTool -Name 'ffprobe'

    return @{ FFmpeg = $ffmpeg; FFprobe = $ffprobe }
}

function Format-Seconds {
    param([double]$Value)
    return $Value.ToString('0.###', [Globalization.CultureInfo]::InvariantCulture)
}

try {
    $resolvedInput = (Resolve-Path -LiteralPath $InputPath).Path
    if (-not (Test-Path -LiteralPath $resolvedInput -PathType Leaf)) {
        throw "Input is not a file: $resolvedInput"
    }

    $tools = Ensure-FFmpeg
    $ffmpeg = $tools.FFmpeg
    $ffprobe = $tools.FFprobe

    $durationText = & $ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 $resolvedInput
    if ($LASTEXITCODE -ne 0 -or -not $durationText) {
        throw 'Could not read the video duration with FFprobe.'
    }
    $videoDuration = [double]::Parse(($durationText | Select-Object -First 1), [Globalization.CultureInfo]::InvariantCulture)
    if ($videoDuration -le 0) { throw 'The source video has an invalid duration.' }
    if ($StartTime -ge $videoDuration) {
        throw "StartTime ($StartTime seconds) must be shorter than the video duration ($videoDuration seconds)."
    }

    $availableDuration = $videoDuration - $StartTime
    $actualDuration = if ($Duration -gt 0) { [Math]::Min($Duration, $availableDuration) } else { $availableDuration }

    if ([string]::IsNullOrWhiteSpace($OutputPath)) {
        $directory = [IO.Path]::GetDirectoryName($resolvedInput)
        $baseName = [IO.Path]::GetFileNameWithoutExtension($resolvedInput)
        $resolvedOutput = Join-Path $directory "$baseName.gif"
    } else {
        $resolvedOutput = [IO.Path]::GetFullPath($OutputPath)
        if ([IO.Path]::GetExtension($resolvedOutput) -ne '.gif') {
            $resolvedOutput = [IO.Path]::ChangeExtension($resolvedOutput, '.gif')
        }
    }

    if ([string]::Equals($resolvedInput, $resolvedOutput, [StringComparison]::OrdinalIgnoreCase)) {
        throw 'Output path cannot be the same as the input path.'
    }

    $outputDirectory = [IO.Path]::GetDirectoryName($resolvedOutput)
    if (-not (Test-Path -LiteralPath $outputDirectory -PathType Container)) {
        New-Item -ItemType Directory -Path $outputDirectory -Force | Out-Null
    }

    if (Test-Path -LiteralPath $resolvedOutput) {
        $answer = Read-Host "Output already exists: '$resolvedOutput'. Overwrite? (Y/N)"
        if ($answer -notin @('Y', 'y', 'Yes', 'yes')) {
            $stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
            $resolvedOutput = Join-Path $outputDirectory ("{0}-{1}.gif" -f [IO.Path]::GetFileNameWithoutExtension($resolvedOutput), $stamp)
            Write-Host "Using new output path: $resolvedOutput"
        }
    }

    $tempDirectory = Join-Path ([IO.Path]::GetTempPath()) ("video-to-gif-" + [guid]::NewGuid().ToString('N'))
    New-Item -ItemType Directory -Path $tempDirectory | Out-Null
    $palettePath = Join-Path $tempDirectory 'palette.png'

    try {
        $start = Format-Seconds $StartTime
        $clipDuration = Format-Seconds $actualDuration
        $scaleFilter = "fps=$Fps,scale='min($Width,iw)':-1:flags=lanczos"

        Write-Host "Input:    $resolvedInput"
        Write-Host "Duration: $clipDuration seconds"
        Write-Host "Settings: width <= $Width px, $Fps FPS"
        Write-Host "Output:   $resolvedOutput"

        & $ffmpeg -hide_banner -nostdin -y -ss $start -i $resolvedInput -t $clipDuration -an -vf "$scaleFilter,palettegen=stats_mode=diff" -frames:v 1 -update 1 $palettePath
        if ($LASTEXITCODE -ne 0 -or -not (Test-Path -LiteralPath $palettePath) -or (Get-Item -LiteralPath $palettePath).Length -eq 0) {
            throw 'Palette generation failed.'
        }

        $gifFilter = "fps=$Fps,scale='min($Width,iw)':-1:flags=lanczos[x];[x][1:v]paletteuse=dither=sierra2_4a"
        & $ffmpeg -hide_banner -nostdin -y -ss $start -i $resolvedInput -i $palettePath -t $clipDuration -filter_complex $gifFilter -loop 0 $resolvedOutput
        if ($LASTEXITCODE -ne 0) { throw "GIF conversion failed with exit code $LASTEXITCODE." }

        if (-not (Test-Path -LiteralPath $resolvedOutput -PathType Leaf)) {
            throw 'Conversion command completed but the output file was not found.'
        }
        $outputFile = Get-Item -LiteralPath $resolvedOutput
        if ($outputFile.Length -le 0) { throw 'The generated GIF is empty.' }

        $verify = & $ffprobe -v error -select_streams v:0 -show_entries stream=width,height -show_entries format=duration -of json $resolvedOutput
        if ($LASTEXITCODE -ne 0 -or -not $verify) {
            throw 'The GIF was created, but FFprobe could not verify it.'
        }
        $metadata = $verify | ConvertFrom-Json
        $stream = $metadata.streams | Select-Object -First 1
        $reportedDuration = if ($metadata.format.duration) {
            [double]::Parse([string]$metadata.format.duration, [Globalization.CultureInfo]::InvariantCulture)
        } else { $actualDuration }

        Write-Host ''
        Write-Host 'GIF conversion successful and verified.' -ForegroundColor Green
        Write-Host "Output:     $resolvedOutput"
        Write-Host "Dimensions: $($stream.width)x$($stream.height)"
        Write-Host "Duration:   $(Format-Seconds $reportedDuration) seconds"
        Write-Host "Frame rate: $Fps FPS (target)"
        Write-Host ("File size:  {0:N2} MB" -f ($outputFile.Length / 1MB))
    }
    finally {
        if (Test-Path -LiteralPath $tempDirectory) {
            Remove-Item -LiteralPath $tempDirectory -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
}
catch {
    Write-Error $_.Exception.Message
    exit 1
}