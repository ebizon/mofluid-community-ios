//
//  ProductReviewData.swift
//  Mofluid
//
//  Created by MANISH on 26/04/18.
//  Copyright © 2018 Mofluid. All rights reserved.
//

import Foundation

class ProductReviewData : NSObject{
    let id : String
    let statusId : String
    let createDate : String
    let details : String?
    let nickName : String
    let value : String
    let title : String
    
    init(id: String,statusId : String, createDate : String, details : String, nickName:String , value:String , title: String){
        self.id = id
        self.statusId = statusId
        self.details = details
        self.createDate = createDate
        self.nickName = nickName
        self.value = value
        self.title = title
    }
}
