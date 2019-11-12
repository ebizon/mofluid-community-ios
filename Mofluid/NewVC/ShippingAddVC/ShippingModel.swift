//
//  ShippingModel.swift
//  Mofluid
//
//  Created by Saurabh Mishra on 31/07/18.
//  Copyright © 2018 Mofluid. All rights reserved.
//

import Foundation
struct AddressModel {
    
    var firstName                               :   String
    var lastName                                :   String?
    var contactNumber                           :   String
    var address1                                :   String
    var address2                                :   String?
    var city                                    :   String
    var country                                 :   String
    var state                                   :   String?
    var zipcode                                 :   String?
    init?(firstName:String,lastName:String,contactNumber:String,address1:String,address2:String?,city:String,country:String,state:String?,zipcode:String?) {
        
        self.firstName                               =   firstName
        self.lastName                                =   lastName
        self.contactNumber                           =   contactNumber
        self.address1                                =   address1
        self.address2                                =   address2
        self.city                                    =   city
        self.country                                 =   country
        self.state                                   =   state
        self.zipcode                                 =   zipcode
    }
}
