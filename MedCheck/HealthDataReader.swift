//
//  HealthDataReader.swift
//  MedCheck
//
//  Created by Iain Nash on 9/26/15.
//  Copyright © 2015 Iain Nash. All rights reserved.
//

import Foundation
import HealthKit
import SwiftyJSON
import AFNetworking
import Alamofire

class HealthDataReader {
  var healthStore : HKHealthStore
  var past : NSDate
  
  static func canRead() -> Bool {
    return HKHealthStore.isHealthDataAvailable();
  }
  
  init() {
    healthStore = HKHealthStore()
    past = NSDate().dateByAddingTimeInterval(-7*24*60*60)
  }
  
  func queryHealthKit(type: NSString, unit: HKUnit, sampleType: HKSampleType, past: NSDate) {
    
    let now : NSDate = NSDate()
    
    let predicate = HKQuery.predicateForSamplesWithStartDate(past, endDate: now, options: .None)
    
    let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: 0, sortDescriptors: nil) {
      query, results, error in
      
      if (error != nil) {
        print("An error occured fetching the user's tracked food. In your app, try to handle this gracefully. The error was: \(error?.localizedDescription)");
      }
      
      //dispatch_async(dispatch_get_main_queue()) {
        let 👀: NSMutableArray = NSMutableArray()
        for sample in (results as? [HKQuantitySample])! {
          let 💩: Double = sample.quantity.doubleValueForUnit(unit)
          let 🕐: Double = sample.startDate.timeIntervalSince1970 * 1000
          let sampleValue: [String: Double] = ["time": 🕐, "val": 💩]
          👀.addObject(sampleValue)
        }
        self.postToServer(type, data: 👀);
      //}
    }
    self.healthStore.executeQuery(query)
  }
  
  func postToServer(type: NSString, data: NSMutableArray) {
    Alamofire.request(.POST, "http://dorm.instasc.com/post.php", parameters: ["data": data], encoding: .JSON)
      .responseString { response in
        NSLog("Uploaded data.")
    }
  }
  
  func update() {
    queryHealthKit("heartrate", unit: HKUnit.countUnit().unitDividedByUnit(HKUnit.minuteUnit()), sampleType: HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)!, past: past)
    queryHealthKit("stepcount", unit: HKUnit.countUnit(), sampleType: HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)!, past: past)
    queryHealthKit("distancemoved", unit: HKUnit.meterUnit(), sampleType: HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceWalkingRunning)!, past: past)
    queryHealthKit("energyburned", unit: HKUnit.calorieUnit(), sampleType: HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierActiveEnergyBurned)!, past: past)
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