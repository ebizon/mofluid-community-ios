//
//  sample.swift
//  Mofluid
//
//  Created by sudeep goyal on 10/09/15.
//  Copyright © 2015 Mofluid. All rights reserved.
//

import UIKit
import Foundation

class orderDetailsViewController: PageViewController{
    var orderData: OrderData? = nil
    var orderList = [OrderData]()
    var detailsParentScrollView = UIScrollView()
    var productsParentScrollView = UIScrollView()
    var leftTitlesArray = ["Billing Address".localized(),"Shipping Address".localized(),"Grand Total".localized(),"Status".localized(),"Order Id".localized(),"Payment Method".localized(),"Shipping Method".localized(),"Order Date".localized()]
    
    var totalAmountParentView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "View Order".uppercased()
        createDetailsList()
        createProductsList()
        createTotalAmount()
        
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
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "OptionViewTap"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "selectOptionViewOption"), object: nil)
    }
    
    func createDetailsList(){
        if let order = self.orderData{
            detailsParentScrollView.frame = CGRect(x: 0, y: 0, width: mainParentScrollView.frame.width, height: 150)
            let titleParentView = UIView()
            titleParentView.frame = CGRect(x: 0, y: 0, width: detailsParentScrollView.frame.width, height: 60)
            titleParentView.backgroundColor = UIColor(netHex:0xeaeaea)
            var TitleLabel = UILabel()
            TitleLabel = Utils.createTitleLabel(titleParentView,yposition: 15)
            TitleLabel.text = "Items in your Order".localized()
            titleParentView.addSubview(TitleLabel)
            detailsParentScrollView.addSubview(titleParentView)
            
            var posy:CGFloat = titleParentView.frame.origin.y + titleParentView.frame.height
            
            
            let rightTitleArray = [
                "Billing Address",
                "Shipping Address",
                Utils.appendWithCurrencySymStr(order.grandTotal ?? "0.0"),
                order.getStatus(),
                order.id,order.paymentMethod ?? "",
                order.shipMethod ?? "",
                order.date
            ]
            
            if idForSelectedLangauge == Utils.getArebicLanguageCode() {
                for titleCount in 0 ..< leftTitlesArray.count{
                    TitleLabel.textAlignment = .right
                    let singleParentView = UIView()
                    singleParentView.frame = CGRect(x: 0, y: posy, width: detailsParentScrollView.frame.width, height: 50)
                    
                    
                    //This will go to left
                    let rightScrollView = UIScrollView()
                    rightScrollView.frame = CGRect(x: 20, y: 10, width: singleParentView.frame.size.width/2 - 20, height: singleParentView.frame.size.height)
                    var rightYposition:CGFloat = 0
                    singleParentView.addSubview(rightScrollView)
                    
                    //This will go to right
                    let leftLabel = UILabel(frame: CGRect(x:rightScrollView.bounds.width + 10, y: 10, width: singleParentView.frame.size.width/2 - 40, height: 25))
                    leftLabel.text = leftTitlesArray[titleCount]
                    leftLabel.textColor = UIColor.black
                    leftLabel.textAlignment = .right
                    singleParentView.addSubview(leftLabel)
                    
                    if(titleCount == 0){
                        if let address = order.billingAddress{
                            rightYposition = self.createAddresLabel(rightScrollView: rightScrollView, inRightYposition: rightYposition, address: address, singleParentView: singleParentView)
                        }
                    }else if(titleCount == 1){
                        if let address = order.shippingAddress{
                            rightYposition = self.createAddresLabel(rightScrollView: rightScrollView, inRightYposition: rightYposition, address: address, singleParentView: singleParentView)
                        }
                    }
                    else{
                        
                        let rightLabel = UILabel(frame: CGRect(x: 20, y: 10, width: singleParentView.frame.size.width/2 - 20, height: 25))
                        rightLabel.text = rightTitleArray[titleCount]
                        rightLabel.textAlignment = .right
                        rightLabel.textColor = UIColor.black
                        singleParentView.addSubview(rightLabel)
                        singleParentView.frame.size.height = rightLabel.frame.origin.y + rightLabel.frame.height + 10
                    }
                    
                    let border = UILabel(frame: CGRect(x: singleParentView.frame.origin.x + 15, y: singleParentView.frame.height - 1, width: singleParentView.frame.width - 30, height: 1))
                    border.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
                    singleParentView.addSubview(border)
                    posy = posy + singleParentView.frame.height
                    detailsParentScrollView.addSubview(singleParentView)
                    detailsParentScrollView.frame.size.height = singleParentView.frame.origin.y + singleParentView.frame.height + 10
                }
            }
            else{
                for titleCount in 0 ..< leftTitlesArray.count{
                    
                    let singleParentView = UIView()
                    singleParentView.frame = CGRect(x: 0, y: posy, width: detailsParentScrollView.frame.width, height: 50)
                    
                    let leftLabel = UILabel(frame: CGRect(x: 20, y: 10, width: singleParentView.frame.size.width/2 - 40, height: 25))
                    leftLabel.text = leftTitlesArray[titleCount]
                    leftLabel.textColor = UIColor.black
                    singleParentView.addSubview(leftLabel)
                    
                    let rightScrollView = UIScrollView()
                    rightScrollView.frame = CGRect(x: leftLabel.frame.size.width + leftLabel.frame.origin.x + 10, y: 10, width: singleParentView.frame.size.width/2 - 20, height: singleParentView.frame.size.height)
                    var rightYposition:CGFloat = 0
                    singleParentView.addSubview(rightScrollView)
                    
                    if(titleCount == 0){
                        if let address = order.billingAddress{
                            rightYposition = self.createAddresLabel(rightScrollView: rightScrollView, inRightYposition: rightYposition, address: address, singleParentView: singleParentView)
                        }
                    }
                    else if(titleCount == 1){
                        if let address = order.shippingAddress{
                            rightYposition = self.createAddresLabel(rightScrollView: rightScrollView, inRightYposition: rightYposition, address: address, singleParentView: singleParentView)
                        }
                    }
                    else{
                        
                        let rightLabel = UILabel(frame: CGRect(x: leftLabel.frame.size.width + leftLabel.frame.origin.x + 10, y: 10, width: singleParentView.frame.size.width/2 - 20, height: 25))
                        rightLabel.text = rightTitleArray[titleCount]
                        rightLabel.textColor = UIColor.black
                        singleParentView.addSubview(rightLabel)
                        singleParentView.frame.size.height = rightLabel.frame.origin.y + rightLabel.frame.height + 10
                    }
                    
                    let border = UILabel(frame: CGRect(x: singleParentView.frame.origin.x + 15, y: singleParentView.frame.height - 1, width: singleParentView.frame.width - 30, height: 1))
                    border.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
                    singleParentView.addSubview(border)
                    posy = posy + singleParentView.frame.height
                    detailsParentScrollView.addSubview(singleParentView)
                    detailsParentScrollView.frame.size.height = singleParentView.frame.origin.y + singleParentView.frame.height + 10
                }
            }
            
            mainParentScrollView.addSubview(detailsParentScrollView)
            mainParentScrollView.contentSize.height = detailsParentScrollView.frame.origin.y + detailsParentScrollView.frame.height + 100
        }
    }
    
    func createAddresLabel(rightScrollView : UIScrollView, inRightYposition : CGFloat, address : Address, singleParentView : UIView) -> CGFloat{
        var rightYposition = self.createLabel(address.getFullName(), scrollView : rightScrollView, yPosition: inRightYposition)
        rightYposition = self.createLabel(address.getFullStreet(), scrollView : rightScrollView, yPosition: rightYposition)
        rightYposition = self.createLabel(address.city, scrollView : rightScrollView, yPosition: rightYposition)
        rightYposition = self.createLabel(address.region.name, scrollView : rightScrollView, yPosition: rightYposition)
        rightYposition = self.createLabel(address.getCountryName(), scrollView : rightScrollView, yPosition: rightYposition)
        rightYposition = self.createLabel(address.postCode, scrollView : rightScrollView, yPosition: rightYposition)
        rightYposition = self.createLabel(address.telePhone, scrollView : rightScrollView, yPosition: rightYposition)
        singleParentView.frame.size.height = rightScrollView.frame.origin.y + rightScrollView.frame.height + 10
        
        return rightYposition
    }
    
    func createLabel(_ labelText: String, scrollView: UIScrollView, yPosition: CGFloat)->CGFloat{
        let label = UILabel(frame: CGRect(x: 5, y: yPosition, width: scrollView.frame.size.width-10, height: 25))
        label.text = labelText
        label.numberOfLines = 2
        label.sizeToFit()
        label.textColor = UIColor.black
        scrollView.addSubview(label)
        scrollView.frame.size.height = label.frame.origin.y + label.frame.height
        let rightYposition = yPosition + label.frame.height
        
        return rightYposition
    }
    
    func createProductsList(){
        productsParentScrollView.frame = CGRect(x: 0, y: detailsParentScrollView.frame.origin.y + detailsParentScrollView.frame.height, width: mainParentScrollView.frame.width, height: 150)
        let titleParentView = UIView()
        titleParentView.frame = CGRect(x: 0, y: 0, width: detailsParentScrollView.frame.width, height: 60)
        titleParentView.backgroundColor = UIColor(netHex:0xeaeaea)
        var TitleLabel = UILabel()
        TitleLabel = Utils.createTitleLabel(titleParentView,yposition: 15)
        TitleLabel.text = "Items in your Order".localized()
        titleParentView.addSubview(TitleLabel)
        productsParentScrollView.addSubview(titleParentView)
        
        var productYPositon:CGFloat = titleParentView.frame.origin.y + titleParentView.frame.height
        
        
        
        if idForSelectedLangauge == Utils.getArebicLanguageCode() {
            TitleLabel.textAlignment = .right
            for item in (orderData?.items)!{
                let singleParentView = UIView()
                singleParentView.frame = CGRect(x: 15, y: productYPositon, width: productsParentScrollView.frame.width - 30, height: 50)
                
                let width = singleParentView.bounds.width
                
                let icon_img_view = UIImageView()
                icon_img_view.contentMode = .scaleAspectFit
                UIImageCache.setImage(icon_img_view, image: item.image)
                icon_img_view.frame = CGRect(x: width - 80, y: 10, width: 80, height: 80)
                singleParentView.addSubview(icon_img_view)
                
                let productTitleLabel = UILabel(frame: CGRect(x: 10, y: 10, width:width - icon_img_view.frame.size.width - 15, height: 37))
                productTitleLabel.text = item.name
                productTitleLabel.textColor = UIColor.black
                productTitleLabel.numberOfLines = 2
                productTitleLabel.sizeToFit()
                singleParentView.addSubview(productTitleLabel)
                
                let subTotalProductpriceLabel = UILabel(frame: CGRect(x: 10, y: productTitleLabel.frame.origin.y + productTitleLabel.bounds.height + 10, width: 120, height: 22))
                let tot = Utils.StringToDouble(item.price) * Double(item.quantity)
                subTotalProductpriceLabel.text = Utils.appendWithCurrencySym(tot)
                subTotalProductpriceLabel.textColor = UIColor.black
                subTotalProductpriceLabel.textAlignment = .left;
                singleParentView.addSubview(subTotalProductpriceLabel)
                
                let countLabel = UILabel(frame: CGRect(x: subTotalProductpriceLabel.frame.origin.x + subTotalProductpriceLabel.frame.width + 1, y: productTitleLabel.frame.origin.y + productTitleLabel.frame.height + 10, width: 25, height: 22))
                countLabel.text = String(item.quantity)
                countLabel.textAlignment = .right;
                countLabel.textColor = UIColor.lightGray
                singleParentView.addSubview(countLabel)
                
                let crossLabel = UILabel(frame: CGRect(x: countLabel.frame.origin.x + countLabel.frame.width, y: productTitleLabel.frame.origin.y + productTitleLabel.frame.height + 10, width: 10, height: 22))
                crossLabel.text = "x"
                crossLabel.textAlignment = .left
                crossLabel.textColor = UIColor.lightGray
                singleParentView.addSubview(crossLabel)
                
                let unitProductpriceLabel = UILabel(frame: CGRect(x: crossLabel.frame.origin.x + crossLabel.frame.width, y: productTitleLabel.frame.origin.y + productTitleLabel.bounds.height + 10, width: 90, height: 22))
                unitProductpriceLabel.text = Utils.appendWithCurrencySymStr(item.price)
                unitProductpriceLabel.textColor = UIColor.lightGray
                unitProductpriceLabel.textAlignment = .right
                singleParentView.addSubview(unitProductpriceLabel)
                
                singleParentView.frame.size.height = icon_img_view.frame.origin.y + icon_img_view.frame.height + 20
                
                let border = UILabel(frame: CGRect(x: 0, y: singleParentView.frame.height - 2, width: singleParentView.frame.width, height: 1))
                border.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
                singleParentView.addSubview(border)
                productsParentScrollView.addSubview(singleParentView)
                productsParentScrollView.frame.size.height = singleParentView.frame.origin.y + singleParentView.frame.height
                productYPositon = productYPositon + singleParentView.frame.height + 5
            }
        }else{
            if orderData?.items != nil {
                for item in (orderData?.items)!{
                    let singleParentView = UIView()
                    singleParentView.frame = CGRect(x: 15, y: productYPositon, width: productsParentScrollView.frame.width - 30, height: 50)
                    
                    let icon_img_view = UIImageView()
                    icon_img_view.contentMode = .scaleAspectFit
                    UIImageCache.setImage(icon_img_view, image: item.image)
                    icon_img_view.frame = CGRect(x: 0, y: 10, width: 80, height: 80)
                    singleParentView.addSubview(icon_img_view)
                    
                    let productTitleLabel = UILabel(frame: CGRect(x: icon_img_view.frame.origin.x + icon_img_view.frame.size.width + 20, y: 10, width:singleParentView.frame.width - icon_img_view.frame.size.width * 1.5, height: 37))
                    productTitleLabel.text = item.name
                    productTitleLabel.textColor = UIColor.black
                    productTitleLabel.numberOfLines = 2
                    productTitleLabel.sizeToFit()
                    singleParentView.addSubview(productTitleLabel)
                    
                    let unitProductpriceLabel = UILabel(frame: CGRect(x: productTitleLabel.frame.origin.x, y: productTitleLabel.frame.origin.y + productTitleLabel.frame.height + 10, width: 90, height: 22))
                    unitProductpriceLabel.text = Utils.appendWithCurrencySymStr(item.price)
                    unitProductpriceLabel.textColor = UIColor.lightGray
                    singleParentView.addSubview(unitProductpriceLabel)
                    
                    let crossLabel = UILabel(frame: CGRect(x: unitProductpriceLabel.frame.origin.x + unitProductpriceLabel.frame.width + 3, y: productTitleLabel.frame.origin.y + productTitleLabel.frame.height + 10, width: 10, height: 22))
                    crossLabel.text = "x"
                    crossLabel.textColor = UIColor.lightGray
                    singleParentView.addSubview(crossLabel)
                    
                    let countLabel = UILabel(frame: CGRect(x: crossLabel.frame.origin.x + crossLabel.frame.width + 1, y: productTitleLabel.frame.origin.y + productTitleLabel.frame.height + 10, width: 30, height: 22))
                    countLabel.text = String(item.quantity)
                    countLabel.textAlignment = .left;
                    countLabel.textColor = UIColor.lightGray
                    singleParentView.addSubview(countLabel)
                    
                    
                    
                    let subTotalProductpriceLabel = UILabel(frame: CGRect(x: singleParentView.frame.width - 140, y: unitProductpriceLabel.frame.origin.y, width: 140, height: 22))
                    let tot = Utils.StringToDouble(item.price) * Double(item.quantity)
                    subTotalProductpriceLabel.text = Utils.appendWithCurrencySym(tot)
                    subTotalProductpriceLabel.textColor = UIColor.black
                    subTotalProductpriceLabel.textAlignment = .right;
                    singleParentView.addSubview(subTotalProductpriceLabel)
                    
                    singleParentView.frame.size.height = icon_img_view.frame.origin.y + icon_img_view.frame.height + 20
                    
                    
                    let border = UILabel(frame: CGRect(x: 0, y: singleParentView.frame.height - 2, width: singleParentView.frame.width, height: 1))
                    border.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
                    singleParentView.addSubview(border)
                    productsParentScrollView.addSubview(singleParentView)
                    productsParentScrollView.frame.size.height = singleParentView.frame.origin.y + singleParentView.frame.height
                    productYPositon = productYPositon + singleParentView.frame.height + 5
                }
            }
        }
        
        mainParentScrollView.addSubview(productsParentScrollView)
        mainParentScrollView.contentSize.height = productsParentScrollView.frame.origin.y + productsParentScrollView.frame.height + 100
    }
    
    func createTotalAmount(){
        
        totalAmountParentView.frame = CGRect(x: 15, y: productsParentScrollView.frame.origin.y + productsParentScrollView.frame.height + 10, width: mainParentScrollView.frame.width - 30, height: 150)
        
        if let order = self.orderData{
            if idForSelectedLangauge == Utils.getArebicLanguageCode() {
                
                let width = totalAmountParentView.bounds.width
                var nextY:CGFloat = 5.0
                
                // Subtitle line
                let subTotalPriceLabel = UILabel(frame: CGRect(x: 0, y: nextY, width: 150, height: 22))
                subTotalPriceLabel.text = Utils.appendWithCurrencySym(order.getSubTotal())
                subTotalPriceLabel.textColor = UIColor.red
                subTotalPriceLabel.textAlignment = .left
                totalAmountParentView.addSubview(subTotalPriceLabel)
                
                let subTotalTitleLabel = UILabel(frame: CGRect(x: subTotalPriceLabel.bounds.width, y: nextY, width: width - 150, height: 22))
                subTotalTitleLabel.text = "Sub Total".localized()
                subTotalTitleLabel.textAlignment = .right
                subTotalTitleLabel.textColor = UIColor.black
                totalAmountParentView.addSubview(subTotalTitleLabel)
                
                // Shipping line
                nextY = subTotalTitleLabel.frame.origin.y + subTotalTitleLabel.frame.height
                
                let shipAmountPriceLabel = UILabel(frame: CGRect(x: 0, y: nextY , width: 150, height: 22))
                shipAmountPriceLabel.text = Utils.appendWithCurrencySym(Utils.StringToDouble(order.shippingAmount ?? "0.0"))
                // shipAmountPriceLabel.text = Utils.appendWithCurrencySym(Utils.StringToDouble(order.shippingAmount!))
                shipAmountPriceLabel.textColor = UIColor.red
                shipAmountPriceLabel.textAlignment = .left;
                totalAmountParentView.addSubview(shipAmountPriceLabel)
                
                let shipAmountTitleLabel = UILabel(frame: CGRect(x: shipAmountPriceLabel.bounds.width, y: nextY, width: width - 150, height: 22))
                shipAmountTitleLabel.text = "Shipping & Handling".localized()
                shipAmountTitleLabel.textColor = UIColor.black
                shipAmountTitleLabel.textAlignment = .right
                totalAmountParentView.addSubview(shipAmountTitleLabel)
                
                var lastTitleLabel = shipAmountTitleLabel
                var lastPriceLabel = shipAmountPriceLabel
                
                if let _ = order.couponCode{
                    if order.getDiscount() < 0.0{
                        
                        nextY = lastTitleLabel.frame.origin.y + shipAmountTitleLabel.frame.height + 5
                        
                        let discounTitleLabel = UILabel(frame: CGRect(x: lastTitleLabel.frame.origin.x, y: nextY, width: 150, height: 22))
                        discounTitleLabel.text = "Discount".localized()
                        discounTitleLabel.textColor = UIColor.black
                        totalAmountParentView.addSubview(discounTitleLabel)
                        
                        let discountPriceLabel = UILabel(frame: CGRect(x: lastPriceLabel.frame.origin.x, y: discounTitleLabel.frame.origin.y, width: 150, height: 22))
                        discountPriceLabel.text = Utils.appendWithCurrencySym(order.getDiscount())
                        discountPriceLabel.textColor = UIColor.red
                        discountPriceLabel.textAlignment = .right;
                        totalAmountParentView.addSubview(discountPriceLabel)
                        lastTitleLabel = discounTitleLabel
                        lastPriceLabel = discountPriceLabel
                    }
                }
                
                if let taxAmount = order.taxAmount{
                    let taxValue = Utils.StringToDouble(taxAmount)
                    if taxValue > 0{
                        nextY = shipAmountTitleLabel.frame.origin.y + shipAmountTitleLabel.frame.height + 5
                        let taxTitleLabel = UILabel(frame: CGRect(x: shipAmountTitleLabel.frame.origin.x, y: nextY, width: 150, height: 22))
                        taxTitleLabel.text = "Tax".localized()
                        taxTitleLabel.textColor = UIColor.black
                        totalAmountParentView.addSubview(taxTitleLabel)
                        
                        let taxPriceLabel = UILabel(frame: CGRect(x: lastPriceLabel.frame.origin.x, y: taxTitleLabel.frame.origin.y, width: 150, height: 22))
                        taxPriceLabel.text = Utils.appendWithCurrencySym(Utils.StringToDouble(order.taxAmount ?? "0.0"))
                        taxPriceLabel.textColor = UIColor.red
                        taxPriceLabel.textAlignment = .right;
                        totalAmountParentView.addSubview(taxPriceLabel)
                        lastTitleLabel = taxTitleLabel
                    }
                }
                
                nextY = lastTitleLabel.frame.origin.y + lastTitleLabel.frame.height + 5
                
                let grandTotalTitleLabel = UILabel(frame: CGRect(x: width - 150, y: nextY, width: 150, height: 22))
                grandTotalTitleLabel.text = "Grand Total".localized()
                grandTotalTitleLabel.textAlignment = .right
                grandTotalTitleLabel.textColor = UIColor.black
                totalAmountParentView.addSubview(grandTotalTitleLabel)
                
                let grandTotalPriceLabel = UILabel(frame: CGRect(x: 0, y: grandTotalTitleLabel.frame.origin.y, width: 150, height: 22))
                grandTotalPriceLabel.text = Utils.appendWithCurrencySym(Utils.StringToDouble(order.grandTotal!))
                grandTotalPriceLabel.textColor = UIColor.red
                grandTotalPriceLabel.textAlignment = .left
                totalAmountParentView.addSubview(grandTotalPriceLabel)
                
                totalAmountParentView.frame.size.height = grandTotalPriceLabel.frame.origin.y + grandTotalPriceLabel.frame.height + 25
                
            }
            else{
                let subTotalTitleLabel = UILabel(frame: CGRect(x: 0, y: 5, width: 350, height: 22))
                subTotalTitleLabel.text = "Sub Total".localized()
                subTotalTitleLabel.textColor = UIColor.black
                totalAmountParentView.addSubview(subTotalTitleLabel)
                
                let subTotalPriceLabel = UILabel(frame: CGRect(x: totalAmountParentView.frame.width - 150, y: subTotalTitleLabel.frame.origin.y, width: 150, height: 22))
                subTotalPriceLabel.text = Utils.appendWithCurrencySym(order.getSubTotal())
                subTotalPriceLabel.textColor = UIColor.red
                subTotalPriceLabel.textAlignment = .right;
                totalAmountParentView.addSubview(subTotalPriceLabel)
                
                let shipAmountTitleLabel = UILabel(frame: CGRect(x: subTotalTitleLabel.frame.origin.x, y: subTotalTitleLabel.frame.origin.y + subTotalTitleLabel.frame.height + 5, width: 350, height: 22))
                shipAmountTitleLabel.text = "Shipping & Handling".localized()
                shipAmountTitleLabel.textColor = UIColor.black
                totalAmountParentView.addSubview(shipAmountTitleLabel)
                
                let shipAmountPriceLabel = UILabel(frame: CGRect(x: totalAmountParentView.frame.width - 150, y: shipAmountTitleLabel.frame.origin.y, width: 150, height: 22))
                shipAmountPriceLabel.text = Utils.appendWithCurrencySym(Utils.StringToDouble(order.shippingAmount!))
                shipAmountPriceLabel.textColor = UIColor.red
                shipAmountPriceLabel.textAlignment = .right;
                totalAmountParentView.addSubview(shipAmountPriceLabel)
                var lastTitleLabel = shipAmountTitleLabel
                var lastPriceLabel = shipAmountPriceLabel
                
                if let _ = order.couponCode{
                    if order.getDiscount() < 0.0{
                        let discounTitleLabel = UILabel(frame: CGRect(x: lastTitleLabel.frame.origin.x, y: lastTitleLabel.frame.origin.y + shipAmountTitleLabel.frame.height + 5, width: 150, height: 22))
                        discounTitleLabel.text = "Discount".localized()
                        discounTitleLabel.textColor = UIColor.black
                        totalAmountParentView.addSubview(discounTitleLabel)
                        
                        let discountPriceLabel = UILabel(frame: CGRect(x: lastPriceLabel.frame.origin.x, y: discounTitleLabel.frame.origin.y, width: 150, height: 22))
                        discountPriceLabel.text = Utils.appendWithCurrencySym(order.getDiscount())
                        discountPriceLabel.textColor = UIColor.red
                        discountPriceLabel.textAlignment = .right;
                        totalAmountParentView.addSubview(discountPriceLabel)
                        lastTitleLabel = discounTitleLabel
                        lastPriceLabel = discountPriceLabel
                    }
                }
                
                if let taxAmount = order.taxAmount{
                    let taxValue = Utils.StringToDouble(taxAmount)
                    if taxValue > 0{
                        let taxTitleLabel = UILabel(frame: CGRect(x: shipAmountTitleLabel.frame.origin.x, y: shipAmountTitleLabel.frame.origin.y + shipAmountTitleLabel.frame.height + 5, width: 150, height: 22))
                        taxTitleLabel.text = "Tax".localized()
                        taxTitleLabel.textColor = UIColor.black
                        totalAmountParentView.addSubview(taxTitleLabel)
                        
                        let taxPriceLabel = UILabel(frame: CGRect(x: lastPriceLabel.frame.origin.x, y: taxTitleLabel.frame.origin.y, width: 150, height: 22))
                        taxPriceLabel.text = Utils.appendWithCurrencySym(Utils.StringToDouble(order.taxAmount ?? "0.0"))
                        taxPriceLabel.textColor = UIColor.red
                        taxPriceLabel.textAlignment = .right;
                        totalAmountParentView.addSubview(taxPriceLabel)
                        lastTitleLabel = taxTitleLabel
                    }
                }
                
                let grandTotalTitleLabel = UILabel(frame: CGRect(x: shipAmountTitleLabel.frame.origin.x, y: lastTitleLabel.frame.origin.y + lastTitleLabel.frame.height + 5, width: 150, height: 22))
                grandTotalTitleLabel.text = "Grand Total".localized()
                grandTotalTitleLabel.textColor = UIColor.black
                totalAmountParentView.addSubview(grandTotalTitleLabel)
                
                let grandTotalPriceLabel = UILabel(frame: CGRect(x: shipAmountPriceLabel.frame.origin.x, y: grandTotalTitleLabel.frame.origin.y, width: 150, height: 22))
                if order.grandTotal != nil{
                    
                    grandTotalPriceLabel.text = Utils.appendWithCurrencySym(Utils.StringToDouble(order.grandTotal!))
                }
                else {
                    
                    //let value = Float(order.taxAmount!)! + Float(order.shippingAmount!)!
                    //grandTotalPriceLabel.text = String(value)
                    
                }
                grandTotalPriceLabel.textColor = UIColor.red
                grandTotalPriceLabel.textAlignment = .right;
                totalAmountParentView.addSubview(grandTotalPriceLabel)
                
                totalAmountParentView.frame.size.height = grandTotalPriceLabel.frame.origin.y + grandTotalPriceLabel.frame.height + 25
            }
            let border = UILabel(frame: CGRect(x: 0, y: totalAmountParentView.frame.height - 2, width: totalAmountParentView.frame.width, height: 1))
            border.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
            totalAmountParentView.addSubview(border)
            
            mainParentScrollView.addSubview(totalAmountParentView)
            
        }
        
        let viewAllOrdersButton = ZFRippleButton()
        viewAllOrdersButton.frame = CGRect(x: totalAmountParentView.frame.origin.x, y: totalAmountParentView.frame.origin.y + totalAmountParentView.frame.size.height + 30, width: totalAmountParentView.frame.width, height: 38)
        viewAllOrdersButton.addTarget(self, action: #selector(orderDetailsViewController.viewAllOrdersButtonAction(_:)), for: UIControl.Event.touchUpInside)
        //        let backgroundImg = UIImage(named: "background")
        //        viewAllOrdersButton.setBackgroundImage(backgroundImg, forState: UIControlState.Normal)
        viewAllOrdersButton.backgroundColor = Settings().getButtonBgColor()//UIColor(red: (223/255.0), green: (114/255.0), blue: (114/255.0), alpha: 1.0)
        viewAllOrdersButton.layer.cornerRadius = 3.0
        viewAllOrdersButton.setTitle("View All Orders".localized(), for: UIControl.State())
        viewAllOrdersButton.titleLabel?.textColor = UIColor(netHex:0xf78f1e)
        
        mainParentScrollView.addSubview(viewAllOrdersButton)
        mainParentScrollView.contentSize.height = viewAllOrdersButton.frame.origin.y + viewAllOrdersButton.frame.height + 100
        
    }
    
    @objc func viewAllOrdersButtonAction(_ button:ZFRippleButton){
        //    self.navigationController?.popViewControllerAnimated(true)
        let myOrderView = NewMyOrderViewController(nibName: "NewMyOrderViewController", bundle: Bundle.main)
        myOrderView.orderList = self.orderList
        self.navigationController?.pushViewController(myOrderView, animated: false)
    }
    
    func backButtonFunction(){
        self.navigationController?.popViewController(animated: true)
    }
}

