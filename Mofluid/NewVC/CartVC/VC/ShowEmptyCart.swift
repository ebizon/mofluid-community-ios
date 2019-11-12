//
//  ShowEmptyCart.swift
//  Mofluid
//
//  Created by Saurabh Mishra on 23/07/18.
//  Copyright © 2018 Mofluid. All rights reserved.
//

import UIKit
protocol EmptyCartDelegate {
    
    func clickedOnShowNow()
}
class ShowEmptyCart: UIViewController {

    @IBOutlet weak var viewContent          :   UIView!
    @IBOutlet weak var ivCart               :   UIImageView!
    @IBOutlet weak var btnShopNow           :   UIButton!
    @IBOutlet weak var lblDesc              :   UILabel!
    @IBOutlet weak var lblHeader            :   UILabel!
    let kRadius                             =   CGFloat(15.0)
    var delegate                            :   EmptyCartDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        setInitUi()
    }
    //MARK:- Set Initial UI
    func setInitUi(){
        
        viewContent.layer.cornerRadius      =   kRadius
        viewContent.layer.shadowColor       =   UIColor.white.cgColor
        btnShopNow.backgroundColor          =   Settings().getButtonBgColor()
        lblHeader.text                      =   Settings().emptyCart
        lblDesc.text                        =   Settings().addItem
        lblHeader.font                      =   Settings().latoBold
        lblDesc.font                        =   Settings().latoBold
        btnShopNow.setTitle(Settings().shopnow, for: UIControl.State.normal)
    }
    //MARK:- IBACTION
    @IBAction func clickShopNow(_ sender: Any) {
        
        self.delegate?.clickedOnShowNow()
        self.dismiss(animated: true) {
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
