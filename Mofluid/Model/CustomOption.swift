//
//  CustomOption.swift
//  Mofluid
//
//  Created by MANISH on 01/08/16.
//  Copyright © 2016 Mofluid. All rights reserved.
//

import Foundation

class CustomOption{
    let id : String
    let price : String
    let priceType : String?
    let sku : String?
    let sortOrder : String?
    let title : String
    var selected = false
    
    init(id: String, price: String, priceType: String?, sku : String?, sortOrder: String?, title: String){
        
        self.id = id
        self.price = price
        self.priceType = priceType
        self.sku = sku
        self.sortOrder = sortOrder
        self.title = title
        
    }
    
    func titleWithPrice()->String{
        let dPrice = Utils.StringToDouble(self.price)
        var titlePrice = self.title
        
        if dPrice > 0.0{
            titlePrice += " + " + Utils.appendWithCurrencySymStr(self.price)
        }
        
        return titlePrice
    }
    
}