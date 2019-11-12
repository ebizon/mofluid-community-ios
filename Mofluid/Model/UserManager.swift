//
//  UserManager.swift
//  Mofluid
//
//  Created by MANISH on 27/01/16.
//  Copyright © 2016 Mofluid. All rights reserved.
//

import Foundation

class UserManager: NSObject {
    
    /********************************************************************************/
    static var Instance : UserManager = UserManager()
    fileprivate var userLogged : UserInfo? = nil
    
    fileprivate override init(){
        super.init()
    }
    
    func setUserInfo(_ userInfo: UserInfo?){
        self.userLogged = userInfo
        ShoppingCart.Instance.loadServerCart()
        loadShippingAddress()
        loadBillingAddress()
    }
    
    func getUserInfo()->UserInfo?{
        return self.userLogged
    }
    func reset(){
        
        UserManager.Instance    =   UserManager()
    }
    func setBillingAddress(_ dataDict : NSDictionary){
        let address = Address.processAddress(dataDict: dataDict)
        if(Config.guestCheckIn){
            UserInfo.guestBillAddress = address
        }else{
            //assert(self.getUserInfo() != nil)
            self.getUserInfo()?.billAddress = address
        }
    }
    
    func setShippingAddress(_ dataDict : NSDictionary){
        let address = Address.processAddress(dataDict: dataDict)
        if(Config.guestCheckIn){
            UserInfo.guestShipAddress = address
        }else{
            //assert(self.getUserInfo() != nil)
            self.getUserInfo()?.shipAddress = address
        }
    }
    
    func loadBillingAddress(){
        let url = WebApiManager.Instance.getBillingAddressURL()
        Utils.fillTheData(url, callback: self.processBillingAddress, errorCallback : self.showError)
    }
    
    func processBillingAddress(_ dataDict : NSDictionary){
        setBillingAddress(dataDict)
    }
    
    func loadShippingAddress(){
        let url = WebApiManager.Instance.getShippingAddressURL()
        Utils.fillTheData(url, callback: self.processShippingAddress, errorCallback : self.showError)
    }
    
    func processShippingAddress(_ dataDict : NSDictionary){
        setShippingAddress(dataDict)
    }
    
    func showError(){
        //Empty
    }
}
