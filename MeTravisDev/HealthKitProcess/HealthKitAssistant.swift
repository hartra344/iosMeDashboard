//
//  HealthKitAssistant.swift
//  MeTravisDev
//
//  Created by Travis Harris on 4/13/20.
//  Copyright © 2020 Travis Harris. All rights reserved.
//

import Foundation
import HealthKit
import Promises
import SwiftDate

class HealthKitAssistant {
    class func updateAllStats() -> Promise<Bool> {
        let stats: [(HKQuantityTypeIdentifier, HKStatisticsOptions,HKUnit, String )] =
            [
                (HKQuantityTypeIdentifier.bodyMass, HKStatisticsOptions.discreteMin, HKUnit.pound(), "weight"),
                (HKQuantityTypeIdentifier.bodyMassIndex, HKStatisticsOptions.discreteMin, HKUnit.count(), "bmi"),
                (HKQuantityTypeIdentifier.restingHeartRate, HKStatisticsOptions.discreteMin, HKUnit.count().unitDivided(by: HKUnit.minute()), "resting_heart_rate"),
                (HKQuantityTypeIdentifier.activeEnergyBurned, HKStatisticsOptions.cumulativeSum, HKUnit.kilocalorie(), "active_calories"),
                (HKQuantityTypeIdentifier.basalEnergyBurned, HKStatisticsOptions.cumulativeSum, HKUnit.kilocalorie(), "basal_calories"),
                (HKQuantityTypeIdentifier.dietaryEnergyConsumed, HKStatisticsOptions.cumulativeSum, HKUnit.kilocalorie(), "dietary_calories"),
                (HKQuantityTypeIdentifier.dietaryCarbohydrates, HKStatisticsOptions.cumulativeSum, HKUnit.gram(), "carbs"),
                (HKQuantityTypeIdentifier.dietaryFiber, HKStatisticsOptions.cumulativeSum, HKUnit.gram(), "fiber"),
                (HKQuantityTypeIdentifier.dietaryFatTotal, HKStatisticsOptions.cumulativeSum, HKUnit.gram(), "fat"),
                (HKQuantityTypeIdentifier.dietaryProtein, HKStatisticsOptions.cumulativeSum, HKUnit.gram(), "protein"),
        ];
        
        let p = stats.map{
            return getStatForDays(days: 3, identifier: $0.0, statistics_options: $0.1, unit: $0.2, key: $0.3)
        }
        
        return all(p).then{
            values in
            return Promise(values.allSatisfy{
                v in
                return v
            })
        }
    }
    
    class func getStatForDays(days: Int, identifier:  HKQuantityTypeIdentifier,statistics_options: HKStatisticsOptions , unit: HKUnit, key: String ) -> Promise<Bool> {
        return Promise<Bool>(on:.main){
            fulfill, reject in
            
            
            let quantityType = HKQuantityType.quantityType(forIdentifier: identifier)!
            let reg = Region(calendar: Calendars.gregorian, zone: Zones.americaLosAngeles, locale: Locales.englishUnitedStates)
            SwiftDate.defaultRegion = reg;
            let now = Date()
            let daysAgo = (now - 3.days).dateAtStartOf(.day)
            
            let predicate = HKQuery.predicateForSamples(withStart: daysAgo, end: now, options: .strictStartDate)
            
            let query = HKStatisticsCollectionQuery.init(quantityType: quantityType,
                                                         quantitySamplePredicate: predicate,
                                                         options: statistics_options,
                                                         anchorDate: daysAgo,
                                                         intervalComponents: DateComponents(day: 1))
            
            query.initialResultsHandler = { query, results, error in
                guard let statsCollection = results else {
                    // Perform proper error handling here...
                    reject(error!)
                    return
                }
                var updates: [StatUpdateInput] = []
                statsCollection.enumerateStatistics(from: daysAgo, to: now) { statistics, stop in
                    
                    if let quantity = (statistics_options == HKStatisticsOptions.cumulativeSum  ? statistics.sumQuantity() : statistics.minimumQuantity()) {
                        let value = quantity.doubleValue(for: unit)
                        
                        updates.insert(StatUpdateInput(date: statistics.startDate.toISO(), quantity: value, key: key), at: 0)
                    }
                }
                send_data(dataToSend: updates).then{
                    value in
                    fulfill(value)
                }.catch{
                    err in
                    reject(err)
                }
            }
            
            query.statisticsUpdateHandler = {
                query, statistics, statisticsCollection, error in
                guard let statsCollection = statisticsCollection else {
                    // Perform proper error handling here...
                    reject(error!)
                    return
                }
                var updates: [StatUpdateInput] = []
                statsCollection.enumerateStatistics(from: daysAgo, to: now) { statistics, stop in
                    if let quantity = statistics.sumQuantity() {
                        let value = quantity.doubleValue(for: unit)
                        updates.insert(StatUpdateInput(date: statistics.startDate.toISO(), quantity: value, key: key), at: 0)
                    }
                }
                send_data(dataToSend: updates).then{
                    value in
                }.catch{
                    err in
                }
                
            }
            
            HKHealthStore().execute(query)
        }
    }
    
    class func send_data(dataToSend: [StatUpdateInput]) -> Promise<Bool> {
        return Promise<Bool>(on:.main) {
            fulfill, reject in
            Network.shared.apollo.perform(mutation: AddStatMutation(statsToAdd: dataToSend)){
                result in
                guard let data = try? result.get().data else {
                    return
                }
                
                fulfill(data.updateStats)
            }
        }
        
    }
    
    class func authorizeHealthKit() -> Promise<Bool> {
        return Promise<Bool>(on:.main){
            fulfill, reject in
            
            guard HKHealthStore.isHealthDataAvailable() else {
                fulfill(false)
                return
            }
            
            guard   let dateOfBirth = HKObjectType.characteristicType(forIdentifier: .dateOfBirth),
                let biologicalSex = HKObjectType.characteristicType(forIdentifier: .biologicalSex),
                let bodyMassIndex = HKObjectType.quantityType(forIdentifier: .bodyMassIndex),
                let bodyMass = HKObjectType.quantityType(forIdentifier: .bodyMass),
                let activeEnergy = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned),
                let dietEnergyConsumed = HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed),
                let carbs = HKObjectType.quantityType(forIdentifier: .dietaryCarbohydrates),
                let fiber = HKObjectType.quantityType(forIdentifier: .dietaryFiber),
                let fat = HKObjectType.quantityType(forIdentifier: .dietaryFatTotal),
                let protein = HKObjectType.quantityType(forIdentifier: .dietaryProtein),
                let basalEnergy = HKObjectType.quantityType(forIdentifier: .basalEnergyBurned),
                let rhr = HKObjectType.quantityType(forIdentifier: .restingHeartRate) else {
                    
                    fulfill(false)
                    return
            }
            
            let healthKitTypesToWrite: Set<HKSampleType> = []
            
            let healthKitTypesToRead: Set<HKObjectType> = [dateOfBirth,
                                                           activeEnergy,
                                                           biologicalSex,
                                                           bodyMassIndex,
                                                           carbs,
                                                           fiber,
                                                           fat,
                                                           protein,
                                                           basalEnergy,
                                                           bodyMass,
                                                           dietEnergyConsumed,
                                                           rhr,
                                                           HKObjectType.workoutType()]
            
            HKHealthStore().requestAuthorization(toShare: healthKitTypesToWrite,
                                                 read: healthKitTypesToRead) { (success, error) in
                                                    fulfill(success)
            }
            
        }
    }
    
    
}
