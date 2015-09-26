//
//  LoadingViewController.swift
//  MedCheck
//
//  Created by Iain Nash on 9/26/15.
//  Copyright © 2015 Iain Nash. All rights reserved.
//

import Foundation
import UIKit

class LoadingViewController : UIViewController {
  override func viewDidAppear(animated: Bool) {
    performSegueWithIdentifier("loadingToMain", sender: self)
  }
}