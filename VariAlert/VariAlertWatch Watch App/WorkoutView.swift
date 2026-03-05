// SPDX-License-Identifier: MIT
//
//  WorkoutView.swift
//  VariAlertWatch Watch App
//

import SwiftUI

struct WorkoutView: View {
    @EnvironmentObject var appState: WatchAppState
    @EnvironmentObject var bluetoothManager: BluetoothManager
    @EnvironmentObject var workoutManager: WorkoutSessionManager

    @State private var isPressing = false
    @State private var currentTime = Date()
    @State private var showingThreatAlert = false

    var body: some View {
        VStack(spacing: 16) {
            Text(timeFormatter.string(from: currentTime))
                .font(.title)

            Text(radarStatusText)
                .font(.subheadline)
                .foregroundColor(radarStatusColor)

            Button(action: {}) {
                Text("Pause Ride")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isPressing ? Color.red.opacity(0.7) : Color.red)
                    .cornerRadius(10)
            }
            .simultaneousGesture(
                LongPressGesture(minimumDuration: 1.0)
                    .onChanged { _ in isPressing = true }
                    .onEnded { _ in
                        isPressing = false
                        stopWorkoutSession()
                    }
            )
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.red, lineWidth: 6)
                .opacity(showingThreatAlert ? 1 : 0)
        )
        .onAppear {
            startTimeUpdater()
            bluetoothManager.startScanning()
            bluetoothManager.onNewThreatDetected = {
                showingThreatAlert = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation(.easeOut(duration: 0.5)) {
                        showingThreatAlert = false
                    }
                }
            }
        }
        .onDisappear {
            bluetoothManager.disconnect()
        }
        .onChange(of: bluetoothManager.isConnected) { connected in
            appState.isRadarConnected = connected
        }
    }

    // MARK: - Radar Status

    private var radarStatusText: String {
        if bluetoothManager.isConnected {
            return "Radar Connected"
        } else if bluetoothManager.isScanning {
            return "Scanning..."
        } else {
            return "No Radar"
        }
    }

    private var radarStatusColor: Color {
        bluetoothManager.isConnected ? .green : .secondary
    }

    // MARK: - Helpers

    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }

    private func startTimeUpdater() {
        currentTime = Date()
        Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { _ in
            currentTime = Date()
        }
    }

    private func stopWorkoutSession() {
        bluetoothManager.disconnect()
        workoutManager.stopWorkout()
        appState.isRadarConnected = false
        appState.mode = .idle
    }
}
