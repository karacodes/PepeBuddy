# PepeBuddy
Pepe Buddy - World of Warcraft addon that places Pepe on your UI.

## Baseline Behavior (Phase 0)
This baseline is the expected behavior to preserve during refactors.

1. Addon load:
   - Pepe renders on a perch frame.
   - Perch is hidden when addon is disabled and shown when enabled.
2. Perch movement:
   - Dragging is performed via the handle frame, not the full perch frame.
   - Handle remains anchored relative to perch and scales with perch size.
3. Resizing:
   - Scale changes resize perch and handle.
   - Handle bottom-center remains the anchor reference used during resize.
4. Pepe switching:
   - Changing selected Pepe applies a SpellVisualKit and updates saved selection.
5. Debug mode:
   - Perch and handle outlines are visible only in debug mode.
   - Background remains transparent.

## Manual Regression Checklist
Run this checklist after any structural change.

1. `/reload` and verify Pepe is visible.
2. Switch Pepe variants repeatedly; verify no permanent invisible state.
3. Drag perch via handle; verify it tracks cursor and stops cleanly.
4. Change scale from small to large values (for example `0.55`, `1.0`, `2.0`, `3.5`).
5. Confirm handle remains aligned where expected after each resize.
6. Toggle debug on/off with `/pb debug` and verify border visibility changes correctly.
7. Disable and re-enable addon; verify perch hide/show behavior.
8. `/reload` again and verify selected Pepe, scale, and debug mode persisted.

## Temporary Debug Tracing (Phase 0)
When `debugMode` is enabled, `Frames/Perch.lua` emits trace logs to chat for:

1. `modelApply`: model creation, visual kit apply result, retry scheduling/failure.
2. `anchorMath`: resize anchor inputs and resulting perch/handle bottom-center coords.

These traces are intended for refactor validation and can be reduced/removed after stabilization.
