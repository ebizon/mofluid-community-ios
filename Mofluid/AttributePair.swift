//
//  AttributePair.swift
//  Mofluid
//
//  Created by MANISH on 26/04/18.
//  Copyright © 2018 Mofluid. All rights reserved.
//

import Foundation

class AttributePair : Hashable {
    static func == (lhs: AttributePair, rhs: AttributePair) -> Bool {
        return lhs.name == rhs.name && lhs.value == rhs.value
    }
    
    let name: String
    let value: String
    init(name: String, value:String){
        self.name = name
        self.value = value
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
//    public var hashValue: Int {
//        return self.name.hashValue ^ self.value.hashValue
//    }
}
