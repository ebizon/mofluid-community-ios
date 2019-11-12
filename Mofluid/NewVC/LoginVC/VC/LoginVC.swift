//
//  LoginVC.swift
//  Mofluid
//
//  Created by Saurabh Mishra on 6/18/18.
//  Copyright © 2018 Mofluid. All rights reserved.
//

import UIKit

class LoginVC: UIViewController{

    @IBOutlet weak var ivLogo: UIImageView!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var lblTagline: UILabel!
    @IBOutlet weak var lblAccount: UILabel!
    @IBOutlet weak var btnSignup: UIButton!
    @IBOutlet weak var btnForget: UIButton!
    @IBOutlet weak var btnPrivacy: UIButton!
    @IBOutlet weak var lblLogging: UILabel!
    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var btnGoogle: UIButton!
    @IBOutlet weak var viewEdit: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.loginWithFB(_:)), name: NSNotification.Name(rawValue: "isLoginWithFB"), object: nil)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        setInitialUi()
        setTextOnControlls()
        self.navigationController?.setNavigationBarHidden(true, animated:false)
    }
    //MARK:- INIT UI
    func setInitialUi(){
        
        self.view.backgroundColor       =       Settings().getBackgroundColor()
        self.btnLogin.backgroundColor   =       Settings().getButtonBgColor()
        viewEdit.layer.borderColor      =       UIColor.lightGray.cgColor
        viewEdit.layer.borderWidth      =       1.0
        viewEdit.layer.cornerRadius     =       5.0
        tfEmail.layer.borderColor       =       UIColor.lightGray.cgColor
        tfPassword.layer.borderColor    =       UIColor.lightGray.cgColor
        lblLogging.font                 =       Settings().headerFont
        lblAccount.font                 =       Settings().titleFont
        //do the initial property on controllers
    }
    //MARK:- INIT Placeholders
    func setTextOnControlls(){
        
        //do the initial set title labels on controllers
    }
    //MARK:- IBACTIONS
    @IBAction func clickPrivacy(_ sender: Any) {
        
        let privacy = PrivacyVC(nibName:"PrivacyVC",bundle: nil)
        self.present(privacy, animated: true, completion: nil)
    }
    @IBAction func clickFB(_ sender: Any) {
        
        //MyLoader.shared.showInView(view: self.view, withHeader: "Loading", andFooter: "Please wait...")
        if tabBarController?.selectedIndex == 2 {
            UserDefaults.standard.set(true, forKey: "isLoginWithUserProfile")
            
            let fbLogin = FbLoginManager()
            fbLogin.facebookLogin()
        }
        else{
            UserDefaults.standard.set(true, forKey: "isFirstTimeCalled")
            let fbLogin = FbLoginManager()
            fbLogin.facebookLogin()
        }
    }
    @IBAction func clickGoogle(_ sender: Any) {
        
        Helper().addLoader(self)
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().clientID = Config.Instance.getGoogleClientID()
        GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/plus.login")
        GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/plus.me")
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    @IBAction func clickSignup(_ sender: Any) {
        
        showSignupView()
    }
    @IBAction func clickForget(_ sender: Any) {
        
        let forgotPass              =          ForgetPasswordVC(nibName:"ForgetPasswordVC",bundle: nil)
        forgotPass.isFromUser       =          true
        self.present(forgotPass, animated: true, completion: nil)
    }
    @IBAction func clickLogin(_ sender: Any) {
        
        resignTextfields()
        let returnValue             =           Helper().validateEmailPassword(emailField: tfEmail!, passwordField: tfPassword!)
        if returnValue.status{
            
            loginApiCall()
        }
        else{
            
            Helper().showAlert(self, message:returnValue.message)
        }
    }
    //MARK:- Custom Methods
    func resignTextfields(){
        
        tfPassword.resignFirstResponder()
        tfEmail.resignFirstResponder()
    }
    func navigateToVC(_ value:Bool){
        
        //Helper().removeLoader()
        let response = LoginVM().navigator(value, tabbarIndex:(tabBarController?.selectedIndex)!)
        
        if response.message == ""{
            
            self.navigationController?.pushViewController(response.vc, animated:true)
        }
        else{
            
            Helper().showAlert(self, message:response.message)
        }
    }
    @objc func loginWithFB(_ notification: Notification){
        
            self.navigateToVC(true)
            UserDefaults.standard.set(false, forKey: "isFirstTimeCalled")
    }
    func loginApiCall(){
        
        MyLoader.shared.showInView(view: self.view, withHeader: "Loading", andFooter: "Please wait...")
        LoginVM().callForLoginApi(emailId: tfEmail.text!, password:tfPassword.text!, { (status,response) in
            
            MyLoader.shared.hide()
            if status{
                
                let value = LoginVM().loginSuccessParse((response as? NSDictionary)!)
                DispatchQueue.main.async() {
                    self.navigateToVC(value)
                }
            }
            else{
                
                Helper().showAlert(self, message:Settings().credentialMessage)
            }
        })
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        Helper().removeLoader()
        self.navigationController?.setNavigationBarHidden(false, animated:false)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
//MARK:- TEXTDELEGATES
extension LoginVC:UITextFieldDelegate{
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        textField.resignFirstResponder()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}
//MARK:- Google +
extension LoginVC:GIDSignInUIDelegate,GIDSignInDelegate{
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        
        if (error == nil) {
            // Perform any operations on signed in user here.
            let googleLogin = GooglePlusLogin()
            googleLogin.googlePlusData(user)
            Helper().removeLoader()
            DispatchQueue.main.async() {
                self.navigateToVC(true)
            }
        }
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user:GIDGoogleUser!,
              withError error: Error!) {
        

        // Perform any operations when the user disconnects from app here.
        // ...
    }
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        
        //Helper().removeLoader()
    }
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        
        //Helper().removeLoader()
        self.present(viewController, animated: true, completion: nil)
    }
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        
        //Helper().removeLoader()
        self.dismiss(animated: true, completion: nil)
    }
}
//MARK:- SIGNUP
extension LoginVC{
    
    func showSignupView(){
        
        let vc                      =    SignUpVC(nibName: "SignUpVC", bundle: nil)
        vc.modalTransitionStyle     =   .crossDissolve
        vc.modalPresentationStyle   =   .overCurrentContext
        vc.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.tabBarController?.present(vc, animated: true, completion: {
            
        })
    }
}
