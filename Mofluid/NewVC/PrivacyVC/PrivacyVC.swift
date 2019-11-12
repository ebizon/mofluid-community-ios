//
//  PrivacyVC.swift
//  Mofluid
//
//  Created by Saurabh Mishra on 6/21/18.
//  Copyright © 2018 Mofluid. All rights reserved.
//

import UIKit

class PrivacyVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func clickClose(_ sender: Any) {
        
        self.presentingViewController?.dismiss(animated: true, completion:nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
