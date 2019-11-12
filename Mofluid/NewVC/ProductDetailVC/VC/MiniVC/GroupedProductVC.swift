//
//  GroupedProductVC.swift
//  Mofluid
//
//  Created by Saurabh Mishra on 7/13/18.
//  Copyright © 2018 Mofluid. All rights reserved.
//

import UIKit
protocol GroupProductDelegate {
    
    func clickedOnButton(_ sender:UIButton)
}
class GroupedProductVC: UIViewController , StackContainable{

    var delegate:GroupProductDelegate?
    @IBOutlet weak var btnName: UIButton!
    var name:String?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func clickBtn(_ sender: Any) {
        
        self.delegate?.clickedOnButton(sender as! UIButton)
    }
    //MARK:- StackView Settings
    public static func create() -> GroupedProductVC {
        
        return GroupedProductVC(nibName:"GroupedProductVC",bundle: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
