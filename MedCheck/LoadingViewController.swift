//
//  LoadingViewController.swift
//  MedCheck
//
//  Created by Iain Nash on 9/26/15.
//  Copyright © 2015 Iain Nash. All rights reserved.
//

import Foundation
import UIKit
import Security

class LoadingViewController : UIViewController {
    
  override func viewDidAppear(animated: Bool) {
    var keychainItem: KeychainItemWrapper
    performSegueWithIdentifier("UserLoggedOut", sender: self)
  }
}