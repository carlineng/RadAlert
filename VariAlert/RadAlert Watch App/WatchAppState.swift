// SPDX-License-Identifier: MIT
//
//  WatchAppState.swift
//  RadAlert Watch App
//
//  Created by Carlin Eng on 2/3/25.
//

import SwiftUI

class WatchAppState: ObservableObject {
    enum Mode {
        case idle
        case workout
    }

    @Published var mode: Mode = .idle
    @Published var isRadarConnected: Bool = false
}
