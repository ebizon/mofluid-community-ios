//
//  ChangePasswordScreenVC.swift
//  Mofluid
//
//  Created by Sadique_ebizon on 19/01/16.
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
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


class ChangePasswordScreenVC: UIViewController {
    
    @IBOutlet weak var oldText: UITextField?
    @IBOutlet weak var newText: UITextField?
    @IBOutlet weak var confirmText: UITextField?
    
    let baseViewObject = BaseViewController ()
    var loaderCount = 0
    var email:String? = nil
    let userInfo = UserManager.Instance.getUserInfo()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Change Password".uppercased()
        email = userInfo?.userName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func pwdURL(_ url:String,email:String,oldpwd:String,newpwd:String)->String{
        let serviceURL = url+"&username="+email+"&oldpassword="+oldpwd+"&newpassword="+newpwd
        
        return serviceURL
    }

    
    @IBAction func updateButtonAction(_ sender: UIButton) {
                let oldPwd = oldText!.text
                let newPwd = newText!.text
                let confirmPwd = confirmText!.text
                let url = WebApiManager.Instance.changePasswordURL()
        
        if(oldPwd != nil && oldPwd != ""){
            if(newPwd != nil && newPwd != ""){
                        if(newPwd?.count >= 6){
                            if(newPwd == confirmPwd){
                                let oldpasswdUTF8 = Encoder.encodeUTF8(oldPwd!)
                                let newpasswdUTF8 = Encoder.encodeUTF8(newPwd!)
        
                                if let oldpasswdBase64Encoded = Encoder.encodeBase64(oldpasswdUTF8){
                                    if let newpasswdBase64Encoded = Encoder.encodeBase64(newpasswdUTF8){
                                        self.addLoader()
        
                                        if email != nil {
                                            let serviceURL = pwdURL(url!, email: email!, oldpwd: oldpasswdBase64Encoded, newpwd: newpasswdBase64Encoded)
                                            Utils.fillTheData(serviceURL, callback: self.passwordStatus, errorCallback : baseViewObject.showError)
                                        }
                                    }
                                }
        
                            }
                                
                            else{
                                baseViewObject.alert("New Password and Confirm Password are not same")
                            }
                        }
                        else{
                            baseViewObject.alert("Password length should be atleast 6")
                        }
                    }
                    else{
                        baseViewObject.alert("New Password is required")
                        newText!.becomeFirstResponder()
                    }
                }
                else{
                    baseViewObject.alert("Old Password is required")
                    oldText!.becomeFirstResponder()
        
    }
        
    }
    
    func addLoader(){
        
        self.loaderCount += 1
        
        if self.loaderCount == 1{
            
            self.view.isUserInteractionEnabled=false
        }
    }
    
    func removeLoader(){
        self.loaderCount -= 1
        
        if self.loaderCount == 0{
            self.view.isUserInteractionEnabled=true
        }
    }

    func passwordStatus(_ response: NSDictionary){
        let change_status = response["change_status"] as? Int
        let message = response["message"] as? String
        let newpassword = response["newpassword"] as? String
        let newpasswdUTF8 = Encoder.encodeUTF8(newpassword!)
        let newpasswdBase64Encoded = Encoder.encodeBase64(newpasswdUTF8)
        
        defer{self.removeLoader()}
        if(change_status != 0){
            baseViewObject.alert(message!)
            if let loginType = UserManager.Instance.getUserInfo()?.loginType{
                UserInfo.saveLoginInfo(email!, base64EncodePassword: newpasswdBase64Encoded!, loginType : loginType)
            }
            self.goToHomePage()
        }
        else{
            baseViewObject.alert(message!)
        }
        
    }
    
    func goToHomePage(){
//        let Object = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as? ViewController
        self.navigationController?.popViewController(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
