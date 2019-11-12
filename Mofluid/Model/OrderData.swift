//
//  OrderData.swift
//  Mofluid
//
//  Created by MANISH on 12/11/15.
//  Copyright © 2015 Mofluid. All rights reserved.
//

import Foundation

class OrderItem{
    let id : Int
    let name : String
    let image : String?
    let quantity : Int
    let sku : String
    let price : String
    
    init(id: Int, name: String, image: String?, quantity: Int, sku: String, price: String){
        self.id = id
        self.name = name
        self.image = image ?? ""
        self.quantity = quantity
        self.sku = sku
        self.price = price
    }
    
    func getSubTotal()->Double{
        return Utils.StringToDouble(self.price) * Double(self.quantity)
    }
}

class OrderData{
    let id : String
    let date : String
    fileprivate let status : String
    var paymentMethod: String? = nil
    var paymentMethodCode: String? = nil
    var shippingAmount: String? = nil
    var taxAmount: String? = nil
    var grandTotal: String? = nil
    var shipMethod: String? = nil
    var shipMethodCode: String? = nil
    var couponCode: String? = nil
    var orderStatus: String? = nil
    var discountAmount: Double = 0.0
    var items = [OrderItem]()
    var shippingAddress : Address? = nil
    var billingAddress : Address? = nil
    
    init(id : String, date: String, status: String){
        self.id = id
        self.date = date
        self.status = status
    }
    
    func getItemQuantity(_ idToFind : Int)->Int{
        var quantity = 1
        
        if let item = self.items.filter({$0.id == idToFind}).first{
            quantity = item.quantity
        }
        
        return quantity
    }
    
    func getProductIdsEncoded()->String?{
        let pids = self.items.map({$0.id})
        
        return Encoder.encodeBase64(pids as NSArray)
    }
    
    func getReorderURL()->String?{
        var url = WebApiManager.Instance.getReorderURL()
        
        if url != nil{
            if let pids = self.getProductIdsEncoded(){
                url = url! + "&pid=\(pids)"
            }
            url = url! + "&orderid=\(self.id)"
        }
        
        return url
    }
    
    func getDiscount()->Double{
        return self.discountAmount * -1.0
    }
    
    func getSubTotal()->Double{
        var subTotal = 0.0
        
        for item in items{
            subTotal += item.getSubTotal()
        }
        
        return subTotal
    }
    
    func getStatus()->String{
        var capStatus = self.status 
        capStatus.replaceSubrange(capStatus.startIndex...capStatus.startIndex, with: String(capStatus[capStatus.startIndex]).capitalized)
        
        return capStatus
    }
    
}
