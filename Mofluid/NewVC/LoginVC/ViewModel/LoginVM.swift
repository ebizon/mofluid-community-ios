//
//  LoginVM.swift
//  Mofluid
//
//  Created by Saurabh Mishra on 6/18/18.
//  Copyright © 2018 Mofluid. All rights reserved.
//

import Foundation
class LoginVM{
    
    //MARK:- API CALL
    func callForgetPasswordApi(emailId:String,_ completion:@escaping (_ isSuccess:Bool,_ data:AnyObject)->Void){
        
        let url = Config.Instance.getForgotPasswordURL(email: emailId)
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
        
        let url = WebApiManager.Instance.getLoginAccessURL()
        let passwdUTF8 = Encoder.encodeUTF8(password)
        let passwdBase64Encoded = Encoder.encodeBase64(passwdUTF8)
        let serviceURL = url! + "&username=" + emailId + "&password=" + passwdBase64Encoded!
        UserInfo.saveLoginInfo(emailId, base64EncodePassword: passwdBase64Encoded!, loginType : LoginType.Mofluid)
        ApiManager().getApi(url: serviceURL, completion: { (response,status) in
            
            if status{
                
                completion(true,response)
            }
            else{
                
                completion(false,NSNull())
            }
        })
    }
    //MARK:- API PARSER
    func forgotPasswordResult(){
        
        
    }
    func loginSuccessParse(_ response:NSDictionary)->Bool{
        
        
        let isStatus =  UserInfo.createUserInfo(response, loginType : LoginType.Mofluid)
        return isStatus
    }
    func addItemForAnonym()
    {
        
        let cart = ShoppingCart.Instance
        if cart.getTotalCount() > 0{
            for (item ,count ) in cart
            {
                Utils.addItemInCartWithSyncAnonym(item, count: count)
            }
        }
    }
    
    //MARK:- View Presenter
    
    func navigator(_ status:Bool,tabbarIndex:Int)->(vc:UIViewController,message:String){
        
        var vc = UIViewController()
        var message = ""
        
        if status{
            
            self.addItemForAnonym()
            UserDefaults.standard.set(true, forKey: "isLogin")
            UserDefaults.standard.synchronize()
            if tabbarIndex == 2{
                
                //vc = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cartViewController") as? cartViewController)!//ProfileViewController(nibName: "ProfileViewController", bundle: Bundle.main)
            }
            if(UserDefaults.standard.bool(forKey: "isLoginForWishListPageFromMenu")){
                
                UserDefaults.standard.set(false, forKey: "isLoginForWishListPageFromMenu")
                vc = WishListViewController(nibName: "WishListViewController", bundle: nil)
            }
            
            if(UserDefaults.standard.bool(forKey: "isLoginForWishListPage")){
                
                UserDefaults.standard.set(false, forKey: "isLoginForWishListPage")
                vc = WishListViewController(nibName: "WishListViewController", bundle: nil)
            }
            
            if UserManager.Instance.getUserInfo() != nil{

                vc = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CartVC") as? CartVC)!//ProfileViewController(nibName: "ProfileViewController", bundle: Bundle.main)//vc = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "buyNowViewController") as? buyNowViewController)!
            }
                
            else{
                
                vc = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CartVC") as? CartVC)!//ProfileViewController(nibName: "ProfileViewController", bundle: Bundle.main)//vc = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "buyNowViewController") as? buyNowViewController)!
            }
        }
            
        else{
            
            message = "Email id or Password is incorrect".localized()
        }
        
        return (vc:vc,message:message)
     }
}
