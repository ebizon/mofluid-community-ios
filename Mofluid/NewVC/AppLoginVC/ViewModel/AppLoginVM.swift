//
//  AppLoginVM.swift
//  Mofluid
//
//  Created by Saurabh Mishra on 6/14/18.
//  Copyright © 2018 Mofluid. All rights reserved.
//

import Foundation
class AppLoginVM{
    
    //forget password --- User Module || Applogin Module using a flag value
    //MARK:- API CALL
    func callForgetPasswordApi(emailId:String,isUser:Bool,_ completion:@escaping (_ isSuccess:Bool,_ data:AnyObject)->Void){
        
        var  url = Config.Instance.getForgotPasswordURL(email: emailId)
        if isUser{
            
            url = WebApiManager.Instance.getForgotPasswordURL()! + "&email=" + emailId
        }
        ApiManager().getApi(url: url) { (response,status) in
            
            if status{
                
                completion(true,response)
            }
            else{
                
                completion(false,NSNull())
            }
        }
    }
    func callForLoginApi(emailId:String,password:String,_ completion:@escaping (_ isSuccess:Bool,_ data:AnyObject)->Void){
        
        let param = ["email" : emailId ,
                    "password" : password ]
        ApiManager().postApi(url: Config.Instance.getAppLogincAccessURL(),params:param as AnyObject) { (response,status) in
            
            if status{
                
                completion(true,response)
            }
            else{
                
                completion(false,NSNull())
            }
        }
    }
    func callForSignUpApi(emailId:String,password:String,name:String,_ completion:@escaping (_ isSuccess:Bool,_ data:AnyObject)->Void){
        
        let firstNameUTF8 = Encoder.encodeUTF8(name)
        let firstNameUTF8Base64Encoded = Encoder.encodeBase64(firstNameUTF8)
        let lastNameUTF8 = Encoder.encodeUTF8(name)
        let lastNameUTF8UTF8Base64Encoded = Encoder.encodeBase64(lastNameUTF8)
        guard let url = WebApiManager.Instance.getCreateUserURL() else{
            return
        }
        let passwdUTF8 = Encoder.encodeUTF8(password)
        let passwdBase64Encoded = Encoder.encodeBase64(passwdUTF8)
        let finalUrl = url + "&firstname=\(firstNameUTF8Base64Encoded!)&lastname=\(lastNameUTF8UTF8Base64Encoded!)&email=\(emailId)&password=\(passwdBase64Encoded!)"
        ApiManager().getApi(url: finalUrl) { (response, status) in
            
            if status{
                
                 completion(true,response)
            }
            else{
                
                 completion(false,NSNull())
            }
        }
    }
    //MARK:- API PARSER
    func forgotPasswordResult(){
        
    }
    func createUserResult(_ dataDict: NSDictionary)->(status:Bool,message:String){

        var status = true
        var message = ""
        guard let value = dataDict["status"] as? Int else{
            
            status = false
            message=""
            return(status,message)
        }
        if value == 1{
            
            status = true
            message=""
       
        }else{
            
            status = true
            message="Account already exists with email id".localized()
        }
        
        return(status,message)
    }
    func loginSuccessParse(_ response:NSDictionary){
        
        Config.Instance.setBaseURL(url: (response["website"] as? String)!)
        UserDefaults.standard.set(false, forKey: "isLogin")
        UserDefaults.standard.set(response["website"] as? String, forKey: Constants.AppBaseURL)
        UserDefaults.standard.synchronize()
        Helper().resetAllInstances()
    }
}
