//
//  SimpleProductVC.swift
//  Mofluid
//
//  Created by Saurabh Mishra on 7/3/18.
//  Copyright © 2018 Mofluid. All rights reserved.
//

import UIKit

class SimpleProductVC: UIViewController,StackContainable {

    @IBOutlet weak var lblPrice         :   UILabel!
    @IBOutlet weak var lblSpecialPrice  :   UILabel!
    @IBOutlet weak var lblDiscount      :   UILabel!
    var specialPrice                    :   String?
    var basePrice                       :   NSAttributedString?
    var discountValue                   :   String?
    var customOptionSet                 :   [CustomOptionSet]?
    var isStock                         :   Bool?
    @IBOutlet weak var lblOutStock      :   UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
        // Do any additional setup after loading the view.
    }
    //MARK:- INIT UI
    func setData(){
        
        lblSpecialPrice.text            =       specialPrice
        lblPrice.attributedText         =       basePrice
        lblDiscount.text                =       discountValue
        isStock! ? (lblOutStock.isHidden=true) : (lblOutStock.isHidden=false)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public static func create() -> SimpleProductVC {
        
        return SimpleProductVC(nibName:"SimpleProductVC",bundle: nil)
    }
}
