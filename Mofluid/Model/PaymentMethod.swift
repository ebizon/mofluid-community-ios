//
//  PaymentMethod.swift
//  Mofluid
//
//  Created by MANISH on 09/01/16.
//  Copyright © 2016 Mofluid. All rights reserved.
//

import Foundation

class PaymentMethod{
    let code : String
    let title : String
    
    init(code: String, title : String){
        self.code = code
        self.title = title
    }
}
