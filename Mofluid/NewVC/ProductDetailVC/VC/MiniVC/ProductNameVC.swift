//
//  ProductNameVC.swift
//  Mofluid
//
//  Created by Saurabh Mishra on 7/4/18.
//  Copyright © 2018 Mofluid. All rights reserved.
//

import UIKit

class ProductNameVC: UIViewController,StackContainable {

    let kHeight = 20
    @IBOutlet weak var lblName: UILabel!
    var name:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitUi()
        resizeXib()
        // Do any additional setup after loading the view.
    }
    //MARK:- INIT UI
    func resizeXib(){
        
        var textRect: CGRect = self.lblName.frame
        textRect.size.height = textRect.size.height + CGFloat(kHeight)
        self.view.frame = textRect
    }
    func setInitUi(){
        
        self.lblName.text   =   self.name
    }
    public static func create() -> ProductNameVC {
        
        return ProductNameVC(nibName:"ProductNameVC",bundle: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
