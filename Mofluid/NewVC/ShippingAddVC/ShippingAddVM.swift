//
//  ShippingAddVM.swift
//  Mofluid
//
//  Created by Saurabh Mishra on 30/07/18.
//  Copyright © 2018 Mofluid. All rights reserved.
//

import Foundation
class ShippingAddVM{
    
    var kCountry    =   "Country"
    var kState      =   "State"
    func getContentHeight(_ view:UIView)->CGFloat{
        
        let height           =   view.frame.size.height
        let pos              =   view.frame.origin.y
        return   height + pos + 50
    }
    func getTitleForButton(_ title:String)->String{
        
        let countryCode     =   Config.Instance.getCountryCode()
        var returnValue     =   Settings().select
        if title            ==  kCountry{
            
            returnValue     =   LocaleManager.Instance.getCountryNameByCode(countryCode)!
        }
        return returnValue
    }
    func getCountryName(_ code:String)->String{
        
        var country         =   Settings().select
        if let countryName  =   LocaleManager.Instance.getCountryNameByCode(code){
            country         =   countryName
        }
        return country
    }
    func isVerifyInputs(firstname:String?,lastname:String?,number:String?,address1:String?,address2:String?,city:String?,country:String?,state:String?,zipcode:String?)->(status:Bool,message:String){
        
        var status      =   true
        var message     =   ""
        switch true {
        case firstname==nil,firstname?.count==0:
            status=false
            message=Settings().erFirstname
            break
        case lastname==nil,lastname?.count==0:
            status=false
            message=Settings().erLastname
            break
        case number==nil,number?.count==0:
            status=false
            message=Settings().erNumber
            break
        case address1==nil,address1?.count==0:
            status=false
            message=Settings().erAdd1
            break
        case address2==nil,address2?.count==0:
            status=false
            message=Settings().erAdd2
            break
        case city==nil , city?.count==0:
            status=false
            message=Settings().erCity
            break
        case country == Settings().select , country==nil:
            status=false
            message=Settings().erCountry
            break
        case state==nil , state==Settings().select , state?.count==0:
            status=false
            message=Settings().erState
            break
        case zipcode==nil,zipcode?.count==0:
            status=false
            message=Settings().erZipcode
            break
        default:
            print("")
        }
        return (status:status,message:message)
    }
    func getStateList(_ code:String,completion:@escaping(_ isSuccess:Bool,_ response:[State]?)->Void){
        
        var stateList = [State]()
        let url = WebApiManager.Instance.getStateListURL(code)
        ApiManager().getApi(url: url!) { (response, status) in
            
            if status{
                
                if let dataDict = response as? NSDictionary{
                    if let items = dataDict["mofluid_regions"] as? NSArray{
                        for item in items{
                            if let itemDict = item as? NSDictionary{
                                let id = itemDict["region_id"] as? String
                                let name = itemDict["region_name"] as? String
                                
                                if id != nil && name != nil{
                                    stateList.append(State(id: id!, name: name!))
                                }
                            }
                        }
                    }
                }
                completion(true,stateList)
            }
            else{
                
                completion(false,nil)
            }
        }
    }
}
extension ShippingAddressVC:CountryDelegate{
    func clickedOnItem(title: Country,type:String) {
        
        if type==kCountry{
            
            btnCountry.setTitle(title.name, for: .normal)
            getStateForCountry(title.id)
        }
        else{
            
            btnState.setTitle(title.name, for: .normal)
            stateCode=title.id
        }
    }
}

