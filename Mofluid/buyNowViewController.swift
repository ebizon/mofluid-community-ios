//
//  sample.swift
//  Mofluid
//
//  Created by sudeep goyal on 10/09/15.
//  Copyright © 2015 Mofluid. All rights reserved.
//

import UIKit
import Foundation

class ViewData {
    
    var firstNameText = UITextField()
    var lastNameText = UITextField()
    var contactNumberText = UITextField()
    var address1 = UITextField()
    var address2 = UITextField()
    var cityText = UITextField()
    var zipText = UITextField()
    var stateText = UITextField()
    var emailText : UITextField?
    var countryDropDownButton = UIButton()
    var stateDropDownButton = UIButton()
    var countryCode = Config.Instance.getCountryCode()
    var stateName = ""
    var stateRegion : AddressRegion?
    var regionId = 0
    var billData = UserManager.Instance.getUserInfo()?.billAddress
    
}

class buyNowViewController: PageViewController, UITableViewDataSource, UITableViewDelegate{
    let rowHeight : CGFloat = 40
    var cart = ShoppingCart.Instance
    var headerTitleLabel = UILabel()
    var billAddressParentView = UIView()
    var shipAddressParentView = UIView()
    
    var billingAddressForm : ViewData?
    var shippingAddressForm : ViewData?
    
    var billData = UserManager.Instance.getUserInfo()?.billAddress
    var shipData = UserManager.Instance.getUserInfo()?.shipAddress
    
    var radioButtonsParentView = UIView()
    var billRadioButton = RadioButton()
    var shipRadioButton = RadioButton()
    // var itemType = String()
    var dropDownTableView = UITableView()
    var dropDownButtonTagValue = 0
    var customdropDownGestureView = UIButton()
    var dropDownBooleanValue = 1
    var submitButton = ZFRippleButton()
    var guestCheckBool = false
    var newAddress = false
    var shipToDiffAddBool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        if( itemType == "downloadable")
        {
            self.navigationItem.title = "Billing Address".localized().uppercased()
        }
        else
        {
            
            self.navigationItem.title = "Shipping Address".localized().uppercased()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(buyNowViewController.popVie(_:)), name: NSNotification.Name(rawValue: "isLoggedOut"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(buyNowViewController.navigateToDiscountPage(_:)), name: NSNotification.Name(rawValue: "discountView"), object: nil)
        self.shippingAddressForm?.countryCode = "US"
        headerTitleLabel = Utils.createTitleLabel(mainParentScrollView,yposition: 10)
        billAddressParentView = Utils.createImageParentView(mainParentScrollView, titLabel: headerTitleLabel)
        mainParentScrollView.addSubview(headerTitleLabel)
        mainParentScrollView.addSubview(billAddressParentView)
        headerTitleLabel.text = "Please fill the form to complete your order.".localized()
        if (idForSelectedLangauge == Utils.getArebicLanguageCode()) {
            headerTitleLabel.textAlignment = .right
            
        }
        
        shipAddressParentView.frame = billAddressParentView.frame
        
        if(deviceName != "big"){
            headerTitleLabel.frame.size.width = mainParentScrollView.frame.size.width - 40
        }
        
        dropDownTableView.delegate =   self
        dropDownTableView.dataSource =   self
        dropDownTableView.register(UITableViewCell.self, forCellReuseIdentifier: "DropDownCell")
        dropDownTableView.frame = CGRect(x: 20, y: 0, width: mainParentScrollView.frame.size.width - 40, height: 0)
        dropDownTableView.separatorStyle = .singleLine
        dropDownTableView.backgroundColor =  UIColor(red: (144/255.0), green: (144/255.0), blue: (144/255.0), alpha: 1.0)
        
        
        mainParentScrollView.addSubview(dropDownTableView)
        self.fillWithUserAddress()
        
    }
    
    @objc func popVie(_ notification: Notification){
        self.navigationController?.popToRootViewController(animated: false)
        
    }
    
    func fillWithUserAddress(){
        Config.guestCheckIn = false
        self.addLoader()
        let url = WebApiManager.Instance.getBillingAddressURL()
        
        if let userInfo = UserManager.Instance.getUserInfo(){
            if userInfo.billAddress == nil || userInfo.shipAddress == nil{
                Utils.fillTheData(url, callback: self.processBillingAddress, errorCallback : self.showError)
            }else{
                createBillAddressForm()
            }
        }else{
            if(self.billData == nil){
                self.billData =  UserInfo.guestBillAddress
            }
            createBillAddressForm()
        }
    }
    
    func billingError(){
        self.removeLoader()
    }
    
