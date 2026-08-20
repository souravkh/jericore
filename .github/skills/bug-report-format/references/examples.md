# Worked Examples

## Example 1 — Typical messy input with environment details

**User input:**
"hey so when i try to check out on mobile safari after i put in a promo code the
button just doesnt do anything, i tapped it like 5 times. worked fine on chrome
desktop. this was on the current prod build this morning"

**Output:**

```markdown
### Title
Checkout button unresponsive on Mobile Safari after applying a promo code

### Description
On the current production build, the checkout button becomes unresponsive on Mobile
Safari after a promo code is applied, preventing users from completing checkout.

### Steps to Reproduce
1. Open the site on Mobile Safari.
2. Add an item to the cart and proceed to checkout.
3. Enter a valid promo code and apply it.
4. Tap the checkout/submit button.

### Actual Result
The checkout button does not respond to taps; nothing happens after multiple attempts.

### Expected Result
Tapping the checkout button should proceed with the order after a promo code is applied.

### Environment
- Browser: Mobile Safari
- Build: Current production (as of this morning)
- Note: Not reproducible on Chrome desktop

### Screenshots / Attachments
None provided
```

---

## Example 2 — Crash report with data loss (no environment info given)

**User input:**
"app crashed while i was editing a note, lost everything i typed. happened twice
today already"

**Output:**

```markdown
### Title
App crashes during note editing, causing loss of unsaved content

### Description
The app crashes while a note is being edited, resulting in loss of all unsaved
changes. The user reports this occurring twice in one day.

### Steps to Reproduce
1. Open an existing note (or create a new one).
2. Begin editing/typing content.
3. Continue editing until the crash occurs. (exact trigger not provided)

### Actual Result
The app crashes mid-edit and all unsaved content is lost.

### Expected Result
The app should not crash during editing, and in-progress content should be
preserved or auto-saved even if a crash occurs.

### Screenshots / Attachments
None provided
```

---

## Example 3 — Input too vague to produce reproduction steps

**User input:**
"the app is broken"

**Output:**
Do not guess. Ask exactly one targeted clarifying question, for example:

"Can you tell me what you were doing when it broke — which screen or action —
and what happened (error, crash, freeze, wrong result)?"

Do not produce a partial bug report template in this case; wait for the answer,
then generate the full structured report.
