//
//  sample.swift
//  Mofluid
//
//  Created by sudeep goyal on 10/09/15.
//  Copyright © 2015 Mofluid. All rights reserved.
//

import UIKit
import Foundation

class editProfileViewController: PageViewController, UITableViewDataSource,UITableViewDelegate{
    
    let rowHeight : CGFloat = 40
    var address : Address? = nil
    var addressType : AddressType = .billing
    var titleParentView = UIView()
    var firstNameText = UITextField()
    var lastNameText = UITextField()
    var contactNumberText = UITextField()
    var address1Text = UITextField()
    var address2Text = UITextField()
    var cityText = UITextField()
    var countryDropDownButton = UIButton()
    var countryTextField = UITextField()
    var stateDropDownButton = UIButton()
    var stateTextField = UITextField()
    var zipText = UITextField()
    var countryCode = "US"
    var stateCode = ""
    
    var dropDownTableView = UITableView()
    var dropDownButtonTagValue = 0
    var customdropDownGestureView = UIButton()
    var dropDownBooleanValue = 1
    
    var updateButton = ZFRippleButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Edit Profile".localized().uppercased()
        titleParentView.frame = CGRect(x: 0, y: 0, width: mainParentScrollView.frame.width, height: 60)
        titleParentView.backgroundColor = UIColor(netHex:0xeaeaea)
        let titleLabel = Utils.createTitleLabel(mainParentScrollView,yposition: 15)
        self.addText(titleLabel)
        titleParentView.addSubview(titleLabel)
        mainParentScrollView.addSubview(titleParentView)
        
