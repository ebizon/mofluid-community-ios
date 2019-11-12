//
//  FiltersAttributeData.swift
//  Mofluid
//
//  Created by MANISH on 01/02/18.
//  Copyright © 2018 Mofluid. All rights reserved.
//

import Foundation

class FiltersAttributeData : NSObject{
    let id : String
    let name: String
    let attributeValue: [FilterAttributeValue]
    
    init(id: String, name: String, attributeValue: [FilterAttributeValue]){
        self.id = id
        self.name = name
        self.attributeValue = attributeValue
    }
}
