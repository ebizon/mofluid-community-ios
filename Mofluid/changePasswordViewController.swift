//
//  sample.swift
//  Mofluid
//
//  Created by sudeep goyal on 10/09/15.
//  Copyright © 2015 Mofluid. All rights reserved.
//

import UIKit
import Foundation
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


class changePasswordViewController: PageViewController{
    var titleParentView = UIView()
    var TitleLabel = UILabel()
    var oldLabel = UILabel()
    var oldText = UITextField()
    var newLabel = UILabel()
    var newText = UITextField()
    var confirmLabel = UILabel()
    var confirmText = UITextField()
    var updateButton = ZFRippleButton()
    let userInfo = UserManager.Instance.getUserInfo()
    var email:String? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.navigationItem.title = "Change Password".uppercased()
//        titleParentView.frame = CGRectMake(0, 0, mainParentScrollView.frame.width, 50)
//        titleParentView.backgroundColor = UIColor(netHex:0xeaeaea)
//        TitleLabel = Utils.createTitleLabel(mainParentScrollView,yposition: 15)
//        TitleLabel.text = "Change Password"
     //   titleParentView.addSubview(TitleLabel)
        mainParentScrollView.addSubview(titleParentView)
        
        
        oldLabel = Utils.titleLabels(TitleLabel)
        oldLabel.frame.origin.y = titleParentView.frame.origin.y + titleParentView.frame.height + 20
        oldLabel.frame.size.width = mainParentScrollView.frame.width - 40
        oldLabel.text = "Old Password"
        mainParentScrollView.addSubview(oldLabel)
        oldText = Utils.titleTextFields(oldLabel)
        oldText.placeholder = "Old Password"
        oldText.delegate = self
        oldText.isSecureTextEntry = true
        mainParentScrollView.addSubview(oldText)
        
        newLabel = Utils.titleLabels(oldText)
        newLabel.text = "New Password"
        mainParentScrollView.addSubview(newLabel)
        newText = Utils.titleTextFields(newLabel)
        newText.placeholder = "New Password"
        newText.delegate = self
        newText.isSecureTextEntry = true
        mainParentScrollView.addSubview(newText)
        
        confirmLabel = Utils.titleLabels(newText)
        confirmLabel.text = "Confirm Password"
        mainParentScrollView.addSubview(confirmLabel)
        confirmText = Utils.titleTextFields(confirmLabel)
        confirmText.placeholder = "Confirm Password"
        confirmText.delegate = self
        confirmText.isSecureTextEntry = true
        mainParentScrollView.addSubview(confirmText)
        
        
        updateButton.frame = CGRect(x: 20, y: confirmText.frame.origin.y + confirmText.frame.height + 20, width: mainParentScrollView.frame.width - 40, height: 38)
        updateButton.addTarget(self, action: #selector(changePasswordViewController.updateButtonAction), for: UIControl.Event.touchUpInside)
        updateButton.backgroundColor = Settings().getButtonBgColor()//UIColor(red: (223/255.0), green: (114/255.0), blue: (114/255.0), alpha: 1.0)
        updateButton.layer.cornerRadius = 3.0
//        let backgroundImg = UIImage(named: "background")
//        updateButton.setBackgroundImage(backgroundImg, forState: UIControlState.Normal)
        updateButton.setTitle("Update", for: UIControl.State())
        updateButton.titleLabel?.font = UIFont(name: "Lato", size: 20)
        updateButton.titleLabel?.textColor = UIColor(netHex:0xf78f1e)
        mainParentScrollView.addSubview(updateButton)
       mainParentScrollView.contentSize.height = updateButton.frame.origin.y + updateButton.frame.height + 100
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       email = userInfo?.userName ?? ""
//        if(deviceName == "big"){
//            UILabel.appearance().font = UIFont(name: "Lato", size: 20)
//        }
//        else{
//            UILabel.appearance().font = UIFont(name: "Lato", size: 15)
//        }
        super.viewWillAppear(animated)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "OptionViewTap"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "selectOptionViewOption"), object: nil)
        
    }

    
    @objc func updateButtonAction(){
        
//        let ChangeViewObject = self.storyboard?.instantiateViewControllerWithIdentifier("ChangePasswordScreenVC") as? ChangePasswordScreenVC
//        self.navigationController?.pushViewController(ChangeViewObject!, animated: true)
        let oldPwd = oldText.text
        let newPwd = newText.text
        let confirmPwd = confirmText.text
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
                                    
                                    Utils.fillTheData(serviceURL, callback: self.passwordStatus, errorCallback : self.showError)
                                    
                                }                            }
                        }
                        
                    }
                    else{
                        self.alert("New Password and Confirm Password are not same")
                    }
                }
                else{
                    self.alert("Password length should be atleast 6")
                }
            }
                
            else{
                self.alert("New Password is required")
                newText.becomeFirstResponder()
            }
        }
            
        else{
            self.alert("Old Password is required")
            oldText.becomeFirstResponder()
        }
    }
    
       
    
    func pwdURL(_ url:String,email:String,oldpwd:String,newpwd:String)->String{
        let serviceURL = url+"&username="+email+"&oldpassword="+oldpwd+"&newpassword="+newpwd
        
        return serviceURL
    }
    
    func passwordStatus(_ response: NSDictionary){        
        let change_status = response["change_status"] as? Int ?? 0
        let message = response["message"] as? String ?? ""
        let newpassword = response["newpassword"] as? String ?? ""
        let newpasswdUTF8 = Encoder.encodeUTF8(newpassword)
        let newpasswdBase64Encoded = Encoder.encodeBase64(newpasswdUTF8)
        
        defer{self.removeLoader()}
        if(change_status != 0){
            self.alert(message)
            if let loginType = UserManager.Instance.getUserInfo()?.loginType{
            UserInfo.saveLoginInfo(email!, base64EncodePassword: newpasswdBase64Encoded!, loginType : loginType)
            }
            self.goToHomePage()
        }
        else{
            self.alert(message)
        }
        
    }

    func backButtonFunction(){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

