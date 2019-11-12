//
//  AttributeMap.swift
//  Mofluid
//
//  Created by MANISH on 01/08/16.
//  Copyright © 2016 Mofluid. All rights reserved.
//

import Foundation

class AttributeMap : NSObject{
    let id : Int
    var attributes:[(label: String, value: String)] = []
    
    init(id: Int){
        self.id = id
    }
}


