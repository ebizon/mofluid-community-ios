//
//  appLoginViewController.swift
//  Mofluid
//
//  Created by sudeep goyal on 10/09/15.
//  Copyright © 2015 Mofluid. All rights reserved.
//

import UIKit
import Foundation
import AddressBook
import MediaPlayer
import AssetsLibrary
import CoreLocation
import CoreMotion
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


class appLoginViewController: BaseViewController, UITextFieldDelegate{
    var loginType = LoginType.Mofluid
    var headerLabel: UILabel = UILabel()
    var emailAddressText = UITextField()
    var passwordText = UITextField()
    var orgnisationText = UITextField()
    var magentoStoreText = UITextField()
    let forgotEmailText = UITextField()
    let retrievePasswordTitleLabel = UILabel()
    var wishListShoppingItem:ShoppingItem? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ////////
        //self.openHomeView()
        ///////
        self.navigationItem.title = "LOGIN".localized()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(appLoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.push(_:)), name: NSNotification.Name(rawValue: "isPushedtoUser"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appLoginViewController.removeLoad(_:)), name: NSNotification.Name(rawValue: "removeLoader"), object: nil)
        
        
        createTextFieldDelegate(emailAddressText)
        createTextFieldDelegate(passwordText)
        createTextFieldDelegate(forgotEmailText)
        createTextFieldDelegate(orgnisationText)
        createTextFieldDelegate(magentoStoreText)
        
        let spaceLabel1 = UILabel()
        spaceLabel1.frame = CGRect(x: 10, y: 0, width: 7, height: 26)
        spaceLabel1.backgroundColor = UIColor.clear
        emailAddressText.frame = CGRect(x: 20, y: headerLabel.frame.size.height + headerLabel.frame.origin.y + 30, width: mainParentScrollView.frame.size.width - 40, height: 45)
        emailAddressText.layer.borderColor = UIColor.lightGray.cgColor//UIColor(netHex:0x5d5d5d).CGColor
        emailAddressText.layer.borderWidth = 1.5
        emailAddressText.font = UIFont(name: "Lato", size: 20)
        emailAddressText.textColor = UIColor.black
        emailAddressText.backgroundColor = UIColor.white
        emailAddressText.layer.cornerRadius = 3.0
        emailAddressText.placeholder = "Email Address".localized()
        emailAddressText.leftView = spaceLabel1
        emailAddressText.leftViewMode = UITextField.ViewMode.always
        emailAddressText.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        emailAddressText.keyboardType = UIKeyboardType.emailAddress
        
        let spaceLabel2 = UILabel()
        spaceLabel2.frame = CGRect(x: 10, y: 0, width: 7, height: 26)
        spaceLabel2.backgroundColor = UIColor.clear
        passwordText.frame = CGRect(x: emailAddressText.frame.origin.x, y: emailAddressText.frame.origin.y + emailAddressText.frame.size.height + 15, width: emailAddressText.frame.size.width, height: emailAddressText.frame.size.height)
        passwordText.layer.borderColor = UIColor.lightGray.cgColor
        passwordText.layer.borderWidth = 1.5
        passwordText.font = UIFont(name: "Lato", size: 20)
        passwordText.textColor = UIColor.black
        passwordText.backgroundColor = UIColor.white
        passwordText.layer.cornerRadius = 3.0
        passwordText.placeholder = "Password".localized()
        passwordText.leftView = spaceLabel2
        passwordText.leftViewMode = UITextField.ViewMode.always
        passwordText.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        
        
        let spaceLabel3 = UILabel()
        spaceLabel3.frame = CGRect(x: 10, y: 0, width: 7, height: 26)
        spaceLabel3.backgroundColor = UIColor.clear
        orgnisationText.frame = CGRect(x: 20, y: headerLabel.frame.size.height + headerLabel.frame.origin.y + 30, width: mainParentScrollView.frame.size.width - 40, height: emailAddressText.frame.size.height)
        orgnisationText.layer.borderColor = UIColor.lightGray.cgColor//UIColor(netHex:0x5d5d5d).CGColor
        orgnisationText.layer.borderWidth = 1.5
        orgnisationText.font = UIFont(name: "Lato", size: 20)
        orgnisationText.textColor = UIColor.black
        orgnisationText.backgroundColor = UIColor.white
        orgnisationText.layer.cornerRadius = 3.0
        orgnisationText.placeholder = "Organisation".localized()
        orgnisationText.leftView = spaceLabel3
        orgnisationText.leftViewMode = UITextField.ViewMode.always
        orgnisationText.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        orgnisationText.keyboardType = UIKeyboardType.alphabet
        
        
        let spaceLabel4 = UILabel()
        spaceLabel4.frame = CGRect(x: 10, y: 0, width: 7, height: 26)
        spaceLabel4.backgroundColor = UIColor.clear
        magentoStoreText.frame = CGRect(x: 20, y: headerLabel.frame.size.height + headerLabel.frame.origin.y + 30, width: mainParentScrollView.frame.size.width - 40, height: emailAddressText.frame.size.height)
        magentoStoreText.layer.borderColor = UIColor.lightGray.cgColor//UIColor(netHex:0x5d5d5d).CGColor
        magentoStoreText.layer.borderWidth = 1.5
        magentoStoreText.font = UIFont(name: "Lato", size: 20)
        magentoStoreText.textColor = UIColor.black
        magentoStoreText.backgroundColor = UIColor.white
        magentoStoreText.layer.cornerRadius = 3.0
        magentoStoreText.placeholder = "Magento Store URL".localized()
        magentoStoreText.leftView = spaceLabel3
        magentoStoreText.leftViewMode = UITextField.ViewMode.always
        magentoStoreText.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        magentoStoreText.keyboardType = UIKeyboardType.alphabet
        
        passwordText.resignFirstResponder()
        
        if (idForSelectedLangauge == Utils.getArebicLanguageCode()) {
            emailAddressText.textAlignment = .right
            orgnisationText.textAlignment = .right
            passwordText.textAlignment = .right
            magentoStoreText.textAlignment = .right
        }
        
        
        if(moveToLogin == true){
            createSigninPage()
        }else{
            createAccountButtonAction()
            moveToLogin = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "LOGIN".localized()
        
        let appearance = UITabBarItem.appearance()
        appearance.setTitleTextAttributes([NSAttributedString.Key.font:UIFont(name: "American Typewriter", size: 13)!], for: UIControl.State())
        appearance.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for:UIControl.State())
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "OptionViewTap"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "selectOptionViewOption"), object: nil)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @objc func removeLoad(_ notification: Notification){
        self.removeLoader()
    }
    
    func clicked(_ notification:Notification){
        self.removeLoader()
    }
    
    @objc func createSigninPage(){
        
        self.navigationItem.title = "LOGIN".localized()
        for view in mainParentScrollView.subviews{
            view.removeFromSuperview()
        }
        
        //headerLabel.text = "Login"
        emailAddressText.text = "".localized()
        passwordText.text = ""
        passwordText.isSecureTextEntry = true
        
        emailAddressText.frame.origin.y = headerLabel.frame.size.height + headerLabel.frame.origin.y + 30
        passwordText.frame.origin.y = emailAddressText.frame.origin.y + emailAddressText.frame.size.height + 15
        
        mainParentScrollView.addSubview(headerLabel)
        mainParentScrollView.addSubview(emailAddressText)
        mainParentScrollView.addSubview(passwordText)
        
        let CheckboxbuttonView = BigCheckBoxButton()
        CheckboxbuttonView.frame = CGRect(x: emailAddressText.frame.origin.x, y: passwordText.frame.origin.y + passwordText.frame.size.height + 25, width: emailAddressText.frame.size.width, height: 35)
        CheckboxbuttonView.addTarget(self, action: #selector(appLoginViewController.CheckboxbuttonAction(_:)), for: UIControl.Event.touchUpInside)
        
        CheckboxbuttonView.setTitleColor(UIColor.black, for: UIControl.State())
        CheckboxbuttonView.titleLabel?.font = UIFont(name: "Lato", size: 20)
        CheckboxbuttonView.setTitle("Show Password".localized(), for: UIControl.State())
        CheckboxbuttonView.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        CheckboxbuttonView.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        mainParentScrollView.addSubview(CheckboxbuttonView)
        
        // Flip for RTL
        if idForSelectedLangauge == Utils.getArebicLanguageCode() {
            CheckboxbuttonView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0);
            CheckboxbuttonView.titleLabel!.transform = CGAffineTransform(scaleX: -1.0, y: 1.0);
            CheckboxbuttonView.imageView!.transform = CGAffineTransform(scaleX: -1.0, y: 1.0);
        }
        
        
        let loginButton = ZFRippleButton()
        loginButton.frame = CGRect(x: emailAddressText.frame.origin.x, y: CheckboxbuttonView.frame.origin.y + CheckboxbuttonView.frame.size.height + 5, width: CheckboxbuttonView.frame.size.width, height: 45)
        loginButton.addTarget(self, action: #selector(appLoginViewController.loginButtonAction(_:)), for: UIControl.Event.touchUpInside)
        loginButton.backgroundColor = UIColor(red: (223/255.0), green: (114/255.0), blue: (114/255.0), alpha: 1.0)
        loginButton.layer.cornerRadius = 3.0
        loginButton.setTitle("Login".localized(), for: UIControl.State())
        loginButton.titleLabel?.font = UIFont(name: "Lato-Bold", size: 20)
        loginButton.titleLabel?.textColor = UIColor.white
        loginButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
        loginButton.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        
        let forgotPasswordButton = UIButton()
        forgotPasswordButton.frame = CGRect(x: emailAddressText.frame.origin.x, y: loginButton.frame.origin.y + loginButton.frame.size.height + 20, width: emailAddressText.frame.size.width, height: 35)
        forgotPasswordButton.addTarget(self, action: #selector(appLoginViewController.forgotPasswordButtonAction), for: UIControl.Event.touchUpInside)
        forgotPasswordButton.setTitleColor(UIColor.gray, for: UIControl.State())
        forgotPasswordButton.titleLabel?.font = UIFont(name: "Lato", size: 20)
        forgotPasswordButton.setTitle("Forgot Password".localized(), for: UIControl.State())
        forgotPasswordButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
        forgotPasswordButton.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        
        let createAccountButton = UIButton()
        createAccountButton.frame = CGRect(x: emailAddressText.frame.origin.x, y: forgotPasswordButton.frame.origin.y + forgotPasswordButton.frame.size.height, width: emailAddressText.frame.size.width, height: 35)
        createAccountButton.addTarget(self, action: #selector(appLoginViewController.createAccountButtonAction), for: UIControl.Event.touchUpInside)
        createAccountButton.setTitle("Create Account".localized(), for: UIControl.State())
        createAccountButton.titleLabel?.font = UIFont(name: "Lato", size: 20)
        createAccountButton.setTitleColor(UIColor.gray, for: UIControl.State())
        createAccountButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
        createAccountButton.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        
       // mainParentScrollView.addSubview(createAccountButton)
        
        mainParentScrollView.addSubview(loginButton)
        mainParentScrollView.addSubview(forgotPasswordButton)
        
        mainParentScrollView.contentSize.height = forgotPasswordButton.frame.origin.y + 100 + forgotPasswordButton.frame.size.height + 80
    }
    
    @objc func CheckboxbuttonAction(_ button: UIButton){
        button.isSelected = !button.isSelected;
        passwordText.isSecureTextEntry = !passwordText.isSecureTextEntry;
        passwordText.resignFirstResponder()
        passwordText.becomeFirstResponder()
    }
    
    @objc func loginButtonAction(_ button:ZFRippleButton){
        
        if(emailAddressText.text != nil && emailAddressText.text != ""){
            let checkEmail = isValidEmail(emailAddressText.text!)
            if(checkEmail == true){
                if(passwordText.text != ""){
                    if(passwordText.text?.count >= 6){
                        self.verifyLogin()
                    }else{
                        self.alert("Password length should be atleast 6 characters".localized())
                    }
                }else{
                    self.alert("Password is required".localized())
                }
            }else{
                self.alert("Email id entered is incorrect.".localized())
            }
        }else{
            self.alert("Email is required".localized())
        }
    }
    
    func verifyLogin(){
        if let passwd = passwordText.text{
            if let email = emailAddressText.text{
                //let stringUrl = Config.Instance.getAppLogincAccessURL()
                let json = ["email": email, "password" : passwd]
                let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                let url = URL(string: "https://api.mofluid.com/appLogin")
                var request = URLRequest(url: url!)
                request.httpMethod = "POST"
                request.httpBody = jsonData
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                let appAccessKey = Config.Instance.getAppAccessKey()
                request.addValue(appAccessKey , forHTTPHeaderField: "Authorization")
                
                self.addLoader()
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    guard let data = data, error == nil else {
                        DispatchQueue.main.async{
                            //(error!)
                            self.removeLoader()
                        }
                        return
                    }
                    DispatchQueue.main.async{
                        //callback(data)
                        self.removeLoader()
                        self.loginSuccess(data: data)
                    }
                }
                
                task.resume()
                //Utils.post(url: Config.Instance.getAppLogincAccessURL(), dict: json, callback: loginSuccess, errorCallback: loginError)
            }
        }
    }
    
    func loginSuccess(data : Data){
        let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
        if let responseJSON = responseJSON as? [String: Any] {
            if let baseURL = responseJSON["website"] as? String{
                Config.Instance.setBaseURL(url: baseURL)
                UserDefaults.standard.set(baseURL, forKey: Constants.AppBaseURL)
                UserDefaults.standard.synchronize()
                self.removeLoader()
                self.openHomeView()
            }else{
                self.removeLoader()
                self.alert("Login Failed")
            }
        }else{
            self.removeLoader()
            self.alert("Login Failed")
        }
    }
    
    func loginError(error : Error){
        self.alert("Login Failed")
        self.removeLoader()
    }
    
    func openHomeView(){
        let tabView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabViewController")
        UIApplication.shared.keyWindow?.rootViewController = tabView
    }
    
    @objc func forgotPasswordButtonAction(){
        
        self.navigationItem.title = "Forgot Password".localized().uppercased()
        for view in mainParentScrollView.subviews{
            view.removeFromSuperview()
        }
        
        headerLabel.text = "Forgot Password".localized()
        emailAddressText.text = ""
        passwordText.text = ""
        orgnisationText.text = ""
        passwordText.isSecureTextEntry = true
        
        retrievePasswordTitleLabel.frame = CGRect(x: 20, y: emailAddressText.frame.origin.y, width: emailAddressText.frame.size.width, height: 47)
        retrievePasswordTitleLabel.text = "Please provide your registered email to retrieve your password".localized()
        retrievePasswordTitleLabel.backgroundColor = UIColor.white
        retrievePasswordTitleLabel.textColor = UIColor.darkGray
        retrievePasswordTitleLabel.font = UIFont(name: "Lato", size: 18)
        retrievePasswordTitleLabel.textAlignment = .center;
        retrievePasswordTitleLabel.numberOfLines = 2
        
        emailAddressText.frame.origin.y = retrievePasswordTitleLabel.frame.origin.y + retrievePasswordTitleLabel.frame.size.height + 15
        
        mainParentScrollView.addSubview(headerLabel)
        mainParentScrollView.addSubview(retrievePasswordTitleLabel)
        mainParentScrollView.addSubview(emailAddressText)
        
        let retrievePasswordButton = ZFRippleButton()
        retrievePasswordButton.frame = CGRect(x: emailAddressText.frame.origin.x, y: emailAddressText.frame.origin.y + emailAddressText.frame.size.height + 20, width: emailAddressText.frame.size.width, height: 45)
        retrievePasswordButton.addTarget(self, action: #selector(appLoginViewController.retrievePasswordButtonAction(_:)), for: UIControl.Event.touchUpInside)
        
        retrievePasswordButton.backgroundColor = UIColor(red: (223/255.0), green: (114/255.0), blue: (114/255.0), alpha: 1.0)
        retrievePasswordButton.layer.cornerRadius = 3.0
        retrievePasswordButton.setTitle("Retrive Your Password".localized(), for: UIControl.State())
        retrievePasswordButton.titleLabel?.font = UIFont(name: "Lato-Bold", size: 20)
        retrievePasswordButton.titleLabel?.textColor = UIColor.white
        retrievePasswordButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
        retrievePasswordButton.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        
        let goToLogin = UIButton()
        goToLogin.frame = CGRect(x: emailAddressText.frame.origin.x, y: retrievePasswordButton.frame.origin.y + retrievePasswordButton.frame.size.height + 25, width: emailAddressText.frame.size.width, height: 35)
        goToLogin.addTarget(self, action: #selector(appLoginViewController.createSigninPage), for: UIControl.Event.touchUpInside)
        goToLogin.setTitleColor(UIColor.gray, for: UIControl.State())
        goToLogin.titleLabel?.font = UIFont(name: "Lato", size: 20)
        goToLogin.setTitle("Go Back To Login".localized(), for: UIControl.State())
        goToLogin.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
        goToLogin.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        
        mainParentScrollView.addSubview(retrievePasswordButton)
        mainParentScrollView.addSubview(goToLogin)
        
        mainParentScrollView.contentSize.height = goToLogin.frame.origin.y + goToLogin.frame.size.height + 50
    }
    
    @objc func createAccountButtonAction(){
        
        self.navigationItem.title = "Sign Up".localized().uppercased()
        for view in mainParentScrollView.subviews{
            view.removeFromSuperview()
        }
        
        headerLabel.text = "New User? Sign Up".localized()
        emailAddressText.text = "".localized()
        passwordText.text = ""
        orgnisationText.text = ""
        
        emailAddressText.frame.origin.y = orgnisationText.frame.origin.y + orgnisationText.frame.size.height + 15
        magentoStoreText.frame.origin.y = emailAddressText.frame.origin.y + emailAddressText.frame.size.height + 15
        mainParentScrollView.addSubview(headerLabel)
        mainParentScrollView.addSubview(orgnisationText)
        mainParentScrollView.addSubview(emailAddressText)
        mainParentScrollView.addSubview(magentoStoreText)
        
        let signupButton = ZFRippleButton()
        signupButton.frame = CGRect(x: emailAddressText.frame.origin.x, y: passwordText.frame.origin.y + passwordText.frame.size.height + 20, width: emailAddressText.frame.size.width, height: 45)
        signupButton.addTarget(self, action: #selector(appLoginViewController.signupButtonAction(_:)), for: UIControl.Event.touchUpInside)
        
        signupButton.backgroundColor = UIColor(red: (223/255.0), green: (114/255.0), blue: (114/255.0), alpha: 1.0)
        signupButton.layer.cornerRadius = 3.0
        signupButton.setTitle("Sign Up Now".localized(), for: UIControl.State())
        signupButton.titleLabel?.font = UIFont(name: "Lato-Bold", size: 20)
        signupButton.titleLabel?.textColor = UIColor.white
        signupButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
        signupButton.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        
        let goToLogin = UIButton()
        goToLogin.frame = CGRect(x: emailAddressText.frame.origin.x, y: signupButton.frame.origin.y + signupButton.frame.size.height + 15, width: emailAddressText.frame.size.width, height: 35)
        goToLogin.addTarget(self, action: #selector(appLoginViewController.createSigninPage), for: UIControl.Event.touchUpInside)
        goToLogin.setTitleColor(UIColor.gray, for: UIControl.State())
        goToLogin.titleLabel?.font = UIFont(name: "Lato", size: 20)
        goToLogin.setTitle("Already have an account? Login".localized(), for: UIControl.State())
        goToLogin.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
        goToLogin.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        
        mainParentScrollView.addSubview(signupButton)
        mainParentScrollView.addSubview(goToLogin)
        mainParentScrollView.contentSize.height = goToLogin.frame.origin.y + goToLogin.frame.size.height + 200
    }
    
    @objc func signupButtonAction(_ button:ZFRippleButton){
        
        if(orgnisationText.text != nil && orgnisationText.text != ""){
            if(emailAddressText.text != nil && emailAddressText.text != ""){
                let checkEmail = isValidEmail(emailAddressText.text!)
                if(checkEmail == true){
                    if(passwordText.text != ""){
                        if(passwordText.text?.count >= 6){
                            self.addLoader()
                            self.verifySignup()
                        }else{
                            self.alert("Password length should be atleast 6 characters".localized())
                        }
                    }else{
                        self.alert("Password is required".localized())
                    }
                }else{
                    self.alert("Email id entered is incorrect.".localized())
                }
            }else{
                self.alert("Email id is required".localized())
            }
        }else{
            self.alert("Full Name is required".localized())
        }
    }
    
    
    func verifySignup(){
        guard let email = emailAddressText.text else{
            return
        }
        
        guard let fullName = orgnisationText.text else{
            return
        }
        
        guard let password = passwordText.text, passwordText.text?.count >= 6 else{
            return
        }
        
        let names = fullName.components(separatedBy: " ")
        
        guard names.count > 0 else{
            return
        }
        
        let firstName = names.first!
        let lastName = names.last!
        
        
        //**************PC************SignUp update 
        let firstNameUTF8 = Encoder.encodeUTF8(firstName)
        let firstNameUTF8Base64Encoded = Encoder.encodeBase64(firstNameUTF8)
        
        let lastNameUTF8 = Encoder.encodeUTF8(lastName)
        let lastNameUTF8UTF8Base64Encoded = Encoder.encodeBase64(lastNameUTF8)
        //******************************************
        
        
        guard let url = WebApiManager.Instance.getCreateUserURL() else{
            return
        }
        
        let passwdUTF8 = Encoder.encodeUTF8(password)
        
        if let passwdBase64Encoded = Encoder.encodeBase64(passwdUTF8){
            let serviceURL = url + "&firstname=\(firstNameUTF8Base64Encoded!)&lastname=\(lastNameUTF8UTF8Base64Encoded!)&email=\(email)&password=\(passwdBase64Encoded)"
            
            Utils.fillTheData(serviceURL, callback: self.createUserResult, errorCallback : self.showError)
        }
    }
    
    func createUserResult(_ dataDict: NSDictionary){
        defer{self.removeLoader()}
        guard let status = dataDict["status"] as? Int else{
            return
        }
        
        if status == 1{
            self.verifyLogin()
        }else{
            assert(self.emailAddressText.text != nil)
            self.alert("Account already exists with email id \(self.emailAddressText.text!). ".localized())
        }
    }
    
    @objc func retrievePasswordButtonAction(_ button:ZFRippleButton){
        if(emailAddressText.text != ""){
            let checkEmail = isValidEmail(emailAddressText.text!)
            if(checkEmail == true){
                if let email = emailAddressText.text{
                    let url = Config.Instance.getForgotPasswordURL(email: email)
                    self.addLoader()
                    Utils.fillTheData(url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), callback: self.forgotPasswordResult, errorCallback : self.showError)
                }
            }else{
                self.alert("Email id entered is incorrect.".localized())
            }
        }else{
            self.alert("Email is required".localized())
        }
    }
    
    func forgotPasswordResult(_ dataDict : NSDictionary){
        defer{self.removeLoader()}
        let refreshAlert = UIAlertController(title: "", message: "If email is registered, You will receive an email with a link to reset your password.".localized(), preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok".localized(), style: .default, handler: { (action: UIAlertAction!) in
            
            self.createSigninPage()
        }))
        present(refreshAlert, animated: true, completion: nil)
        //self.alert("If email is registered, You will receive an email with a link to reset your password.".localized())
    }
    
    func isValidEmail(_ testStr:String) -> Bool {
        return Utils.isValidEmail(testStr)
    }
    
    func backButtonFunction(){
        
        if tabBarController?.selectedIndex == 2 {
            let delegate = UIApplication.shared.delegate as! AppDelegate
            self.tabBarController?.selectedIndex = delegate.previousSelected!
            
            delegate.previousSelected = delegate.currentSelected
            delegate.currentSelected = self.tabBarController?.selectedIndex
            delegate.tabSelectedIndex =  delegate.currentSelected
            
        }
            
        else {
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func createTextFieldDelegate(_ textField: UITextField){
        textField.delegate = self
    }
}



