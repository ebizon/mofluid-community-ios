//
//  ShippingAddressVC.swift
//  Mofluid
//
//  Created by Saurabh Mishra on 02/08/18.
//  Copyright © 2018 Mofluid. All rights reserved.
//

import UIKit

class ShippingAddressVC: UIViewController {
    
    @IBOutlet weak var btnSubmit        :   UIButton!
    @IBOutlet weak var tfAddress2       :   UITextField!
    @IBOutlet weak var btnState         :   UIButton!
    @IBOutlet weak var tfState          :   UITextField!
    @IBOutlet weak var tfAddress1       :   UITextField!
    @IBOutlet weak var btnCountry       :   UIButton!
    @IBOutlet weak var tfZipcode        :   UITextField!
    @IBOutlet weak var tfCity           :   UITextField!
    @IBOutlet weak var tfPhone          :   UITextField!
    @IBOutlet weak var tfLName          :   UITextField!
    @IBOutlet weak var tfFName          :   UITextField!
    @IBOutlet weak var scrollView       :   UIScrollView!
    @IBOutlet weak var lastView         :   UIView!
    @IBOutlet weak var ivShippingDiff   :   UIImageView!
    @IBOutlet weak var ivShippingSame   :   UIImageView!
    @IBOutlet weak var btnSameAdd       :   UIButton!
    @IBOutlet weak var btnDiffAddress   :   UIButton!
    var btnTitle                        :   String?
    var isUpdate                        :   Bool?
    let shipData                        =   UserManager.Instance.getUserInfo()?.shipAddress
    var kCountry                        =   "Country"
    var kState                          =   "State"
    var state                           =   [State]()
    var countryCode                     =   ""
    var stateCode                       =   ""
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        setData()
        // Do any additional setup after loading the view.
    }
    //MARK:- Init View
    func initView(){
        
        self.navigationItem.title                                 =   Settings().shippingAddress
        self.navigationController?.navigationBar.tintColor        =   .black
        btnState.layer.borderColor                                =   UIColor.black.cgColor
        btnState.layer.borderWidth                                =   1.0
        btnCountry.layer.borderColor                              =   UIColor.black.cgColor
        btnCountry.layer.borderWidth                              =   1.0
        btnState.isHidden                                         =   true
        btnSubmit.backgroundColor                                 =   Settings().getButtonBgColor()
        btnSameAdd.setTitle(Settings().sameAddress, for: .normal)
        btnDiffAddress.setTitle(Settings().diffAddress, for: .normal)
        countryCode                     =   (shipData?.countryCode)!
        stateCode                       =   (shipData?.region.code)!
        scrollView.contentSize.height   =   ShippingAddVM().getContentHeight(lastView)
        btnSameAdd.isSelected           =   true
        btnDiffAddress.isSelected       =   false
        ivShippingSame.image            =   #imageLiteral(resourceName: "Radio-active")
        ivShippingDiff.image            =   #imageLiteral(resourceName: "Radio-normal")
    }
    //MARK: Custom Methods
    func setData(){
        
        if let _ = shipData?.firstName{
            
            tfFName.text        =       shipData?.firstName             ??  nil
            tfLName.text        =       shipData?.lastName              ??  nil
            tfPhone.text        =       shipData?.telePhone             ??  nil
            tfCity.text         =       shipData?.city                  ??  nil
            tfState.text        =       shipData?.region.name           ??  nil
            tfZipcode.text      =       shipData?.postCode              ??  nil
            tfAddress1.text     =       (shipData?.street[0])!
            btnCountry.setTitle(ShippingAddVM().getCountryName((shipData?.countryCode)!), for: .normal)
            btnState.setTitle(shipData?.region.name ?? Settings().select, for: .normal)
            getStateForCountry((shipData?.countryCode)!)
            if ((shipData?.street.count)!>1){
                
                tfAddress2.text =   (shipData?.street[1])!
            }
            else{
                
                tfAddress1.text = (shipData?.street[0])!
            }
        }
    }
    func getStateForCountry(_ code:String){
        
        countryCode =   code
        Helper().addLoader(self)
        ShippingAddVM().getStateList(code) { (status,response) in
            
            if status && (response?.count)!>0{
                
                self.state              =   response!
                self.tfState.isHidden   =   true
                self.btnState.isHidden  =   false
            }
            else{
                
                self.btnState.isHidden  =   true
                self.tfState.isHidden   =   false
            }
            Helper().removeLoader()
        }
    }
    func submitData(){
        
        let addressRegion   =   AddressRegion(id: 0, code: stateCode, name: (btnState.isHidden ? (tfState.text!)  :  (btnState.currentTitle!)))
        let shipaddress     =   Address(id : -1, firstName: tfFName.text!, lastName: tfLName.text!, telePhone: tfPhone.text!, street: [tfAddress1.text!, tfAddress2.text!], city: tfCity.text!, regionId : addressRegion.id, region: addressRegion , postCode: tfZipcode.text!, countryCode: countryCode)
        print(shipaddress)
    }
    //MARK: IBACTIONS
    @IBAction func clickCountry(_ sender: Any) {
        
        let vc                      =       CountryVC(nibName:"CountryVC", bundle: nil)
        vc.delegate                 =       self
        vc.type                     =       kCountry
        vc.country                  =       LocaleManager.Instance.getCountryList()
        vc.modalPresentationStyle   =       .overCurrentContext
        vc.view.backgroundColor     =       UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.tabBarController?.present(vc, animated: true, completion: {
            
        })
        
    }
    @IBAction func clickState(_ sender: Any) {
        
        let vc                      =       CountryVC(nibName:"CountryVC", bundle: nil)
        vc.delegate                 =       self
        vc.type                     =       kState
        vc.country                  =       state
        vc.modalPresentationStyle   =       .overCurrentContext
        vc.view.backgroundColor     =       UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.tabBarController?.present(vc, animated: true, completion: {
            
        })
    }
    @IBAction func clickSubmit(_ sender: Any) {
        
        var state=""
        btnState.isHidden ? (state=tfState.text!)  :  (state = btnState.currentTitle!)
        let validate =  ShippingAddVM().isVerifyInputs(firstname: tfFName.text, lastname: tfLName.text, number: tfPhone.text, address1: tfAddress1.text, address2: tfAddress2.text, city: tfCity.text, country:btnCountry.currentTitle ,state:state, zipcode: tfZipcode.text)
        validate.status ?  submitData()   :   Helper().showAlert(self, message: validate.message)
    }
    @IBAction func clickOnDiff(_ sender: Any) {
        
        ivShippingDiff.image            =   #imageLiteral(resourceName: "Radio-active")
        ivShippingSame.image            =   #imageLiteral(resourceName: "Radio-normal")
        btnDiffAddress.isSelected       =   true
        btnSameAdd.isSelected           =   false
    }
    @IBAction func clickOnSame(_ sender: Any) {
        
        ivShippingDiff.image            =   #imageLiteral(resourceName: "Radio-normal")
        ivShippingSame.image            =   #imageLiteral(resourceName: "Radio-active")
        btnDiffAddress.isSelected       =   false
        btnSameAdd.isSelected           =   true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
