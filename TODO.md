# VariAlert Standalone watchOS Refactor — TODO

## Plan
- [x] Create watchOS `BluetoothManager.swift` (BLE scanning, auto-connect, threat parsing + dedup, haptic alerts)
- [x] Update `WatchAppState.swift` — add `isRadarConnected` property
- [x] Update `VariAlertWatchApp.swift` — replace `WatchConnectivityManager` with `BluetoothManager`
- [x] Delete `WatchConnectivityManager.swift` from watchOS target
- [x] Update `WorkoutView.swift` — start scanning on appear, show connection status, disconnect on stop
- [x] Update Xcode project file — added BluetoothManager to watchOS Sources, removed WatchConnectivityManager
- [x] Add `NSBluetoothAlwaysUsageDescription` to watchOS build settings
- [ ] **Build and verify in Xcode** — open project and build watchOS target

## Open Questions / Known Issues
- `INFOPLIST_KEY_WKCompanionAppBundleIdentifier` is still set in watchOS build settings (ties watch to iOS app bundle). For a fully independent watch app (no iPhone required), this should be removed and `WKRunsIndependentlyOfCompanionApp = YES` added. Currently left as-is since the Xcode project still includes both targets.
- The iOS app still exists in the project — it will continue to build. iOS `WatchConnectivityManager` (iOS-side) is untouched and still references the watch; it can be removed later if the iOS app is fully retired.
- `Threat.swift` and `RadarDevice.swift` were NOT added to watchOS target — the watchOS `BluetoothManager.swift` defines its own `Threat` struct inline, avoiding the need to share iOS model files (which import `CoreBluetooth` via `RadarDevice`).

## Notes
- Workout session requirement stays: radar alerts only fire during active workout
- Auto-connect to first discovered Garmin Varia (no manual device selection on watch)
- Haptic pattern: 4x `.retry` pulses, 0.3s spacing

## Open Questions
- (none yet)

## Notes
- Workout session requirement stays: radar alerts only fire during active workout
- Auto-connect to first discovered Garmin Varia (no manual device selection on watch)
- Haptic pattern: 4x `.retry` pulses, 0.3s spacing
