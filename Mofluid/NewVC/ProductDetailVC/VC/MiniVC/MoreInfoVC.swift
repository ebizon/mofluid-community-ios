//
//  MoreInfoVC.swift
//  Mofluid
//
//  Created by Saurabh Mishra on 7/4/18.
//  Copyright © 2018 Mofluid. All rights reserved.
//

import UIKit
protocol MoreInfoDelegate {
    
    func clickOnMoreInfoButton(_ title:String)
}
class MoreInfoVC: UIViewController,StackContainable {

    var delegate:MoreInfoDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        //Do any additional setup after loading the view.
    }
    @IBAction func clickInfo(_ sender: AnyObject) {
        
        delegate?.clickOnMoreInfoButton("clicked")
    }
    public static func create() -> MoreInfoVC {
        
        return MoreInfoVC(nibName:"MoreInfoVC",bundle: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
