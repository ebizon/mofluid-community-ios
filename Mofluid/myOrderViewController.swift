//
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
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}


class myOrderViewController: PageViewController{
    var orderList = [OrderData]()
    var currentOrder : OrderData? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "My Orders".localized().uppercased()
        self.loadOrders()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(deviceName == "big"){
            UILabel.appearance().font = UIFont(name: "Lato", size: 20)
        }else{
            UILabel.appearance().font = UIFont(name: "Lato", size: 15)
        }
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "OptionViewTap"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "selectOptionViewOption"), object: nil)
    }
    
    func loadOrders(){
        self.addLoader()
        let url = WebApiManager.Instance.getMyOrderURL()
        Utils.fillTheData(url, callback: self.processOrders, errorCallback : self.showError)
    }
    
    func processOrders(_ dataDict: NSDictionary){
        defer{self.removeLoader()}
        let total = dataDict["total"] as? Int
        
        if(total > 0){
            if let data = dataDict["data"] as? NSArray{
                data.forEach{item in
                    if let itemDict = item as? NSDictionary{
                        let orderID = itemDict["order_id"] as? String
                        let orderDate = itemDict["order_date"] as? String
                        let orderStatus = itemDict["status"] as? String
                        if orderID != nil && orderDate != nil && orderStatus != nil{
                            if(orderStatus != "complete"){
                                let orderData = OrderData(id: orderID!, date : orderDate!, status: orderStatus!)
                                if let product = itemDict["product"] as? NSDictionary{
                                    orderData.items = self.createOrderItems(product)
                                }
                                
                                if let shippingAddress = itemDict["shipping_address"] as? NSDictionary{
                                    orderData.shippingAddress = AddressData.createAddress(shippingAddress)
                                }
                                if let billingAddress = itemDict["billing_address"] as? NSDictionary{
                                    orderData.billingAddress = AddressData.createAddress(billingAddress)
                                }
                                if let payMethods = itemDict["payment_method"] as? NSDictionary{
                                    if let payTitle = payMethods["payment_method_title"] as? String{
                                        orderData.paymentMethod = payTitle
                                    }
                                }
                                if let shipAmount = itemDict["shipping_amount"] as? String{
                                    orderData.shippingAmount = shipAmount
                                }
                                if let taxAmount = itemDict["tax_amount"] as? String{
                                    orderData.taxAmount = taxAmount
                                }
                                if let grandTotal = itemDict["grand_total"] as? String{
                                    orderData.grandTotal = grandTotal
                                }
                                if let shipMethod = itemDict["shipping_message"] as? String{
                                    orderData.shipMethod = shipMethod
                                }
                                
                                if let couponUsed = itemDict["couponUsed"] as? Int{
                                    if couponUsed == 1{
                                        if let couponCode = itemDict["couponCode"] as? String{
                                            orderData.couponCode = couponCode
                                            
                                            if let discountAmount = itemDict["discount_amount"] as? Double{
                                                orderData.discountAmount = discountAmount
                                            }
                                        }
                                    }
                                }
                                
                                self.orderList.append(orderData)
                            }
                        }
                    }
                }
            }
            self.createList()
        }else{
            let emptyLabel = UILabel()
            emptyLabel.frame = CGRect(x: 20, y: 150, width: mainParentScrollView.frame.width - 40, height: 25)
            emptyLabel.text = "No Orders are placed yet".localized()
            emptyLabel.font = UIFont(name: "Lato", size: 20)
            emptyLabel.textAlignment = .center;
            emptyLabel.textColor = UIColor.black
            mainParentScrollView.addSubview(emptyLabel)
        }
    }
    
    func createOrderItems(_ productDict : NSDictionary)->[OrderItem]{
        var orderItems = [OrderItem]()
        
        guard let ids = productDict["id"] as? NSArray else{
            return orderItems
        }
        
        let count = ids.count
        
        guard let images = productDict["small_image"] as? NSArray, images.count == count else{
            return orderItems
        }
        
        guard let names =  productDict["name"] as? NSArray, names.count == count else{
            return orderItems
        }
        
        guard let quantities = productDict["quantity"] as? NSArray, quantities.count == count else{
            return orderItems
        }
        
        guard let skus =  productDict["sku"] as? NSArray, skus.count == count else{
            return orderItems
        }
        
        guard let prices = productDict["unitprice"] as? NSArray, prices.count == count else{
            return orderItems
        }
        
        
        for (i, _) in ids.enumerated(){
            let idStr = ids[i] as! String
            let id = Int(idStr)
            let qty1 = quantities[i] as! String
            let qty = Int(Utils.StringToDouble(qty1))
            let orderItem = OrderItem(id: id!, name: names[i] as! String, image: images[i] as? String, quantity: qty, sku: skus[i] as! String, price: prices[i] as! String)
            orderItems.append(orderItem)
        }
        
        return orderItems
    }
    
    func createList(){
        var listYPositon: CGFloat = 0
        
        for (index, order) in self.orderList.enumerated(){
            let listParentView = UIView(frame: CGRect(x: 0, y: listYPositon, width: mainParentScrollView.frame.width, height: 150))
            let titleParentView = UIView()
            titleParentView.frame = CGRect(x: 0, y: 0, width: listParentView.frame.width, height: 60)
            titleParentView.backgroundColor = UIColor(netHex:0xeaeaea)
            var TitleLabel = UILabel()
            TitleLabel = Utils.createTitleLabel(listParentView,yposition: 15)
            TitleLabel.text = order.date + "(\(order.id))".localized()
            titleParentView.addSubview(TitleLabel)
            listParentView.addSubview(titleParentView)
            
            let productListParentScrollView = UIScrollView(frame: CGRect(x: 0, y: titleParentView.frame.origin.y + titleParentView.frame.height, width: listParentView.frame.width, height: 150))
            var productYPositon:CGFloat = 10
            
            for item in order.items{
                let productParentView = UIView(frame: CGRect(x: 20, y: productYPositon, width: productListParentScrollView.frame.width - 40, height: 110))
                let icon_img_view = UIImageView()
                icon_img_view.contentMode = .scaleAspectFit
                UIImageCache.setImage(icon_img_view, image: item.image)
                icon_img_view.frame = CGRect(x: 0, y: 10, width: 80, height: 80)
                productParentView.addSubview(icon_img_view)
                
                let productTitleLabel = UILabel(frame: CGRect(x: icon_img_view.frame.origin.x + icon_img_view.frame.size.width + 20, y: 10, width:productParentView.frame.width - icon_img_view.frame.size.width * 1.5, height: 37))
                productTitleLabel.text = item.name
                productTitleLabel.textColor = UIColor.black
                productTitleLabel.numberOfLines = 2
                productTitleLabel.sizeToFit()
                productParentView.addSubview(productTitleLabel)
                
                let subTotalProductpriceLabel = UILabel(frame: CGRect(x: productTitleLabel.frame.origin.x, y: productTitleLabel.frame.origin.y + productTitleLabel.frame.height + 10, width: 140, height: 22))
                subTotalProductpriceLabel.text = Utils.appendWithCurrencySymStr(item.price)
                subTotalProductpriceLabel.textColor = UIColor.black
                productParentView.addSubview(subTotalProductpriceLabel)
                
                let border = UILabel(frame: CGRect(x: 0, y: productParentView.frame.height - 2, width: productParentView.frame.width, height: 1))
                border.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
                productParentView.addSubview(border)
                productListParentScrollView.addSubview(productParentView)
                productListParentScrollView.frame.size.height = productParentView.frame.origin.y + productParentView.frame.height
                
                productYPositon = productYPositon + productParentView.frame.height + 5
            }
            
            listParentView.addSubview(productListParentScrollView)
            
            let statusParentView = UIView(frame: CGRect(x: TitleLabel.frame.origin.x, y: productListParentScrollView.frame.origin.y + productListParentScrollView.frame.height + 20, width: listParentView.frame.width/2, height: 30))
            
            let statusTitleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 55, height: 22))
            statusTitleLabel.text = "Status:".localized()
            statusTitleLabel.textColor = UIColor.black
            statusParentView.addSubview(statusTitleLabel)
            
            let statusResultLabel = UILabel(frame: CGRect(x: statusTitleLabel.frame.origin.x + statusTitleLabel.frame.width + 2, y: statusTitleLabel.frame.origin.y, width: statusParentView.frame.width/2, height: 25))
            statusResultLabel.text = order.getStatus()
            statusResultLabel.textColor = UIColor.black
            statusResultLabel.numberOfLines = 3
            statusResultLabel.sizeToFit()
            statusParentView.addSubview(statusResultLabel)
            listParentView.addSubview(statusParentView)
            
            let xandwidth:CGFloat = listParentView.frame.width - 200
            let buttonParrentView = UIView(frame: CGRect(x: xandwidth, y: statusParentView.frame.origin.y - 5, width: 200, height: 40))
            
            let viewOrderButton = ZFRippleButton()
            viewOrderButton.tag = index
            viewOrderButton.frame = CGRect(x: buttonParrentView.frame.width - 120, y: 0, width: 105, height: 30)
            viewOrderButton.addTarget(self, action: #selector(myOrderViewController.viewOrderButtonAction(_:)), for: UIControlEvents.touchUpInside)
            viewOrderButton.backgroundColor = UIColor(red: (223/255.0), green: (114/255.0), blue: (114/255.0), alpha: 1.0)
            viewOrderButton.layer.cornerRadius = 3.0
            viewOrderButton.setTitle("View Order".localized(), for: UIControlState())
            viewOrderButton.titleLabel?.font = UIFont(name: "Lato-Bold", size: 17)
            viewOrderButton.titleLabel?.textColor = UIColor(netHex:0xf78f1e)
            buttonParrentView.addSubview(viewOrderButton)
            
            let reOrderButton = ZFRippleButton()
            reOrderButton.tag = index
            reOrderButton.frame = CGRect(x: viewOrderButton.frame.origin.x - 90, y: 0, width: 85, height: 30)
            reOrderButton.addTarget(self, action: #selector(myOrderViewController.reOrderButtonAction(_:)), for: UIControlEvents.touchUpInside)
            reOrderButton.backgroundColor = UIColor(red: (144/255.0), green: (144/255.0), blue: (144/255.0), alpha: 1.0)
            reOrderButton.layer.cornerRadius = 3.0
            reOrderButton.setTitle("Reorder".localized(), for: UIControlState())
            reOrderButton.titleLabel?.font = UIFont(name: "Lato-Bold", size: 17)
            reOrderButton.titleLabel?.textColor = UIColor(netHex:0xf78f1e)
            buttonParrentView.addSubview(reOrderButton)
            
            if(deviceName != "big"){
                reOrderButton.frame = CGRect(x: viewOrderButton.frame.origin.x, y: viewOrderButton.frame.origin.y + viewOrderButton.frame.height + 10, width: viewOrderButton.frame.width, height: viewOrderButton.frame.height)
            }
            
            buttonParrentView.frame.size.height = reOrderButton.frame.origin.y + reOrderButton.frame.height + 10
            listParentView.addSubview(buttonParrentView)
            listParentView.frame.size.height = buttonParrentView.frame.origin.y + buttonParrentView.frame.height + 10
            
            listYPositon = listYPositon + listParentView.frame.height
            
            mainParentScrollView.addSubview(listParentView)
            mainParentScrollView.contentSize.height = listParentView.frame.origin.y + listParentView.frame.height + 100
        }
    }
    
    @objc func viewOrderButtonAction(_ button:ZFRippleButton){
        let index = button.tag
        
        let myOrderDetailObject = self.storyboard?.instantiateViewController(withIdentifier: "orderDetailsViewController") as? orderDetailsViewController
        myOrderDetailObject?.orderData = self.orderList[index]
        self.navigationController?.pushViewController(myOrderDetailObject!, animated: true)
    }
    
    @objc func reOrderButtonAction(_ button:ZFRippleButton){
        let index = button.tag
        self.currentOrder = self.orderList[index]
        let url = self.currentOrder?.getReorderURL()
        self.addLoader()
        Utils.fillTheDataFromArray(url, callback: self.reorderData, errorCallback : self.showError)
    }
    
    func reorderData(_ data: NSArray){
        defer{self.removeLoader()}
        ShoppingCart.Instance.clear()
        
        if let orderData = self.currentOrder{
            data.forEach{item in
                if let itemDict = item as? NSDictionary{
                    if let reOrderItem =  StoreManager.Instance.createReorderDataItems(itemDict){
                        let qty = orderData.getItemQuantity(reOrderItem.id)
                        ShoppingCart.Instance.addItem(reOrderItem, num: qty)
                    }
                }
            }
        }
        
        if UserManager.Instance.getUserInfo() != nil{
            let cartView = self.storyboard?.instantiateViewController(withIdentifier: "cartViewController") as? cartViewController
            self.navigationController?.pushViewController(cartView!, animated: true)
        }
    }
    
    func backButtonFunction(){
        self.navigationController?.popViewController(animated: true)
    }
}