        updateButton.frame = CGRect(x: 20, y: 20, width: mainParentScrollView.frame.width - 40, height: 38)
        updateButton.addTarget(self, action: #selector(editProfileViewController.updateButtonAction(_:)), for: UIControl.Event.touchUpInside)
        updateButton.backgroundColor = UIColor(red: (144/255.0), green: (144/255.0), blue: (144/255.0), alpha: 1.0)
        updateButton.layer.cornerRadius = 3.0
        updateButton.setTitle("Update".localized(), for: UIControl.State())
        updateButton.titleLabel?.font = UIFont(name: "Lato", size: 20)
        updateButton.titleLabel?.textColor = UIColor(netHex:0xf78f1e)
        mainParentScrollView.addSubview(updateButton)
        
        dropDownTableView.delegate =   self
        dropDownTableView.dataSource =   self
        dropDownTableView.register(UITableViewCell.self, forCellReuseIdentifier: "DropDownCell")
        dropDownTableView.frame = CGRect(x: 20, y: 0, width: mainParentScrollView.frame.size.width/2 - 40, height: 0)
        dropDownTableView.separatorStyle = .none
        dropDownTableView.backgroundColor = UIColor.darkGray
        mainParentScrollView.addSubview(dropDownTableView)
        
        createAddressForm()
        
        createTextFieldButtons(cityText)
        createTextFieldButtons(zipText)
        createTextFieldButtons(contactNumberText)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        customdropDownGestureView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        customdropDownGestureView.backgroundColor = UIColor.clear
        customdropDownGestureView.addTarget(self, action: #selector(editProfileViewController.dropDownGesturebuttonAction), for: .touchUpInside)
        
//        if(deviceName == "big"){
//            UILabel.appearance().font = UIFont(name: "Lato", size: 20)
//        }
//        else{
//            UILabel.appearance().font = UIFont(name: "Lato", size: 15)
//        }
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "OptionViewTap"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "selectOptionViewOption"), object: nil)
        
    }
    
    
    fileprivate func addText(_ titleLabel : UILabel){
        switch self.addressType{
        case .billing:
            titleLabel.text = "Billing Address".localized()
        case .shipping:
            titleLabel.text = "Shipping Address".localized()
        }
    }
    
    func createAddressForm(){
        let billTitleLabel = UILabel()
        billTitleLabel.frame = CGRect(x: 20, y: titleParentView.frame.origin.y + titleParentView.frame.height + 10, width: mainParentScrollView.frame.width - 40, height: 35)
        billTitleLabel.textColor = UIColor.black
        billTitleLabel.text = "Edit Address".localized()
        mainParentScrollView.addSubview(billTitleLabel)
        
        let firstNameLabel = Utils.titleLabels(billTitleLabel)
        firstNameLabel.attributedText = createStar("First Name*".localized())
        mainParentScrollView.addSubview(firstNameLabel)
        
        firstNameText = Utils.titleTextFields(firstNameLabel)
        firstNameText.delegate = self
        mainParentScrollView.addSubview(firstNameText)
        
        let lastNameLabel = Utils.titleLabels(firstNameText)
        lastNameLabel.attributedText = createStar("Last Name*".localized())
        mainParentScrollView.addSubview(lastNameLabel)
        lastNameText = Utils.titleTextFields(lastNameLabel)
        lastNameText.delegate = self
        mainParentScrollView.addSubview(lastNameText)
        
        
        
        let addressLabel = Utils.titleLabels(lastNameText)
        addressLabel.attributedText = createStar("Street Address*".localized())
        mainParentScrollView.addSubview(addressLabel)
        
        address1Text = Utils.titleTextFields(addressLabel)
        address1Text.delegate = self
        mainParentScrollView.addSubview(address1Text)
        
        let address2Label = Utils.titleLabels(address1Text)
        address2Label.text = "Street Address 2".localized()
        address2Label.font = UIFont(name: "Lato", size: 16)
        mainParentScrollView.addSubview(address2Label)
        
        address2Text = Utils.titleTextFields(address2Label)
        address2Text.delegate = self
        mainParentScrollView.addSubview(address2Text)
        
        let xandwidthPosition = mainParentScrollView.frame.size.width/2
        
        let countryLabel = Utils.titleLabels(address2Text)
        countryLabel.frame = CGRect(x: 20, y: address2Text.frame.origin.y + address2Text.frame.height + 10, width: xandwidthPosition - 40, height: 35)
        countryLabel.attributedText = createStar("Country*".localized())
        mainParentScrollView.addSubview(countryLabel)
        
        countryDropDownButton.frame = CGRect(x: 20, y: countryLabel.frame.origin.y + countryLabel.frame.height + 10, width: xandwidthPosition - 40, height: 38)
        countryDropDownButton.titleLabel?.font = UIFont(name: "Lato", size: 16)
        countryDropDownButton.titleLabel?.textAlignment = .left;
        countryDropDownButton.setTitle("Country".localized(), for: UIControl.State())
        countryDropDownButton.setTitleColor(UIColor.white, for: UIControl.State())
        countryDropDownButton.backgroundColor = UIColor.darkGray
        countryDropDownButton.layer.cornerRadius = 4
        countryDropDownButton.addTarget(self, action: #selector(editProfileViewController.allDropDownButtonAction(_:)), for: UIControl.Event.touchUpInside)
        let Imgright = UIImage(named: "arrow-down-white.png")
        countryDropDownButton.setImage(Imgright, for: UIControl.State())
        countryDropDownButton.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        countryDropDownButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: countryDropDownButton.frame.size.width - (Imgright!.size.width)-10 , bottom: 0, right: 0)
        countryDropDownButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: (Imgright!.size.width)+15)
        countryDropDownButton.tag = 1
        mainParentScrollView.addSubview(countryDropDownButton)
        
        let stateLabel = Utils.titleLabels(address2Text)
        stateLabel.frame = CGRect(x: xandwidthPosition + 20, y: address2Text.frame.origin.y + address2Text.frame.height + 10, width: xandwidthPosition - 40, height: 35)
        stateLabel.attributedText = createStar("State*".localized())
        mainParentScrollView.addSubview(stateLabel)
        
        stateTextField = Utils.titleTextFields(stateLabel)
        stateTextField.frame = CGRect(x: xandwidthPosition + 20, y: stateLabel.frame.origin.y + stateLabel.frame.height + 10, width: xandwidthPosition - 40, height: 38)
        stateTextField.delegate = self
        stateTextField.isHidden = true
        mainParentScrollView.addSubview(stateTextField)
        
        stateDropDownButton.frame = CGRect(x: xandwidthPosition + 20, y: stateLabel.frame.origin.y + stateLabel.frame.height + 10, width: xandwidthPosition - 40, height: 38)
        stateDropDownButton.frame.origin.y = stateLabel.frame.origin.y + stateLabel.frame.size.height + 10
        stateDropDownButton.frame.origin.x = stateLabel.frame.origin.x
        stateLabel.frame.size.width = countryLabel.frame.size.width
        stateDropDownButton.titleLabel?.font = UIFont(name: "Lato", size: 16)
        stateDropDownButton.setTitle("State".localized(), for: UIControl.State())
        stateDropDownButton.setTitleColor(UIColor.white, for: UIControl.State())
        stateDropDownButton.backgroundColor = UIColor.darkGray
        stateDropDownButton.titleLabel?.textAlignment = .left;
        stateDropDownButton.layer.cornerRadius = 4
        stateDropDownButton.addTarget(self, action: #selector(editProfileViewController.allDropDownButtonAction(_:)), for: UIControl.Event.touchUpInside)
        stateDropDownButton.setImage(Imgright, for: UIControl.State())
        stateDropDownButton.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        stateDropDownButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: stateDropDownButton.frame.size.width - (Imgright!.size.width)-10 , bottom: 0, right: 0)
        stateDropDownButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: (Imgright!.size.width)+15)
        stateDropDownButton.tag = 2
        mainParentScrollView.addSubview(stateDropDownButton)
        
        let cityLabel = Utils.titleLabels(countryDropDownButton)
        cityLabel.attributedText = createStar("City*".localized())
        mainParentScrollView.addSubview(cityLabel)
        cityText = Utils.titleTextFields(cityLabel)
        cityText.delegate = self
        mainParentScrollView.addSubview(cityText)
        
        let zipLabel = Utils.titleLabels(countryDropDownButton)
        zipLabel.frame.origin.x = stateLabel.frame.origin.x
        zipLabel.frame.size.width = countryLabel.frame.size.width
        zipLabel.attributedText = createStar("Zipcode*".localized())
        mainParentScrollView.addSubview(zipLabel)
        zipText = Utils.titleTextFields(zipLabel)
        zipText.frame.origin.x = zipLabel.frame.origin.x
        zipText.delegate = self
        mainParentScrollView.addSubview(zipText)
        
        let contactNumberLabel = Utils.titleLabels(firstNameText)
        contactNumberLabel.attributedText = createStar("Contact Number*".localized())
        contactNumberLabel.frame.origin.y = cityText.frame.origin.y + cityText.frame.height + 10
        mainParentScrollView.addSubview(contactNumberLabel)
        contactNumberText = Utils.titleTextFields(contactNumberLabel)
        contactNumberText.delegate = self
        mainParentScrollView.addSubview(contactNumberText)
        
        updateButton.frame.origin.y = contactNumberText.frame.origin.y + contactNumberText.frame.height + 20
        
        mainParentScrollView.contentSize.height = updateButton.frame.origin.y + updateButton.frame.height + 100
        
        if idForSelectedLangauge == Utils.getArebicLanguageCode() {
            billTitleLabel.textAlignment = .right
            firstNameLabel.textAlignment = .right
            firstNameText.textAlignment  = .right
            lastNameLabel.textAlignment  = .right
            lastNameText.textAlignment   = .right
            addressLabel.textAlignment   = .right
            address1Text.textAlignment   = .right
            address2Label.textAlignment  = .right
            address2Text.textAlignment   = .right
            countryLabel.textAlignment   = .right
            stateLabel.textAlignment     = .right
            stateTextField.textAlignment = .right
            cityLabel.textAlignment      = .right
            cityText.textAlignment       = .right
            zipLabel.textAlignment       = .right
            zipText.textAlignment        = .right
            contactNumberLabel.textAlignment = .right
            contactNumberText.textAlignment  = .right
        }
        
        fillingFields()
    }
    
    func fillingFields(){
        switch self.addressType{
        case .billing:
            if let address = UserManager.Instance.getUserInfo()?.billAddress{
                populateAddress(address: address)
            }
        case .shipping:
            if let address = UserManager.Instance.getUserInfo()?.shipAddress{
                populateAddress(address: address)
            }
        }
    }
    
    func populateAddress(address : Address){
        firstNameText.text = address.firstName
        lastNameText.text = address.lastName
        if(address.street.count > 0){
            address1Text.text = address.street.first!
            if(address.street.count > 1){
                address2Text.text = address.street.last!
            }
        }
        
        cityText.text = address.city
        zipText.text = address.postCode
        contactNumberText.text = address.telePhone
        countryDropDownButton.setTitle(address.getCountryName(), for: UIControl.State())
        self.countryTextField.text = address.getCountryName()
        countryCode = address.countryCode
        stateDropDownButton.setTitle(address.region.name, for: UIControl.State())
        stateCode = address.region.code
        stateTextField.text = address.region.name
    }
    
    fileprivate func getCountryList(){
        self.setCountry(countryCode)
    }
    
    fileprivate func setCountry(_ id: String){
        let countryList = LocaleManager.Instance.getCountryList()
        self.countryDropDownButton.setTitle(countryList.filter{$0.id == id}.first?.name, for: UIControl.State())
        self.getStateList(id)
    }
    
    fileprivate func setState(_ name: String?){
        self.stateDropDownButton.setTitle(name, for: UIControl.State())
    }
    
    fileprivate func getStateList(_ countryCode: String){
        let stateList = LocaleManager.Instance.getStateList(countryCode)
          if self.stateTextField.text != nil && self.stateTextField.text!.isEmpty{
            self.stateTextField.text = stateList.first?.name
            self.stateCode = self.stateTextField.text!
        }
        
        if stateList.isEmpty{
            self.stateTextField.isHidden = false
            self.stateDropDownButton.isHidden = true
        }else{
            self.stateTextField.isHidden = true
            self.stateTextField.frame = self.stateDropDownButton.frame
            self.stateDropDownButton.isHidden = false
        }
        
        self.setState(self.stateTextField.text)
    }
    
    
    
    @objc func allDropDownButtonAction(_ button:UIButton){
        dropDownButtonTagValue = button.tag
        var ypos:CGFloat = 0
        if(dropDownButtonTagValue == 1){
            UIView.animate(withDuration: 0.2, animations: {
                self.countryDropDownButton.imageView!.transform = self.countryDropDownButton.imageView!.transform.rotated(by: 180 * CGFloat(Double.pi/180))
                }, completion: { _ in
            })
            ypos =  button.frame.origin.y + button.frame.size.height - 3
        }
        if(dropDownButtonTagValue == 2){
            UIView.animate(withDuration: 0.2, animations: {
                self.stateDropDownButton.imageView!.transform = self.stateDropDownButton.imageView!.transform.rotated(by: 180 * CGFloat(Double.pi/180))
                }, completion: { _ in
            })
            ypos =  button.frame.origin.y + button.frame.size.height - 3
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
            
            dropDownTableView.frame.origin.x = button.frame.origin.x
            dropDownTableView.frame.size.width = button.frame.width
            mainParentScrollView.addSubview(dropDownTableView)
            
            dropDownTableView.frame.origin.y = ypos
            UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions(), animations: {
                if self.dropDownButtonTagValue == 1{
                    let countryList = LocaleManager.Instance.getCountryList()
                    self.dropDownTableView.frame.size.height = CGFloat(countryList.count) * self.rowHeight + 15
                }else if self.dropDownButtonTagValue == 2{
                    let stateList = LocaleManager.Instance.getStateList(self.countryCode)
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
            let heightofsubmitbtn = updateButton.frame.origin.y + updateButton.frame.size.height
            
            if(heightoftableView > heightofsubmitbtn){
                mainParentScrollView.contentSize.height = CGFloat(heightoftableView) + 100
            }
            else{
                mainParentScrollView.contentSize.height = CGFloat(heightofsubmitbtn) + 100
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dropDownButtonTagValue == 1{
            let countryList = LocaleManager.Instance.getCountryList()
            return countryList.count
        }else{
            let stateList = LocaleManager.Instance.getStateList(self.countryCode)
            
            return stateList.count
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
        cell.backgroundColor = UIColor.darkGray
        cell.textLabel?.textColor = UIColor.white
        
        if dropDownButtonTagValue == 1{
            
            let countryList = LocaleManager.Instance.getCountryList()
            if countryList.count > indexPath.row{
                let country = countryList[indexPath.row]
                cell.textLabel?.text = country.name
                self.countryCode = country.id
            }
        }
            
        else if(dropDownButtonTagValue == 2){
            let stateList = LocaleManager.Instance.getStateList(self.countryCode)
            if stateList.count > indexPath.row{
                cell.textLabel?.text = stateList[indexPath.row].name
                self.stateTextField.text = stateList[indexPath.row].name
            }
        }
        
        cell.textLabel?.textAlignment = .center;
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.rowHeight
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if(dropDownButtonTagValue == 1){
            let countryList = LocaleManager.Instance.getCountryList()
            if countryList.count > indexPath.row{
                countryDropDownButton.setTitle(countryList[indexPath.row].name, for: UIControl.State())
                let country = countryList[indexPath.row]
                self.countryCode = country.id
                self.stateTextField.text = ""
                self.stateCode = ""
                stateDropDownButton.setTitle("State".localized(), for: UIControl.State())
                self.getStateList(country.id)
            }
        }
            
        else if(dropDownButtonTagValue == 2){
            let stateList = LocaleManager.Instance.getStateList(self.countryCode)
            if stateList.count > indexPath.row{
                stateDropDownButton.setTitle(stateList[indexPath.row].name, for: UIControl.State())
                self.stateTextField.text = stateList[indexPath.row].name
            }
        }
        
        dropDownGesturebuttonAction()
        
    }
    
    @objc func dropDownGesturebuttonAction(){
        dropDownBooleanValue = 0
        let btn = UIButton()
        btn.tag = dropDownButtonTagValue
        allDropDownButtonAction(btn)
    }
    
    @objc func updateButtonAction(_ button:ZFRippleButton){
        if !self.checkForOnlyAlpha(firstNameText, text: "First Name".localized()){
            return
        }
        
        if !self.checkForOnlyAlpha(self.lastNameText, text: "Last Name".localized()){
            return
        }
        
        if !self.checkForStreet(self.address1Text, text: "Address".localized()){
            return
        }
        
        if !self.checkForOnlyAlpha(self.stateTextField, text: "State".localized()){
            return
        }
        
        if !self.checkForOnlyAlpha(self.cityText, text: "City".localized()){
            return
        }
        
        if !self.checkForPin(self.zipText, text: "Zipcode".localized()){
            return
        }
        if !self.checkForOnlyNumericHyphen(self.contactNumberText, text: "Contact Number".localized()){
            return
        }
        
        guard let _ = UserManager.Instance.getUserInfo() else{
            return
        }
        
        var id = -1
        if let billAddress = UserManager.Instance.getUserInfo()?.billAddress{
            id = billAddress.id
        }
        let addressRegion = AddressRegion(id: 0, code: self.stateTextField.text!, name: self.stateTextField.text!)
        
        let address = Address(id : id, firstName: firstNameText.text!, lastName: lastNameText.text!, telePhone: contactNumberText.text!, street: [address1Text.text!, address2Text.text!], city: cityText.text!, regionId : addressRegion.id, region:addressRegion, postCode: zipText.text!, countryCode: self.countryCode)
        
        Address.addAddress(address)
        UserDefaults.standard.set(true, forKey: "isUpdatedSuccess")
        
        switch self.addressType{
        case .billing:
            UserManager.Instance.getUserInfo()?.billAddress = address
        case .shipping:
            UserManager.Instance.getUserInfo()?.shipAddress = address
        }
        
         backButtonFunction()
    }
    
    func backButtonFunction(){
        self.navigationController?.popViewController(animated: true)
    }
    
    fileprivate func createStar(_ str: String)->NSMutableAttributedString{
        let myMutableString = NSMutableAttributedString(string: str, attributes: [NSAttributedString.Key.font:UIFont(name: "Lato", size: 16)!])
        
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSRange(location:str.count-1,length:1))
        
        return myMutableString
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func createTextFieldButtons(_ textField: UITextField){
        textField.addTarget(self, action: #selector(editProfileViewController.myTargetEditingDidBeginFunction(_:)), for: UIControl.Event.editingDidBegin)
        textField.addTarget(self, action: #selector(editProfileViewController.myTargetEditingDidEndFunction(_:)), for: UIControl.Event.editingDidEnd)
    }
    
    @objc func myTargetEditingDidBeginFunction(_ textField: UITextField) {
        //  mainParentScrollView.frame.origin.y -= 150
    }
    
    
    @objc func myTargetEditingDidEndFunction(_ textField: UITextField) {
        //  mainParentScrollView.frame.origin.y += 150
    }
}

