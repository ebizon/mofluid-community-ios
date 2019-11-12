//
//  sample.swift
//  Mofluid
//
//  Created by sudeep goyal on 10/09/15.
//  Copyright © 2015 Mofluid. All rights reserved.
//

import UIKit
import Foundation

class discountViewController: PageViewController, UITableViewDataSource,UITableViewDelegate{
    var shippingMethods = [ShippingMethod]()
    var cart = ShoppingCart.Instance
    var shipMethodDropDownButton = UIButton()
    var addressParentScrollView = UIScrollView()
    var shipBooleanValue:Bool = true
    var proceedButton = ZFRippleButton()
    var discountParentView = UIView()
    var couponText = UITextField()
    var couponSuccessFailLabel = UILabel()
    var cancelCouponButton = UIButton()
    var dropDownTableView = UITableView()
    var dropDownButtonTagValue = 0
    var customdropDownGestureView = UIButton()
    var dropDownBooleanValue = 1
    
    var productsParentScrollView = UIScrollView()
    var totalAmountParentView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Shipping Method".localized().uppercased()
        dropDownTableView.delegate =   self
        dropDownTableView.dataSource =   self
        dropDownTableView.register(UITableViewCell.self, forCellReuseIdentifier: "DropDownCell")
        dropDownTableView.frame = CGRect(x: 20, y: 0, width: mainParentScrollView.frame.size.width/2 - 20, height: 0)
        dropDownTableView.separatorStyle = .none
        dropDownTableView.backgroundColor = UIColor(red: (144/255.0), green: (144/255.0), blue: (144/255.0), alpha: 1.0)
        mainParentScrollView.addSubview(dropDownTableView)
        
