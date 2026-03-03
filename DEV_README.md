# PepeBuddy Developer Notes
Developer-focused architecture, flow, and validation notes for maintaining PepeBuddy.

## Architecture Overview

### Bootstrap and Lifecycle
- `PepeBuddy.lua`
  - Initializes Ace3 components (`AceConsole`, `AceEvent`, `AceTimer`).
  - Registers slash commands (`/pb`, `/pepebuddy`).
  - Owns addon lifecycle (`OnInitialize`, `OnEnable`, `OnDisable`).

### State (Single Source of Truth)
- `Config/Database.lua`
  - Stores defaults in `pb.defaultOptions.profile`.
  - Exposes normalized setting helpers:
    - `GetSettingDefault`, `GetSetting`, `SetSetting`
    - `GetDebugMode`
    - `GetSelectedPepeSetting` / `SetSelectedPepeSetting`
    - `GetPerchScaleSetting` / `SetPerchScaleSetting`

### UI Options and Commands (Adapters)
- `Config/Options.lua`
  - Options controls call shared state/apply APIs.
- `PepeBuddy.lua`
  - Slash command parser routes to the same core APIs as options.

### Perch Feature
- `Frames/Perch.lua`
  - Contains model, layout, style, and refresh orchestration.
  - Main apply entrypoint: `ApplyPerchState(reason)`.
  - Uses a fixed hidden anchor model (`DisplayInfoID 93797`, Gelbin Mekkatorque) so player shapeshifts do not move Pepe.
  - Uses constants tables:
    - `PERCH_LAYOUT`
    - `PERCH_STYLE`
    - `MODEL_APPLY`

### Settings Header Layout
- `Config/Options.lua`
  - Uses a custom header frame above the AceConfig content area.
  - Header text height is measured dynamically with `GetStringHeight()`, so longer localized strings should increase reserved vertical space correctly.
  - The text/logo split is still driven by fixed constants such as logo size and text gap, so long translations may need follow-up tuning on narrow layouts.
  - When localization is added, move header strings into locale keys and re-check layout with longer languages such as German or French.

## Primary Control Flows

### Initial Load
1. `OnInitialize` sets up database/options/minimap and initializes perch.
2. `OnEnable` shows frame and applies perch state.

### Apply State
1. `ApplyPerchState(reason)`:
   - updates size/layout
   - applies debug style
   - applies selected pepe model

### Model Apply + Retry
1. `SetPerchPepe(index, reason)` normalizes index and persists selection.
2. `TryApplyPepeWithRetry` applies visual kit with token-guarded retries via `AceTimer`.
3. Pending retries are cancelled on refresh stop or superseded apply calls.

### Resize and Anchor Behavior
1. Scale changes update frame size and handle size.
2. Perch reanchors using handle bottom-center as absolute anchor reference.
3. Saved perch position must be computed from the perch frame plus the expected handle offset, not from the handle's live screen coordinates.
4. Reason: the handle may be clamped for drag safety, and a clamped handle can distort persisted `x` coordinates near screen edges.

### Zone/Model Refresh
1. While frame is shown, `PLAYER_ENTERING_WORLD` triggers `ApplyPerchState`.
2. Refresh stops and unregisters events when frame hides.

### Known Bug Fix: Player Shapeshift Anchor Drift
1. Previous behavior used `PlayerModel:SetUnit("player")` as Pepe's hidden anchor.
2. Druid shapeshifts and other player model changes moved the anchor inside the scene, making Pepe appear to shift position and scale.
3. The fix is a stable hidden NPC anchor model using `SetDisplayInfo(93797)` instead of binding to the live player unit.
4. If anchor visuals need retuning later, adjust camera/position values in `perchConfig` rather than restoring `SetUnit("player")`.

### Known Bug Fix: Movable Off Position Drift
1. A previous implementation saved perch position from the handle frame's live bottom-center coordinates.
2. Because the handle is clamped for drag interaction safety, its live coordinates could diverge from the perch frame near the right edge of the screen.
3. This caused asymmetric reload/login drift when `Movable` was off: right-side placements shifted left while left-side placements often stayed correct.
4. The fix is to persist anchor position from the perch frame and derive the expected handle anchor mathematically from the configured offset.

## Baseline Behavior
This baseline is expected after refactor phases 0-6.

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
Run this checklist after structural code changes.

1. `/reload` and verify Pepe is visible.
2. Switch Pepe variants repeatedly; verify no permanent invisible state.
3. Drag perch via handle; verify it tracks cursor and stops cleanly.
4. Change scale from small to large values (for example `0.55`, `1.0`, `2.0`, `3.5`).
5. Confirm handle remains aligned where expected after each resize.
6. Toggle debug on/off with `/pb debug` and verify border visibility changes correctly.
7. Disable and re-enable addon; verify perch hide/show behavior.
8. `/reload` again and verify selected Pepe, scale, and debug mode persisted.
9. Turn `Movable` off, `/reload`, and verify Pepe stays on the same side of the screen.

## Release Candidate Test Gate
Run this before a release:

1. Fresh install test
   - remove SavedVariables entry for PepeBuddy
   - `/reload`
   - verify defaults, visibility, no Lua errors
2. Upgrade test
   - start from existing SavedVariables
   - `/reload`
   - verify selected pepe/scale/debug mode persist correctly
   - verify saved perch position also persists when `Movable` is disabled
3. Runtime behavior
   - switch all pepe variants at least once
   - drag and resize repeatedly
   - toggle debug mode on/off
4. World transitions
   - long-distance travel through zones
   - teleport to a different zone
   - verify recovery behavior is acceptable and no stuck-invisible model
5. Anchor stability
   - shapeshift on a druid or trigger other player appearance changes
   - verify Pepe stays fixed in place and does not change apparent size
6. Session stability
   - play at least 20 minutes with normal interactions
   - verify no repeated retry spam and no Lua errors

## Debug Tracing
When `debugMode` is enabled, `Frames/Perch.lua` emits:

1. `modelApply`: model creation, visual kit apply, retry scheduling/failure.
2. `anchorMath`: resize anchor inputs and resulting perch/handle bottom-center coords.

These traces are useful during refactors and can be reduced after stabilization.

## Refactor Status
- Phase 0: Complete
- Phase 1: Complete
- Phase 2: Complete (with scale/debug model-apply safeguard)
- Phase 3: Complete
- Phase 4: Complete
- Phase 5: Complete
- Phase 6: Complete
