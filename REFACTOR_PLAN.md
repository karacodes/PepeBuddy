# PepeBuddy Refactor Plan (Ace3-Centric)

## Goals
- Make future changes local and low-risk.
- Reduce duplicated logic across `PepeBuddy.lua`, `Config/*`, and `Frames/Perch.lua`.
- Standardize behavior so slash commands, options UI, and startup all use the same code paths.
- Keep rendering/layout stable during resize and pepe switching.

## Non-Goals
- No feature expansion in this pass.
- No visual redesign.
- No library/framework migration away from Ace3.

---

## Current Pain Points
- Mixed concerns in `Frames/Perch.lua` (model lifecycle, frame creation, layout math, debug visuals, refresh events).
- Settings are accessed from multiple places with inconsistent patterns (`pb.debugMode` mirror + db profile reads).
- Multiple behavior paths for similar actions (OnEnable, options set handlers, slash commands, refresh timers).
- Magic numbers for layout and style are inline in multiple spots.
- Retry logic for model rendering is distributed and hard to reason about.

---

## Target Architecture

### 1) Bootstrap (Ace lifecycle only)
File: `PepeBuddy.lua`
- Keep:
  - addon identity/constants setup
  - `OnInitialize`, `OnEnable`, `OnDisable`
  - slash command registration
- Move logic out:
  - settings mutation
  - perch layout/model internals
  - ad-hoc retries

### 2) State Layer (AceDB single source of truth)
Files: `Config/Database.lua` + new state helpers on addon
- All runtime settings read/write through `self.db.profile`.
- Remove mirror state where possible (`pb.debugMode`).
- Add normalized settings API:
  - `GetSetting(key)`
  - `SetSetting(key, value)`
  - typed helpers (`GetDebugMode`, `SetDebugMode`, `GetPerchScale`, etc.)

### 3) Perch Feature Layer
File: `Frames/Perch.lua` (internally sectioned, or split into multiple files later)
- PerchView:
  - frame creation
  - handle creation
  - styling hooks
- PerchLayout:
  - size math
  - anchor math
  - bottom-center coordinate helpers
- PerchModel:
  - model creation/refresh
  - visual kit application
  - retry/fallback policy

### 4) Options/Console as Adapters
File: `Config/Options.lua` + slash command handler in `PepeBuddy.lua`
- UI controls call shared setters only.
- Slash command subcommands call same setters.
- Both route through one apply path (`ApplyPerchState`).

---

## Phased Execution Plan

## Phase 0 - Baseline and Safety Net
### Tasks
1. Freeze a known-good baseline behavior (document expected behavior).
2. Add a short manual regression checklist to `README.md`.
3. Add temporary debug logging switches for model apply + anchor math (gated by debug mode).

### Tests before moving on
1. `/reload` then verify Pepe is visible.
2. Switch multiple pepes quickly; confirm no permanent invisible state.
3. Drag with handle and scale 0.5 -> 1.0 -> 2.0 -> 3.5; verify handle-bottom anchor remains stable.
4. Toggle debug on/off and verify border visibility behavior.
5. Disable/enable addon; verify frame hides/shows correctly.

---

## Phase 1 - State Normalization (AceDB-first)
### Tasks
1. Define canonical settings keys in one place (profile defaults).
2. Implement `GetSetting`/`SetSetting` on `PepeBuddy`.
3. Refactor existing getters/setters (`GetPerchScale`, `SetPerchScale`, debug setter) to use this API.
4. Remove direct `pb.debugMode` writes; derive from db profile in helpers.
5. Ensure defaults are complete and no dead keys remain.

### Tests before moving on
1. Change scale in options, reload, verify persistence.
2. Change selected pepe, reload, verify persistence.
3. Toggle debug via slash command, reload, verify persistence.
4. Run with a fresh SavedVariables file and verify defaults are applied.

---

## Phase 2 - Unified Apply Path
### Tasks
1. Create `ApplyPerchState(reason)` in perch feature layer.
2. Route these entry points to `ApplyPerchState`:
   - OnEnable
   - options set handlers
   - slash command handlers
   - relevant events (`PLAYER_ENTERING_WORLD`, `UNIT_MODEL_CHANGED`)
