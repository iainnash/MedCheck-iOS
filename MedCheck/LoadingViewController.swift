//
//  LoadingViewController.swift
//  MedCheck
//
//  Created by Iain Nash on 9/26/15.
//  Copyright © 2015 Iain Nash. All rights reserved.
//

import Foundation
import UIKit
import AFNetworking

class LoadingViewController : UIViewController {
  override func viewDidAppear(animated: Bool) {
    let dataReader : HealthDataReader = HealthDataReader()
    if (HealthDataReader.canRead()) {
      dataReader.connect({ (connected: Bool) -> Void in
        dataReader.update()
        self.performSegueWithIdentifier("GoToSignup", sender: self)
      })
    }
  }
}