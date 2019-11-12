//
//  ShoppingCategory.swift
//  Mobilestic
//
//  Created by Ebizon-mac-2015 on 19/08/15.
//  Copyright © 2015 Ebizon Net. All rights reserved.
//

import Foundation

class ShoppingCategory : NSObject{
    
    fileprivate(set) var id: Int
    fileprivate(set) var name: String
    fileprivate(set) var image: String?
    // MARK: Initialization
    init?(id: Int, name: String, image: String?) {
        self.id = id
        self.name = name
        self.image = image ?? ""
        
        super.init()
        
        if id <= 0 || name.isEmpty{
            return nil
        }
    }
}
