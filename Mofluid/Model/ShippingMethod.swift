//
//  ShippingMethod.swift
//  Mofluid
//
//  Created by Ebizon-mac-2015 on 03/09/15.
//  Copyright (c) 2015 Ebizon Net. All rights reserved.
//

import Foundation

class ShippingMethod : NSObject{
    let id: String
    let code : String?
    let price : Double
    let title  :String?
    let tax    :Double
    
    init?(id: String, code : String?, price: Double, title:String?,  tax:Double){
        self.id = id
        self.code = code
        self.price = price
        self.title = title
        self.tax   = tax
        
        super.init()
        
        if self.id.isEmpty{
            return nil
        }
    }
    
    func getFullTitle()->String?{
        var fullTitle = self.title
        
        if fullTitle != nil{
            if self.price > 0.0{
                fullTitle = fullTitle! + " + " + Utils.appendWithCurrencySym(self.price)
            }
        }
        
        return fullTitle
    }
}