        self.loadShippingMethods()
        createAddressView()
        if(itemType == "downloadable"){
            downloadCreateCart()
        }
        else{
            createShipMethod()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        customdropDownGestureView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        customdropDownGestureView.backgroundColor = UIColor.clear
        customdropDownGestureView.addTarget(self, action: #selector(discountViewController.dropDownGesturebuttonAction), for: .touchUpInside)
        
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
    
    
    func createShipMethod(){
        let titleParentView = UIView()
        titleParentView.frame = CGRect(x: 0, y: 0, width: mainParentScrollView.frame.width/2,height: 60)
        
        let titleLabel = Utils.createTitleLabel(titleParentView,yposition: 25)
        titleLabel.text = "Shipping Method".localized()
        titleParentView.addSubview(titleLabel)
        let xandwidthPosition = mainParentScrollView.frame.size.width
        
        shipMethodDropDownButton.frame = CGRect(x: 20, y: addressParentScrollView.frame.origin.y + addressParentScrollView.frame.height + 10, width: xandwidthPosition - 40, height: 38)
        
        shipMethodDropDownButton.titleLabel?.font = UIFont(name: "Lato", size: 15)
        shipMethodDropDownButton.setTitle("Shipping Method".localized(), for: UIControl.State())
        shipMethodDropDownButton.setTitleColor(UIColor.white, for: UIControl.State())
        shipMethodDropDownButton.backgroundColor = UIColor(red: (144/255.0), green: (144/255.0), blue: (144/255.0), alpha: 1.0)
        shipMethodDropDownButton.layer.cornerRadius = 2
        shipMethodDropDownButton.addTarget(self, action: #selector(discountViewController.allDropDownButtonAction(_:)), for: UIControl.Event.touchUpInside)
        let imgRight = UIImage(named: "arrow-down-white.png")
        shipMethodDropDownButton.setImage(imgRight, for: UIControl.State())
        shipMethodDropDownButton.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        shipMethodDropDownButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: shipMethodDropDownButton.frame.size.width - (imgRight!.size.width)-10 , bottom: 0, right: 0)
        shipMethodDropDownButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: (imgRight!.size.width)+10)
        shipMethodDropDownButton.tag = 1
        mainParentScrollView.addSubview(shipMethodDropDownButton)
        
        mainParentScrollView.contentSize.height = shipMethodDropDownButton.frame.origin.y + shipMethodDropDownButton.frame.height + 100
        
    }
    
    func loadShippingMethods(){
        self.addLoader()
        
        if(itemType == "downloadable"){
            let url = WebApiManager.Instance.getDownloadableShippingURL(self.cart)
            Utils.fillTheDataFromArray(url, callback: self.populateShippingMethods, errorCallback : self.showError)
        }else{
            let url = WebApiManager.Instance.getShippingURL()
            Utils.fillTheDataFromArray(url, callback: self.populateShippingMethods, errorCallback : self.showError)
        }
    }
    
    func downloadCreateCart(){
        self.clearCart()
        
        self.downloadableCreateProductsList()
        self.downloadableCreateTotalAmount()
        
        self.downloadCreateDiscountParentView()
    }
    
    func downloadableCreateTotalAmount(){
        let cart = self.cart
        
        totalAmountParentView.frame = CGRect(x: 15, y: productsParentScrollView.frame.origin.y + productsParentScrollView.frame.height + 10, width: mainParentScrollView.frame.width - 30, height: 150)
        
        let totalTitleLabel = UILabel(frame: CGRect(x: 0, y: 10, width: 150, height: 22))
        totalTitleLabel.text = "Total".localized()
        totalTitleLabel.textColor = UIColor(red: (144/255.0), green: (144/255.0), blue: (144/255.0), alpha: 1.0)
        totalAmountParentView.addSubview(totalTitleLabel)
        
        let totalPriceLabel = UILabel(frame: CGRect(x: totalAmountParentView.frame.width - 150, y: totalTitleLabel.frame.origin.y, width: 150, height: 22))
        totalPriceLabel.text = Utils.appendWithCurrencySym(cart.getSubTotal())
        totalPriceLabel.textColor = UIColor.red
        totalPriceLabel.textAlignment = .right;
        totalAmountParentView.addSubview(totalPriceLabel)
        
        let taxAmount = UILabel(frame: CGRect(x: 0, y: totalTitleLabel.frame.origin.y + totalTitleLabel.frame.height + 10, width: 150, height: 22))
        taxAmount.text = "Tax Amount".localized()
        taxAmount.textColor = UIColor.black
        totalAmountParentView.addSubview(taxAmount)
        
        let taxAmountlabel = UILabel(frame: CGRect(x: totalPriceLabel.frame.origin.x, y: taxAmount.frame.origin.y, width: 150, height: 22))
        taxAmountlabel.text =  Utils.appendWithCurrencySym(cart.getTaxAmount())
        taxAmountlabel.textColor = UIColor.red
        taxAmountlabel.textAlignment = .right;
        totalAmountParentView.addSubview(taxAmountlabel)
        
        
        var lastLabel = totalPriceLabel
        var lastTitleLabel = totalTitleLabel
        let discount = cart.getDiscount()
        
        if discount < 0{
            let discountTitleLabel = UILabel(frame: CGRect(x: lastTitleLabel.frame.origin.x, y: lastTitleLabel.frame.origin.y + lastTitleLabel.frame.height + 5, width: lastTitleLabel.frame.width, height: 22))
            discountTitleLabel.text = "Discount".localized()
            discountTitleLabel.textColor = UIColor(red: (144/255.0), green: (144/255.0), blue: (144/255.0), alpha: 1.0)
            discountTitleLabel.numberOfLines = 0
            discountTitleLabel.sizeToFit()
            totalAmountParentView.addSubview(discountTitleLabel)
            lastTitleLabel = discountTitleLabel
            
            let discountPriceLabel = UILabel(frame: CGRect(x: lastLabel.frame.origin.x, y: lastTitleLabel.frame.origin.y, width: lastLabel.frame.width, height: lastTitleLabel.frame.height))
            discountPriceLabel.text = cart.getDiscountStr()
            discountPriceLabel.textColor = UIColor.red
            discountPriceLabel.textAlignment = .right;
            totalAmountParentView.addSubview(discountPriceLabel)
            lastLabel = discountPriceLabel
        }
        
        if let shippingMethod = cart.shippingMethod{
            let shipMethodTitleLabel = UILabel(frame: CGRect(x: lastTitleLabel.frame.origin.x, y: lastTitleLabel.frame.origin.y + lastTitleLabel.frame.height + 5, width: 150, height: 22))
            shipMethodTitleLabel.text = shippingMethod.title
            shipMethodTitleLabel.textColor = UIColor(red: (144/255.0), green: (144/255.0), blue: (144/255.0), alpha: 1.0)
            shipMethodTitleLabel.numberOfLines = 0
            shipMethodTitleLabel.sizeToFit()
            totalAmountParentView.addSubview(shipMethodTitleLabel)
            lastTitleLabel = shipMethodTitleLabel
            
            let shipMethodPriceLabel = UILabel(frame: CGRect(x: lastLabel.frame.origin.x, y: shipMethodTitleLabel.frame.origin.y, width: lastLabel.frame.width, height: shipMethodTitleLabel.frame.height))
            shipMethodPriceLabel.text = Utils.appendWithCurrencySym(shippingMethod.price)
            shipMethodPriceLabel.textColor = UIColor.red
            shipMethodPriceLabel.textAlignment = .right;
            totalAmountParentView.addSubview(shipMethodPriceLabel)
            lastLabel = shipMethodPriceLabel
        }
        
        let grandTotalTitleLabel = UILabel(frame: CGRect(x: totalTitleLabel.frame.origin.x, y: lastLabel.frame.origin.y+30 + lastLabel.frame.height + 15, width: 150, height: 22))
        grandTotalTitleLabel.text = "Grand Total".localized()
        grandTotalTitleLabel.textColor = UIColor(red: (144/255.0), green: (144/255.0), blue: (144/255.0), alpha: 1.0)
        totalAmountParentView.addSubview(grandTotalTitleLabel)
        
        let grandTotalPriceLabel = UILabel(frame: CGRect(x: totalPriceLabel.frame.origin.x, y: grandTotalTitleLabel.frame.origin.y, width: 150, height: 22))
        grandTotalPriceLabel.text = Utils.appendWithCurrencySym(cart.getTotalWithShipping())
        
        grandTotalPriceLabel.textColor = UIColor.red
        grandTotalPriceLabel.textAlignment = .right;
        totalAmountParentView.addSubview(grandTotalPriceLabel)
        
        totalAmountParentView.frame.size.height = grandTotalPriceLabel.frame.origin.y + grandTotalPriceLabel.frame.height + 20
        
        mainParentScrollView.addSubview(totalAmountParentView)
        
        mainParentScrollView.contentSize.height = proceedButton.frame.origin.y + proceedButton.frame.height + 100
    }
    
    func downloadCreateDiscountParentView(){
        proceedButton.isEnabled = true
        discountParentView.frame = CGRect(x: 15, y: totalAmountParentView.frame.origin.y + totalAmountParentView.frame.height + 10, width: mainParentScrollView.frame.width - 30, height: 150)
        
        discountParentView.backgroundColor = UIColor(red: 255, green: 255, blue: 0, alpha: 0.22)
        
        let titleParentView = UIView()
        titleParentView.frame = CGRect(x: 0, y: 0, width: discountParentView.frame.width, height: 50)
        var TitleLabel = UILabel()
        TitleLabel = Utils.createTitleLabel(discountParentView,yposition: 15)
        TitleLabel.text = "Discount Codes".localized()
        TitleLabel.textAlignment = .center;
        titleParentView.addSubview(TitleLabel)
        discountParentView.addSubview(titleParentView)
        
        var couponTitleLabel = UILabel()
        couponTitleLabel = Utils.createTitleLabel(titleParentView,yposition: 15)
        couponTitleLabel.frame.origin.y = titleParentView.frame.origin.y + titleParentView.frame.height
        couponTitleLabel.text = "Enter your coupon code if you have one".localized()
        couponTitleLabel.textColor = UIColor(red: (144/255.0), green: (144/255.0), blue: (144/255.0), alpha: 1.0)
        couponTitleLabel.numberOfLines = 0
        couponTitleLabel.sizeToFit()
        discountParentView.addSubview(couponTitleLabel)
        
        couponText = Utils.titleTextFields(couponTitleLabel)
        couponText.frame.size.width = discountParentView.frame.width - 40
        couponText.delegate = self
        
        createTextFieldButtons(couponText)
        discountParentView.addSubview(couponText)
        couponSuccessFailLabel.frame = CGRect(x: couponText.frame.origin.x, y: couponText.frame.origin.y + couponText.frame.height + 3, width: couponText.frame.width, height: 18)
        couponSuccessFailLabel.textColor = UIColor.red
        couponSuccessFailLabel.font = UIFont(name: "Lato", size: 15)
        couponSuccessFailLabel.text = ""
        discountParentView.addSubview(couponSuccessFailLabel)
        
        let applyCouponButton = UIButton()
        applyCouponButton.frame = CGRect(x: couponText.frame.origin.x, y: couponSuccessFailLabel.frame.origin.y + couponSuccessFailLabel.frame.size.height + 10, width: couponText.frame.width/2, height: 30)
        applyCouponButton.addTarget(self, action: #selector(discountViewController.applyCouponButtonAction(_:)), for: UIControl.Event.touchUpInside)
        applyCouponButton.backgroundColor = UIColor(red: (144/255.0), green: (114/255.0), blue: (114/255.0), alpha: 1.0)
        applyCouponButton.setTitle("Apply Coupon".localized(), for: UIControl.State())
        applyCouponButton.setTitleColor(UIColor.white , for: UIControl.State())
        applyCouponButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
        discountParentView.addSubview(applyCouponButton)
        
        cancelCouponButton.frame = CGRect(x: applyCouponButton.frame.origin.x + applyCouponButton.frame.width + 15, y: applyCouponButton.frame.origin.y, width: couponText.frame.width/2 - 30, height: 30)
        cancelCouponButton.addTarget(self, action: #selector(discountViewController.cancelCouponButtonAction(_:)), for: UIControl.Event.touchUpInside)
        cancelCouponButton.backgroundColor = UIColor(red: (144/255.0), green: (144/255.0), blue: (144/255.0), alpha: 1.0)
        cancelCouponButton.setTitle("Cancel".localized(), for: UIControl.State())
        cancelCouponButton.setTitleColor(UIColor.white, for: UIControl.State())
        cancelCouponButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        cancelCouponButton.isHidden = true
        discountParentView.addSubview(cancelCouponButton)
        
        discountParentView.frame.size.height = applyCouponButton.frame.origin.y + applyCouponButton.frame.height + 20
        
        discountParentView.layer.borderWidth = 8
        let origImage = UIImage(named: "dot.png")
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        discountParentView.layer.borderColor = UIColor(patternImage: tintedImage!).cgColor
        discountParentView.tintColor = UIColor.red
        
        mainParentScrollView.addSubview(discountParentView)
        
        proceedButton.frame = CGRect(x: totalAmountParentView.frame.origin.x, y: discountParentView.frame.origin.y + discountParentView.frame.height + 20, width: totalAmountParentView.frame.width, height: 38)
        proceedButton.addTarget(self, action: #selector(discountViewController.proceedButtonAction(_:)), for: UIControl.Event.touchUpInside)
        proceedButton.backgroundColor = Settings().getButtonBgColor()//UIColor(red: (223/255.0), green: (114/255.0), blue: (114/255.0), alpha: 1.0)
        proceedButton.layer.cornerRadius = 3.0
        proceedButton.setTitle("Proceed".localized(), for: UIControl.State())
        proceedButton.setTitleColor(UIColor.white, for: UIControl.State())
        mainParentScrollView.addSubview(proceedButton)
        proceedButton.frame.origin.y = discountParentView.frame.origin.y + discountParentView.frame.height + 20
        
        mainParentScrollView.contentSize.height = proceedButton.frame.origin.y + proceedButton.frame.height + 100
    }
    
    func downloadableCreateProductsList(){
        productsParentScrollView.frame = CGRect(x: 0, y: addressParentScrollView.frame.origin.y + addressParentScrollView.frame.height + 10, width: mainParentScrollView.frame.width, height: 150)
        let titleParentView = UIView()
        titleParentView.frame = CGRect(x: 0, y: 0, width: productsParentScrollView.frame.width, height: 50)
        var TitleLabel = UILabel()
        TitleLabel = Utils.createTitleLabel(titleParentView,yposition: 15)
        TitleLabel.text = "Order Summary".localized()
        titleParentView.addSubview(TitleLabel)
        productsParentScrollView.addSubview(titleParentView)
        
        var productYPositon:CGFloat = titleParentView.frame.origin.y + titleParentView.frame.height
        
        for (item, count) in self.cart{
            let singleParentView = UIView()
            singleParentView.frame = CGRect(x: 15, y: productYPositon, width: productsParentScrollView.frame.width - 30, height: 50)
            
            let icon_img_view = UIImageView()
            icon_img_view.contentMode = .scaleAspectFit
            UIImageCache.setImage(icon_img_view, image: item.smallImg)
            icon_img_view.frame = CGRect(x: 0, y: 10, width: 80, height: 80)
            singleParentView.addSubview(icon_img_view)
            
            let productTitleLabel = UILabel(frame: CGRect(x: icon_img_view.frame.origin.x + icon_img_view.frame.size.width + 20, y: 10, width:singleParentView.frame.width - icon_img_view.frame.size.width * 1.5, height: 37))
            productTitleLabel.text = item.name
            productTitleLabel.textColor = UIColor.black
            productTitleLabel.numberOfLines = 2
            productTitleLabel.sizeToFit()
            singleParentView.addSubview(productTitleLabel)
            
            let unitProductpriceLabel = UILabel(frame: CGRect(x: productTitleLabel.frame.origin.x, y: productTitleLabel.frame.origin.y + productTitleLabel.frame.height + 10, width: 90, height: 22))
            unitProductpriceLabel.text = item.priceStr
            unitProductpriceLabel.textColor = UIColor(red: (144/255.0), green: (144/255.0), blue: (144/255.0), alpha: 1.0)
            singleParentView.addSubview(unitProductpriceLabel)
            
            let crossLabel = UILabel(frame: CGRect(x: unitProductpriceLabel.frame.origin.x + unitProductpriceLabel.frame.width + 3, y: productTitleLabel.frame.origin.y + productTitleLabel.frame.height + 10, width: 10, height: 22))
            crossLabel.text = "x"
            crossLabel.textColor = UIColor(red: (144/255.0), green: (144/255.0), blue: (144/255.0), alpha: 1.0)
            singleParentView.addSubview(crossLabel)
            
            let countLabel = UILabel(frame: CGRect(x: crossLabel.frame.origin.x + crossLabel.frame.width + 1, y: productTitleLabel.frame.origin.y + productTitleLabel.frame.height + 10, width: 30, height: 22))
            countLabel.text = String(count)
            countLabel.textAlignment = .left;
            countLabel.textColor = UIColor(red: (144/255.0), green: (144/255.0), blue: (144/255.0), alpha: 1.0)
            singleParentView.addSubview(countLabel)
            
            let subTotalProductpriceLabel = UILabel(frame: CGRect(x: singleParentView.frame.width - 140, y: unitProductpriceLabel.frame.origin.y, width: 140, height: 22))
            subTotalProductpriceLabel.text = Utils.appendWithCurrencySym(cart.getSubTotal(item))
            subTotalProductpriceLabel.textColor = UIColor(red: (144/255.0), green: (144/255.0), blue: (144/255.0), alpha: 1.0)
            subTotalProductpriceLabel.textAlignment = .right;
            singleParentView.addSubview(subTotalProductpriceLabel)
            
            singleParentView.frame.size.height = icon_img_view.frame.origin.y + icon_img_view.frame.height + 20
            
            
            let border = UILabel(frame: CGRect(x: 0, y: singleParentView.frame.height - 2, width: singleParentView.frame.width, height: 1))
            border.backgroundColor = UIColor(red: (144/255.0), green: (144/255.0), blue: (144/255.0), alpha: 1.0)
            singleParentView.addSubview(border)
            productsParentScrollView.addSubview(singleParentView)
            productsParentScrollView.frame.size.height = singleParentView.frame.origin.y + singleParentView.frame.height
            productYPositon = productYPositon + singleParentView.frame.height + 5
        }
        
        mainParentScrollView.addSubview(productsParentScrollView)
        mainParentScrollView.contentSize.height = productsParentScrollView.frame.origin.y + productsParentScrollView.frame.height + 100
        
    }
    
    
    func populateShippingMethods(_ items : NSArray){
        defer{self.removeLoader()}
        
        for item in items{
            if let itemDict = item as? NSDictionary{
                let title = itemDict["carrier_title"] as? String
                let code = itemDict["carrier_code"] as? String
                let tax = 0.0
                
                if let id = itemDict["method_code"] as? String, let price = itemDict["price_incl_tax"] as? Double{
                    if let shippingMethod = ShippingMethod(id: id, code: code, price: price, title: title, tax:tax){
                        self.shippingMethods.append(shippingMethod)
                    }
                }
            }
        }
        
        self.shippingMethods.sort(by: {$0.price < $1.price})
        self.dropDownTableView.reloadData()
    }
    
    @objc func allDropDownButtonAction(_ button:UIButton){
        dropDownButtonTagValue = button.tag
        
        UIView.animate(withDuration: 0.2, animations: {
            self.shipMethodDropDownButton.imageView!.transform = self.shipMethodDropDownButton.imageView!.transform.rotated(by: 180 * CGFloat(Double.pi/180))
        }, completion: { _ in
        })
        let ypos =  button.frame.origin.y + button.frame.size.height - 3
        
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
        }else{
            customdropDownGestureView.frame.size.height = mainParentScrollView.contentSize.height
            mainParentScrollView.addSubview(customdropDownGestureView)
            
            dropDownTableView.frame.size.width = button.frame.width
            dropDownTableView.frame.origin.x = button.frame.origin.x
            mainParentScrollView.addSubview(dropDownTableView)
            
            dropDownTableView.frame.origin.y = ypos
            UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions(), animations: {
                self.dropDownTableView.frame.size.height = CGFloat(self.shippingMethods.count) * 40 + 15
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
            
            
            let proceedHeight = proceedButton.frame.origin.y + proceedButton.frame.height
            let dropHeight = dropDownTableView.frame.origin.y + dropDownTableView.frame.height
            if(dropHeight >= proceedHeight){
                mainParentScrollView.contentSize.height = dropHeight + 100
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.shippingMethods.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DropDownCell", for: indexPath) as UITableViewCell
        
        let borderLabel = UILabel(frame: CGRect(x: 10, y: cell.frame.size.height - 1, width: cell.frame.size.width - 20, height: 1))
        borderLabel.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        
        let count = self.shippingMethods.count
        
        if((count - 1) != indexPath.row){
            cell.addSubview(borderLabel)
        }
        
        cell.backgroundColor = UIColor(red: (144/255.0), green: (144/255.0), blue: (144/255.0), alpha: 1.0)
        
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.text = self.shippingMethods[indexPath.row].getFullTitle()
        cell.textLabel?.textAlignment = .center;
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        shipMethodDropDownButton.setTitle(self.shippingMethods[indexPath.row].getFullTitle(), for: UIControl.State())
        dropDownGesturebuttonAction()
        
        self.cart.shippingMethod = self.shippingMethods[indexPath.row]
        
        self.createCart()
    }
    
    func createCart(){
        self.clearCart()
        
        self.createProductsList()
        self.createTotalAmount()
        
        self.createDiscountParentView()
    }
    
    @objc func dropDownGesturebuttonAction(){
        dropDownBooleanValue = 0
        let btn = UIButton()
        btn.tag = dropDownButtonTagValue
        allDropDownButtonAction(btn)
    }
    
    func createAddressView(){
        addressParentScrollView.frame = CGRect(x: 0, y: 5, width: mainParentScrollView.frame.width, height: 150)
        
        if(shipBooleanValue == true){
            if Config.guestCheckIn{
                if let billingAddress = UserInfo.guestBillAddress{
                    createAddress(0, title: "Billing Address".localized(), address : billingAddress, addressTag: AddressType.billing.rawValue)
                }
                
                if let shippingAddress = UserInfo.guestShipAddress{
                    createAddress(addressParentScrollView.frame.height, title: "Shipping Address".localized(), address: shippingAddress, addressTag: AddressType.shipping.rawValue)
                }
            }else{
                if let billingAddress = UserManager.Instance.getUserInfo()?.billAddress{
                    createNewAddress(0, title: "Billing Address".localized(), address : billingAddress, addressTag: AddressType.billing.rawValue)
                }
                
                if let shippingAddress = UserManager.Instance.getUserInfo()?.shipAddress{
                    createNewAddress(addressParentScrollView.frame.height, title: "Shipping Address".localized(), address: shippingAddress, addressTag: AddressType.shipping.rawValue)
                }
            }
        }else{
            if Config.guestCheckIn{
                if let billingAddress = UserInfo.guestBillAddress{
                    createAddress(0, title: "Billing & Shipping Address".localized(), address : billingAddress, addressTag: AddressType.billing.rawValue | AddressType.shipping.rawValue)
                }
            }else{
                if let billingAddress = UserManager.Instance.getUserInfo()?.billAddress{
                    createAddress(0, title: "Billing & Shipping Address".localized(), address : billingAddress, addressTag: AddressType.billing.rawValue | AddressType.shipping.rawValue)
                }
            }
        }
    }
    
    func createNewAddress(_ ypos:CGFloat, title:String, address : Address, addressTag : Int){
        let titleParentView = UIView()
        titleParentView.frame = CGRect(x: 0, y: ypos, width: addressParentScrollView.frame.width, height: 60)
        var TitleLabel = UILabel()
        TitleLabel = Utils.createTitleLabel(titleParentView,yposition: 15)
        if(idForSelectedLangauge == Utils.getArebicLanguageCode()){
            TitleLabel.textAlignment = .right
        }
        TitleLabel.text = title
        titleParentView.addSubview(TitleLabel)
        addressParentScrollView.addSubview(titleParentView)
        
        var posy = titleParentView.frame.origin.y + titleParentView.frame.height + 5
        
        posy = createAddressLabel(address.getFullName(), parentView: addressParentScrollView, pos_y: posy)
        posy = createAddressLabel("\(address.getFullStreet()), \(address.city)", parentView: addressParentScrollView, pos_y: posy)
        posy = createAddressLabel("\(address.region.name), \(address.getCountryName()) - \(address.postCode)", parentView: addressParentScrollView, pos_y: posy)
        self.view.reloadInputViews()
        
        
        addressParentScrollView.frame.size.height = addressParentScrollView.frame.size.height + 10
        
        let editButton = UIButton()
        editButton.tag = addressTag
        editButton.frame =  CGRect(x: addressParentScrollView.frame.origin.x + 20, y: addressParentScrollView.frame.height - 1, width: 100, height: 20)
        editButton.backgroundColor = UIColor(red: (144/255.0), green: (144/255.0), blue: (144/255.0), alpha: 1.0)
        editButton.titleLabel?.font = UIFont(name: "Lato", size: 10)
        
        editButton.setTitle("Edit/Change".localized(), for: UIControl.State())
        editButton.setTitleColor(UIColor.white, for: UIControl.State())
        editButton.frame.origin.x = self.view.frame.width/2 - editButton.frame.size.width/2
        editButton.addTarget(self, action: #selector(discountViewController.editAddressButtonAction(_:)), for: UIControl.Event.touchUpInside)
        
        addressParentScrollView.addSubview(editButton)
        
        let newAddressButton = UIButton()
        newAddressButton.frame =  CGRect(x: addressParentScrollView.frame.origin.x + addressParentScrollView.frame.width - 120, y: addressParentScrollView.frame.height - 1, width: 100, height: 20)
        newAddressButton.backgroundColor = UIColor(red: (144/255.0), green: (144/255.0), blue: (144/255.0), alpha: 1.0)
        newAddressButton.titleLabel?.font = UIFont(name: "Lato", size: 10)
        newAddressButton.setTitle("Add New Address".localized(), for: UIControl.State())
        newAddressButton.setTitleColor(UIColor.white, for: UIControl.State())
        newAddressButton.addTarget(self, action: #selector(discountViewController.addNewAddressButtonAction(_:)), for: UIControl.Event.touchUpInside)
        
       // addressParentScrollView.addSubview(newAddressButton)
        
        
        addressParentScrollView.frame.size.height = addressParentScrollView.frame.size.height + 30
        
        let border = UILabel(frame: CGRect(x: addressParentScrollView.frame.origin.x + 15, y: addressParentScrollView.frame.height - 1, width: addressParentScrollView.frame.width - 30, height: 1))
        border.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
        addressParentScrollView.addSubview(border)
        
        mainParentScrollView.addSubview(addressParentScrollView)
    }
    
    
    func createAddress(_ ypos:CGFloat, title:String, address : Address, addressTag : Int){
        let titleParentView = UIView()
        titleParentView.frame = CGRect(x: 0, y: ypos, width: addressParentScrollView.frame.width, height: 60)
        var TitleLabel = UILabel()
        TitleLabel = Utils.createTitleLabel(titleParentView,yposition: 15)
        if(idForSelectedLangauge == Utils.getArebicLanguageCode()){
            TitleLabel.textAlignment = .right
        }
        TitleLabel.text = title
        titleParentView.addSubview(TitleLabel)
        addressParentScrollView.addSubview(titleParentView)
        
        var posy = titleParentView.frame.origin.y + titleParentView.frame.height + 5
        
        posy = createAddressLabel(address.getFullName(), parentView: addressParentScrollView, pos_y: posy)
        posy = createAddressLabel("\(address.getFullStreet()), \(address.city)", parentView: addressParentScrollView, pos_y: posy)
        posy = createAddressLabel("\(address.region.name), \(address.getCountryName()) - \(address.postCode)", parentView: addressParentScrollView, pos_y: posy)
        self.view.reloadInputViews()
        
        
        addressParentScrollView.frame.size.height = addressParentScrollView.frame.size.height + 10
        
        let editButton = UIButton()
        editButton.tag = addressTag
        editButton.frame =  CGRect(x: addressParentScrollView.frame.origin.x + 20, y: addressParentScrollView.frame.height - 1, width: 100, height: 20)
        editButton.backgroundColor = UIColor(red: (144/255.0), green: (144/255.0), blue: (144/255.0), alpha: 1.0)
        editButton.titleLabel?.font = UIFont(name: "Lato", size: 10)
        editButton.frame.origin.x = self.view.frame.width/2 - editButton.frame.size.width/2
        editButton.setTitle("Edit/Change".localized(), for: UIControl.State())
        editButton.setTitleColor(UIColor.white, for: UIControl.State())
        
        editButton.addTarget(self, action: #selector(discountViewController.editAddressButtonAction(_:)), for: UIControl.Event.touchUpInside)
        
        addressParentScrollView.addSubview(editButton)
        
        let newAddressButton = UIButton()
        newAddressButton.frame =  CGRect(x: addressParentScrollView.frame.origin.x + addressParentScrollView.frame.width - 120, y: addressParentScrollView.frame.height - 1, width: 100, height: 20)
        newAddressButton.backgroundColor = UIColor(red: (144/255.0), green: (144/255.0), blue: (144/255.0), alpha: 1.0)
        newAddressButton.titleLabel?.font = UIFont(name: "Lato", size: 10)
        newAddressButton.setTitle("Add New Address".localized(), for: UIControl.State())
        newAddressButton.setTitleColor(UIColor.white, for: UIControl.State())
        newAddressButton.addTarget(self, action: #selector(discountViewController.addNewAddressButtonAction(_:)), for: UIControl.Event.touchUpInside)
        
        //addressParentScrollView.addSubview(newAddressButton)
        
        
        addressParentScrollView.frame.size.height = addressParentScrollView.frame.size.height + 30
        
        let border = UILabel(frame: CGRect(x: addressParentScrollView.frame.origin.x + 15, y: addressParentScrollView.frame.height - 1, width: addressParentScrollView.frame.width - 30, height: 1))
        border.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
        addressParentScrollView.addSubview(border)
        
        mainParentScrollView.addSubview(addressParentScrollView)
    }
    
    @objc func editAddressButtonAction(_ button: UIButton){
//        let addressView = addressViewController(nibName: "addressViewController", bundle: Bundle.main)
//        addressView.addressTag = button.tag
        let addressView = ChooseAddVC(nibName: "ChooseAddVC", bundle: Bundle.main)
        addressView.addressTag = button.tag
        self.navigationController?.pushViewController(addressView, animated: false)
    }
    
    @objc func addNewAddressButtonAction(_ button: UIButton){
        let buyNowObject = self.storyboard?.instantiateViewController(withIdentifier: "buyNowViewController") as? buyNowViewController
        buyNowObject?.newAddress = true
        self.navigationController?.pushViewController(buyNowObject!, animated: true)
    }
    
    func createAddressLabel(_ addressText : String, parentView: UIView, pos_y:CGFloat)->CGFloat{
        let label = UILabel()
        label.font = UIFont(name: "Lato", size: 12)
        if(idForSelectedLangauge == Utils.getArebicLanguageCode()){
            label.frame = CGRect(x: 0 , y: pos_y, width: parentView.frame.width - 25 , height: 20)
            
            label.textAlignment = .right
            
            label.adjustsFontSizeToFitWidth = true
        }else{
            label.frame = CGRect(x: 25, y: pos_y, width: parentView.frame.size.width-50, height: 20)
            
            label.adjustsFontSizeToFitWidth = true
        }
        
        let trimmedString = addressText.replacingOccurrences(of: "\n",with: " ", options: .regularExpression)
        label.text = trimmedString
        
        label.textColor = UIColor(red: (144/255.0), green: (144/255.0), blue: (144/255.0), alpha: 1.0)
        
        label.numberOfLines = 0
        parentView.addSubview(label)
        
        let posy = pos_y + label.frame.size.height
        addressParentScrollView.frame.size.height = label.frame.origin.y + label.frame.height
        return posy
    }
    
    
    func clearCart(){
        for view in productsParentScrollView.subviews{
            view.removeFromSuperview()
        }
        
        for view in totalAmountParentView.subviews{
            view.removeFromSuperview()
        }
    }
    
    func createProductsList(){
        productsParentScrollView.frame = CGRect(x: 0, y: shipMethodDropDownButton.frame.origin.y + shipMethodDropDownButton.frame.height + 10, width: mainParentScrollView.frame.width, height: 150)
        let titleParentView = UIView()
        titleParentView.frame = CGRect(x: 0, y: 0, width: productsParentScrollView.frame.width, height: 50)
        var TitleLabel = UILabel()
        TitleLabel = Utils.createTitleLabel(titleParentView,yposition: 15)
        TitleLabel.text = "Order Summary".localized()
        titleParentView.addSubview(TitleLabel)
        productsParentScrollView.addSubview(titleParentView)
        
        var productYPositon:CGFloat = titleParentView.frame.origin.y + titleParentView.frame.height
        
        for (item, count) in self.cart{
            let singleParentView = UIView()
            print(count)
            singleParentView.frame = CGRect(x: 15, y: productYPositon, width: productsParentScrollView.frame.width - 30, height: 50)
            
            let icon_img_view = UIImageView()
            icon_img_view.contentMode = .scaleAspectFit
            UIImageCache.setImage(icon_img_view, image: item.image)
            if(idForSelectedLangauge == Utils.getArebicLanguageCode())
            {
                icon_img_view.frame = CGRect(x: singleParentView.frame.width - 80, y: 10, width: 80, height: 80)
            }
            else
            {
                icon_img_view.frame = CGRect(x: 0, y: 10, width: 80, height: 80)
            }
            singleParentView.addSubview(icon_img_view)
            let productTitleLabel = UILabel()
            if(idForSelectedLangauge == Utils.getArebicLanguageCode()){
                productTitleLabel.frame = CGRect(x: 10, y: 10, width:singleParentView.frame.width - icon_img_view.frame.size.width * 1.5, height: 37)
            }else{
                productTitleLabel.frame = CGRect(x: icon_img_view.frame.origin.x + icon_img_view.frame.size.width + 20, y: 10, width:singleParentView.frame.width - icon_img_view.frame.size.width * 1.5, height: 37)
            }
            productTitleLabel.text = item.name
            productTitleLabel.textColor = UIColor.black
            productTitleLabel.numberOfLines = 2
            productTitleLabel.sizeToFit()
            singleParentView.addSubview(productTitleLabel)
            
            let unitProductpriceLabel = UILabel(frame: CGRect(x: productTitleLabel.frame.origin.x, y: productTitleLabel.frame.origin.y + productTitleLabel.frame.height + 10, width: 90, height: 22))
            unitProductpriceLabel.text = item.priceStr
            unitProductpriceLabel.textColor = UIColor(red: (144/255.0), green: (144/255.0), blue: (144/255.0), alpha: 1.0)
            singleParentView.addSubview(unitProductpriceLabel)
            
            let crossLabel = UILabel(frame: CGRect(x: unitProductpriceLabel.frame.origin.x + unitProductpriceLabel.frame.width + 3, y: productTitleLabel.frame.origin.y + productTitleLabel.frame.height + 10, width: 10, height: 22))
            crossLabel.text = "x"
            crossLabel.textColor = UIColor(red: (144/255.0), green: (144/255.0), blue: (144/255.0), alpha: 1.0)
            singleParentView.addSubview(crossLabel)
            
            let countLabel = UILabel(frame: CGRect(x: crossLabel.frame.origin.x + crossLabel.frame.width + 1, y: productTitleLabel.frame.origin.y + productTitleLabel.frame.height + 10, width: 30, height: 22))
            countLabel.text = String(item.selectedItemCount)
            countLabel.textAlignment = .left;
            countLabel.textColor = UIColor(red: (144/255.0), green: (144/255.0), blue: (144/255.0), alpha: 1.0)
            singleParentView.addSubview(countLabel)
            
            let subTotalProductpriceLabel = UILabel()
            
            if(idForSelectedLangauge == Utils.getArebicLanguageCode()){
                subTotalProductpriceLabel.frame = CGRect(x: 10, y: productTitleLabel.frame.origin.y + productTitleLabel.bounds.height + 10, width: 120, height: 22)
                
                countLabel.frame = CGRect(x: subTotalProductpriceLabel.frame.origin.x + subTotalProductpriceLabel.frame.width, y: productTitleLabel.frame.origin.y + productTitleLabel.frame.height + 10, width: 25, height: 22)
                
                crossLabel.frame = CGRect(x: countLabel.frame.origin.x + countLabel.frame.width, y: productTitleLabel.frame.origin.y + productTitleLabel.frame.height + 10, width: 10, height: 22)
                
                unitProductpriceLabel.frame = CGRect(x: crossLabel.frame.origin.x + crossLabel.frame.width, y: productTitleLabel.frame.origin.y + productTitleLabel.bounds.height + 10, width: 90, height: 22)
                countLabel.textAlignment = .right
                crossLabel.textAlignment = .left
                unitProductpriceLabel.textAlignment = .right
                subTotalProductpriceLabel.textAlignment = .left
            }else{
                subTotalProductpriceLabel.frame = CGRect(x: singleParentView.frame.width - 140, y: unitProductpriceLabel.frame.origin.y, width: 140, height: 22)
                subTotalProductpriceLabel.textAlignment = .right;
            }
            subTotalProductpriceLabel.text = Utils.appendWithCurrencySym(cart.getSubTotal(item))
            subTotalProductpriceLabel.textColor = UIColor(red: (144/255.0), green: (144/255.0), blue: (144/255.0), alpha: 1.0)
            
            singleParentView.addSubview(subTotalProductpriceLabel)
            
            singleParentView.frame.size.height = icon_img_view.frame.origin.y + icon_img_view.frame.height + 20
            
            
            let border = UILabel(frame: CGRect(x: 0, y: singleParentView.frame.height - 2, width: singleParentView.frame.width, height: 1))
            border.backgroundColor = UIColor(red: (144/255.0), green: (144/255.0), blue: (144/255.0), alpha: 1.0)
            singleParentView.addSubview(border)
            productsParentScrollView.addSubview(singleParentView)
            productsParentScrollView.frame.size.height = singleParentView.frame.origin.y + singleParentView.frame.height
            productYPositon = productYPositon + singleParentView.frame.height + 5
        }
        
        mainParentScrollView.addSubview(productsParentScrollView)
        mainParentScrollView.contentSize.height = productsParentScrollView.frame.origin.y + productsParentScrollView.frame.height + 100
    }
    
    func createTotalAmount(){
        let cart = self.cart
        
        totalAmountParentView.frame = CGRect(x: 15, y: productsParentScrollView.frame.origin.y + productsParentScrollView.frame.height + 10, width: mainParentScrollView.frame.width - 30, height: 150)
        
        let totalTitleLabel = UILabel()
        if(idForSelectedLangauge == Utils.getArebicLanguageCode()){
            totalTitleLabel.textAlignment = .right
            totalTitleLabel.frame =  CGRect(x: totalAmountParentView.frame.width - 150, y: 10 , width: 150, height: 22)
        }else{
            totalTitleLabel.frame =  CGRect(x: 0, y: 10, width: 150, height: 22)
        }
        
        totalTitleLabel.text = "Total".localized()
        totalTitleLabel.textColor = UIColor(red: (144/255.0), green: (144/255.0), blue: (144/255.0), alpha: 1.0)
        totalAmountParentView.addSubview(totalTitleLabel)
        let totalPriceLabel = UILabel()
        if(idForSelectedLangauge == Utils.getArebicLanguageCode()){
            totalPriceLabel.textAlignment = .left
            totalPriceLabel.frame =   CGRect(x: 0, y: 10, width: 150, height: 22)
        }else{
            totalPriceLabel.frame = CGRect(x: totalAmountParentView.frame.width - 150, y: 10 , width: 150, height: 22)
            totalPriceLabel.textAlignment = .right
        }
        
        totalPriceLabel.text = Utils.appendWithCurrencySym(cart.getSubTotal())
        totalPriceLabel.textColor = UIColor.red
        totalAmountParentView.addSubview(totalPriceLabel)
        
        var lastLabel = totalPriceLabel
        var lastTitleLabel = totalTitleLabel
        
        let taxAmount = UILabel()
        if(idForSelectedLangauge == Utils.getArebicLanguageCode()){
            taxAmount.frame = CGRect(x: totalTitleLabel.frame.origin.x , y: lastTitleLabel.frame.origin.y + lastTitleLabel.frame.height + 5 , width: 150, height: 22);
            taxAmount.textAlignment = .right
        }else{
            taxAmount.frame =  CGRect(x: 0, y: lastTitleLabel.frame.origin.y + lastTitleLabel.frame.height + 5, width: 150, height: 22)
        }
        
        taxAmount.text = "Tax Amount".localized()
        taxAmount.textColor = UIColor(red: (144/255.0), green: (144/255.0), blue: (144/255.0), alpha: 1.0)
        totalAmountParentView.addSubview(taxAmount)
        
        let taxAmountlabel = UILabel()
        if(idForSelectedLangauge == Utils.getArebicLanguageCode()){
            taxAmountlabel.textAlignment = .left
            taxAmountlabel.frame = CGRect(x: 0, y: lastTitleLabel.frame.origin.y + lastTitleLabel.frame.height + 5, width: 150, height: 22);
        }else{
            taxAmountlabel.frame = CGRect(x: totalAmountParentView.frame.width - 150, y: lastTitleLabel.frame.origin.y + lastTitleLabel.frame.height + 5 , width: 150, height: 22);             taxAmountlabel.textAlignment = .right;
        }
        
        taxAmountlabel.text =  Utils.appendWithCurrencySym(cart.getTaxAmount())
        taxAmountlabel.textColor = UIColor.red
        
        totalAmountParentView.addSubview(taxAmountlabel)
        
        lastTitleLabel = taxAmount
        
        let discount = cart.getDiscount()
        
        if discount < 0{
            let discountTitleLabel = UILabel(frame: CGRect(x: lastTitleLabel.frame.origin.x, y: lastTitleLabel.frame.origin.y + lastTitleLabel.frame.height + 5, width: lastTitleLabel.frame.width, height: 22))
            discountTitleLabel.text = "Discount".localized()
            if(idForSelectedLangauge == Utils.getArebicLanguageCode())
            {
                taxAmountlabel.textAlignment = .right
            }
            
            discountTitleLabel.textColor = UIColor(red: (144/255.0), green: (144/255.0), blue: (144/255.0), alpha: 1.0)
            discountTitleLabel.numberOfLines = 0
            discountTitleLabel.sizeToFit()
            totalAmountParentView.addSubview(discountTitleLabel)
            lastTitleLabel = discountTitleLabel
            
            let discountPriceLabel = UILabel(frame: CGRect(x: lastLabel.frame.origin.x, y: lastTitleLabel.frame.origin.y, width: lastLabel.frame.width, height: lastTitleLabel.frame.height))
            discountPriceLabel.text = cart.getDiscountStr()
            if(idForSelectedLangauge == Utils.getArebicLanguageCode())
            {
                taxAmountlabel.textAlignment = .left
            }
            discountPriceLabel.textColor = UIColor.red
            discountPriceLabel.textAlignment = .right;
            totalAmountParentView.addSubview(discountPriceLabel)
            lastLabel = discountPriceLabel
        }
        
        if let shippingMethod = cart.shippingMethod{
            let shipMethodTitleLabel = UILabel()
            if(idForSelectedLangauge == Utils.getArebicLanguageCode()){
                shipMethodTitleLabel.frame = CGRect(x: totalTitleLabel.frame.origin.x , y: lastTitleLabel.frame.origin.y + lastTitleLabel.frame.height + 5, width: 150, height: 22)
                shipMethodTitleLabel.textAlignment = .right
            }else{
                shipMethodTitleLabel.frame = CGRect(x: lastTitleLabel.frame.origin.x, y: lastTitleLabel.frame.origin.y + lastTitleLabel.frame.height + 5, width: 150, height: 22)
            }
            
            shipMethodTitleLabel.text = shippingMethod.title
            shipMethodTitleLabel.textColor = UIColor(red: (144/255.0), green: (144/255.0), blue: (144/255.0), alpha: 1.0)
            
            shipMethodTitleLabel.numberOfLines = 0
            totalAmountParentView.addSubview(shipMethodTitleLabel)
            lastTitleLabel = shipMethodTitleLabel
            
            let shipMethodPriceLabel = UILabel()
            shipMethodPriceLabel.frame = CGRect(x: lastLabel.frame.origin.x, y: shipMethodTitleLabel.frame.origin.y, width: lastLabel.frame.width, height: shipMethodTitleLabel.frame.height)
            shipMethodPriceLabel.text = Utils.appendWithCurrencySym(shippingMethod.price)
            
            
            if(idForSelectedLangauge == Utils.getArebicLanguageCode()){
                shipMethodPriceLabel.textAlignment = .left
            }else{
                shipMethodPriceLabel.textAlignment = .right;
            }
            
            shipMethodPriceLabel.textColor = UIColor.red
            totalAmountParentView.addSubview(shipMethodPriceLabel)
            lastLabel = shipMethodPriceLabel
        }
        
        let grandTotalTitleLabel = UILabel()
        
        grandTotalTitleLabel.frame =  CGRect(x: totalTitleLabel.frame.origin.x, y: lastLabel.frame.origin.y + lastLabel.frame.height + 15, width: 150, height: 22)
        grandTotalTitleLabel.text = "Grand Total".localized()
        if(idForSelectedLangauge == Utils.getArebicLanguageCode()){
            grandTotalTitleLabel.textAlignment = .right
        }
        
        grandTotalTitleLabel.textColor = UIColor(red: (144/255.0), green: (144/255.0), blue: (144/255.0), alpha: 1.0)
        totalAmountParentView.addSubview(grandTotalTitleLabel)
        let grandTotalPriceLabel = UILabel()
        grandTotalPriceLabel.frame = CGRect(x: totalPriceLabel.frame.origin.x, y: grandTotalTitleLabel.frame.origin.y, width: 150, height: 22)
        grandTotalPriceLabel.text = Utils.appendWithCurrencySym(cart.getTotalWithShipping())
        grandTotalPriceLabel.textAlignment = .right;
        grandTotalPriceLabel.textColor = UIColor.red
        if(idForSelectedLangauge == Utils.getArebicLanguageCode()){
            grandTotalPriceLabel.textAlignment = .left
        }else{
            grandTotalPriceLabel.textAlignment = .right;
        }
        
        totalAmountParentView.addSubview(grandTotalPriceLabel)
        
        totalAmountParentView.frame.size.height = grandTotalPriceLabel.frame.origin.y + grandTotalPriceLabel.frame.height + 20
        
        mainParentScrollView.addSubview(totalAmountParentView)
        
        mainParentScrollView.contentSize.height = proceedButton.frame.origin.y + proceedButton.frame.height + 100
    }
    
    func createDiscountParentView(){
        proceedButton.isEnabled = true
        discountParentView.frame = CGRect(x: 15, y: totalAmountParentView.frame.origin.y + totalAmountParentView.frame.height + 10, width: mainParentScrollView.frame.width - 30, height: 150)
        
        discountParentView.backgroundColor = UIColor(red: 255, green: 255, blue: 0, alpha: 0.22)
        
        let titleParentView = UIView()
        titleParentView.frame = CGRect(x: 0, y: 0, width: discountParentView.frame.width, height: 50)
        var TitleLabel = UILabel()
        TitleLabel = Utils.createTitleLabel(discountParentView,yposition: 15)
        TitleLabel.text = "Discount Codes".localized()
        TitleLabel.textAlignment = .center;
        titleParentView.addSubview(TitleLabel)
        discountParentView.addSubview(titleParentView)
        
        let couponTitleLabel = Utils.createTitleLabel(titleParentView,yposition: 15)
        couponTitleLabel.frame.origin.y = titleParentView.frame.origin.y + titleParentView.frame.height
        couponTitleLabel.text = "Enter your coupon code if you have one".localized()
        couponTitleLabel.textColor = UIColor(red: (144/255.0), green: (144/255.0), blue: (144/255.0), alpha: 1.0)
        couponTitleLabel.numberOfLines = 0
        if(idForSelectedLangauge == Utils.getArebicLanguageCode()){
            couponTitleLabel.textAlignment = .right
        }
        discountParentView.addSubview(couponTitleLabel)
        
        couponText = Utils.titleTextFields(couponTitleLabel)
        if(idForSelectedLangauge == Utils.getArebicLanguageCode()){
            couponText.textAlignment = .right
        }
        couponText.frame.size.width = discountParentView.frame.width - 40
        couponText.delegate = self
        createTextFieldButtons(couponText)
        discountParentView.addSubview(couponText)
        couponSuccessFailLabel.frame = CGRect(x: couponText.frame.origin.x, y: couponText.frame.origin.y + couponText.frame.height + 3, width: couponText.frame.width, height: 18)
        couponSuccessFailLabel.textColor = UIColor.red
        couponSuccessFailLabel.font = UIFont(name: "Lato", size: 15)
        couponSuccessFailLabel.text = ""
        if(idForSelectedLangauge == Utils.getArebicLanguageCode()) {
            couponSuccessFailLabel.textAlignment = .right
        }
        discountParentView.addSubview(couponSuccessFailLabel)
        
        let applyCouponButton = UIButton()
        
        if(idForSelectedLangauge == Utils.getArebicLanguageCode()){
            applyCouponButton.frame = CGRect(x: discountParentView.frame.width - couponText.frame.width/2 - 20, y: couponSuccessFailLabel.frame.origin.y + couponSuccessFailLabel.frame.size.height + 10, width: couponText.frame.width/2, height: 30)
        }else{
            applyCouponButton.frame = CGRect(x: couponText.frame.origin.x, y: couponSuccessFailLabel.frame.origin.y + couponSuccessFailLabel.frame.size.height + 10, width: couponText.frame.width/2, height: 30)
        }
        
        applyCouponButton.addTarget(self, action: #selector(discountViewController.applyCouponButtonAction(_:)), for: UIControl.Event.touchUpInside)
        applyCouponButton.backgroundColor = UIColor(red: (144/255.0), green: (144/255.0), blue: (144/255.0), alpha: 1.0)
        applyCouponButton.setTitle("Apply Coupon".localized(), for: UIControl.State())
        applyCouponButton.setTitleColor(UIColor.white, for: UIControl.State())
        applyCouponButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
        discountParentView.addSubview(applyCouponButton)
        
        cancelCouponButton.frame = CGRect(x: applyCouponButton.frame.origin.x + applyCouponButton.frame.width + 15, y: applyCouponButton.frame.origin.y, width: couponText.frame.width/2 - 30, height: 30)
        cancelCouponButton.addTarget(self, action: #selector(discountViewController.cancelCouponButtonAction(_:)), for: UIControl.Event.touchUpInside)
        cancelCouponButton.backgroundColor = UIColor(red: (144/255.0), green: (144/255.0), blue: (144/255.0), alpha: 1.0)
        cancelCouponButton.setTitle("Cancel".localized(), for: UIControl.State())
        cancelCouponButton.setTitleColor(UIColor.white, for: UIControl.State())
        cancelCouponButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        cancelCouponButton.isHidden = true
        discountParentView.addSubview(cancelCouponButton)
        
        discountParentView.frame.size.height = applyCouponButton.frame.origin.y + applyCouponButton.frame.height + 20
        
        discountParentView.layer.borderWidth = 8
        let origImage = UIImage(named: "dot.png")
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        discountParentView.layer.borderColor = UIColor(patternImage: tintedImage!).cgColor
        discountParentView.tintColor = UIColor.red
        
        mainParentScrollView.addSubview(discountParentView)
        
        proceedButton.frame = CGRect(x: totalAmountParentView.frame.origin.x, y: discountParentView.frame.origin.y + discountParentView.frame.height + 20, width: totalAmountParentView.frame.width, height: 38)
        proceedButton.addTarget(self, action: #selector(discountViewController.proceedButtonAction(_:)), for: UIControl.Event.touchUpInside)
        proceedButton.backgroundColor = Settings().getButtonBgColor()//UIColor(red: (223/255.0), green: (114/255.0), blue: (114/255.0), alpha: 1.0)
        proceedButton.layer.cornerRadius = 3.0
        proceedButton.setTitle("Proceed".localized(), for: UIControl.State())
        proceedButton.setTitleColor(UIColor.white, for: UIControl.State())
        mainParentScrollView.addSubview(proceedButton)
        proceedButton.frame.origin.y = discountParentView.frame.origin.y + discountParentView.frame.height + 20
        
        mainParentScrollView.contentSize.height = proceedButton.frame.origin.y + proceedButton.frame.height + 100
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func applyCouponButtonAction(_ button: UIButton){
        Utils.fadeButton(button)
        self.addLoader()
        let coupon = couponText.text
        if coupon != nil && !coupon!.isEmpty{
            let url = self.cart.getCouponURL(coupon)
            Utils.fillTheData(url, callback: self.processCoupon, errorCallback : self.showError)
        }else{
            couponSuccessFailLabel.text = "Please enter coupon code".localized()
            self.removeLoader()
        }
    }
    
    @objc func cancelCouponButtonAction(_ button:UIButton){
        Utils.fadeButton(button)
        self.cart.applyCoupon("")
        self.createCart()
    }
    
    fileprivate func processCoupon(_ dataDict: NSDictionary){
        cancelCouponButton.isHidden = true
        couponSuccessFailLabel.text = ""
        couponText.resignFirstResponder()
        let couponCode = couponText.text!
        self.cart.applyCoupon(couponCode)
        
        self.createCart()
        
        if let couponStatus = dataDict["coupon_status"] as? Int{
            if couponStatus == 1{
                cancelCouponButton.isHidden = false
                couponSuccessFailLabel.text = "\(couponCode) applied successfully".localized()
                self.alert("\(couponCode) applied successfully".localized())
            }else{
                couponSuccessFailLabel.text = "\(couponCode) is invalid".localized()
            }
        }else{
            couponSuccessFailLabel.text = "\(couponCode) is invalid".localized()
        }
        
        self.removeLoader()
    }
    
    @objc func proceedButtonAction(_ button:ZFRippleButton){
        
        let paymentObject = self.storyboard?.instantiateViewController(withIdentifier: "paymentMethodViewController") as? paymentMethodViewController
        paymentObject?.cart = self.cart
        self.navigationController?.pushViewController(paymentObject!, animated: true)
    
    }
    
    func backButtonFunction(){
        ShoppingCart.Instance.applyCoupon(nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    func createTextFieldButtons(_ textField: UITextField){
        textField.addTarget(self, action: #selector(discountViewController.myTargetEditingDidBeginFunction(_:)), for: UIControl.Event.editingDidBegin)
        textField.addTarget(self, action: #selector(discountViewController.myTargetEditingDidEndFunction(_:)), for: UIControl.Event.editingDidEnd)
    }
    
    @objc func myTargetEditingDidBeginFunction(_ textField: UITextField) {
    }
    @objc func myTargetEditingDidEndFunction(_ textField: UITextField) {
    }
}

