# VariAlert Standalone watchOS Refactor — TODO

## Plan
- [x] Create watchOS `BluetoothManager.swift` (BLE scanning, auto-connect, threat parsing + dedup, haptic alerts)
- [x] Update `WatchAppState.swift` — add `isRadarConnected` property
- [x] Update `VariAlertWatchApp.swift` — replace `WatchConnectivityManager` with `BluetoothManager` + keep `WorkoutSessionManager`
- [x] Delete `WatchConnectivityManager.swift` from watchOS target
- [x] Update `WorkoutView.swift` — start scanning on appear, show connection status, disconnect on stop
- [x] Update Xcode project file — added BluetoothManager to watchOS Sources, removed WatchConnectivityManager
- [x] Add `NSBluetoothAlwaysUsageDescription` to watchOS build settings
- [x] Fix HealthKit entitlements — removed `com.apple.developer.healthkit.access` (Health Records), kept basic `com.apple.developer.healthkit` for workout session background execution
- [ ] **Build and verify in Xcode** — open project and build watchOS target

## Known Issues / Follow-ups
- None outstanding — the project is now watch-only.

## Notes
- Workout session (`HKWorkoutSession`) is kept to maintain background execution during rides
- Haptic alerts still only fire during active workout mode
- Auto-connect to first discovered Garmin Varia (no manual device selection on watch)
- Haptic pattern: 4x `.retry` pulses, 0.3s spacing
