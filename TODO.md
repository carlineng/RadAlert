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

---

## App Store Readiness

### Prerequisites
- [ ] **Paid Apple Developer Program membership** ($99/yr) — required to submit to App Store; personal/free team cannot submit
- [ ] **Rename the app and project** — "VariAlert" derives directly from Garmin's "Varia" trademark and could trigger App Store rejection (guideline 4.1) or a Garmin C&D; choose a name that describes the functionality without referencing Garmin (e.g. RadarAlert, TailAlert, RearGuard, CycleRadar); "compatible with Garmin Varia" can still appear in the App Store description

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
- [ ] **Radar disconnect notification** — if the radar drops mid-ride, alert the user immediately (haptic + UI) rather than silently showing "No Radar"
- [ ] **Scan retry logic** — if initial scan finds nothing, offer a "Scan Again" button rather than leaving the user on a static "No Radar" state
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
- `WKCompanionAppBundleIdentifier = com.carlineng.VariAlert` is required by WatchKit installer (bundle ID prefix constraint) even though the iOS app no longer exists
