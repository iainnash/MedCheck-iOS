//
//  HealthDataReader.swift
//  MedCheck
//
//  Created by Iain Nash on 9/26/15.
//  Copyright © 2015 Iain Nash. All rights reserved.
//

import Foundation
import HealthKit

class HealthDataReader {
  var healthStore : HKHealthStore
  
  static func canRead() -> Bool {
    return HKHealthStore.isHealthDataAvailable();
  }
  
  init() {
    healthStore = HKHealthStore()
  }
  
  func queryHeartbeatLast() {
    let past : NSDate = NSDate().dateByAddingTimeInterval(-7*24*60*60);
    let now : NSDate = NSDate()
    
    let heartRateUnit: HKUnit = HKUnit.countUnit().unitDividedByUnit(HKUnit.minuteUnit())
    
    let sampleType = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)!
    let predicate = HKQuery.predicateForSamplesWithStartDate(past, endDate: now, options: .None)
    
    let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: 0, sortDescriptors: nil) {
      query, results, error in
      
      if (error != nil) {
        print("An error occured fetching the user's tracked food. In your app, try to handle this gracefully. The error was: \(error?.localizedDescription)");
      }
      
      dispatch_async(dispatch_get_main_queue()) {
        
        var out: NSString = NSString();
        for sample in (results as? [HKQuantitySample])! {
          let value: Double = sample.quantity.doubleValueForUnit(heartRateUnit)
          let time: NSNumber = sample.startDate.timeIntervalSince1970 * 1000
          out = out.stringByAppendingFormat("%f,%@\n", value, time)
        }
        NSLog(out as String)
      }
    }
    self.healthStore.executeQuery(query)
  }
  
  func connect(callback: (Bool) -> Void) {
  
    let typesToRead : NSSet = NSSet(objects:
      HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)!,
      HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)!,
      HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceWalkingRunning)!,
      HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierActiveEnergyBurned)!
    )
    
    let typesToShare: NSSet = NSSet()
    
    healthStore.requestAuthorizationToShareTypes((typesToShare as! Set<HKSampleType>),
      readTypes: (typesToRead as! Set<HKObjectType>),
      completion: { (good: Bool, err: NSError?) -> Void in
        NSLog("Has permissions :)");
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
          callback(good);
      })
    })
  }
}