//
//  UserInfo.swift
//  Mobilestic
//
//  Created by Ebizon-mac-2015 on 02/09/15.
//  Copyright (c) 2015 Ebizon Net. All rights reserved.
//

import Foundation

enum LoginType : String{
    case Mofluid = "Mofluid"
    case FacebookLogin = "facebooklogin"
    case GooglePlus = "GooglePlus"
}

class UserInfo : NSObject{
    static let ArchiveURL = Utils.DocumentsDirectory.appendingPathComponent("MofluidUserInfo")
    static var guestBillAddress : Address? = nil
    static var guestShipAddress: Address? = nil
    
    fileprivate(set) var id : Int
    fileprivate(set) var firstName : String
    fileprivate(set) var lastName : String
    fileprivate(set) var userName : String
    fileprivate(set) var loginStatus : Bool
    fileprivate(set) var loginType : LoginType
    
    var billAddress : Address? = nil
    var shipAddress: Address? = nil
    
    
    init?(id : Int, firstName: String, lastName: String, userName: String, loginStatus: Bool, loginType : LoginType){
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.userName = userName
        self.loginStatus = loginStatus
        self.loginType = loginType
        
        super.init()
        
        if id < 0{
            return nil
        }
    }
    
    static func saveLoginInfo(_ email: String, base64EncodePassword: String, loginType: LoginType) {
        let dataDict = NSMutableDictionary()
        
        dataDict.setObject(email, forKey: "email" as NSCopying)
        dataDict.setObject(base64EncodePassword, forKey: "password" as NSCopying)
        dataDict.setObject(loginType.rawValue, forKey: "logintype" as NSCopying)
        
        NSKeyedArchiver.archiveRootObject(dataDict, toFile: (UserInfo.ArchiveURL?.path)!)
    }
    
    static func createUserInfo(_ dataDict : NSDictionary, loginType: LoginType)->Bool{
        var bStatus = false
        
        guard let status = dataDict["login_status"] as? Int, status == 1 else{
            return bStatus
        }
        
        guard let idStr = dataDict["id"] as? String else{
            return bStatus
        }
        
        guard let id = Int(idStr), id > 0 else{
            return bStatus
        }
        
        let firstName = dataDict["firstname"] as? String ?? ""
        let lastName = dataDict["lastname"] as? String ?? ""
        var userName = dataDict["username"] as? String
        
        if userName == nil {
            userName = dataDict["email"] as? String ?? ""
        }
        
        if userName == nil {
            return bStatus
        }
        
        bStatus = status == 1
        let userInfo = UserInfo(id: id, firstName: firstName, lastName: lastName, userName: userName!, loginStatus: bStatus, loginType: loginType)
        UserManager.Instance.setUserInfo(userInfo)
        
        return bStatus
    }
}
