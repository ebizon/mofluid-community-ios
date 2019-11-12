//
//  CustomOptionSet.swift
//  Mofluid
//
//  Created by MANISH on 01/08/16.
//  Copyright © 2016 Mofluid. All rights reserved.
//

import Foundation

class CustomOptionSet : NSObject{
    let id : String
    let name: String
    let type: String
    let isRequired: Bool
    let options: [CustomOption]
    var maxChars  = 0
    var priceStr : String? = nil
    var textBox : UITextField? = nil
    
    init(id: String, name: String, type: String, isRequired: Bool, options: [CustomOption]){
        self.id = id
        self.name = name
        self.type = type
        self.isRequired = isRequired
        self.options = options
    }
}

