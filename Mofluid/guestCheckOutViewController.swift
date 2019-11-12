//
//  loginViewController.swift
//  Mofluid
//
//  Created by sudeep goyal on 10/09/15.
//  Copyright © 2015 Mofluid. All rights reserved.
//

import UIKit
import Foundation

class guestCheckOutViewController: PageViewController{
    var headerLabel: UILabel = UILabel()
    var radioParentView = UIView()
    var radioButtonsArray = ["Checkout As Guest".localized(),"Login".localized(),"Create An Account".localized()]
    var continueButton = ZFRippleButton()
    var boolCheckContinue: Int? = nil;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createCheckOutPage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "OptionViewTap"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "selectOptionViewOption"), object: nil)
        
    }
    
    
    func createCheckOutPage(){
        headerLabel.frame = CGRect(x: 20, y: 20, width: mainParentScrollView.frame.size.width - 40, height: 60)
        headerLabel.textAlignment = .center;
        headerLabel.font = UIFont(name: "Lato-Bold", size: 25)
        headerLabel.textColor = UIColor.gray
        headerLabel.text = "CHECKOUT AS A GUEST OR LOGIN".localized()
//        headerLabel.text = "CHECKOUT AS A GUEST OR REGISTER OR LOGIN".localized()
        headerLabel.numberOfLines = 2
        
        if(deviceName != "big"){
            headerLabel.font = UIFont(name: "Lato-Bold", size: 20)
        }
        mainParentScrollView.addSubview(headerLabel)
        
        radioParentView.frame = CGRect(x: 0, y: headerLabel.frame.height + headerLabel.frame.origin.y + 10, width: mainParentScrollView.frame.size.width, height: 150)
        
        var posY:CGFloat = 0
        for i in 0 ..< radioButtonsArray.count{
            let radioboxbuttonView = RadioButton()
            radioboxbuttonView.frame = CGRect(x: 20, y: posY, width: mainParentScrollView.frame.size.width - 40, height: 35)
            radioboxbuttonView.addTarget(self, action: #selector(guestCheckOutViewController.radioboxbuttonViewAction(_:)), for: UIControl.Event.touchUpInside)
            radioboxbuttonView.tag = i
            
            radioboxbuttonView.setTitleColor(UIColor.black, for: UIControl.State())
            radioboxbuttonView.titleLabel?.font = UIFont(name: "Lato", size: 20)
            radioboxbuttonView.setTitle(radioButtonsArray[i], for: UIControl.State())
            
            radioboxbuttonView.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
            radioboxbuttonView.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
            
            if(idForSelectedLangauge == Utils.getArebicLanguageCode())
            {
                
                radioboxbuttonView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0);
                radioboxbuttonView.titleLabel!.transform = CGAffineTransform(scaleX: -1.0, y: 1.0);
                radioboxbuttonView.imageView!.transform = CGAffineTransform(scaleX: -1.0, y: 1.0);
                
            }
            
            radioboxbuttonView.layer.borderColor = UIColor.lightGray.cgColor//UIColor(netHex:0x5d5d5d).CGColor
            radioboxbuttonView.layer.borderWidth = 1.5
            radioboxbuttonView.layer.cornerRadius = 4
            
            radioParentView.addSubview(radioboxbuttonView)
            
            radioParentView.frame.size.height = radioboxbuttonView.frame.size.height + radioboxbuttonView.frame.origin.y + 10
            
            if(deviceName == "big"){
                posY = posY + radioboxbuttonView.frame.size.height + 25
            }
            else{
                posY = posY + radioboxbuttonView.frame.size.height + 5
            }
        }
        
        mainParentScrollView.addSubview(radioParentView)
        
        if (UIDevice.current.model.range(of: "iPad") != nil) {
            continueButton.frame = CGRect(x: 20, y: radioParentView.frame.height + radioParentView.frame.origin.y + 15, width: mainParentScrollView.frame.size.width - 40, height: 40)
        }
            
        else {
            continueButton.frame = CGRect(x: 20, y: radioParentView.frame.height + radioParentView.frame.origin.y , width: mainParentScrollView.frame.size.width - 40, height: 40)
        }
        
        
        continueButton.addTarget(self, action: #selector(guestCheckOutViewController.continueButtonAction), for: UIControl.Event.touchUpInside)
        continueButton.backgroundColor = Settings().getButtonBgColor()//UIColor(red: (223/255.0), green: (114/255.0), blue: (114/255.0), alpha: 1.0)
        continueButton.layer.cornerRadius = 3.0
        continueButton.setTitle("Continue".localized(), for: UIControl.State())
        continueButton.titleLabel?.font = UIFont(name: "Lato-Bold", size: 20)
        continueButton.titleLabel?.textColor = UIColor.white
        continueButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
        continueButton.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        
        mainParentScrollView.addSubview(continueButton)
        
    }
    
    @objc func radioboxbuttonViewAction(_ button: UIButton){
        self.FlipButton(button as? FlipFlopButton)
        
        boolCheckContinue = button.tag
    }
    
    @objc func continueButtonAction(){
        
        if(boolCheckContinue == 1){
            moveToLogin = true
            LoginOrAccountPage()
        }
        else if(boolCheckContinue == 2){
            moveToLogin = false
            LoginOrAccountPage()
        }
        else if(boolCheckContinue == 0){
            moveToLogin = true
            guestPage()
        }
        else{
            
            self.alert("Please select any of the above options!")
        }
    }
    
    func LoginOrAccountPage(){
        let loginObject = LoginVC(nibName:"LoginVC",bundle: nil)//self.storyboard?.instantiateViewController(withIdentifier: "loginViewController") as? loginViewController
        self.navigationController?.pushViewController(loginObject, animated: true)
    }
    
    func guestPage(){
        let buyNowObject = self.storyboard?.instantiateViewController(withIdentifier: "buyNowViewController") as? buyNowViewController
        buyNowObject?.guestCheckBool = true
        self.navigationController?.pushViewController(buyNowObject!, animated: true)
    }
    
    func backButtonFunction(){
        self.navigationController?.popViewController(animated: true)
    }
}
