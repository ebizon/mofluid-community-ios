//
//  FbLoginManager.swift
//  Mofluid
//
//  Created by Sadique_ebizon on 14/12/15.
//  Copyright © 2015 Mofluid. All rights reserved.
//

import UIKit

import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit

class FbLoginManager: NSObject {
    func facebookLogin(){
        
        if let facebookId = Bundle.main.object(forInfoDictionaryKey: "FacebookAppID") as? String{
            FBSDKSettings.setAppID(facebookId)
        }
        
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logOut()
        
        fbLoginManager.logIn(withReadPermissions: ["email", "public_profile"], from: nil, handler:{ (result, error) -> Void in
            
            if ((error) != nil){
                // Process error
            }
            else if (result?.isCancelled)! {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "removeLoader"), object: nil)
                // Handle cancellations
                //This method ; I should have implemented
            }
            else {
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    self.faceBookUserData()
                }
            }
            
        })
        
    }
    
    func faceBookUserData(){
        
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id, name, picture, first_name, last_name, email"])
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            
            if error == nil{
                if let resultDict = result as? NSDictionary{
                    
                let email = resultDict["email"] as? String
                if email == "" || email == nil {
                    Utils.showAlert("Unable to fetch Facebook credentials due to privacy settings. Please login/register using e-mail ID")
                    return
                }

                let first_name = resultDict["first_name"] as? String
                let last_name = resultDict["last_name"] as? String
                
                if email != nil && first_name != nil && last_name != nil{
                    var url = WebApiManager.Instance.getSocialLoginUrl()
                    
                    if url != nil{
                        let ext = "&username=\(email!)&firstname=\(first_name!)&lastname=\(last_name!)"
                        url = url! + ext
                        
                        if let jsonData = WebApiManager.Instance.getJSON(url!){
                            if let dataDict = Utils.parseJSON(jsonData){
                                UserInfo.saveLoginInfo(email!, base64EncodePassword: "", loginType : LoginType.FacebookLogin)
                                UserDefaults.standard.set(true, forKey: "isLogin")
                                self.createUserInfo(dataDict)
                                if UserDefaults.standard.bool(forKey: "isLoginWithUserProfile"){
                                    
                                    print("test")
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "isLoginWithFB"), object: nil)
                                }
                                    
                      else{
                        //NotificationCenter.default.post(name: Notification.Name(rawValue: "isLoginWithFacebook"), object: nil)
                                }
                                
                            }
                        }
                    }
                  }
                }
                
            }
            else{
                
                UserDefaults.standard.set(false, forKey: "isLogin")
            }
        })
        
    }
    
    func createUserInfo(_ dataDict : NSDictionary){
        let _ = UserInfo.createUserInfo(dataDict, loginType : LoginType.FacebookLogin)
      //  Utils.loadWishlistItemData()
    }
    
    
    
    
}
