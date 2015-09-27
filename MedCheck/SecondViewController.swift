//
//  SecondViewController.swift
//  MedCheck
//
//  Created by Iain Nash on 9/26/15.
//  Copyright © 2015 Iain Nash. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    //MARK: Properties
    
    @IBOutlet weak var doctorResponse: UILabel!
    var trueDoctorResponse: String! = "Hello!"
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        doctorResponse.text = trueDoctorResponse
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

