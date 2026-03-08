# VariAlert TODO

## Completed (Standalone watchOS Refactor)
- [x] Create watchOS `BluetoothManager.swift` (BLE scanning, auto-connect, threat parsing + dedup, haptic alerts)
- [x] Update `WatchAppState.swift` — add `isRadarConnected` property
- [x] Update `VariAlertWatchApp.swift` — replace `WatchConnectivityManager` with `BluetoothManager`
- [x] Delete `WatchConnectivityManager.swift` from watchOS target
- [x] Update `WorkoutView.swift` — start scanning on appear, show connection status, disconnect on stop
- [x] Update Xcode project file — added BluetoothManager to watchOS Sources, removed WatchConnectivityManager
- [x] Add `NSBluetoothAlwaysUsageDescription` to watchOS build settings
- [x] Fix HealthKit entitlements — removed `healthkit.access` (Health Records), kept basic `healthkit`
- [x] Remove iOS app and test targets entirely
- [x] Configure watch as standalone (`WKRunsIndependentlyOfCompanionApp = YES`)
- [x] Update CLAUDE.md and README

## Completed (Development Experience)
- [x] **Simulator support** — `BluetoothManager` uses `#if targetEnvironment(simulator)` to simulate radar connection (2s delay), periodic fake threats (every 4s), and an unexpected disconnect (at 20s) without any BLE hardware
- [x] **Visual threat indicator** — red border flashes on `WorkoutView` when a threat is detected, making haptic events visible in the simulator
- [x] **Stub iOS companion app** (`VariAlertStub`) — prevents watchOS from orphan-cleaning the watch app during local development; includes step-by-step removal instructions

## Completed (Reliability & Safety UX)
- [x] **Radar disconnect notification** — unexpected mid-ride disconnect plays `.failure` haptic, flashes orange border, shows "Radar Lost" status, then auto-retries scanning after 2s; explicit "Pause Ride" stop does not trigger the alert
- [x] **Scan retry** — 15s scan timeout stops a stalled scan; "Scan Again" button appears whenever not connected and not scanning

---

## App Store Readiness

### Prerequisites
- [ ] **Paid Apple Developer Program membership** ($99/yr) — required to submit to App Store; personal/free team cannot submit
- [ ] **Remove VariAlertStub iOS target** — the `VariAlertStub/` iOS app is a development workaround to prevent watchOS from orphan-cleaning the watch app (see `VariAlertStub/StubApp.swift` for step-by-step removal instructions); it must be removed before App Store submission as Apple will reject a stub iOS app under guideline 4.2 (Minimum Functionality); removal requires a paid developer account so App Store distribution manages watch app persistence instead
- [ ] **Rename the app and project** — new name: **RadAlert** (subtitle: "Radar Alerts for Cyclists"); "VariAlert" derives directly from Garmin's "Varia" trademark; "RadAlert" is clean — "Rad" = radar/wheel (German), no trademark conflicts of concern; App Store keywords to include: "garmin varia, cycling radar, bike radar, haptic alert"; full rename plan below:
  - **User-facing:** display name `VariAlertWatch` → `RadAlert`; bundle IDs `com.carlineng.VariAlert.*` → `com.carlineng.RadAlert.*`; update `WKCompanionAppBundleIdentifier` to match new stub bundle ID
  - **Project structure:** `VariAlert.xcodeproj/` → `RadAlert.xcodeproj/`; `VariAlertWatch Watch App/` directory → `RadAlert Watch App/`; `VariAlertWatch Watch App.entitlements` → `RadAlert Watch App.entitlements`; `VariAlertWatchApp.swift` → `RadAlertApp.swift`; all path references in `project.pbxproj` updated to match
  - **Source code:** struct `VariAlertWatch_Watch_AppApp` → `RadAlertApp`; file header comments in all Swift files; stub `ContentView.swift` and `StubApp.swift` comment references
  - **Docs:** `README.md`, `CLAUDE.md`, `TODO.md` — all VariAlert references → RadAlert
  - **GitHub:** rename repo `VariAlert` → `RadAlert` on GitHub (Settings → rename); update git remote URL locally after
  - **Skip:** outer `VariAlert/VariAlert/` directory nesting (cosmetic, not worth disruption); git history; `xcuserdata/`
  - **Risk:** `project.pbxproj` directory rename means all file reference paths change — do with find/replace + `plutil -lint` validation after

### Legal & Compliance
- [ ] **In-app disclaimer screen** — show on first launch; must make clear the app is a supplement to situational awareness, not a certified safety device; require user acknowledgement before proceeding
- [ ] **App Store description disclaimer** — safety/liability language in the store listing
- [ ] **Privacy policy** — required for any app using HealthKit; must be hosted at a public URL and linked in App Store Connect

### Core UX / App Review Requirements
- [ ] **Onboarding flow** — explain what the app does and what hardware is needed (Garmin Varia) before the user hits the main screen
- [ ] **Bluetooth permission denial handling** — if user denies Bluetooth, show an actionable message explaining why it's needed and how to enable it in Settings (currently the app silently does nothing)
- [ ] **HealthKit permission denial handling** — if user denies HealthKit, either gracefully degrade (no workout tracking) or explain why it's required
- [ ] **Rename "Idle State" label** — replace debug-looking UI text with something user-facing (e.g. "Ready" or just the app name)

### Reliability & Safety UX
- [ ] **Workout metrics** — surface at least basic stats (elapsed time, heart rate) in WorkoutView to justify HealthKit usage to Apple reviewers; purely using HealthKit for background execution without surfacing data is a review risk

### Polish
- [ ] **App icon** — required for App Store submission
- [ ] **App name** — decide on final name; "VariAlertWatch" is the current display name
- [ ] **Version and build number** — set appropriately before submission
- [ ] **Screenshot(s)** — App Store requires at least one Apple Watch screenshot

### App Store Connect Setup
- [ ] Create app record in App Store Connect
- [ ] Configure HealthKit data types in App Store Connect (required when using HealthKit entitlement)
- [ ] Write App Store description, keywords, and support URL
- [ ] Link privacy policy URL

---

## Notes
- Workout session (`HKWorkoutSession`) is kept to maintain background execution during rides
- Haptic alerts only fire during active workout mode
- Auto-connect to first discovered Garmin Varia (no manual device selection)
- Haptic pattern: 4× `.retry` pulses, 0.3s spacing
- `VariAlertStub` iOS target exists only to satisfy the companion app check and prevent watch app orphan-cleanup during development; see `VariAlertStub/StubApp.swift` for removal instructions
- `WKCompanionAppBundleIdentifier = com.carlineng.VariAlert` is required by WatchKit installer (bundle ID prefix constraint) and must match the stub's bundle ID; remove both when removing the stub
