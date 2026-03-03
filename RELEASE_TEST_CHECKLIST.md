# PepeBuddy Release Test Checklist

Run this checklist in game after a meaningful batch of changes and before any release build. The goal is to catch regressions early and keep the checklist current as PepeBuddy gains features or new bugs are discovered.

## Maintenance Rule
- Update this checklist whenever a new feature is added.
- Update this checklist whenever a bug is found that should have been caught by in-game verification.
- Prefer adding a concrete repro or validation step instead of a vague reminder.

## Core Startup
1. Launch or `/reload` with PepeBuddy enabled.
2. Verify there are no Lua errors on login.
3. Verify Pepe appears when the addon is enabled.
4. Verify saved settings load correctly for the current character.

## Settings Panel
1. Open settings with `/pb`.
2. Verify the custom header renders correctly.
3. Verify the header logo appears in the expected position.
4. Verify the title, author, version, and description are readable and do not overlap the settings area.
5. Verify the settings panel icon appears correctly in the Blizzard settings list.

## Pepe Selection
1. Change Pepe variants several times in a row.
2. Verify the selected variant updates immediately.
3. Verify Pepe does not become permanently invisible after repeated switching.
4. `/reload` and verify the selected Pepe persists.

## Position And Movement
1. Turn `Movable` on.
2. Drag Pepe using the handle area.
3. Verify movement starts and stops cleanly.
4. Verify the perch remains in the chosen position after `/reload`.
5. Turn `Movable` off and verify dragging is disabled.
6. With `Movable` off, place Pepe near the right side of the screen, `/reload`, and verify horizontal position does not shift.
7. With `Movable` off, log out and back in, and verify horizontal position still does not shift.

## Scale And Facing
1. Change scale across small, medium, and large values.
2. Verify Pepe resizes correctly and stays anchored where expected.
3. Change facing across left, center, and right values.
4. Verify the facing update applies immediately.
5. `/reload` and verify scale and facing persist.

## Reset Behavior
1. Move Pepe and change scale, facing, and selected variant.
2. Use `Reset Pepe to all defaults`.
3. Verify position, scale, facing, and selected Pepe reset correctly.
4. Verify the perch returns to screen center.

## World And Model Refresh
1. Change zones or use a teleport.
2. Verify Pepe recovers if the model briefly disappears.
3. Verify no repeated retry spam or Lua errors occur during world transitions.

## Anchor Stability
1. On a druid, shapeshift between forms while PepeBuddy is visible.
2. Verify Pepe does not appear to move or change size during shapeshifts.
3. Trigger other player appearance changes if available and verify the perch remains stable.
4. Hide the full UI with another addon or `/console hideUI 1`, restore it, and verify Pepe hides with the UI and returns when the UI is restored.

## Session Stability
1. Play normally for at least 15-20 minutes with PepeBuddy enabled.
2. Interact with the settings panel during the session.
3. Verify there are no stuck states, missing models, or Lua errors over time.

## Release Note
- If a test fails, fix the issue and add or refine the checklist step that would have caught it more clearly next time.
