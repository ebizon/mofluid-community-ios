//
//  SignUpVC.swift
//  Mofluid
//
//  Created by Saurabh Mishra on 6/18/18.
//  Copyright © 2018 Mofluid. All rights reserved.
//

import UIKit
//protocol SignupDelegate {
//
//    func didSignup(username: String, email: String,password: String)
//}
class SignUpVC: UIViewController {

    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var viewEdit: UIView!
    @IBOutlet weak var btnSignUP: UIButton!
    //var delegate: SignupDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSignUP.backgroundColor=Settings().getButtonBgColor()
        //let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpVC.tapGestureRecognized(_:)))
        //self.view.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view.
    }
    //MARK:- IBACTIONS
    //Tap gesture
    @objc func tapGestureRecognized(_ sender:UITapGestureRecognizer) {
        self.dismiss(animated: true) {
        }     
    }
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        // handling code
        self.dismiss(animated: true) {
        }
    }
    @IBAction func clickClose(_ sender: Any) {
        
        self.dismiss(animated: true) {
        }
    }
    @IBAction func clickSignup(_ sender: Any) {
        
        resignTextfields()
        let returnValue = Helper().validateEmailPasswordName(emailField: tfEmail!, passwordField: tfPassword! , nameField:tfName!)
        if returnValue.status{
            
            loginSignupCall()
        }
        else{
            
            Helper().showAlert(self, message:returnValue.message)
        }
    }
    @IBAction func onTapView(sender: UITapGestureRecognizer)
    {
        self.dismiss(animated: true) {
        }
    }
    
    //MARK:- Custom Methods
    private func resignTextfields(){
        
        tfPassword.resignFirstResponder()
        tfEmail.resignFirstResponder()
        tfName.resignFirstResponder()
    }
    private func loginSignupCall(){
        
        resignTextfields()
        Helper().addLoader(self)
        AppLoginVM().callForSignUpApi(emailId: tfEmail.text!, password:tfPassword.text!, name:tfName.text!) { (status, response) in
            
            if status{
                
                self.showSignupResponse(AppLoginVM().createUserResult((response as? NSDictionary)!))
            }
            else{
                
                Helper().showAlert(self, message:Settings().errorMessage)
            }
            Helper().removeLoader()
        }
    }
    private func showSignupResponse(_ response:(status:Bool,message:String)){
        
        if response.message == ""{
            
            AJAlertController.initialization().showAlertWithOkButton(aStrMessage:Settings().signUpSuccess,vc:self)
            { (index, title) in
                print(index,title)
                
                self.presentingViewController?.dismiss(animated: true, completion:nil)
            }
        }
        else{
            
            Helper().showAlert(self, message:response.message)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
