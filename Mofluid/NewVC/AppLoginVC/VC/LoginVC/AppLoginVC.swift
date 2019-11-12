//
//  AppLoginVC.swift
//  Mofluid
//
//  Created by Saurabh Mishra on 6/14/18.
//  Copyright © 2018 Mofluid. All rights reserved.
//

import UIKit

class AppLoginVC: UIViewController {

    @IBOutlet weak var ivLogo: UIImageView!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var lblTagline: UILabel!
    @IBOutlet weak var lblAccount: UILabel!
    @IBOutlet weak var btnDemo: UIButton!
    @IBOutlet weak var btnForget: UIButton!
    @IBOutlet weak var btnPrivacy: UIButton!
    @IBOutlet weak var lblLogging: UILabel!
    @IBOutlet weak var viewEdit: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        setInitialUi()
        setTextOnControlls()
    }
    //MARK:- INIT UI
    func setInitialUi(){
        
        viewEdit.layer.borderColor      =       UIColor.lightGray.cgColor
        viewEdit.layer.borderWidth      =       1.0
        viewEdit.layer.cornerRadius     =       5.0
        tfEmail.layer.borderColor       =       UIColor.lightGray.cgColor
        tfPassword.layer.borderColor    =       UIColor.lightGray.cgColor
        lblLogging.font                 =       UIFont(name: "Ubuntu", size: 14)
        lblAccount.font                 =       UIFont(name: "Ubuntu-Light", size: 17)
        lblTagline.font                 =       UIFont(name: "Ubuntu", size: 22)
        btnLogin.layer.cornerRadius     =       3.0
        //do the initial property on controllers
    }
    //MARK:- INIT Placeholders
    func setTextOnControlls(){
        
        //do the initial set title labels on controllers
    }
    //MARK:- IBACTIONS
    
    @IBAction func clickForget(_ sender: Any) {
        
        let forgotPass = ForgetPasswordVC(nibName:"ForgetPasswordVC",bundle: nil)
        forgotPass.isFromUser = false
        self.present(forgotPass, animated: true, completion: nil)
    }
    @IBAction func test(_ sender: Any) {
        
        let home = ProductVC(nibName:"ProductVC",bundle: nil)
        let nav = UINavigationController(rootViewController: home)
        appDelegate.window!.rootViewController = nav
        self.navigationController?.pushViewController(home, animated:true)
    }
    @IBAction func clickLogin(_ sender: Any) {
        
        resignTextfields()
        let returnValue = Helper().validateEmailPassword(emailField: tfEmail!, passwordField: tfPassword!)
        if returnValue.status{
            
            loginApiCall()
        }
        else{
            
            Helper().showAlert(self, message: returnValue.message)
        }
    }
    
    @IBAction func clickSeeDemo(_ sender: Any) {
        
        Config.Instance.setBaseURL(url: Settings().liveUrl)
        UserDefaults.standard.set(Settings().liveUrl, forKey: Constants.AppBaseURL)
        UserDefaults.standard.set("true", forKey: "isDemo")
        UserDefaults.standard.synchronize()
        Helper().resetAllInstances()
        openHomeView()
    }
    
    @IBAction func clickPrivacy(_ sender: Any) {
        
        let privacy = PrivacyVC(nibName:"PrivacyVC",bundle: nil)
        self.present(privacy, animated: true, completion: nil)
    }
    //MARK:- Custom Methods
    func resignTextfields(){
        
        tfPassword.resignFirstResponder()
        tfEmail.resignFirstResponder()
    }
    func openHomeView(){
        
        let tabView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabViewController")
        UIApplication.shared.keyWindow?.rootViewController = tabView
    }
    func loginApiCall(){
        
        MyLoader.shared.showInView(view: self.view, withHeader: "Loading", andFooter: "Please wait...")
        AppLoginVM().callForLoginApi(emailId: tfEmail.text!, password:tfPassword.text!, { (status,response) in
            
            MyLoader.shared.hide()
            if status{
                
                AppLoginVM().loginSuccessParse((response as? NSDictionary)!)
                UserDefaults.standard.removeObject(forKey: "isDemo")
                UserDefaults.standard.synchronize()
                self.openHomeView()
            }
            else{
                
                Helper().showAlert(self, message: Settings().credentialMessage)
            }
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
//MARK:- TEXTDELEGATES
extension AppLoginVC:UITextFieldDelegate{
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        textField.resignFirstResponder()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}
