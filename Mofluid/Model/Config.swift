//
//  Config.swift
//  Mofluid
//
//  Created by Ebizon-mac-2015 on 24/09/15.
//  Copyright (c) 2015 Ebizon Net. All rights reserved.
//

import Foundation


class Config: NSObject {
    static let Instance : Config = Config()
    static var guestCheckIn:Bool = false
    
    static let DefaultAppName = "Mofluid"
    
    /********************************************************************************/
    fileprivate var configMap:[String: String]? = nil
    /********************************************************************************/
    
    fileprivate override init(){
        super.init()
        
        self.loadConfig()
        
        self.loadBaseURL()
        
        if self.configMap == nil{
            ErrorHandler.Instance.showError(Constants.GenericError)
        }
    }
    
    fileprivate func loadConfig(){
        if let path = Bundle.main.path(forResource: "config", ofType: "plist") {
            self.configMap = NSDictionary(contentsOfFile: path) as? [String:String]
        }
    }
    
    func getAppLogincAccessURL()->String{
        return self.configMap![Constants.AppURL]! + "appLogin"
    }
    
    func getForgotPasswordURL(email : String)->String{
        return self.configMap![Constants.AppURL]! + "forgotPassword/\(email)"
    }
    
    func loadBaseURL(){
        if let url =  UserDefaults.standard.string(forKey: Constants.AppBaseURL){
            setBaseURL(url: url)
        }
    }
    
    func setBaseURL(url : String){
        var fullURL = url
        if(fullURL.last != "/"){
            fullURL += "/"
        }
        
        fullURL += Constants.mofluidAppExtension
        
        print(fullURL)
        self.configMap![Constants.BaseURL] = fullURL
    }
    
    func getURl() -> String{
        let url = self.configMap![Constants.BaseURL]
        return url!
    }
    
    func getBaseURL()->String?{
        var url = self.configMap![Constants.BaseURL]
        if url != nil{
            url = url! + "&store=\(self.configMap![Constants.StoreID]!)"+"&service="
        }
        return url
    }
    func getRawBaseUrl()->String{
    
        return (self.configMap![Constants.BaseURL]?.components(separatedBy:"mofluidapi2")[0])!
    }
    func getDiffirentBaseURL()->String?{
        var url : String? = nil
        if var baseURL = self.configMap![Constants.BaseURL]{
            if let storeId = self.configMap![Constants.StoreID]{
                baseURL.remove(at: baseURL.index(before: baseURL.endIndex))
                
                baseURL =  baseURL + "/api/?"
                baseURL = baseURL + "store=\(storeId)" + "&cmd="
                
                url = baseURL
                
            }
        }
        
        return url
    }
    
    
    func setStoreId(_ id : String){
        self.configMap![Constants.StoreID] = id
    }
    
    func setCurrencyCode(_ code : String){
        self.configMap![Constants.CurrencyCode] = code
    }
    
    func getCurrencyCode()->String{
        assert(self.configMap![Constants.CurrencyCode] != nil)
        return self.configMap![Constants.CurrencyCode]!
    }
    
    func getCountryCode()->String{
        assert(self.configMap![Constants.CountryCode] != nil)
        return self.configMap![Constants.CountryCode]!
    }
    
    func getApplePayMerchantID()->String{
        assert(self.configMap![Constants.ApplePayMerchantID] != nil)
        return self.configMap![Constants.ApplePayMerchantID]!
    }
    
    func getGoogleClientID()->String{
        assert(self.configMap![Constants.GoogleClientID] != nil)
        return self.configMap![Constants.GoogleClientID]!
    }
    
    func getPayPalSandBoxId()->String{
        assert(self.configMap![Constants.PayPalIDSandbox] != nil)
        return self.configMap![Constants.PayPalIDSandbox]!
    }
    
    func getPayPalLiveId()->String{
        assert(self.configMap![Constants.PayPalIDLive] != nil)
        return self.configMap![Constants.PayPalIDLive]!
    }
    
    func getAppAccessKey()->String{
        assert(self.configMap![Constants.AppAccessKey] != nil)
        return self.configMap![Constants.AppAccessKey]!
    }
    
}

