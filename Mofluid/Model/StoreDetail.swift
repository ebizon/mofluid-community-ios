//
//  StoreDetail.swift
//  Mobilestic
//
//  Created by Ebizon-mac-2015 on 11/08/15.
//  Copyright © 2015 Ebizon Net. All rights reserved.
//

import Foundation

enum ProductsType{
    case feature
    case new
    case bestseller // best seller
}

class StoreDetail: NSObject{
    //MARK Properties
    var logo: String? = nil
    var banners: [String] = []
    var bannersDict: [NSDictionary] = []
    var products : [ProductsType : [ShoppingItem]] = [ProductsType: [ShoppingItem]]()
    var aboutUsId : String? = nil
    var privacyPloicy : String? = nil
    
    // MARK: Initialization
    override init(){
        super.init()
    }
}
