// SPDX-License-Identifier: MIT
//
//  WorkoutViewLogicTests.swift
//  RadAlertTests
//

import XCTest
import SwiftUI
@testable import RadAlert_Watch_App

final class WorkoutViewLogicTests: XCTestCase {

    // MARK: - formatElapsed

    func testFormatElapsedZero() {
        XCTAssertEqual(formatElapsed(0), "00:00")
    }

    func testFormatElapsedSeconds() {
        XCTAssertEqual(formatElapsed(45), "00:45")
    }

    func testFormatElapsedMinutesAndSeconds() {
        XCTAssertEqual(formatElapsed(90), "01:30")
        XCTAssertEqual(formatElapsed(3599), "59:59")
    }

    func testFormatElapsedHours() {
        XCTAssertEqual(formatElapsed(3600), "1:00:00")
        XCTAssertEqual(formatElapsed(3661), "1:01:01")
        XCTAssertEqual(formatElapsed(7384), "2:03:04")
    }

    // MARK: - RadarPillState.text

    func testPillTextConnected() {
        let state = RadarPillState(isConnected: true, isConnecting: false,
                                   isScanning: false, isDisconnectWarning: false)
        XCTAssertEqual(state.text, "Connected")
    }

    func testPillTextConnecting() {
        let state = RadarPillState(isConnected: false, isConnecting: true,
                                   isScanning: false, isDisconnectWarning: false)
        XCTAssertEqual(state.text, "Connecting")
    }

    func testPillTextSearching() {
        let state = RadarPillState(isConnected: false, isConnecting: false,
                                   isScanning: true, isDisconnectWarning: false)
        XCTAssertEqual(state.text, "Searching")
    }

    func testPillTextLost() {
        let state = RadarPillState(isConnected: false, isConnecting: false,
                                   isScanning: false, isDisconnectWarning: true)
        XCTAssertEqual(state.text, "Lost")
    }

    func testPillTextNoRadar() {
        let state = RadarPillState(isConnected: false, isConnecting: false,
                                   isScanning: false, isDisconnectWarning: false)
        XCTAssertEqual(state.text, "No Radar")
    }

    func testPillTextConnectedTakesPriority() {
        // Even if other flags are set, connected wins
        let state = RadarPillState(isConnected: true, isConnecting: true,
                                   isScanning: true, isDisconnectWarning: true)
        XCTAssertEqual(state.text, "Connected")
    }

    // MARK: - RadarPillState.dotColor

    func testPillDotColorConnected() {
        let state = RadarPillState(isConnected: true, isConnecting: false,
                                   isScanning: false, isDisconnectWarning: false)
        XCTAssertEqual(state.dotColor, .green)
    }

    func testPillDotColorConnecting() {
        let state = RadarPillState(isConnected: false, isConnecting: true,
                                   isScanning: false, isDisconnectWarning: false)
        XCTAssertEqual(state.dotColor, .yellow)
    }

    func testPillDotColorScanning() {
        let state = RadarPillState(isConnected: false, isConnecting: false,
                                   isScanning: true, isDisconnectWarning: false)
        XCTAssertEqual(state.dotColor, .yellow)
    }

    func testPillDotColorLost() {
        let state = RadarPillState(isConnected: false, isConnecting: false,
                                   isScanning: false, isDisconnectWarning: true)
        XCTAssertEqual(state.dotColor, .red)
    }

    func testPillDotColorNoRadar() {
        let state = RadarPillState(isConnected: false, isConnecting: false,
                                   isScanning: false, isDisconnectWarning: false)
        XCTAssertEqual(state.dotColor, .gray)
    }
}
