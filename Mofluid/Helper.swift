//
//  Helper.swift
//  Mofluid
//
//  Created by Saurabh Mishra on 6/18/18.
//  Copyright © 2018 Mofluid. All rights reserved.
//

import Foundation
let appDelegate =  UIApplication.shared.delegate as! AppDelegate
class Helper{
    
    enum productType{
        
        case simple
        case config
        case group
    }
    func isNull(_ someObject: AnyObject?) -> Bool {
        guard let someObject = someObject else {
            return true
        }
        return (someObject is NSNull)
    }
    let appDelegate =  UIApplication.shared.delegate as! AppDelegate
    //show alert
    func showAlert(_ vc:UIViewController,message:String){
        
        AJAlertController.initialization().showAlertWithOkButton(aStrMessage:message,vc:vc)
        { (index, title) in
            print(index,title)
        }
    }
    //show alert
    func showAlertWithCancel(_ vc:UIViewController,message:String,completion:@escaping(_ index:Int,_ title:String)->Void){
        
        AJAlertController.initialization().showAlert(aStrMessage: message, aCancelBtnTitle: Settings().cancel, aOtherBtnTitle:Settings().ok, vc: vc) { (index,title) in
            
            completion(index,title)
        }
    }
    //add loader
    func addLoader(_ vc:UIViewController){
        
        MyLoader.shared.showInView(view: vc.view, withHeader: "Loading", andFooter: "Please wait...")
    }
    func removeLoader(){
        
         MyLoader.shared.hide()
    }
    func validateEmail(email:UITextField)->(status:Bool,message:String){
        
        var message = ""
        var status = true
        if(email.text != nil && email.text != ""){
            
            let checkEmail = Utils.isValidEmail(email.text!)
            if(checkEmail == true){
                
                status = true
                message = "done".localized()
            }
            else{
                
                status = false
                message = "Entered email id is incorrect".localized()
            }
        }
        else{
            
            status = false
            message = "Email is required".localized()
        }
        return (status,message)
    }
    
    
    func validateEmailPassword(emailField:Any,passwordField:Any)->(status:Bool,message:String){
        
        var email = UITextField()
        var password = UITextField()
        ////email
        if emailField is UITextField{
            
            email = (emailField as? UITextField)!
        }
        else if emailField is String{
            
            email.text = emailField as? String
        }
        ////password
        if passwordField is UITextField{
            
            password = (passwordField as? UITextField)!
        }
        else if passwordField is String{
            
            password.text = passwordField as? String
        }
        var message = ""
        var status = true
        if(email.text != nil && email.text != ""){
            let checkEmail = Utils.isValidEmail(email.text!)
            if(checkEmail == true){
                if(password.text != nil && password.text != ""){
                    if(password.text!.count >= 6){
                        status = true
                        message = "done".localized()
                    }else{
                        
                        status = false
                        message = "Password length should be atleast 6 characters".localized()
                    }
                }else{
                    
                    status = false
                    message = "Password is required".localized()
                }
            }else{
                
                status = false
                message = "Entered email id is incorrect".localized()
            }
        }else{
            
            status = false
            message = "Email is required".localized()
        }
        return (status,message)
    }
    
    func validateEmailPasswordName(emailField:Any,passwordField:Any,nameField:Any)->(status:Bool,message:String){
        
        var email = UITextField()
        var password = UITextField()
        var name = UITextField()
        ////email
        if emailField is UITextField{
            
            email = (emailField as? UITextField)!
        }
        else if emailField is String{
            
            email.text = emailField as? String
        }
        ////password
        if passwordField is UITextField{
            
            password = (passwordField as? UITextField)!
        }
        else if passwordField is String{
            
            password.text = passwordField as? String
        }
        ////Name
        if nameField is UITextField{
            
            name = (nameField as? UITextField)!
        }
        else if nameField is String{
            
            name.text = nameField as? String
        }
        var message = ""
        var status = true
        if(name.text != nil && name.text != ""){
            if(email.text != nil && email.text != ""){
                let checkEmail = Utils.isValidEmail(email.text!)
                if(checkEmail == true){
                    if(password.text != ""){
                        if(password.text!.count >= 6){
                            status = true
                            message = "done".localized()
                        }else{
                            
                            status = false
                            message = "Password length should be atleast 6 characters".localized()
                        }
                    }else{
                        
                        status = false
                        message = "Password is required".localized()
                    }
                }else{
                    
                    status = false
                    message = "Email id entered is incorrect.".localized()
                }
            }else{
                
                status = false
                message = "Email id is required".localized()
            }
        }else{
            
            status = false
            message = "Full Name is required".localized()
        }
        return (status,message)
    }
    func validateOptionName(_ value:String)->(color:UIColor,status:Bool){
        
        var status  =   false
        var color   =   UIColor()
        if (UIColor(name: value) != nil){
            
            color   =   UIColor(name:value)!
            status  =   true
        }
//        else{
//
//            color   =   .white
//            status  =   true
//        }
        return(color:color,status:status)
    }
    //MARK:- Set navigation bar properties
    func setNavigationProperties(){
        
    }
    func resetAllInstances(){
        
        //to reset all the cache data in sigleton classes
        StoreManager.Instance.reset()
        WebApiManager.Instance.reset()
        ShoppingCart.Instance.reset()
        ShoppingWishlist.Instance.reset()
        UserManager.Instance.reset()
        UIImageCache.Instance.reset()
    }
}

