# CLAUDE.md

Behavioral guidelines to reduce common LLM coding mistakes. Merge with project-specific instructions as needed.

**Tradeoff:** These guidelines bias toward caution over speed. For trivial tasks, use judgment.

## 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:
- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

## 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:
- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.

When your changes create orphans:
- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request.

## 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:
- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:
```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.

## 5. AHK v1 Coordinate Debugging

**When GUI controls and MouseMove coordinates don't align, check these in order:**

1. **DPI auto-scaling conflict** — AHK v1 auto-scales Gui control positions by system DPI by default. If the script calls `SetProcessDpiAwareness(2)`, `MouseMove,Screen` uses raw physical pixels, but the Gui still applies its own scaling. Symptoms: systematic upper-left or lower-right offset proportional to DPI scale. Fix: `Gui, Name:-DPIScale` BEFORE adding controls.

2. **Round() drift between layout and navigation** — If `Build()` uses `Round(n * spacing)` for control positions but `Navigate()` uses `(n + offset) * spacing` (floating-point), the fractional `spacing` causes a sawtooth error pattern: some cells round up, some down. Symptoms: inconsistent offset per cell ("random at E, K positions"). Fix: use **identical** `Round()` expressions in both layout and navigation:
   ```
   ; Build:
   colX := Round(idx * spacing)
   ; Navigate — same formula:
   colX := Round(idx * spacing)
   xCoord := colX + ctrlHalfSize
   ```

3. **Verify error direction before making changes** — If mouse is upper-left of target, coordinates are too small. If lower-right, coordinates are too large. Use the direction to narrow the root cause (scaling factor, offset, or rounding).

4. **Prefer WinGetPos over stored coordinates** — After arrow-key grid movement or DPI-per-monitor transitions, stored GUI positions may be stale. `WinGetPos` returns the actual screen position in the same coordinate system as `MouseMove,Screen`.

---

**These guidelines are working if:** fewer unnecessary changes in diffs, fewer rewrites due to overcomplication, and clarifying questions come before implementation rather than after mistakes.
