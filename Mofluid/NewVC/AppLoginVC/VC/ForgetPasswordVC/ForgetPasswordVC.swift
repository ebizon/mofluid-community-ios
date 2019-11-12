//
//  ForgetPasswordVC.swift
//  Mofluid
//
//  Created by Saurabh Mishra on 6/14/18.
//  Copyright © 2018 Mofluid. All rights reserved.
//

import UIKit

class ForgetPasswordVC: UIViewController {

    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnPassword: UIButton!
    @IBOutlet weak var tfEmailId: UITextField!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var clickClose: UIButton!
    var isFromUser      =       true
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        setInitialUi()
    }
    //MARK:- INIT UI
    func setInitialUi(){
        
        //do the initial property on controllers
        lblHeader.font      =   Settings().boldFont
        lblDescription.font =   UIFont (name: "Ubuntu", size: 21)
    }
    //MARK:- INIT Placeholders
    func setTextOnControlls(){
        
        //do the initial set title labels on controllers
    }
    //MARK:- Custom methods
    func callForgetPasswordApi(){
        
        MyLoader.shared.showInView(view: self.view, withHeader: "Loading", andFooter: "Please wait...")
        AppLoginVM().callForgetPasswordApi(emailId: tfEmailId.text!,isUser:isFromUser) { (status,response) in
            
            if status{
                
                if self.isFromUser{
                    
                    self.parseData((response as? NSDictionary)!)
                }
                else{
                    
                    AJAlertController.initialization().showAlertWithOkButton(aStrMessage:((response as? NSDictionary)?.value(forKey:"message") as? String)!,vc:self)
                    { (index, title) in
                        
                        self.presentingViewController?.dismiss(animated: true, completion:nil)
                        print(index,title)
                    }
                }
                
            }
            else{
                
                Helper().showAlert(self, message: Settings().errorMessage)
            }
            MyLoader.shared.hide()
        }
    }
    func parseData(_ data:NSDictionary){
        
        guard let response = data["response"] as? String else{
            return
        }
        if response == "success"{
            
            Helper().showAlert(self, message:Settings().forgetUserNameSuccess)
            
        }else{
            
            Helper().showAlert(self, message:"\(Settings().forgetUserError) \(self.tfEmailId.text!)")
        }
    }
    //MARK:- IBACTIONS
    @IBAction func clickClose(_ sender: Any) {
        
        self.presentingViewController?.dismiss(animated: true, completion:nil)
    }
    
    @IBAction func clickPassword(_ sender: Any) {
        
        tfEmailId.resignFirstResponder()
        let value = Helper().validateEmail(email: tfEmailId)
        if value.status{
            
            callForgetPasswordApi()
        }
        else{
            
            Helper().showAlert(self, message: value.message)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
//MARK:- TEXTDELEGATES
extension ForgetPasswordVC:UITextFieldDelegate{
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        textField.resignFirstResponder()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}
