// SPDX-License-Identifier: MIT
//
//  ContentView.swift
//  VariAlertStub
//
// See StubApp.swift for removal instructions.

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "applewatch")
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            Text("RadAlert runs on Apple Watch.")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}
