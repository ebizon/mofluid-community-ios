//
//  sample.swift
//  Mofluid
//
//  Created by sudeep goyal on 10/09/15.
//  Copyright © 2015 Mofluid. All rights reserved.
//

import UIKit
import Foundation
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}



class customOptionsViewController: PageViewController,UITableViewDataSource, UITableViewDelegate{
    let supportedOptions = ["drop_down", "checkbox", "multiple", "radio", "field", "area"]
    var titleParentView = UIView()
    var titileLabel = UILabel()
    var customTableListParentView = UIView()
    var priceValue = UILabel()
    
    var imageVTransfer = UIImageView()
    
    var addToCartButton = ZFRippleButton()
    var optionSet : [CustomOptionSet] = [CustomOptionSet]()
    var productTitle:String? = nil
    var productPrice:String? = nil
    var stockBool:Bool = false
    var titlesArray = [String] ()
    var righttitlesArray = [String] ()
    var shoppingItem:ShoppingItem? = nil
    
    var dropDownTableView = UITableView()
    var dropDownButtonTagValue = 0
    var customdropDownGestureView = UIButton()
    var dropDownBooleanValue = 1
    var dropDownTableViewXPos:CGFloat? = nil
    var dropDownTableViewYPos:CGFloat? = nil
    var changeButton:UIButton = UIButton()
    var priceLabel = UILabel()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleParentView.frame = CGRect(x: 0, y: 0, width: mainParentScrollView.frame.width, height: 50)
        titileLabel = Utils.createTitleLabel(titleParentView,yposition: 15)
        titileLabel.font = UIFont(name: "Lato", size: 20)
        titileLabel.text = productTitle
        titileLabel.numberOfLines = 2
        titileLabel.sizeToFit()
        titleParentView.addSubview(titileLabel)
        
        priceValue = Utils.createTitleLabel(titleParentView,yposition: titileLabel.frame.origin.y + titileLabel.frame.height + 10)
        priceValue.text = productPrice
        priceValue.font = titileLabel.font
        priceValue.numberOfLines = 1
       // priceValue.sizeToFit()
        priceValue.textColor = UIColor.red
        titleParentView.frame.size.height = priceValue.frame.height + priceValue.frame.origin.y + 10
        titleParentView.addSubview(priceValue)
        
        mainParentScrollView.addSubview(titleParentView)
        
        let firstBorder = UILabel(frame: CGRect(x: 0, y: titleParentView.frame.height - 2, width: titleParentView.frame.width, height: 1))
        firstBorder.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
        titleParentView.addSubview(firstBorder)
        
        dropDownTableView.delegate =   self
        dropDownTableView.dataSource =   self
        dropDownTableView.register(UITableViewCell.self, forCellReuseIdentifier: "DropDownCell")
        dropDownTableView.frame = CGRect(x: 20, y: 0, width: 0, height: 0)
        dropDownTableView.scrollsToTop = true
        dropDownTableView.separatorStyle = .none
        dropDownTableView.backgroundColor = UIColor.darkGray
        mainParentScrollView.addSubview(dropDownTableView)
        
        addToCartButton.isEnabled = false
    
