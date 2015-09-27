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
    var keychainItem: KeychainWrapper = KeychainWrapper()
    performSegueWithIdentifier("userLoggedOut", sender: self)
  }

  func loadInBackground() {
    let dataReader : HealthDataReader = HealthDataReader()
    if (HealthDataReader.canRead()) {
      dataReader.connect({ (connected: Bool) -> Void in
        dataReader.update()
        
      })
    }
  }
  
  override func viewDidAppear(animated: Bool) {
    if KeychainWrapper.hasValueForKey("GTAccessCode") {
      loadInBackground()
            performSegueWithIdentifier("loadingToMain", sender: self)
    } else {
      performSegueWithIdentifier("userLoggedOut", sender: self)
    }
  }
}
