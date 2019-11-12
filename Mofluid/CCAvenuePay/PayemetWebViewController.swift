
//
//  PaymentWebViewController.swift
//
//  Created by Vivek Shukla on 04/10/16.
//  Copyright © 2016 Mofluid. All rights reserved.
//

import UIKit

class PayemetWebViewController: UIViewController,UIWebViewDelegate {
    
    @IBOutlet weak var webviewInstance: UIWebView!
    var cart = ShoppingCart.Instance
    var address = Address.self
    var orderId : String? = nil
    var loaderCount = 0
    var status:Bool? = nil
    var paymentMethod:String? = nil
    var myActivityIndicator1 = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
    var backButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "PAYMENT".localized().uppercased()
        self.navigationItem.setHidesBackButton(true, animated:true);
        webviewInstance.delegate = self
        myActivityIndicator1.color = UIColor.black
        myActivityIndicator1.center = CGPoint(x: UIScreen.main.bounds.size.width  / 2, y: UIScreen.main.bounds.size.height / 2)
        myActivityIndicator1.hidesWhenStopped = true;
        geturl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.leftBarButtonItem = self.createBackButton()
    }
    
    func geturl() {
        let totalAmount = cart.getTotalWithShipping()
        var url = Config.Instance.getURl().replacingOccurrences(of: "mofluid119", with: "payment2checkout")
        url = url + "paymentdata=" + createPaymentData(totalAmount)!
        loadPageWithUrl(url)
    }
    
    fileprivate func createBackButton()->UIBarButtonItem{
        let backButtonButtonItem = UIBarButtonItem()
        self.backButton = Utils.createBackButton()
        
        backButton.addTarget(self, action: #selector(eventOnBackBtn), for: .touchUpInside)
        backButtonButtonItem.customView = backButton
        
        return backButtonButtonItem
    }
    
    func createPaymentData(_ amount:Double) ->String? {
        var dataDict:[String:AnyObject]  = [:]
        // dataDict["userid"] = Utils.intToString(customerId)
        dataDict["orderid"] = Utils.stringToInt(self.orderId!) as AnyObject
        dataDict["amount"] = "\(amount)" as AnyObject?
        dataDict["OS"] = "iOS" as AnyObject?
        return Encoder.encodeBase64(dataDict as NSDictionary)
    }
    
    func userAddressData() -> Address? {
        if Config.guestCheckIn{
            if let userAddress = UserInfo.guestBillAddress != nil ? UserInfo.guestBillAddress : UserInfo.guestShipAddress {
                return userAddress
            }
            
        }else {
            if let userInfo = UserManager.Instance.getUserInfo(),let userAddress = userInfo.billAddress != nil ? userInfo.billAddress : userInfo.shipAddress {
                return userAddress
            }
        }
        
        return nil
    }
    
    fileprivate func showAlert(_ alertTxt:String) {
        Utils.showAlert(alertTxt)
    }
    
    func loadPageWithUrl(_ url:String) {
        self.addloader()
        if let nsURL = URL(string: url) {
            let requestObj = URLRequest(url:nsURL)
            webviewInstance.scalesPageToFit = true
            webviewInstance.contentMode = .scaleAspectFit
            webviewInstance.loadRequest(requestObj)
        }
        
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        self.removeLoader()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.removeLoader()
    }
    
    internal func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        let urlStr = request.url?.absoluteString
        if urlStr?.range(of: "payment2checkout/index/success") != nil {
            callDelegate_forplace_order("success")
            return false
        }
        
        return true
        
    }
    
    func callDelegate_forplace_order(_ paymentStatus:String) {
        placeOrderWithCCAvnue(paymentStatus, orderId: self.orderId!, status: self.status!, paymentMethod: self.paymentMethod!)
        
    }
    
    func placeOrderWithCCAvnue(_ paymentStatus:String,orderId:String,status:Bool,paymentMethod:String) {
        if self.check_transaction(paymentStatus) {
            self.processStatus(status, orderId: orderId, paymentMethod: paymentMethod)
        }
        
    }
    
    func processStatus(_ status: Bool, orderId: String?, paymentMethod : String?) {
        if status && orderId != nil{
            download_link_list = [:]
            let inVoiceObject = UIStoryboard(name: "Main",bundle: Bundle.main).instantiateViewController(withIdentifier: "inVoiceViewController") as? inVoiceViewController
            inVoiceObject!.orderID = orderId
            self.cart.clear()
            self.navigationController?.pushViewController(inVoiceObject!, animated: true)
            reloadBadgeNumber()
        }else{
            ErrorHandler.Instance.showError(Constants.FailedPlaceOrder)
        }
    }
    
    func reloadBadgeNumber(){
        self.updateCartButton()
        
    }
    
    func updateCartButton(){
        let tabArray = self.tabBarController?.tabBar.items as NSArray?
        let tabItem = tabArray?.object(at: 3) as! UITabBarItem
        Utils.setCartLabel(tabItem)
    }
    
    
    func check_transaction(_ transactionId:String) ->Bool {
        if transactionId != "success" {
            self.navigationController?.popViewController(animated: true)
            Utils.showAlert("Transaction Failed, Please try again")
            return false
        }
        
        return true
    }
    
    fileprivate func addloader(){
        self.loaderCount += 1
        if self.loaderCount == 1 {
            self.view.addSubview(myActivityIndicator1)
            self.view.isUserInteractionEnabled=false
            myActivityIndicator1.startAnimating()
        }
    }
    
    fileprivate func removeLoader(){
        if loaderCount > 0 {self.loaderCount -= 1}
        if self.loaderCount == 0{
            self.view.isUserInteractionEnabled=true
            myActivityIndicator1.stopAnimating()
        }
    }
    
    @objc func eventOnBackBtn() {
        DispatchQueue.main.async(execute: { [unowned self] in
            self.navigationController?.popViewController(animated: true)
            })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