        self.loadProduct()
    }
    
     
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        customdropDownGestureView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        customdropDownGestureView.backgroundColor = UIColor.clear
        customdropDownGestureView.addTarget(self, action: #selector(customOptionsViewController.dropDownGesturebuttonAction), for: .touchUpInside)
        
//        if(deviceName == "big"){
//            UILabel.appearance().font = UIFont(name: "Lato", size: 20)
//        }
//            
//        else{
//            UILabel.appearance().font = UIFont(name: "Lato", size: 15)
//        }
        super.viewWillAppear(animated)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "OptionViewTap"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "selectOptionViewOption"), object: nil)
        
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    
    func loadProduct(){
        if let item = self.shoppingItem{
            self.addLoader()
            let url = WebApiManager.Instance.getDescUrl(item.id, type: item.type)
            Utils.fillTheData(url, callback: self.populateData, errorCallback : self.showError)
        }
    }
    
    func populateData(_ dataDict: NSDictionary){
        defer{self.removeLoader()}
        
        if let customOptions = dataDict["custom_option"] as? NSArray{
            if let quantity = dataDict["quantity"] as? String{
                self.shoppingItem?.numInStock = Int(Utils.StringToDouble(quantity))
            }
            
                for item in customOptions{
        
                    var optionList = [CustomOption]()
                    if let itemDict = item as? NSDictionary{
                        let optionId = itemDict["custom_option_id"] as? String
                        let name = itemDict["custom_option_name"] as? String
                        let type = itemDict["custom_option_type"] as? String
                        let isRequired = itemDict["custom_option_is_required"] as? String
                        
                        if let options = itemDict["custom_option_value_array"] as? NSArray{
                            for optionItem in options{
                                if let optionDict = optionItem as? NSDictionary{
                                    let id  = optionDict["id"] as? String
                                    let price = optionDict["price"] as? String
                                    let priceType = optionDict["price_type"] as? String
                                    let sku = optionDict["sku"] as? String
                                    let sortOrder = optionDict["sort_order"] as? String
                                    let title = optionDict["title"] as? String
                                    if id != nil && price != nil && title != nil{
                                        let option = CustomOption(id: id!, price: price!, priceType: priceType, sku: sku, sortOrder: sortOrder, title: title!)
                                        optionList.append(option)
                                    }
                                }
                            }
                        }
                        if optionId != nil && name != nil && type != nil && isRequired != nil{
                            let bRequired = isRequired! == "1" ? true : false
                            let customSet = CustomOptionSet(id: optionId!, name: name!, type: type!, isRequired: bRequired, options: optionList)
                            
                            if let all = itemDict["all"] as? NSDictionary{
                                if let maxChar = all["max_characters"] as? String{
                                    if let maxCharVal = Int(maxChar){
                                        customSet.maxChars = maxCharVal
                                    }
                                }
                                if let priceStr = all["price"] as? String{
                                    if let priceVal = Int(priceStr){
                                        customSet.priceStr = Utils.DoubleToString(Double(priceVal))
                                    }
                                }
                            }
                            
                            self.optionSet.append(customSet)
                        }
                    }
            }
        }
         createCustomOptionsTable()
    }
    
    func createCustomOptionsTable(){
        
        let detailsTitleLabel = UILabel()
        detailsTitleLabel.frame = CGRect(x: 15, y: titleParentView.frame.origin.y + titleParentView.frame.height + 20,  width: mainParentScrollView.frame.width - 30, height: 24)
        detailsTitleLabel.text = "Product Options"
        detailsTitleLabel.font = UIFont(name: "Lato", size: 18)
        detailsTitleLabel.textColor = UIColor.black
        mainParentScrollView.addSubview(detailsTitleLabel)
        
        customTableListParentView.frame = CGRect(x: 15, y: detailsTitleLabel.frame.origin.y + detailsTitleLabel.frame.height + 20, width: mainParentScrollView.frame.width - 30, height: 150)
        
        var posy = 0
        for item in self.optionSet{
            if self.supportedOptions.firstIndex(of: item.type) != nil{
                let singleParentView = UIView()
                singleParentView.frame = CGRect(x: 0, y: CGFloat(posy), width: customTableListParentView.frame.size.width, height: 50)
                
                let label1 = UILabel(frame: CGRect(x: 0, y: 0, width: singleParentView.frame.size.width/2, height: singleParentView.frame.size.height))
                label1.text = item.name
                if item.isRequired{
                    label1.text = item.name + "*"
                }
                label1.textAlignment = .center;
                label1.textColor = UIColor.black
                singleParentView.addSubview(label1)
                
                if(item.type == "drop_down"){
                    
                    let dropdownParentView = UIView(frame: CGRect(x: label1.frame.size.width + label1.frame.origin.x, y: 0, width: singleParentView.frame.size.width/2, height: singleParentView.frame.size.height))
                    
                    let customOptionDropdownButton = UIButton()
                    customOptionDropdownButton.tag = item.id.hashValue
                    customOptionDropdownButton.frame = CGRect(x: 20, y: 5, width: dropdownParentView.frame.size.width - 40, height: dropdownParentView.frame.size.height - 10)
                    customOptionDropdownButton.addTarget(self, action: #selector(customOptionsViewController.simpleProductCustomDropDown(_:)), for: UIControl.Event.touchUpInside)
                    customOptionDropdownButton.backgroundColor = UIColor.darkGray
                    customOptionDropdownButton.setTitle("Please Select", for: UIControl.State())
                    customOptionDropdownButton.titleLabel?.font = UIFont(name: "Lato", size: 15)
                    customOptionDropdownButton.titleLabel?.textColor = UIColor.white
                    
                    dropdownParentView.addSubview(customOptionDropdownButton)
                    dropdownParentView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
                    dropdownParentView.layer.borderWidth = 0.5
                    singleParentView.addSubview(dropdownParentView)
                    
                    
                }
                else if(item.type == "checkbox" || item.type == "multiple"){
                    var Pos_y_check = 5
                    let customCheckBoxParentScrollView = UIScrollView()
                    customCheckBoxParentScrollView.frame = CGRect(x: label1.frame.size.width + label1.frame.origin.x, y: 0, width: singleParentView.frame.size.width/2, height: singleParentView.frame.size.height)
                    
                    
                    for option in item.options{
                        let customCheckboxbuttonView = CheckBoxButton()
                        customCheckboxbuttonView.tag = option.id.hashValue
                        customCheckboxbuttonView.frame = CGRect(x: 20, y: CGFloat(Pos_y_check), width: customCheckBoxParentScrollView.frame.size.width - 40, height: 35)
                        customCheckboxbuttonView.addTarget(self, action: #selector(customOptionsViewController.customCheckboxbuttonAction(_:)), for: UIControl.Event.touchUpInside)
                        
                        customCheckboxbuttonView.setTitleColor(UIColor.white, for: UIControl.State())
                        customCheckboxbuttonView.titleLabel?.font = UIFont(name: "Lato", size: 15)
                        customCheckboxbuttonView.setTitle(option.titleWithPrice(), for: UIControl.State())
                        customCheckboxbuttonView.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
                        customCheckboxbuttonView.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
                        
                        customCheckboxbuttonView.backgroundColor = UIColor.darkGray
                        
                        customCheckBoxParentScrollView.addSubview(customCheckboxbuttonView)
                        
                        customCheckBoxParentScrollView.frame.size.height = customCheckboxbuttonView.frame.origin.y + customCheckboxbuttonView.frame.size.height + 5
                        
                        
                        Pos_y_check = Pos_y_check + Int(customCheckboxbuttonView.frame.size.height)+5
                    }
                    
                    customCheckBoxParentScrollView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
                    customCheckBoxParentScrollView.layer.borderWidth = 0.5
                    singleParentView.frame.size.height = customCheckBoxParentScrollView.frame.size.height
                    singleParentView.addSubview(customCheckBoxParentScrollView)
                    
                    
                }else if(item.type == "radio"){
                    var Pos_y_radio = 5
                    let customRadioParentScrollView = UIScrollView()
                    customRadioParentScrollView.frame = CGRect(x: label1.frame.size.width + label1.frame.origin.x, y: 0, width: singleParentView.frame.size.width/2, height: singleParentView.frame.size.height)
                    
                    customRadioParentScrollView.tag = item.id.hashValue
                    
                    for option in item.options{
                        let customradiobuttonView = RadioButton()
                        customradiobuttonView.tag = option.id.hashValue
                        customradiobuttonView.frame = CGRect(x: 20, y: CGFloat(Pos_y_radio), width: customRadioParentScrollView.frame.size.width - 40, height: 35)
                        customradiobuttonView.addTarget(self, action: #selector(customOptionsViewController.customradiobuttonView(_:)), for: UIControl.Event.touchUpInside)
                        
                        customradiobuttonView.setTitleColor(UIColor.white, for: UIControl.State())
                        customradiobuttonView.titleLabel?.font = UIFont(name: "Lato", size: 15)
                        customradiobuttonView.setTitle(option.titleWithPrice(), for: UIControl.State())
                        customradiobuttonView.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
                        customradiobuttonView.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
                        
                        customradiobuttonView.backgroundColor = UIColor.darkGray
                        
                        customRadioParentScrollView.addSubview(customradiobuttonView)
                        
                        customRadioParentScrollView.frame.size.height = customradiobuttonView.frame.origin.y + customradiobuttonView.frame.size.height + 5
                        
                        
                        Pos_y_radio = Pos_y_radio + Int(customradiobuttonView.frame.size.height)+5
                        
                    }
                    
                    customRadioParentScrollView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
                    customRadioParentScrollView.layer.borderWidth = 0.5
                    singleParentView.frame.size.height = customRadioParentScrollView.frame.size.height
                    singleParentView.addSubview(customRadioParentScrollView)
                    
                }
                
                else if(item.type == "field" || item.type == "area"){
                    if let priceStr = item.priceStr{
                        if let text = label1.text{
                            if Utils.StringToDouble(priceStr) > 0.0{
                                label1.text = text + " + " + Utils.appendWithCurrencySymStr(priceStr)
                            }
                        }
                    }
                    
                    let textfieldParentView = UIView(frame: CGRect(x: label1.frame.size.width + label1.frame.origin.x, y: 0, width: singleParentView.frame.size.width/2, height: singleParentView.frame.size.height))
                    let textBox1 = UITextField(frame: CGRect(x: 10, y: 5, width: textfieldParentView.frame.size.width - 20, height: textfieldParentView.frame.size.height - 10))
                    textfieldParentView.tag = item.maxChars
                    let spaceLabel1 = UILabel()
                    spaceLabel1.frame = CGRect(x: 10, y: 0, width: 7, height: 26)
                    spaceLabel1.backgroundColor = UIColor.clear
                    textBox1.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
                    textBox1.layer.borderWidth = 2
                    textBox1.font = UIFont(name: "Lato", size: 17)
                    textBox1.textColor = UIColor.black
                    textBox1.backgroundColor = UIColor.white
                    textBox1.layer.cornerRadius = 2
                    textBox1.placeholder = "Enter"
                    textBox1.leftView = spaceLabel1
                    textBox1.leftViewMode = UITextField.ViewMode.always
                    textBox1.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
                    textBox1.delegate = self
                    item.textBox = textBox1
                    
                    textfieldParentView.addSubview(textBox1)
                    textfieldParentView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
                    textfieldParentView.layer.borderWidth = 0.5
                    singleParentView.addSubview(textfieldParentView)
                }
                
                label1.frame.size.height = singleParentView.frame.size.height
                singleParentView.layer.borderWidth = 0.5
                singleParentView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
                customTableListParentView.addSubview(singleParentView)
                
                posy = posy + Int(singleParentView.frame.size.height)
            }
        }
        
        let singleParentView = UIView()
        singleParentView.frame = CGRect(x: 0, y: CGFloat(posy), width: customTableListParentView.frame.size.width, height: 50)
        
        self.priceLabel = UILabel(frame: CGRect(x: 0, y: 0, width: singleParentView.frame.size.width/2, height: singleParentView.frame.size.height))
        self.priceLabel.text = self.shoppingItem?.priceStr
        self.priceLabel.textAlignment = .center;
        self.priceLabel.textColor = UIColor.black
        singleParentView.addSubview(self.priceLabel)
        
        let customPriceParentView = UIView(frame: CGRect(x: self.priceLabel.frame.size.width + self.priceLabel.frame.origin.x, y: 0, width: singleParentView.frame.size.width/2, height: singleParentView.frame.size.height))
        
        let customOptionPriceButton = UIButton()
        customOptionPriceButton.frame = CGRect(x: 20, y: 5, width: customPriceParentView.frame.size.width - 40, height: customPriceParentView.frame.size.height - 10)
        customOptionPriceButton.addTarget(self, action: #selector(customOptionsViewController.customOptionPriceButtonAction(_:)), for: UIControl.Event.touchUpInside)
//        let backgroundImg = UIImage(named: "background")
//        customOptionPriceButton.setBackgroundImage(backgroundImg, forState: UIControlState.Normal)
        customOptionPriceButton.backgroundColor = UIColor(red: (223/255.0), green: (114/255.0), blue: (114/255.0), alpha: 1.0)
        customOptionPriceButton.layer.cornerRadius = 3.0
        customOptionPriceButton.setTitle("Get Price", for: UIControl.State())
        customOptionPriceButton.titleLabel?.font = UIFont(name: "Lato", size: 17)
        customOptionPriceButton.titleLabel?.textColor = UIColor.white
        
        customPriceParentView.addSubview(customOptionPriceButton)
        customPriceParentView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
        customPriceParentView.layer.borderWidth = 0.5
        
        customPriceParentView.frame.size.height = customOptionPriceButton.frame.origin.y + customOptionPriceButton.frame.size.height + 5
        singleParentView.addSubview(customPriceParentView)
        
        
        singleParentView.frame.size.height = customPriceParentView.frame.size.height
        
        
        self.priceLabel.frame.size.height = singleParentView.frame.size.height
        singleParentView.layer.borderWidth = 0.5
        singleParentView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
        customTableListParentView.addSubview(singleParentView)
        
        posy = posy + Int(singleParentView.frame.size.height)
        customTableListParentView.frame.size.height = CGFloat(posy) + 10
        mainParentScrollView.addSubview(customTableListParentView)
        
        
        addToCartButton.frame = CGRect(x: customTableListParentView.frame.origin.x, y: customTableListParentView.frame.origin.y + customTableListParentView.frame.size.height + 20, width: customTableListParentView.frame.size.width, height: 38)
        addToCartButton.addTarget(self, action: #selector(customOptionsViewController.addToCartButtonAction(_:)), for: UIControl.Event.touchUpInside)
        addToCartButton.backgroundColor = UIColor(red: (223/255.0), green: (114/255.0), blue: (114/255.0), alpha: 1.0)
        addToCartButton.layer.cornerRadius = 3.0
        //addToCartButton.setBackgroundImage(backgroundImg, forState: UIControlState.Normal)
        addToCartButton.setTitle("Add To Cart", for: UIControl.State())
        addToCartButton.titleLabel?.textColor = UIColor(netHex:0xf78f1e)
        
        mainParentScrollView.addSubview(addToCartButton)
        
        mainParentScrollView.contentSize.height = addToCartButton.frame.origin.y + addToCartButton.frame.size.height + 100
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text{
            if (range.length + range.location > text.count){
                return false;
            }
            
            let newLength = text.count + string.count - range.length
            
            return newLength <= textField.superview?.tag
        }
        
        return false
    }
    
    @objc func simpleProductCustomDropDown(_ button:UIButton){
        changeButton = button
        dropDownTableViewXPos =  customTableListParentView.frame.origin.x + button.superview!.superview!.frame.origin.x + button.superview!.frame.origin.x + button.frame.origin.x
        dropDownTableViewYPos =  customTableListParentView.frame.origin.y + button.superview!.superview!.frame.origin.y + button.superview!.frame.origin.y + button.frame.origin.y + button.frame.height - 3
        
        allDropDownButtonAction(button)
        
    }
    
    func getMessage()->String{
        var requiredOptions : [String] = [String]()
        for item in self.optionSet{
            if self.supportedOptions.firstIndex(of: item.type) != nil{
                if item.isRequired{
                    let selectedOption = item.options.filter({$0.selected == true})
                    
                    if item.textBox == nil{
                        if selectedOption.count == 0 {
                            requiredOptions.append(item.name)
                        }
                    }else{
                        if item.textBox?.text?.count == 0{
                            requiredOptions.append(item.name)
                        }
                    }
                }
            }
        }
        
        var msg = ""
        if requiredOptions.count > 0{
            for (index, name) in requiredOptions.enumerated(){
                msg += name
                
                if index < requiredOptions.count - 1  {
                    msg += ", "
                }
            }
            
            if requiredOptions.count == 1{
                msg += " is required option"
            }else{
                msg += " are required options"
            }
        }
        
        return msg
    }
    
    @objc func customOptionPriceButtonAction(_ button: UIButton){
        let msg = self.getMessage()
        
        if msg.isEmpty{
            var prices = self.shoppingItem!.priceStr
            let allSelected = self.getSelectedOptions()
            self.priceLabel.numberOfLines = 3
            for option in allSelected{
                if Utils.StringToDouble(option.price) > 0.0{
                    prices += " + " + Utils.appendWithCurrencySymStr(option.price)
                }
            }
            
            for item in self.optionSet{
                if let text = item.textBox?.text{
                    if text.count > 0 && item.priceStr != nil{
                        if Utils.StringToDouble(item.priceStr!) > 0.0{
                            prices += " + " + Utils.appendWithCurrencySymStr(item.priceStr!)
                        }
                    }
                }
            }
            
            let customItem = CustomShoppingItem(item: self.shoppingItem!, customOptionsSet: self.optionSet)
            self.priceLabel.text = prices
            if let item = customItem{
                if prices != item.priceStr{
                     self.priceLabel.font = UIFont(name: "HelveticaNeue", size: 12)
                    self.priceLabel.text = prices + " = " + item.priceStr
                    self.priceValue.text = item.priceStr
                }
            }
            self.addToCartButton.isEnabled = self.stockBool
        }else{
            self.alert(msg)
        }
    }
    
    func getSelectedOptions()->[CustomOption]{
        var allSelected = [CustomOption]()
        
        for item in self.optionSet{
            let selectedOption = item.options.filter({$0.selected == true})
            allSelected += selectedOption
        }
        
        return allSelected
    }
    
    func findOption(_ idHashValue: Int)->CustomOption?{
        var option : CustomOption? = nil
        
        for item in self.optionSet{
            option = item.options.filter({$0.id.hashValue == idHashValue}).first
            if option != nil{
                break
            }
        }
        
        return option
    }
    
    @objc func customradiobuttonView(_ button: UIButton){
        self.addToCartButton.isEnabled = false
        self.FlipButton(button as? FlipFlopButton)
        
        if let parentTag = button.superview?.tag{
            for item in self.optionSet{
                if item.id.hashValue == parentTag{
                    for option in item.options{
                        option.selected = false
                    }
                }
            }
        }
        let option = self.findOption(button.tag)
        option?.selected = button.isSelected
    }
    
    @objc func customCheckboxbuttonAction(_ button: UIButton){
        self.addToCartButton.isEnabled = false
        button.isSelected = !button.isSelected;
        
        let option = self.findOption(button.tag)
        option?.selected = button.isSelected
    }
    
    func allDropDownButtonAction(_ button:UIButton){
        
        dropDownButtonTagValue = button.tag
        
        UIView.animate(withDuration: 0.2, animations: {
            self.changeButton.imageView!.transform = self.changeButton.imageView!.transform.rotated(by: 180 * CGFloat(Double.pi/180))
            }, completion: { _ in
        })
        
        
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
            
            dropDownTableView.frame.origin.x = dropDownTableViewXPos!
            dropDownTableView.frame.size.width = button.frame.width
            mainParentScrollView.addSubview(dropDownTableView)
            
            dropDownTableView.frame.origin.y = dropDownTableViewYPos!
            UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions(), animations: {
                if let options = self.getTableOptions(){
                    self.dropDownTableView.frame.size.height = CGFloat(options.count) * 40 + 15
                    if self.isTableOptionRequired(){
                        //self.changeButton.setTitle(options.first?.titleWithPrice(), forState: .Normal)
                        options.first?.selected = true
                        self.dropDownTableView.reloadData()
                    }
                }
                if(self.dropDownTableView.frame.size.height > 150){
                    self.dropDownTableView.frame.size.height = 150
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
            let heightofsubmitbtn = addToCartButton.frame.origin.y + addToCartButton.frame.size.height
            
            if(heightoftableView > heightofsubmitbtn){
                mainParentScrollView.contentSize.height = CGFloat(heightoftableView) + 100
            }
            else{
                mainParentScrollView.contentSize.height = CGFloat(heightofsubmitbtn) + 100
            }
        }
        
    }
    
    func getTableOptions()->[CustomOption]?{
        
        let options = self.optionSet.filter({$0.id.hashValue == self.dropDownButtonTagValue}).first?.options
        
        return options
    }
    
    func isTableOptionRequired()->Bool{
        var isRequired = false
        
        if let isReq = self.optionSet.filter({$0.id.hashValue == self.dropDownButtonTagValue}).first?.isRequired{
            isRequired = isReq
        }
        
        return isRequired
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let options = self.getTableOptions(){
            return options.count
        }else{
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
        cell.backgroundColor = UIColor.darkGray
        cell.textLabel?.textColor = UIColor.white
        if let options = self.getTableOptions(){
            
            cell.textLabel?.text = options[indexPath.row].titleWithPrice()
        }
        cell.textLabel?.textAlignment = .center;
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let options = self.getTableOptions(){
            changeButton.setTitle(options[indexPath.row].titleWithPrice(), for: UIControl.State())
            for option in options{
                option.selected = false
            }
            options[indexPath.row].selected = true
        }
            
        dropDownGesturebuttonAction()
        
    }
    
    @objc func dropDownGesturebuttonAction(){
        dropDownBooleanValue = 0
        let btn = UIButton()
        btn.tag = dropDownButtonTagValue
        allDropDownButtonAction(btn)
        
    }
    
    @objc func addToCartButtonAction(_ button:ZFRippleButton){
        
        if let customItem = CustomShoppingItem(item: self.shoppingItem!, customOptionsSet: self.optionSet){
            if let oldItem = ShoppingCart.Instance.findItemByHash(customItem.hashValue){
                ShoppingCart.Instance.addItem(item: oldItem)
            }else{
                ShoppingCart.Instance.addItem(item: customItem)
            }
            
            self.AddImagetocartWithAnimation(imageVTransfer)
                        
//            let cartObject = self.storyboard?.instantiateViewControllerWithIdentifier("cartViewController") as? cartViewController
//            self.navigationController?.pushViewController(cartObject!, animated: true)
        }
    }
    
    func backButtonFunction(){
        self.navigationController?.popViewController(animated: true)
    }
}
