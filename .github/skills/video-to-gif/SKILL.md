
---
name: video-to-gif
description: Reusable FFmpeg workflow for converting complete video files into optimized GIFs. Use for video-to-GIF conversion, trimming, resizing, frame-rate adjustment, palette optimization, and output verification.
---

# Video-to-GIF Conversion Skill

## Objective
Convert a video into an animated GIF using FFmpeg, preserving the requested duration and balancing visual quality with file size.

## Prerequisites
- FFmpeg and FFprobe must be installed and accessible from the command line.
- Never install dependencies automatically.
- Use PowerShell-compatible commands on Windows when appropriate.


## Dependency installation and verification

- FFmpeg and FFprobe are required.
- Check for both executables before conversion.
- If either is missing, help the user install FFmpeg using an available package manager.
- On Windows, prefer `winget` when available.
- Ask for approval before installing software or changing system configuration.
- After installation, verify both executables and their versions.
- Do not begin conversion until dependency verification succeeds.
- If installation is unavailable or unsuccessful, provide troubleshooting instructions and stop.


## Default configuration
- Start time: 0 seconds
- Duration: Entire remaining video
- Width: 640 pixels
- Frame rate: 12 FPS
- Height: Preserve the source aspect ratio
- Looping: Infinite
- Output: Same directory and base filename as the source, with a `.gif` extension

## Duration handling
1. By default, convert the entire video from beginning to end.
2. If the user specifies a start time but no duration, convert from that time to the end.
3. If the user specifies a duration, convert only the requested segment.
4. Use FFprobe to determine the source duration when necessary.
5. Do not impose an arbitrary default duration limit.
6. If the selected start time is beyond the video's duration, explain the problem and do not proceed.
7. If the requested duration exceeds the remaining video, convert only the available portion and report the actual duration.

## Conversion procedure
1. Validate the input path and supported video format.
2. Inspect duration, dimensions, and frame rate using FFprobe.
3. Resolve the start time, duration, output width, frame rate, and output path from the user's request or defaults.
4. Check whether the destination already exists. Never overwrite without explicit approval.
5. Generate a palette using FFmpeg's `palettegen` filter.
6. Apply the palette with `paletteuse` to create the GIF.
7. Use Lanczos scaling where resizing is required and preserve aspect ratio.
8. Ensure palette generation and GIF creation use compatible trimming, scaling, and frame-rate settings.
9. Check process exit codes and verify that the GIF exists, is non-empty, and can be inspected.
10. Remove temporary palette files after processing.
11. Report the final path, dimensions, duration, frame rate, and file size.

## FFmpeg filter guidance
Use a filter workflow equivalent to:

- Video preparation: `fps=12,scale=640:-1:flags=lanczos`
- Palette generation: `palettegen`
- Palette application: `paletteuse`

Adapt frame rate and width to the user's requested settings. If the source is smaller than the requested width, avoid upscaling unless requested.

## File-size considerations
GIFs can become very large when converting long videos.

- Warn the user when a full-length conversion is likely to produce a large file.
- Do not shorten the video or reduce the requested quality silently.
- If optimization is needed, suggest a lower frame rate, smaller width, or shorter duration and let the user decide.
- Preserve the entire duration unless the user explicitly requests trimming.

## Output handling
- Keep the source video unchanged.
- Use a different output filename if the destination already exists, unless the user approves overwriting.
- For batch jobs, summarize successes and failures separately.

## Troubleshooting
- If FFmpeg is missing, provide operating-system-specific installation instructions.
- If the input cannot be read, check the path, file permissions, and supported codecs.
- If colors look poor, adjust palette generation or dithering.
- If the GIF is too large, suggest a lower FPS or width.
- If playback speed looks incorrect, check the frame rate and conversion settings.

## Completion report
After successful conversion, report:
- Input filename
- Output filename and path
- Actual duration converted
- Output dimensions
- Frame rate
- Output file size
