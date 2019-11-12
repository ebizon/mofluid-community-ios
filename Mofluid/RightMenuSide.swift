//
//  RightMenuSide.swift
//  SultanCenter
//
//  Created by mac on 22/07/16.
//  Copyright © 2016 mac. All rights reserved.
//

import UIKit
protocol RightSideMenuDelegate{
    
    func tappedOnButton(_ vc:UIViewController,message:String)
}
class RightMenuSide: UIView  {
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var menuTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var wishlistButton: UIButton!
    @IBOutlet weak var privacyPolicyButton: UIButton!
    @IBOutlet weak var rateusButton: UIButton!
    @IBOutlet weak var aboutusButton: UIButton!
    var delegate:RightSideMenuDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        self.initilize()
    }
    
    func initilize() {
        var trailVal:CGFloat = 10.0
        if idForSelectedLangauge == Utils.getArebicLanguageCode() {
            trailVal = UIScreen.main.bounds.size.width - menuView.frame.size.width - 10
        }
        menuTrailingConstraint.constant = trailVal
        layoutIfNeeded()
        menuView.updateConstraintsIfNeeded()
        aboutusButton.setTitle("About us".localized(), for: UIControl.State())
        wishlistButton.setTitle("Wish List".localized(), for: UIControl.State())
        privacyPolicyButton.setTitle("Privacy Policy".localized(), for: UIControl.State())
        rateusButton.setTitle("Rate this app".localized(), for: UIControl.State())
    }
    
    @IBAction func myTapPressed(_ sender: AnyObject) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "OptionViewTap"), object: nil)
    }
    
    @IBAction func btnOptionPressed(_ sender: AnyObject) {
        
        var vc = UIViewController()
        var message = ""
        switch sender.tag {
        case 30:
            vc = WishListViewController(nibName: "WishListViewController", bundle: nil)
            break
        case 20:
            vc = PrivacyVC(nibName:"PrivacyVC",bundle: nil)
            break
        case 50:
            message = "rateTheApp"
            break
        case 40:
            vc = PrivacyVC(nibName:"PrivacyVC",bundle: nil)
            break
        default: break
            
        }
        delegate?.tappedOnButton(vc,message:message)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "selectOptionViewOption"), object: sender)
    }
}