3. Remove duplicated ad-hoc calls that partially apply state.
4. Keep `reason` for debug traces only.

### Tests before moving on
1. Toggle debug from slash and from options-equivalent path; verify identical behavior.
2. Change scale and selected pepe repeatedly; verify no desync (UI value == rendered state).
3. `/reload` and verify same final state after initialize/enable.

---

## Phase 3 - Perch.lua Internal Separation
### Tasks
1. Split code into explicit sections/functions:
   - `EnsurePerchFramesCreated`
   - `ApplyPerchDebugStyle`
   - `ComputeHandleLayout`
   - `ApplyPerchLayout`
   - `EnsureModelReady`
   - `ApplyPepeVisual`
2. Keep cross-section dependencies one-way:
   - state -> layout/model
   - layout does not mutate state
3. Remove inline magic values into constants table:
   - handle ratio
   - y-offset formula coefficients
   - border colors/alpha
4. Preserve current behavior exactly while restructuring.

### Tests before moving on
1. Run full baseline tests from Phase 0.
2. Resize stress test: scrub scale slider continuously for 10-15 seconds.
3. Drag + resize + drag sequence; verify no anchor drift.
4. Pepecycle test: switch all pepe variants in sequence twice.

---

## Phase 4 - Model Apply Reliability
### Tasks
1. Define explicit model lifecycle policy:
   - when model is created
   - when it is rebuilt
   - how/when retries happen
2. Consolidate retries into one function using `AceTimer-3.0`.
3. Ensure apply return semantics are correct (`pcall` success + function result handling).
4. Add guarded fallback path only when apply truly fails.
5. Keep logging for retry attempts in debug mode.

### Tests before moving on
1. Rapid pepe switching while moving frame.
2. Zone transition / loading screen (trigger `PLAYER_ENTERING_WORLD`) and verify pepe remains visible.
3. Equipment or model-affecting events (trigger `UNIT_MODEL_CHANGED`) and verify recovery.
4. No repeated retry loops after success.

---

## Phase 5 - Options and Command Cleanup
### Tasks
1. Keep options declarative: each control maps to one setting key and shared setter.
2. Keep slash command parser minimal and route to shared setters.
3. Standardize command usage/help output.
4. Remove stale comments and dead code paths.

### Tests before moving on
1. `/pb` opens settings.
2. `/pb debug`, `/pb debug on`, `/pb debug off` all work.
3. Options and slash commands produce identical end state.
4. No Lua errors on invalid slash input.

---

## Phase 6 - Documentation and Final Hardening
### Tasks
1. Update `README.md` with:
   - architecture overview
   - primary control flows
   - regression checklist
2. Add inline comments only where logic is non-obvious (anchor math, retry behavior).
3. Final pass for naming consistency (`offset` vs `offSet`, etc.).

### Final test gate (release candidate)
1. Fresh install test (new SavedVariables).
2. Upgrade test (existing SavedVariables from current version).
3. Long session test (play for 20+ minutes, zone at least once, switch multiple pepes).
4. UI toggles and addon disable/enable while in session.
5. Verify zero Lua errors in all scenarios.

---

## Suggested Commit Strategy
1. `refactor(state): normalize settings access through AceDB helpers`
2. `refactor(perch): introduce ApplyPerchState and unify entry points`
3. `refactor(perch): separate layout/style/model responsibilities`
4. `fix(model): consolidate visual kit retry behavior`
5. `refactor(ui): wire options/slash commands to shared setters`
6. `docs: add architecture notes and regression checklist`

---

## Risk Register
- High risk: model lifecycle changes can break visibility.
  - Mitigation: Phase 4 isolated; add debug logging and retry caps.
- Medium risk: anchor math drift during scale updates.
  - Mitigation: retain bottom-center helper tests every phase.
- Medium risk: persistence regressions from settings API changes.
  - Mitigation: explicit reload tests in each phase.

---

## Definition of Done
- One canonical path for settings mutation and state application.
- No duplicated scale/debug/selected-pepe apply logic across files.
- Perch rendering, dragging, and resizing remain stable.
- Pepe remains visible across switch, reload, and world/model refresh events.
- Manual regression checklist passes without Lua errors.
