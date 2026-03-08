// SPDX-License-Identifier: MIT
//
//  StubApp.swift
//  VariAlertStub
//
// =============================================================================
// DEVELOPMENT STUB — NOT FOR APP STORE SUBMISSION
// =============================================================================
// This iOS app exists solely to prevent watchOS from orphan-cleaning the watch
// app. When a watch app's WKCompanionAppBundleIdentifier points to an iOS app
// that isn't installed on the paired iPhone, watchOS periodically removes the
// watch app. This stub satisfies that check during local development.
//
// HOW TO REMOVE THIS STUB (before App Store submission):
//   1. Delete the VariAlertStub/ directory.
//   2. In project.pbxproj, remove all objects with "VariAlertStub" in their
//      comment, and remove the target ID from PBXProject.targets.
//      (Easiest via Xcode: select the VariAlertStub target → Editor →
//      Delete Target, then delete the VariAlertStub group in the file tree.)
//   3. In the watch target's build settings, remove
//      INFOPLIST_KEY_WKCompanionAppBundleIdentifier entirely. The key is only
//      required when a companion app exists; standalone watchOS App Store apps
//      omit it.
//   4. Distribute via App Store (paid Apple Developer account required). App
//      Store-distributed watch apps are not subject to companion-app cleanup.
//
// NOTE: Bundle ID is com.carlineng.RadAlert to match the watch app's
// WKCompanionAppBundleIdentifier.
// =============================================================================

import SwiftUI

@main
struct StubApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
