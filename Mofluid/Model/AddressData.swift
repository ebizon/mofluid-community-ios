//
//  AddressData.swift
//  Mobilestic
//
//  Created by Ebizon-mac-2015 on 14/08/15.
//  Copyright © 2015 Ebizon Net. All rights reserved.
//

import Foundation

class AddressRegion{
    let id: Int
    let code : String
    let name: String
    
    init(id: Int, code : String, name: String){
        self.id = id
        self.code = code
        self.name = name
    }
    
    func createMap()->NSDictionary{
        let dataDict = NSMutableDictionary()
        
        dataDict.setObject(self.code, forKey: "region_code" as NSCopying)
        dataDict.setObject(self.name, forKey: "region" as NSCopying)
        dataDict.setObject(self.id, forKey: "region_id" as NSCopying)
        
        return dataDict
    }
}

//This is new format, old format will get delted once migrated everything to new one
class Address: NSObject{
    var id : Int
    let firstName: String
    let lastName: String
    let telePhone: String
    let street: [String]
    let city: String
    let regionId : Int
    let region : AddressRegion
    let postCode : String
    let countryCode : String
    var company : String?
    // MARK: Initialization
    init(id: Int, firstName:String, lastName:String, telePhone:String, street:[String], city:String, regionId:Int, region : AddressRegion, postCode:String, countryCode:String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.telePhone = telePhone
        self.street = street
        self.city = city
        self.regionId = regionId
        self.region = region
        self.postCode = postCode
        self.countryCode = countryCode
        
        super.init()
    }
    
    func getFullName()->String{
        return "\(self.firstName) \(self.lastName)"
    }
    
    func getFullStreet()->String{
        var street = ""
        
        if(self.street.count > 0){
            street = self.street.first!
            if(self.street.count > 1){
                street = "\(street), \(self.street.last!)"
            }
        }
        
        return street
    }
    
    func getCountryName()->String{
        var country = ""
        
        if let countryName = LocaleManager.Instance.getCountryNameByCode(self.countryCode){
            country = countryName
        }
        
        return country
    }
    
    func createMap(customerId : Int)->NSDictionary{
        let dataDict = NSMutableDictionary()
        
        dataDict.setObject(customerId, forKey: "customer_id" as NSCopying)
        dataDict.setObject(self.firstName, forKey: "firstname" as NSCopying)
        dataDict.setObject(self.lastName, forKey: "lastName" as NSCopying)
        dataDict.setObject(self.region.createMap(), forKey: "region" as NSCopying)
        dataDict.setObject(self.regionId, forKey: "region_id" as NSCopying)
        dataDict.setObject(self.street, forKey: "street" as NSCopying)
        dataDict.setObject(self.city, forKey: "city" as NSCopying)
        dataDict.setObject(self.countryCode, forKey: "country_id" as NSCopying)
        dataDict.setObject(self.postCode, forKey: "postcode" as NSCopying)
        dataDict.setObject(self.telePhone, forKey: "telephone" as NSCopying)
        dataDict.setObject("true", forKey: "default_shipping" as NSCopying)
        dataDict.setObject("true", forKey: "default_billing" as NSCopying)
        if let company = self.company{
            dataDict.setObject(company, forKey: "company" as NSCopying)
        }
        
        return dataDict
    }
    func billcreateMap()->NSDictionary{
        let dataDict = NSMutableDictionary()
        dataDict.setObject(self.firstName, forKey: "billfname" as NSCopying)
        dataDict.setObject(self.lastName, forKey: "billlname" as NSCopying)
        dataDict.setObject(self.street[0], forKey: "billstreet1" as NSCopying)
        dataDict.setObject(self.street[1], forKey: "billstreet2" as NSCopying)
        dataDict.setObject(self.city, forKey: "billcity" as NSCopying)
        dataDict.setObject(self.region.code, forKey: "billstate" as NSCopying)
        dataDict.setObject(self.countryCode, forKey: "billcountry" as NSCopying)
        dataDict.setObject(self.postCode, forKey: "billpostcode" as NSCopying)
        dataDict.setObject(self.telePhone, forKey: "billphone" as NSCopying)
        
        return dataDict
    }
    static func processAddress(dataDict : NSDictionary)->Address?{
        var address: Address? = nil
        if let id = dataDict["id"] as? Int{
            var addressRegion : AddressRegion? = nil
            
            if let region = dataDict["region"] as? NSDictionary{
                let id = region["region_id"] as! Int
                let code = region["region_code"] as! String
                let name = region["region"] as! String
                addressRegion = AddressRegion(id: id, code: code, name: name)
            }
            let regionId = dataDict["region_id"] as! Int    
            let countryId = dataDict["country_id"] as! String
            let street = dataDict["street"] as! [String]
            let telePhone = dataDict["telephone"] as! String
            let postCode = dataDict["postcode"] as! String
            let city = dataDict["city"] as! String
            let firstName = dataDict["firstname"] as! String
            let lastName = dataDict["lastname"] as! String
            
            assert(addressRegion != nil)
            
            address = Address(id: id, firstName: firstName, lastName: lastName, telePhone: telePhone, street: street, city: city, regionId: regionId, region: addressRegion!, postCode: postCode, countryCode: countryId)
        }
        return address
    }
    
    static func addAddress(_ address : Address){
         if let userInfo = UserManager.Instance.getUserInfo(){
            
            print(userInfo)
            let email = UserManager.Instance.getUserInfo()?.userName
            let addDict = address.billcreateMap()//(customerId: userInfo.id)
            if let addData = Encoder.encodeBase64(NSArray(objects : addDict)){
                if address.id > 0{
                    let url =  WebApiManager.Instance.updateAddressURL(addressId: address.id, addressData: addData)
                    Utils.fillTheDataFromArray(url, callback: processAddress, errorCallback: showError)
                }else{
                    //let url =  WebApiManager.Instance.addNewAddressURL(addressData: addData)
                    //Utils.fillTheDataFromArray(url, callback: processAddress, errorCallback: showError)
                    /////
                    let url = WebApiManager.Instance.getUpdateProfileURL()
                    if let addData = Encoder.encodeBase64(addDict){
                        
                        let emailDic=NSMutableDictionary()
                        emailDic.setValue(email!, forKey:"email")
                        let emailData = Encoder.encodeBase64(emailDic)
                        let url =  WebApiManager.Instance.billService(url!, addData: addData, emailData: emailData!)
                        Utils.fillTheData(url, callback: processBilling, errorCallback: showError)
                    }
                }
            }
        }
    }
    
    static func processBilling(data:NSDictionary){
        
        //set shipping address
        let userInfo = UserManager.Instance.getUserInfo()
        let url=Config.Instance.getBaseURL()!+"get_billing_address&customerid=\(userInfo?.id ?? 0)"
        Utils.fillTheData(url, callback: getBilling, errorCallback: showError)
        
    }
    static func getBilling(_ data:NSDictionary){
        
        let id=data.value(forKey:"id") as? Int
        let userInfo = UserManager.Instance.getUserInfo()
        let url=Config.Instance.getBaseURL()!+"set_shipping_address&customerid=\(userInfo?.id ?? 0)&&addressid=\(String(id!))"
        Utils.fillTheData(url, callback: leftCallBack, errorCallback: showError)
    }
    static func leftCallBack(data:NSDictionary){
        
        NotificationCenter.default.post(name: Notification.Name("discountView"), object: nil)
    }
    static func processAddress(data : NSArray){
        print(data)
    }
    
    static func showError(){
        //Empty
    }
}
