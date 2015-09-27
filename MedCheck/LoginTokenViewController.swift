//
//  LoginTokenViewController.swift
//  MedCheck
//
//  Created by Iain Nash on 9/27/15.
//  Copyright © 2015 Iain Nash. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class LoginTokenViewController : UIViewController, UITextFieldDelegate {
  @IBOutlet var textField: UITextField!;

  func textFieldShouldReturn(textField: UITextField) -> Bool {
    Alamofire.request(.POST, "http://dorm.instasc.com/login.php", parameters: ["accessCode":  textField.text!]).responseString { response, a, b in
      if (b.value == "OK") {
        KeychainWrapper.setString(textField.text!, forKey: "GTAccessCode");
      } else {
        let alertView : UIAlertView = UIAlertView()
        alertView.title =  "invalid claim code "
        //alertView.
        alertView.show()
      }
    }
    return false;
  }
}