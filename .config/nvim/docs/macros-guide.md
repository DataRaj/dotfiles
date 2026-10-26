# Neovim Macros: The Complete Practical Guide

> [!NOTE]
> A **macro** is a recording of a sequence of keypresses you can replay on demand. Think of it as a keyboard shortcut you create on the fly — no config, no plugin, just `q`.

---

## The Mental Model

```
RECORD  →  RUN ONCE  →  RUN MANY TIMES
  qa           @a            100@a
              (one line)    (100 lines)
```

Macros are the answer to:
> "I need to do this same exact edit on 50 different lines / blocks."

They are better than find-replace when your edit involves **movement + multiple changes + position-awareness**.

---

## Core Mechanics

### The 4 Keys You Need

| Key | What it does |
|-----|-------------|
| `qa` | **Start recording** into register `a` (you can use `a`–`z`) |
| `q` | **Stop recording** |
| `@a` | **Replay** register `a` once |
| `@@` | Replay the **last used** macro again |
| `5@a` | Replay 5 times |
| `V` + select lines + `@a` | Replay **once per selected line** |

---

## Example 1: Add `- ` bullet prefix to lines

**Starting text:**
```
physics
chemistry
mathematics
```

**Goal:** turn each into a Markdown bullet.

**Step-by-step:**
1. Go to line `physics`
2. Type `qa` → recording starts (you'll see `recording @a` in status bar)
3. Type `I- <Esc>` → insert `- ` at line start, exit insert
4. Type `j` → move down one line (for single-line replay)
5. Type `q` → stop recording

> [!IMPORTANT]
> Include `j` at the END of your macro. This moves to the next line after each replay, so `100@a` naturally walks down the file.

6. On `chemistry`, type `@a` → it adds `- ` and moves to `mathematics`
7. Type `@@` → repeats on `mathematics`

**Or faster:** Before recording, don't include `j`.  
Select `chemistry` and `mathematics` with `Vj`, then type `@a` → runs on each selected line.

---

## Example 2: Wrap function arguments in quotes (real backend scenario)

You have:
```go
log.Info(requestId, userId, orderId)
```

You want:
```go
log.Info("requestId", "userId", "orderId")
```

**Record:**
1. Position cursor on `r` of `requestId`
2. `qa` → start recording
3. `ciw"<C-r>""<Esc>` → change inner word, wrap in quotes, paste original word back, exit  
   *(or simpler: `bi"<Esc>ea"<Esc>` → insert `"` before word, jump to end, insert `"`)*
4. `w` → move to next word
5. `q` → stop

6. `2@a` → run twice more to quote `userId` and `orderId`

---

## Example 3: Convert a Python dict to Go struct fields

**Starting text:**
```
user_id: int
email: str
created_at: datetime
```

**Goal:**
```go
UserID    int
Email     string
CreatedAt time.Time
```

This is complex enough to warrant a macro:

1. `qa` on `user_id: int`
2. `^` → go to start of line
3. `guw` → lowercase word (just in case)
4. `~` → capitalize first letter  
5. `f_` → find underscore
6. `x~` → delete underscore, capitalize next letter (camelCase step)
7. `f:` → find the colon
8. `C   ` → change rest of line to a Tab + the Go type
9. `j^q` → next line, start, stop

Then `5@a` walks through 5 remaining fields.

---

## Example 4: Comment out every error handling block (`:g` + macro combo)

You want to surround every line containing `if err != nil` with a comment marker:

```
:g/if err != nil/normal! I// <Esc>
```

No macro needed here — but if your edit is complex (multiple lines per match), record a macro and then:
```
:g/if err != nil/normal! @a
```
This applies macro `a` to every matching line in the file.

---

## Example 5: Add JSON commas to the last field in a list

**API response fields, missing trailing commas:**
```json
  "status": "active"
  "user_id": 123
  "created_at": "2026-10-26"
```

1. `qa` on first line
2. `A,<Esc>j` → append comma at end, go next line
3. `q` → stop
4. `2@a` → run on the remaining 2 lines

**Even faster:** Select all 3 lines with `Vjj`, then:
```
:normal! A,
```

---

## Visual Selection Macro (The "Really Cool" Method)

> [!TIP]
> When you use **linewise Visual mode** (`V`) and press `@a`, Neovim runs the macro **once per selected line** automatically. This is a Neovim default mapping (`v_@-default`).

```
1. Select lines with V (then j/k to extend)
2. Press @a
```

**Rule:** When using Visual `@a`, do NOT put `j` inside your macro — the selection already moves line by line.

---

## Macro Best Practices

### ✅ DO

- **Start from a predictable position** — begin your macro at the first non-space character (`^` or `0`) or a specific pattern so it works on every line
- **Test on one line first** with `@a`, then use `100@a` or Visual select
- **Use `n` in the macro** to jump to the next search result: search first (e.g. `/error`), then record `q a` using `n` to navigate
- **Edit a macro**: `"ap` pastes it as text, edit it, `"ayy` yanks back into register `a`

### ❌ DON'T

- **Don't include `j`** when using Visual `@a` — double movement breaks it
- **Don't record over a macro** you want to keep — use different letters (`qa`, `qb`, `qc`)
- **Don't use macros for simple column edits** — Visual block (`<C-v>`) is faster and cleaner

---

## When to Use What

| Problem | Best Tool |
|---------|-----------|
| Single repeated change at cursor | `.` (dot-repeat) |
| Same multi-step edit on consecutive lines | Macro + count (`50@a`) |
| Same edit on lines matching a pattern | `:g/pattern/normal @a` |
| Edit a specific column across many lines | Visual block `<C-v>` |
| Rename symbol across entire codebase | LSP rename (`<leader>cr`) |
| Add same text to line ends | `:normal! A<text>` |
| Complex transformation, unpredictable spacing | Macro |

---

## Quick Reference Card

```
qa      → start recording into register 'a'
q       → stop recording
@a      → replay macro 'a'
@@      → replay last macro
5@a     → replay 5 times
V j @a  → replay on each selected line

"ap     → paste macro 'a' as editable text
"ayy    → yank line back into register 'a' (after editing)

:g/pattern/normal! @a  → run macro on all matching lines
```
