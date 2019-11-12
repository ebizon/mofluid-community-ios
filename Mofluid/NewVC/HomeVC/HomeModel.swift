//
//  HomeModel.swift
//  Mofluid
//
//  Created by Saurabh Mishra on 6/27/18.
//  Copyright © 2018 Mofluid. All rights reserved.
//

import Foundation
struct HomeModel{
    
    var products    : [ShoppingItem]
    var sectionName : String?
    init(products:[ShoppingItem],sectionName:String?) {
        
        self.products = products
        self.sectionName = sectionName
    }
}
struct SectionName {
    
    var name : String
    init(name:String) {
        
        self.name = name
    }
}
struct FinalProduct{
    
    enum names {
        case NewProducts
        case FeaturedProducts
        case BestProducts
    }
    var homeModel:HomeModel
    var name : names?
    init(home:HomeModel,name:names?) {
        
        self.homeModel  =    home
        self.name       =    name
    }
}
