# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

RadAlert is a **standalone watchOS application** for Garmin Varia radar device integration. The app runs entirely on Apple Watch — no companion iPhone app is required at runtime.

- **watchOS App**: Connects directly to a Garmin Varia radar via Bluetooth, monitors for vehicle threats, and delivers haptic alerts during cycling workouts
- There is no iOS app target in this project — the app is fully standalone

## Build & Test Commands

### Building the Project
- Open `RadAlert/RadAlert.xcodeproj` in Xcode
- Single build target: `RadAlert Watch App` (watchOS)
- Use standard Xcode build commands (⌘+B) or xcodebuild CLI

### Development Requirements
- Xcode 15.4 or later
- watchOS 10.5+ deployment target
- Swift 5.0
- Paid Apple Developer Program membership ($99/yr) — required for App Store distribution and to avoid 7-day build expiry on device

### Setup Instructions
1. Open `RadAlert/RadAlert.xcodeproj` in Xcode
2. Select the `RadAlert Watch App` target
3. Go to "Signing & Capabilities" tab
4. Set your Development Team (Apple ID/Developer Account)
5. Connect iPhone via USB, select your Apple Watch as the run destination, and hit ⌘R

## Architecture Overview

### Core Design Pattern
The app follows MVVM architecture with SwiftUI and Combine.

### Data Flow
1. User taps "Start Ride" → `WorkoutSessionManager` starts an `HKWorkoutSession`
2. `BluetoothManager` begins scanning for Garmin Varia radar (service UUID `6A4E3200-667B-11E3-949A-0800200C9A66`)
3. Auto-connects to the first discovered device
4. Characteristic notifications deliver radar data packets
5. `parseRadarData()` decodes `[header][threatID][distance][speed]` byte payloads into `Threat` objects
6. New threat IDs (not seen in previous update) trigger 4× `.retry` haptic pulses (0.3s spacing)
7. "Pause Ride" long-press disconnects Bluetooth and ends the workout session

### Key Files

| File | Purpose |
|------|---------|
| `BluetoothManager.swift` | BLE scanning, auto-connect, threat parsing, deduplication, haptic alerts |
| `WorkoutSessionManager.swift` | HealthKit workout session (keeps app alive in background) |
| `WatchAppState.swift` | App mode (`.idle` / `.workout`) and radar connection state |
| `RadAlertApp.swift` | App entry point, environment object wiring |
| `WorkoutView.swift` | Active ride UI — shows connection status, radar state |
| `IdleView.swift` | Pre-ride UI — "Start Ride" button |
| `HapticTestView.swift` | Developer tool for testing haptic patterns |

### Key Implementation Details

**Bluetooth Communication**
- Service UUID: `6A4E3200-667B-11E3-949A-0800200C9A66`
- Auto-connects to first discovered Garmin Varia (no manual device selection)
- Threat data parsing in `parseRadarData()`: payload format is `[header][threatID][distance][speed]...`
- Threat deduplication via `Set<UInt8>` tracking in `BluetoothManager`

**Haptic Alerts**
- Only fire during active workout mode (`WatchAppState.mode == .workout`)
- Pattern: 4× `.retry` pulses with 0.3s spacing
- Triggered directly in `BluetoothManager` on new threat detection

**Background Execution**
- `HKWorkoutSession` keeps the app alive in the background during rides
- HealthKit entitlement: `com.apple.developer.healthkit` (basic — no Health Records access)

**Standalone Watch Configuration**
- `WKRunsIndependentlyOfCompanionApp = YES` — watch app does not require companion iOS app

## Development Notes

- **Installing to device**: connect iPhone via USB, select the watch as run destination in Xcode — trust is handled automatically by Xcode, no manual trust step needed
- Bluetooth permission: `NSBluetoothAlwaysUsageDescription` in watchOS build settings
- HealthKit permissions: `NSHealthShareUsageDescription` and `NSHealthUpdateUsageDescription` in watchOS build settings