    func processBillingAddress(_ dataDict : NSDictionary){
        defer{self.removeLoader()}
        billData = UserManager.Instance.getUserInfo()?.billAddress
        UserManager.Instance.setBillingAddress(dataDict)
        
        createBillAddressForm()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        customdropDownGestureView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        customdropDownGestureView.backgroundColor = UIColor.clear
        customdropDownGestureView.addTarget(self, action: #selector(buyNowViewController.dropDownGesturebuttonAction), for: .touchUpInside)
        
        if(deviceName == "big"){
            UILabel.appearance().font = UIFont(name: "Lato", size: 18)
        }
        else{
            UILabel.appearance().font = UIFont(name: "Lato", size: 16)
        }
        super.viewWillAppear(animated)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "OptionViewTap"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "selectOptionViewOption"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "discountView"), object: nil)
    }
    
    
    func createBillAddressForm(){
        defer{self.removeLoader()}
        
        billingAddressForm = createForm(billAddressParentView, titleName: "Billing Address".localized(), tag:1, isBilling : guestCheckBool)
        
        if(newAddress == false){
            
            filldata(billingAddressForm, addressData: billData)
        }
        
        self.createRadioandSubmit()
        
    }
    
    func filldata(_ addressForm : ViewData?, addressData : Address?){
        if addressForm == nil || addressData == nil {
            return
        }
        addressForm?.firstNameText.text = addressData?.firstName
        addressForm?.lastNameText.text = addressData?.lastName
        addressForm?.address1.text = addressData?.street.first
        if( (addressData?.street.count)! > 1){
            addressForm?.address2.text = addressData?.street.last
        }
        addressForm?.regionId = (addressData?.region.id)!
        addressForm?.cityText.text = addressData?.city
        addressForm?.zipText.text = addressData?.postCode
        addressForm?.contactNumberText.text = addressData?.telePhone
        addressForm?.emailText?.text = ""
        addressForm?.countryCode = Config.Instance.getCountryCode()
        addressForm?.countryDropDownButton.setTitle(addressData?.getCountryName(), for: UIControl.State())
        if let countryCode = addressData?.countryCode{
            addressForm?.countryCode = countryCode
        }
        
        self.getCountryList(addressForm!)
        addressForm?.stateDropDownButton.setTitle(addressData?.region.name, for: UIControl.State())
        addressForm?.stateName = (addressData?.region.name)!
        
        addressForm?.stateText.text = addressData?.region.name
        if let countryCode = addressForm?.countryCode{
            self.getStateList(countryCode, type: addressForm!)
        }
    }
    
    fileprivate func getCountryList(_ type:ViewData){
        self.setCountry(type.countryCode,type:type)
    }
    
    fileprivate func setCountry(_ id: String,type:ViewData){
        let countryList = LocaleManager.Instance.getCountryList()
        type.countryDropDownButton.setTitle(countryList.filter{$0.id == id}.first?.name, for: UIControl.State())
        self.getStateList(id,type:type)
    }
    
    fileprivate func getStateList(_ countryCode: String, type:ViewData){
        let stateList = LocaleManager.Instance.getStateList(countryCode)
        if !type.stateName.isEmpty{
            if let state = stateList.filter({$0.name == type.stateName}).first{
                
                stateId = state.id
                type.stateDropDownButton.setTitle(state.name, for: UIControl.State())
                type.stateText.isHidden = true
                type.stateText.frame = type.stateDropDownButton.frame
                type.stateDropDownButton.isHidden = false
            }else{
                type.stateText.text = stateList.first?.name
                self.setState(type.stateText.text, type:type)
                type.stateText.isHidden = false
                type.stateDropDownButton.isHidden = true
            }
        }
        
        if stateList.isEmpty{
            type.stateText.isHidden = false
            type.stateDropDownButton.isHidden = true
        }else{
            type.stateText.isHidden = true
            type.stateText.frame = type.stateDropDownButton.frame
            type.stateDropDownButton.isHidden = false
        }
    }
    
    fileprivate func setState(_ name: String?, type:ViewData){
        var localName = name
        if localName == nil {
            localName = ""
        }
        
        type.stateDropDownButton.setTitle(localName, for: UIControl.State())
        type.stateName = localName!
    }
    
    
    func createRadioandSubmit(){
        
        let font = UIFont(name: "Lato", size: 18)
        let borderColor = UIColor.lightGray.cgColor
        let borderWidth:CGFloat = 1
        let cornerRadius:CGFloat = 4
        
        radioButtonsParentView.frame = CGRect(x: headerTitleLabel.frame.origin.x, y: billAddressParentView.frame.origin.y + billAddressParentView.frame.size.height + 10, width: billAddressParentView.frame.size.width - 40, height: 50)
        
        billRadioButton.frame = CGRect(x: 0, y: 0, width: radioButtonsParentView.frame.size.width, height: 40)
        billRadioButton.addTarget(self, action: #selector(buyNowViewController.billRadioButtonAction(_:)), for: UIControl.Event.touchUpInside)
        
        billRadioButton.on()
        billRadioButton.setTitleColor(UIColor.white, for: UIControl.State())
        billRadioButton.layer.borderColor = borderColor
        billRadioButton.layer.borderWidth = borderWidth
        billRadioButton.titleLabel?.font = font
        billRadioButton.setTitle("Billing & Shipping Address".localized(), for: UIControl.State())
        billRadioButton.setTitleColor(UIColor.white, for: UIControl.State())
        billRadioButton.backgroundColor = UIColor(red: (144/255.0), green: (144/255.0), blue: (144/255.0), alpha: 1.0)
        
        billRadioButton.layer.cornerRadius = cornerRadius
        
        billRadioButton.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        
        radioButtonsParentView.addSubview(billRadioButton)
        
        shipRadioButton.frame = CGRect(x: 0, y: billRadioButton.frame.origin.y + billRadioButton.frame.size.height + 5, width: radioButtonsParentView.frame.size.width, height: 40)
        shipRadioButton.addTarget(self, action: #selector(buyNowViewController.shipRadioButtonAction(_:)), for: UIControl.Event.touchUpInside)
        
        shipRadioButton.setTitleColor(UIColor.white, for: UIControl.State())
        shipRadioButton.layer.borderColor = borderColor
        shipRadioButton.layer.borderWidth = borderWidth
        shipRadioButton.titleLabel?.font = font
        shipRadioButton.setTitle("Shipping to different address".localized(), for: UIControl.State())
        shipRadioButton.setTitleColor(UIColor.white, for: UIControl.State())
        shipRadioButton.backgroundColor = UIColor(red: (144/255.0), green: (144/255.0), blue: (144/255.0), alpha: 1.0)
        
        shipRadioButton.layer.cornerRadius = cornerRadius
        
        billRadioButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        shipRadioButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        
        if(idForSelectedLangauge == Utils.getArebicLanguageCode())
        {
            shipRadioButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0);
            shipRadioButton.titleLabel!.transform = CGAffineTransform(scaleX: -1.0, y: 1.0);
            shipRadioButton.imageView!.transform = CGAffineTransform(scaleX: -1.0, y: 1.0);
            
            billRadioButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0);
            billRadioButton.titleLabel!.transform = CGAffineTransform(scaleX: -1.0, y: 1.0);
            billRadioButton.imageView!.transform = CGAffineTransform(scaleX: -1.0, y: 1.0);
        }
        shipRadioButton.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        
        radioButtonsParentView.addSubview(shipRadioButton)
        
        radioButtonsParentView.frame.size.height = shipRadioButton.frame.origin.y + shipRadioButton.frame.size.height + 5
        
        mainParentScrollView.addSubview(radioButtonsParentView)
        
        submitButton.frame = CGRect(x: 15, y: radioButtonsParentView.frame.origin.y + radioButtonsParentView.frame.size.height + 20, width: mainParentScrollView.frame.size.width - 40, height: 40)
        submitButton.addTarget(self, action: #selector(buyNowViewController.submitButtonAction(_:)), for: UIControl.Event.touchUpInside)
        
        submitButton.backgroundColor = Settings().getButtonBgColor()//UIColor(red: (223/255.0), green: (114/255.0), blue: (114/255.0), alpha: 1.0)
        submitButton.layer.cornerRadius = 3.0
        submitButton.setTitle("Submit".localized(), for: UIControl.State())
        submitButton.titleLabel?.font = UIFont(name: "Lato-Bold", size: 20)
        submitButton.titleLabel?.textColor = UIColor(netHex:0xf78f1e)
        submitButton.layer.cornerRadius = cornerRadius
        submitButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
        submitButton.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        mainParentScrollView.addSubview(submitButton)
        
        mainParentScrollView.contentSize.height = submitButton.frame.origin.y + submitButton.frame.size.height + 100
        if(itemType == "downloadable")
        {
            radioButtonsParentView.isHidden = true
        }
    }
    
    @objc func billRadioButtonAction(_ button:UIButton){
        self.FlipButton(button as? FlipFlopButton)
        shipToDiffAddBool = false
        shipAddressParentView.removeFromSuperview()
        
        submitButton.frame.origin.y = radioButtonsParentView.frame.origin.y + radioButtonsParentView.frame.size.height + 20
        mainParentScrollView.contentSize.height = submitButton.frame.origin.y + submitButton.frame.size.height + 100
        
    }
    
    @objc func shipRadioButtonAction(_ button:UIButton){
        self.FlipButton(button as? FlipFlopButton)
        shipToDiffAddBool = true
        for views in shipAddressParentView.subviews{
            views.removeFromSuperview()
        }
        
        shipAddressParentView.frame.origin.y = radioButtonsParentView.frame.origin.y + radioButtonsParentView.frame.height + 10
        
        self.shippingAddressForm  = createForm(shipAddressParentView, titleName: "Shipping Address".localized(), tag:3)
        
        shippingAddressForm?.countryCode = Config.Instance.getCountryCode()
        self.getCountryList(shippingAddressForm!)
        
        filldata(shippingAddressForm, addressData: shipData)
        
        mainParentScrollView.addSubview(shipAddressParentView)
        submitButton.frame.origin.y = shipAddressParentView.frame.origin.y + shipAddressParentView.frame.size.height + 20
        mainParentScrollView.contentSize.height = submitButton.frame.origin.y + submitButton.frame.size.height + 100
    }
    
    @objc func allDropDownButtonAction(_ button:UIButton){
        
        dropDownButtonTagValue = button.tag
        var ypos:CGFloat = 0
        if(dropDownButtonTagValue == 1){
            
            UIView.animate(withDuration: 0.2, animations: {
                self.billingAddressForm?.countryDropDownButton.imageView!.transform = (self.billingAddressForm?.countryDropDownButton.imageView!.transform)!.rotated(by: 180 * CGFloat(Double.pi/180))
            }, completion: { _ in
            })
            ypos = billAddressParentView.frame.origin.y + button.frame.origin.y + button.frame.size.height - 4
        }
        if(dropDownButtonTagValue == 2){
            UIView.animate(withDuration: 0.2, animations: {
                self.billingAddressForm?.stateDropDownButton.imageView!.transform = (self.billingAddressForm?.stateDropDownButton.imageView!.transform)!.rotated(by: 180 * CGFloat(Double.pi/180))
            }, completion: { _ in
            })
            ypos = billAddressParentView.frame.origin.y + button.frame.origin.y + button.frame.size.height - 4
        }
        
        if(dropDownButtonTagValue == 3){
            UIView.animate(withDuration: 0.2, animations: {
                self.shippingAddressForm?.countryDropDownButton.imageView!.transform = (self.shippingAddressForm?.countryDropDownButton.imageView!.transform)!.rotated(by: 180 * CGFloat(Double.pi/180))
            }, completion: { _ in
            })
            ypos = shipAddressParentView.frame.origin.y + button.frame.origin.y + button.frame.size.height - 4
        }
        
        if(dropDownButtonTagValue == 4){
            UIView.animate(withDuration: 0.2, animations: {
                self.shippingAddressForm?.stateDropDownButton.imageView!.transform = (self.shippingAddressForm?.stateDropDownButton.imageView!.transform)!.rotated(by: 180 * CGFloat(Double.pi/180))
            }, completion: { _ in
            })
            ypos = shipAddressParentView.frame.origin.y + button.frame.origin.y + button.frame.size.height - 4
        }
        
        if(dropDownBooleanValue == 0){
            
            customdropDownGestureView.removeFromSuperview()
            
            UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions(), animations: {
                self.dropDownTableView.frame.size.height = 0
            }, completion: { _ in
                self.dropDownTableView.isHidden = true
            })
            
            for allSubViews in self.view.subviews{
                allSubViews.isUserInteractionEnabled = true
            }
            
            navigationItem.titleView?.isUserInteractionEnabled = true
            backButton.isUserInteractionEnabled = true
            menuButton.isUserInteractionEnabled = true
            dropDownBooleanValue = 1
        }
        else{
            customdropDownGestureView.frame.size.height = mainParentScrollView.contentSize.height
            mainParentScrollView.addSubview(customdropDownGestureView)
            mainParentScrollView.addSubview(dropDownTableView)
            dropDownTableView.frame.origin.x = billAddressParentView.frame.origin.x + button.frame.origin.x
            dropDownTableView.frame.size.width = button.frame.width
            dropDownTableView.frame.origin.y = ypos
            UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions(), animations: {
                if self.dropDownButtonTagValue == 1 || self.dropDownButtonTagValue == 3{
                    let countryList = LocaleManager.Instance.getCountryList()
                    self.dropDownTableView.frame.size.height = CGFloat(countryList.count) * self.rowHeight + 15
                }
                    
                else if self.dropDownButtonTagValue == 2{
                    
                    let stateList = LocaleManager.Instance.getStateList((self.billingAddressForm?.countryCode)!)
                    self.dropDownTableView.frame.size.height = CGFloat(stateList.count) * self.rowHeight + 15
                }
                else if self.dropDownButtonTagValue == 4{
                    let stateList = LocaleManager.Instance.getStateList((self.shippingAddressForm?.countryCode)!)
                    self.dropDownTableView.frame.size.height = CGFloat(stateList.count) * self.rowHeight + 15
                }
                
                if(self.dropDownTableView.frame.size.height > 180){
                    self.dropDownTableView.frame.size.height = 180
                }
                
            }, completion: { _ in
                self.dropDownTableView.isHidden = false
            })
            
            dropDownTableView.reloadData()
            navigationItem.titleView?.isUserInteractionEnabled = false
            backButton.isUserInteractionEnabled = false
            menuButton.isUserInteractionEnabled = false
            
            dropDownBooleanValue = 0
            let heightoftableView = dropDownTableView.frame.origin.y + dropDownTableView.frame.size.height
            let heightofsubmitbtn = submitButton.frame.origin.y + submitButton.frame.size.height
            
            if(heightoftableView > heightofsubmitbtn){
                mainParentScrollView.contentSize.height = CGFloat(heightoftableView) + 100
            }
            else{
                mainParentScrollView.contentSize.height = CGFloat(heightofsubmitbtn) + 100
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dropDownButtonTagValue == 1 || dropDownButtonTagValue == 3{
            let countryList = LocaleManager.Instance.getCountryList()
            return countryList.count
        }else if dropDownButtonTagValue == 2{
            let stateList = LocaleManager.Instance.getStateList((billingAddressForm?.countryCode)!)
            return stateList.count
        }
        else if dropDownButtonTagValue == 4{
            let stateList = LocaleManager.Instance.getStateList((shippingAddressForm?.countryCode)!)
            return stateList.count
        }
        else{
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DropDownCell", for: indexPath) as UITableViewCell
        
        let borderLabel = UILabel(frame: CGRect(x: 10, y: cell.frame.size.height - 1, width: cell.frame.size.width - 20, height: 1))
        borderLabel.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        cell.addSubview(borderLabel)
        cell.backgroundColor = UIColor(red: (144/255.0), green: (144/255.0), blue: (144/255.0), alpha: 1.0)
        
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.textAlignment = .center;
        
        if dropDownButtonTagValue == 1{
            let countryList = LocaleManager.Instance.getCountryList()
            if countryList.count > indexPath.row{
                let country = countryList[indexPath.row]
                cell.textLabel?.text = country.name
                //billingAddressForm!.countryCode = country.id
            }
        } else if(dropDownButtonTagValue == 2){
            let stateList = LocaleManager.Instance.getStateList(billingAddressForm!.countryCode)
            if stateList.count > indexPath.row{
                cell.textLabel?.text = stateList[indexPath.row].name
            }
        }
        else if dropDownButtonTagValue == 3{
            let countryList = LocaleManager.Instance.getCountryList()
            if countryList.count > indexPath.row{
                let country = countryList[indexPath.row]
                cell.textLabel?.text = country.name
                //shippingAddressForm!.countryCode = country.id
            }
            
        } else if(dropDownButtonTagValue == 4){
            let stateList = LocaleManager.Instance.getStateList(shippingAddressForm!.countryCode)
            if stateList.count > indexPath.row{
                cell.textLabel?.text = stateList[indexPath.row].name
            }
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if(dropDownButtonTagValue == 1){
            let countryList = LocaleManager.Instance.getCountryList()
            if countryList.count > indexPath.row && billingAddressForm != nil{
                billingAddressForm!.countryDropDownButton.setTitle(countryList[indexPath.row].name, for: UIControl.State())
                let country = countryList[indexPath.row]
                billingAddressForm?.countryCode = country.id
                billingAddressForm?.stateText.text = ""
                billingAddressForm?.stateName = ""
                billingAddressForm?.stateDropDownButton.setTitle("State".localized(), for: UIControl.State())
                self.getStateList(country.id, type: billingAddressForm!)
            }
        }
            
        else if(dropDownButtonTagValue == 2){
            if billingAddressForm != nil {
                let stateList = LocaleManager.Instance.getStateList(billingAddressForm!.countryCode)
                if stateList.count > indexPath.row{
                    billingAddressForm!.stateDropDownButton.setTitle(stateList[indexPath.row].name, for: UIControl.State())
                    stateId = stateList[indexPath.row].id
                    billingAddressForm?.stateText.text = billingAddressForm!.stateDropDownButton.titleLabel?.text
                    let region = stateList[indexPath.row]
                    billingAddressForm?.stateRegion = AddressRegion(id: 0, code: region.id, name: region.name)
                }
            }
        }
            
        else if(dropDownButtonTagValue == 3){
            let countryList = LocaleManager.Instance.getCountryList()
            if countryList.count > indexPath.row && shippingAddressForm != nil{
                shippingAddressForm!.countryDropDownButton.setTitle(countryList[indexPath.row].name, for: UIControl.State())
                let country = countryList[indexPath.row]
                shippingAddressForm!.countryCode = country.id
                shippingAddressForm?.stateText.text = ""
                shippingAddressForm!.stateName = ""
                shippingAddressForm!.stateDropDownButton.setTitle("State".localized(), for: UIControl.State())
                self.getStateList(country.id, type: shippingAddressForm!)
            }
        }
            
        else if(dropDownButtonTagValue == 4){
            if shippingAddressForm != nil{
                let stateList = LocaleManager.Instance.getStateList(shippingAddressForm!.countryCode)
                if stateList.count > indexPath.row{
                    shippingAddressForm!.stateDropDownButton.setTitle(stateList[indexPath.row].name, for: UIControl.State())
                    shippingAddressForm?.stateText.text = shippingAddressForm!.stateDropDownButton.titleLabel?.text
                    let region = stateList[indexPath.row]
                    shippingAddressForm?.stateRegion = AddressRegion(id: 0, code: region.id, name: region.name)
                }
            }}
        
        dropDownGesturebuttonAction()
        
    }
    
    @objc func dropDownGesturebuttonAction(){
        dropDownBooleanValue = 0
        let btn = UIButton()
        btn.tag = dropDownButtonTagValue
        allDropDownButtonAction(btn)
    }
    
    @objc func submitButtonAction(_ button:ZFRippleButton){
        assert(billingAddressForm != nil)
        if !validateForm(billingAddressForm!){
            return
        }
        
        var billAddressRegion = AddressRegion(id: 0, code: (billingAddressForm?.stateText.text)!, name: (billingAddressForm?.stateText.text)!)

        if let region = billingAddressForm?.stateRegion{
            billAddressRegion = region
        }
        
        let billaddress = Address(id : -1, firstName: billingAddressForm!.firstNameText.text!, lastName: billingAddressForm!.lastNameText.text!, telePhone: billingAddressForm!.contactNumberText.text!, street: [billingAddressForm!.address1.text!,billingAddressForm!.address2.text!], city: billingAddressForm!.cityText.text!, regionId : billAddressRegion.id, region: billAddressRegion, postCode: billingAddressForm!.zipText.text!, countryCode: (billingAddressForm?.countryCode)!)
        
        if(shipToDiffAddBool == true){
            assert(shippingAddressForm != nil)
            
            if !validateForm(shippingAddressForm!){
                return
            }else{
                var shipAddressRegion = AddressRegion(id: 0, code: (shippingAddressForm?.stateText.text)!, name: (shippingAddressForm?.stateText.text)!)
                
                if let region = shippingAddressForm?.stateRegion{
                    shipAddressRegion = region
                }
                
                let shipaddress = Address(id : -1, firstName: shippingAddressForm!.firstNameText.text!, lastName: shippingAddressForm!.lastNameText.text!, telePhone: shippingAddressForm!.contactNumberText.text!, street: [shippingAddressForm!.address1.text!, shippingAddressForm!.address2.text!], city: shippingAddressForm!.cityText.text!, regionId : shipAddressRegion.id, region: shipAddressRegion , postCode: shippingAddressForm!.zipText.text!, countryCode: (shippingAddressForm?.countryCode)!)
                
                if guestCheckBool{
                    UserInfo.guestBillAddress = billaddress
                    UserInfo.guestShipAddress = shipaddress
                    self.dicountPage()
                }else{
                    
                    self.addLoader()
                    Address.addAddress(billaddress)
                    UserManager.Instance.getUserInfo()?.billAddress = billaddress
                    
                    Address.addAddress(shipaddress)
                    UserManager.Instance.getUserInfo()?.shipAddress = shipaddress
                }
            }
        }else{
            if guestCheckBool{
                UserInfo.guestBillAddress = billaddress
                UserInfo.guestShipAddress = billaddress
                self.dicountPage()
            }else{
                
                self.addLoader()
                Address.addAddress(billaddress)
                UserManager.Instance.getUserInfo()?.billAddress = billaddress
                UserManager.Instance.getUserInfo()?.shipAddress = billaddress
            }
        }
        //self.dicountPage()
    }
    @objc func navigateToDiscountPage(_ notification: Notification){
       
        self.removeLoader()
        self.dicountPage()
    }
   
    func validateForm(_ type:ViewData)-> Bool{
        
        if !self.checkForOnlyAlpha((type.firstNameText), text: "First Name".localized()){
            defer{self.removeLoader()}
            return false
        }
        
        if !self.checkForOnlyAlpha((type.lastNameText), text: "Last Name".localized()){
            defer{self.removeLoader()}
            return false
        }
        
        if !self.checkForOnlyNumericHyphen((type.contactNumberText), text: "Contact Number".localized()){
            defer{self.removeLoader()}
            return false
        }
        
        if(guestCheckBool == true){
            if(billingAddressForm?.emailText?.text != nil && billingAddressForm?.emailText?.text != ""){
                if !Utils.isValidEmail((billingAddressForm?.emailText?.text)!){
                    defer{self.removeLoader()}
                    alert("Email is not correct".localized())
                    return false
                }
            }
                
            else{
                defer{self.removeLoader()}
                alert("Email is required".localized())
                return false
            }
        }
        
        if !self.checkForAddress((type.address1), text: "Address".localized()){
            defer{self.removeLoader()}
            return false
        }
        
        if !self.checkForOnlyAlpha((type.stateText), text: "State".localized()){
            defer{self.removeLoader()}
            return false
        }
        
        if !self.checkForOnlyAlpha((type.cityText), text: "City".localized()){
            defer{self.removeLoader()}
            return false
        }
        
        if !self.checkForPin((type.zipText), text: "Zipcode".localized()){
            defer{self.removeLoader()}
            return false
        }
        return true
    }
    
    func dicountPage(){
        Config.guestCheckIn = guestCheckBool
        let discountViewObject = self.storyboard?.instantiateViewController(withIdentifier: "discountViewController") as? discountViewController
        discountViewObject?.shipBooleanValue = shipToDiffAddBool
        discountViewObject?.cart = self.cart
        self.navigationController?.pushViewController(discountViewObject!, animated: true)
        do{self.removeLoader()}
    }
    
    func backButtonFunction(){
        
        self.tabBarController?.selectedIndex = 3
        self.navigationController?.popToRootViewController(animated: true)
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func createTextFieldDelegate(_ textField: UITextField){
        textField.delegate = self
    }
    
    func createTextFieldButtons(_ textField: UITextField){
        textField.addTarget(self, action: #selector(buyNowViewController.myTargetEditingDidBeginFunction(_:)), for: UIControl.Event.editingDidBegin)
        textField.addTarget(self, action: #selector(buyNowViewController.myTargetEditingDidEndFunction(_:)), for: UIControl.Event.editingDidEnd)
    }
    
    @objc func myTargetEditingDidBeginFunction(_ textField: UITextField) {
        
        //mainParentScrollView.frame.origin.y -= 150
    }
    @objc func myTargetEditingDidEndFunction(_ textField: UITextField) {
        // mainParentScrollView.frame.origin.y += 150
    }
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Design %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    func createLabel(_ field:UIView)->UILabel{
        let label = UILabel(frame: CGRect(x: headerTitleLabel.frame.origin.x, y: field.frame.origin.y + field.frame.size.height + 10, width: billAddressParentView.frame.width - 40, height: 35))
        label.textColor = UIColor(red: (144/255.0), green: (144/255.0), blue: (144/255.0), alpha: 1.0)
        if (idForSelectedLangauge == Utils.getArebicLanguageCode()) {
            label.textAlignment = .right
        }
        
        return label
    }
    
    func createTextfield(_ field:UIView)->UITextField{
        let spaceLabel1 = UILabel()
        spaceLabel1.frame = CGRect(x: 10, y: 0, width: 7, height: 26)
        spaceLabel1.backgroundColor = UIColor.clear
        let textbox = UITextField(frame: CGRect(x: headerTitleLabel.frame.origin.x, y: field.frame.origin.y + field.frame.height + 10, width: billAddressParentView.frame.width - 40, height: 40))
        textbox.layer.borderColor = UIColor.lightGray.cgColor
        textbox.layer.borderWidth = 1
        textbox.font = UIFont(name: "Lato", size: 17)
        textbox.textColor = UIColor.black
        //textbox.textColor = UIColor(red: (144/255.0), green: (144/255.0), blue: (144/255.0), alpha: 1.0)
        textbox.backgroundColor = UIColor.white
        textbox.layer.cornerRadius = 4
        textbox.leftView = spaceLabel1
        textbox.leftViewMode = UITextField.ViewMode.always
        textbox.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        if (idForSelectedLangauge == Utils.getArebicLanguageCode()) {
            textbox.textAlignment = .right
        }
        createTextFieldDelegate(textbox)
        return textbox
    }
    func createDropDownBtns(_ field:UIView)->UIButton{
        
        let btn = UIButton(frame: CGRect(x: headerTitleLabel.frame.origin.x, y: field.frame.origin.y + field.frame.height + 10, width: billAddressParentView.frame.width - 40, height: 35))
        btn.setTitleColor(UIColor.white, for: UIControl.State())
        btn.backgroundColor = UIColor(red: (144/255.0), green: (144/255.0), blue: (144/255.0), alpha: 1.0)
        
        btn.layer.cornerRadius = 4
        btn.addTarget(self, action: #selector(buyNowViewController.allDropDownButtonAction(_:)), for: UIControl.Event.touchUpInside)
        let Imgright = UIImage(named: "arrow-down-white.png")
        if Imgright != nil {
            btn.setImage(Imgright, for: UIControl.State())
            btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: btn.frame.size.width - (Imgright!.size.width)-10 , bottom: 0, right: 0)
        }
        //   btn.setImage(Imgright, forState: UIControlState.Normal)
        btn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
        btn.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        // btn.imageEdgeInsets = UIEdgeInsetsMake(0, btn.frame.size.width - (Imgright!.size.width)-10 , 0, 0)
        
        return btn
    }
    
    
    func createForm(_ parentView:UIView,titleName:String,tag:Int, isBilling : Bool = false)->ViewData{
        
        let viewData = ViewData()
        let view = parentView
        let title = UILabel()
        title.frame = CGRect(x: headerTitleLabel.frame.origin.x, y: 5, width: view.frame.width - 40, height: 35)
        title.textColor = UIColor.black
        if (idForSelectedLangauge == Utils.getArebicLanguageCode()) {
            title.textAlignment = .right
        }
        
        title.text = titleName
        view.addSubview(title)
        
        let fnLabel = createLabel(title)
        fnLabel.text = "First Name".localized()
        view.addSubview(fnLabel)
        viewData.firstNameText = createTextfield(fnLabel)
        
        view.addSubview(viewData.firstNameText)
        
        let lnLabel = createLabel(viewData.firstNameText)
        lnLabel.text = "Last Name".localized()
        view.addSubview(lnLabel)
        viewData.lastNameText = createTextfield(lnLabel)
        
        view.addSubview(viewData.lastNameText)
        
        let phoLabel = createLabel(viewData.lastNameText)
        phoLabel.text = "Contact Number".localized()
        view.addSubview(phoLabel)
        viewData.contactNumberText = createTextfield(phoLabel)
        view.addSubview(viewData.contactNumberText)
        
        var lastField = viewData.contactNumberText
        
        if isBilling{
            let emailLabel = createLabel(lastField)
            emailLabel.text = "Email".localized()
            view.addSubview(emailLabel)
            viewData.emailText = createTextfield(emailLabel)
            viewData.emailText?.keyboardType = UIKeyboardType.emailAddress
            assert(viewData.emailText != nil)
            
            view.addSubview(viewData.emailText!)
            
            lastField = viewData.emailText!
        }
        
        let addLabel = createLabel(lastField)
        
        addLabel.text = "Address 1".localized()
        view.addSubview(addLabel)
        
        viewData.address1 = createTextfield(addLabel)
        view.addSubview(viewData.address1)
        
        
        
        let add2Label = createLabel(viewData.address1)
        
        add2Label.text = "Address 2".localized()
        view.addSubview(add2Label)
        
        viewData.address2 = createTextfield(add2Label)
        view.addSubview(viewData.address2 )
        
        let cityLabel = createLabel( viewData.address2 )
        
        cityLabel.text = "City".localized()
        view.addSubview(cityLabel)
        viewData.cityText = createTextfield(cityLabel)
        view.addSubview(viewData.cityText)
        
        let Country = createLabel(viewData.cityText)
        
        Country.text = "Country".localized()
        view.addSubview(Country)
        viewData.countryDropDownButton = createDropDownBtns(Country)
        _ = LocaleManager.Instance.getCountryList()
        let countryName = LocaleManager.Instance.getCountryNameByCode(viewData.countryCode)
        viewData.countryDropDownButton.setTitle(countryName, for: UIControl.State())
        
        viewData.countryDropDownButton.tag = tag
        view.addSubview(viewData.countryDropDownButton)
        
        let state = createLabel(viewData.countryDropDownButton)
        state.text = "State".localized()
        view.addSubview(state)
        viewData.stateDropDownButton = createDropDownBtns(state)
        viewData.stateDropDownButton.setTitle("State".localized(), for: UIControl.State())
        viewData.stateDropDownButton.tag = tag + 1
        view.addSubview(viewData.stateDropDownButton)
        viewData.stateText = createTextfield(state)
        viewData.stateText.isHidden = true
        view.addSubview(viewData.stateText)
        
        let zipLabel = createLabel(viewData.stateDropDownButton)
        zipLabel.text = "Zipcode".localized()
        view.addSubview(zipLabel)
        viewData.zipText = createTextfield(zipLabel)
        createTextFieldButtons(viewData.zipText)
        view.addSubview(viewData.zipText)
        
        view.frame.size.height = viewData.zipText.frame.origin.y + viewData.zipText.frame.size.height + 10
        
        return viewData
    }
}

