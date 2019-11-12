//
//  FilterAttributeValue.swift
//  Mofluid
//
//  Created by MANISH on 01/02/18.
//  Copyright © 2018 Mofluid. All rights reserved.
//

import Foundation

class FilterAttributeValue : NSObject{
    let id : String
    let name: String
    let count: String
    var isSelected = false
    init(id: String, name: String, count: String){
        self.id = id
        self.name = name
        self.count = count
    }
    
    func setValueOfIsselcted(_ val :Bool) {
        isSelected = val
    }
}
