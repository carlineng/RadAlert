// SPDX-License-Identifier: MIT
//
//  HealthStoreProviding.swift
//  RadAlert Watch App
//

import HealthKit

protocol HealthStoreProviding {
    func authorizationStatus(for type: HKObjectType) -> HKAuthorizationStatus
    func requestAuthorization(toShare typesToShare: Set<HKSampleType>,
                              read typesToRead: Set<HKObjectType>,
                              completion: @escaping (Bool, Error?) -> Void)
    func makeWorkoutSession(configuration: HKWorkoutConfiguration) throws -> HKWorkoutSession
}

extension HKHealthStore: HealthStoreProviding {
    func makeWorkoutSession(configuration: HKWorkoutConfiguration) throws -> HKWorkoutSession {
        return try HKWorkoutSession(healthStore: self, configuration: configuration)
    }
}
