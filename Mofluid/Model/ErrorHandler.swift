//
//  ErrorHandler.swift
//  Mobilestic
//
//  Created by Ebizon-mac-2015 on 19/08/15.
//  Copyright © 2015 Ebizon Net. All rights reserved.
//

import UIKit
import SystemConfiguration
import Foundation

class ErrorHandler : NSObject{
    static let Instance = ErrorHandler()
    fileprivate var errorMap:[String: String]? = nil
    
    fileprivate override init(){
        
        super.init()
        self.loadErrorMessages()
        
        if self.errorMap == nil{
            ErrorHandler.Instance.showError()
        }

    }
    
    func getOutOfStockError()->String{
        return self.errorMap![Constants.OutOfStockError]!
    }
        
    fileprivate func loadErrorMessages(){
        if let path = Bundle.main.path(forResource: "Errors", ofType: "plist") {
            self.errorMap = NSDictionary(contentsOfFile: path) as? [String:String]
        }
    }
    
    func showError(_ errorType : String){
        let msg = self.getErrorMessage(errorType)
        Utils.showAlert(msg, title: "Error!")
    }
    
    func showError(){
        if !Reachability.isConnectedToNetwork(){
            self.showError(Constants.NoInternetConnection)
        }else{
            //TODO : check all possible cases.
           //self.showError(Constants.GenericError)
        }
    }
    
    func getErrorMessage(_ errorType : String)->String{
        var msg = "Error"
        if let errorMsg = self.errorMap![errorType]{
            msg = errorMsg
        }
        
        return msg
    }
    
    
    // mahesh
    
    func getQuantityNotAvailableError()->String{
        return self.errorMap![Constants.quantityNotAvailable]!
    }
    
    
}
