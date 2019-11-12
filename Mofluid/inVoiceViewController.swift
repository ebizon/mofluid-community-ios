//
//  sample.swift
//  Mofluid
//
//  Created by sudeep goyal on 10/09/15.
//  Copyright © 2015 Mofluid. All rights reserved.
//

import UIKit
import Foundation


class inVoiceViewController: BaseViewController{
    var titleParentView = UIView()
    var titileLabel = UILabel()
    var detailsParentScrollView = UIScrollView()
    var orderID : String? = nil
    var amountToPay: String? = nil
    var payPalPayment: NSDictionary? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
       Utils.deleteAllDataFromDB("Cart")
       self.navigationItem.title = "Order Review".localized().uppercased()
        titleParentView.frame = CGRect(x: 0, y: 0, width: mainParentScrollView.frame.width, height: 50)
        titileLabel = Utils.createTitleLabel(titleParentView,yposition: 15)
        titileLabel.text = "Thank you for placing your order with us. We'll do our best to deliver it to below address..".localized()
        if(idForSelectedLangauge == Utils.getArebicLanguageCode())
        {
           titileLabel.textAlignment = .right
        }
        titileLabel.numberOfLines = 0
       // titileLabel.sizeToFit()
        titleParentView.frame.size.height = titileLabel.frame.height + 20
        titleParentView.addSubview(titileLabel)
        mainParentScrollView.addSubview(titleParentView)
        
        createTableForm()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        if(deviceName == "big"){
//            UILabel.appearance().font = UIFont(name: "Lato", size: 20)
//        }
//        else{
//            UILabel.appearance().font = UIFont(name: "Lato", size: 15)
//        }
        
        super.viewWillAppear(animated)

        
    }
    
