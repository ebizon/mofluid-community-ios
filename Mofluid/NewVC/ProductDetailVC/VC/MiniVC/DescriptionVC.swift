//
//  DescriptionVC.swift
//  Mofluid
//
//  Created by Saurabh Mishra on 7/3/18.
//  Copyright © 2018 Mofluid. All rights reserved.
//

import UIKit

class DescriptionVC: UIViewController,StackContainable {

    @IBOutlet weak var txtviewDescription   : UITextView!
    var shortDescription                    : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialUi()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    //MARK:- INIT UI
    func setInitialUi(){
        
        txtviewDescription.text =   self.shortDescription
        txtviewDescription.layoutIfNeeded()
    }
    //MARK:- StackView Settings
    public func preferredAppearanceInStack() -> ScrollingStackController.ItemAppearance {
        let _ = self.view // force load of the view
        return .view(height: txtviewDescription.frame.size.height)
    }
    public static func create() -> DescriptionVC {
        
        return DescriptionVC(nibName:"DescriptionVC",bundle: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
