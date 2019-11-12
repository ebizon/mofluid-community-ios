//
//  DetailsDictionary.swift
//  Mofluid
//
//  Created by sudeep goyal on 06/10/15.
//  Copyright © 2015 Mofluid. All rights reserved.
//

import Foundation

class DetailsDictionary: NSObject {
    let dataDict: NSDictionary
    let imgDict: NSDictionary
    let type: String
    var attributeMap : [String : [String]] = [String : [String]]()
    var relationData: [String] = [String]()
    var relationMap: [String : [String]] = [String : [String]]()
    var getrelatedProducts:[ShoppingItem] = []       // related product
    init?(dataDict: NSDictionary, imgDict: NSDictionary, type: String){
        self.dataDict = dataDict
        self.imgDict = imgDict
        self.type = type
        super.init()
    }
    
}