//
//  GooglePlusLogin.swift
//  Mofluid
//
//  Created by Sadique_ebizon on 18/01/16.
//  Copyright © 2016 Mofluid. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class GooglePlusLogin: NSObject {
    func googlePlusData (_ userData: GIDGoogleUser) {
        let name = userData.profile.name
       // let seperateString = (name?.componentsSeparatedByString(" "))! as NSArray
        let seperateString = (name?.components(separatedBy: " "))
        var firstName = ""
        var lastName = ""
        
        if seperateString != nil {
            
            firstName   =   (seperateString?.first)!
            lastName    =   (seperateString?.last)!
        }
        if firstName.count < 1{
            
            firstName   =   lastName
        }
        if let email = userData.profile.email{
            if let _ = userData.profile.name{
                var url = WebApiManager.Instance.getSocialLoginUrl()
                if url != nil{
                        let ext = "&username=\(email)&firstname=\(firstName)&lastname=\(lastName)"
                    url = url! + ext
                    
                    if let jsonData = WebApiManager.Instance.getJSON(url!){
                        if let dataDict = Utils.parseJSON(jsonData){
                            UserInfo.saveLoginInfo(email, base64EncodePassword: "", loginType : LoginType.GooglePlus)
                            self.createUserInfoType(dataDict)
                            
                        }
                    }
                }
            }
        }
    }
    
    func createUserInfoType(_ dataDict : NSDictionary){
        let _ = UserInfo.createUserInfo(dataDict, loginType : LoginType.GooglePlus)
    }

}