    func createTableForm(){
        
        detailsParentScrollView.frame = CGRect(x: 15, y: titleParentView.frame.origin.y + titleParentView.frame.height + 20, width: mainParentScrollView.frame.width - 30, height: 150)
        
        var posy:CGFloat = 0
        
        posy = self.addLabel(posy, title: "Order Id".localized(), titleData : self.orderID!)
        
        var address: Address? = nil
        
        if Config.guestCheckIn{
            address = UserInfo.guestShipAddress
        }
        else{
            if UserManager.Instance.getUserInfo() !=  nil{
                  address = UserManager.Instance.getUserInfo()?.shipAddress
            }
            
        }
        
        if  address != nil {
            posy = self.addLabel(posy, title: "Name".localized(), titleData : address!.getFullName())
            posy = self.addLabel(posy, title: "Shipping Address".localized(), titleData : address!.getFullStreet())
            posy = self.addLabel(posy, title: "City".localized(), titleData : address!.city)
            posy = self.addLabel(posy, title: "State".localized(), titleData : address!.region.name)
            posy = self.addLabel(posy, title: "Country".localized(), titleData : address!.getCountryName())
            posy = self.addLabel(posy, title: "Zipcode".localized(), titleData : address!.postCode)
            if let amountToPay = self.amountToPay{
                posy = self.addLabel(posy, title: "Amount Payable".localized(), titleData :amountToPay)
            }else if let payPalConfirmation = self.payPalPayment{
                if let payPalId = payPalConfirmation["id"] as? String{
                    posy = self.addLabel(posy, title: "PayPal Transaction Id".localized(), titleData :payPalId)
                }
            }
            posy = self.addLabel(posy, title: "Contact Number".localized(), titleData : address!.telePhone)
           // posy = self.addLabel(posy, title: "Email Address".localized(), titleData : address!.email, addBorder: false)
        }
        
        mainParentScrollView.addSubview(detailsParentScrollView)
        detailsParentScrollView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
        detailsParentScrollView.layer.borderWidth = 1
        detailsParentScrollView.layer.cornerRadius = 2
        
        let continueShoppingButton = ZFRippleButton()
        continueShoppingButton.frame = CGRect(x: detailsParentScrollView.frame.origin.x, y: detailsParentScrollView.frame.origin.y + detailsParentScrollView.frame.size.height + 20, width: detailsParentScrollView.frame.size.width, height: 38)
        continueShoppingButton.addTarget(self, action: #selector(inVoiceViewController.continueShoppingAction(_:)), for: UIControl.Event.touchUpInside)
       // let backgroundImg = UIImage(named: "background")
     //   continueShoppingButton.setBackgroundImage(backgroundImg, forState: UIControlState.Normal)
        continueShoppingButton.backgroundColor = UIColor.darkGray
        continueShoppingButton.setTitle("Continue Shopping".localized(), for: UIControl.State())
        continueShoppingButton.titleLabel?.textColor = UIColor.white
        
        mainParentScrollView.addSubview(continueShoppingButton)
        
        mainParentScrollView.contentSize.height = continueShoppingButton.frame.origin.y + continueShoppingButton.frame.size.height + 100
        
    }
    
    func addLabel(_ posy : CGFloat, title : String, titleData : String, addBorder : Bool = true)->CGFloat{ //ankur
        let singleParentView = UIView(frame: CGRect(x: 0, y: posy, width: detailsParentScrollView.frame.width, height: 150))
        
        let leftTitleLabel = UILabel()
        if(idForSelectedLangauge == Utils.getArebicLanguageCode())
        {
            leftTitleLabel.frame = CGRect(x: singleParentView.frame.width/2 + 5, y: 10, width: singleParentView.frame.width/2 - 10, height: 20)
            leftTitleLabel.textAlignment = .right
        }
        else
        {
            leftTitleLabel.frame = CGRect(x: 10, y: 10, width: singleParentView.frame.width/2 - 20, height: 20)
        }
        leftTitleLabel.textColor = UIColor.black
        leftTitleLabel.text = title
        leftTitleLabel.numberOfLines = 0
        leftTitleLabel.adjustsFontSizeToFitWidth = true
        // leftTitleLabel.sizeToFit()
        singleParentView.addSubview(leftTitleLabel)
        
        let rightTitleLabel = UILabel()
        if(idForSelectedLangauge == Utils.getArebicLanguageCode())
        {
            
            rightTitleLabel.frame = CGRect(x: 10, y: 10, width: singleParentView.frame.width/2 - 20, height: 20)
            rightTitleLabel.textAlignment = .right
        }
        else
        {
            
            rightTitleLabel.frame = CGRect(x: singleParentView.frame.width/2 + 5, y: 10, width: singleParentView.frame.width/2 - 10, height: 20)
        }
        
        
        rightTitleLabel.textColor = UIColor.black
        rightTitleLabel.text =  titleData
        rightTitleLabel.numberOfLines = 0
        rightTitleLabel.adjustsFontSizeToFitWidth = true
        //rightTitleLabel.sizeToFit()
        singleParentView.addSubview(rightTitleLabel)
        
        if(rightTitleLabel.frame.height > leftTitleLabel.frame.height){
            singleParentView.frame.size.height = rightTitleLabel.frame.origin.y + rightTitleLabel.frame.height + 10
        }
        else{
            singleParentView.frame.size.height = leftTitleLabel.frame.origin.y + leftTitleLabel.frame.height + 10
        }
        
        
        if addBorder{
            let border = UILabel(frame: CGRect(x: 0, y: singleParentView.frame.height - 2, width: singleParentView.frame.width, height: 1))
            border.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
            singleParentView.addSubview(border)
        }
        
        let border = CALayer()
        border.frame = CGRect(x: -10, y: -9, width: 1, height: singleParentView.frame.height)
        border.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
        rightTitleLabel.layer.addSublayer(border)
        
        detailsParentScrollView.addSubview(singleParentView)
        detailsParentScrollView.frame.size.height = singleParentView.frame.origin.y + singleParentView.frame.height
        
        let modY = posy + singleParentView.frame.height
        return modY
    }
    
    @objc func continueShoppingAction(_ button:ZFRippleButton){
        self.tabBarController?.selectedIndex = 0
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.tabSelectedIndex = 0
        NotificationCenter.default.post(name: Notification.Name(rawValue: "popToRoot"), object: nil)
        self.navigationController?.popToRootViewController(animated: false)
    }
    
    func backButtonFunction(){
        self.navigationController?.popViewController(animated: true)
    }
}

