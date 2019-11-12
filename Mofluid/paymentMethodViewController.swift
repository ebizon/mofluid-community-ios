import UIKit
import Foundation
import PassKit
import StoreKit
import Toast

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
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}


class paymentMethodViewController: PageViewController, UITableViewDataSource,UITableViewDelegate, PayPalPaymentDelegate,PKPaymentAuthorizationViewControllerDelegate{
    var paymentMethodAccountKey = ""
    var paymentMethodAccountId = ""
    var cart = ShoppingCart.Instance
    var dropDownTableView = UITableView()
    var dropDownButtonTagValue = 0
    var paymentMethodList = [PaymentMethod]()
    var customdropDownGestureView = UIButton()
    var dropDownBooleanValue = 1
    var modeOfPayment = ""
    let paypalLabel = UILabel()
    var titleParentView = UIView()
    var paymentInfoDropDownButton = UIButton()
    var paymentmethodArray=NSArray()
    var paymentCode:String? = nil
    var webview=UIWebView()
    var phoneNumber=UITextField()
    let continueButton = ZFRippleButton()
    var environment:String = PayPalEnvironmentSandbox{//PayPalEnvironmentNoNetwork {
        willSet(newEnvironment) {
            if (newEnvironment != environment) {
                PayPalMobile.preconnect(withEnvironment: newEnvironment)
            }
        }
    }
    
    var payPalConfig = PayPalConfiguration() // default
    var payPalConfirmation : NSDictionary? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Payment Method".localized().uppercased()
        dropDownTableView.delegate =   self
        dropDownTableView.dataSource =   self
        dropDownTableView.register(UITableViewCell.self, forCellReuseIdentifier: "DropDownCell")
        dropDownTableView.frame = CGRect(x: 15, y: 0, width: mainParentScrollView.frame.size.width - 30, height: 0)
        dropDownTableView.separatorStyle = .none
        dropDownTableView.backgroundColor = UIColor(red: (144/255.0), green: (144/255.0), blue: (144/255.0), alpha: 1.0)
        mainParentScrollView.addSubview(dropDownTableView)
        
        self.loadPaymentMethods()
        
        payPalConfig.acceptCreditCards = true;
        payPalConfig.merchantName = Config.DefaultAppName
        payPalConfig.merchantPrivacyPolicyURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")
        payPalConfig.merchantUserAgreementURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")
        payPalConfig.languageOrLocale = Locale.preferredLanguages[0]
        payPalConfig.payPalShippingAddressOption = .payPal;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        customdropDownGestureView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        customdropDownGestureView.backgroundColor = UIColor.clear
        customdropDownGestureView.addTarget(self, action: #selector(paymentMethodViewController.dropDownGesturebuttonAction), for: .touchUpInside)
        
        //        if(deviceName == "big"){
        //            UILabel.appearance().font = UIFont(name: "Lato", size: 20)
        //        }else{
        //            UILabel.appearance().font = UIFont(name: "Lato", size: 15)
        //        }
        
        environment = PayPalEnvironmentSandbox
        PayPalMobile.preconnect(withEnvironment: environment)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "OptionViewTap"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "selectOptionViewOption"), object: nil)
        
    }
    
    func loadPaymentMethods(){
        self.addLoader()
        let url = WebApiManager.Instance.getCheckOutAndPaymentMethodsURL()
        Utils.fillTheData(url, callback: self.processData, errorCallback : self.showError)
    }
    
    func processData(_ dataDict : NSDictionary){
        defer{self.removeLoader()}
        
        if let paymentMethods = dataDict["payment_methods"] as? NSArray{
            
            paymentmethodArray=paymentMethods
            for item in paymentMethods{
                if let itemDict = item as? NSDictionary{
                    if let code = itemDict["code"] as? String, let title = itemDict["title"] as? String{
                        let peymentMethod = PaymentMethod(code : code, title: title)
                        self.paymentMethodList.append(peymentMethod)
                        
                    }
                }
            }
        }
        else {
            
            alert("No Payment method available".localized())
        }
        
        self.createButtons()
    }
    
    func createButtons(){
        
        paymentInfoDropDownButton.frame = CGRect(x: 15, y: titleParentView.frame.origin.y + titleParentView.frame.height + 30, width: mainParentScrollView.frame.width - 30, height: 38)
        paymentInfoDropDownButton.setTitle("Select Payment".localized(), for: UIControl.State())
        paymentInfoDropDownButton.setTitleColor(UIColor.white, for: UIControl.State())
        paymentInfoDropDownButton.backgroundColor = UIColor(red: (144/255.0), green: (144/255.0), blue: (144/255.0), alpha: 1.0)
        paymentInfoDropDownButton.layer.cornerRadius = 2
        paymentInfoDropDownButton.addTarget(self, action: #selector(paymentMethodViewController.allDropDownButtonAction(_:)), for: UIControl.Event.touchUpInside)
        let Imgright = UIImage(named: "arrow-down-white.png")
        paymentInfoDropDownButton.setImage(Imgright, for: UIControl.State())
        paymentInfoDropDownButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
        paymentInfoDropDownButton.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        paymentInfoDropDownButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: paymentInfoDropDownButton.frame.size.width - (Imgright!.size.width)-10 , bottom: 0, right: 0)
        paymentInfoDropDownButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: (Imgright!.size.width)+10)
        paymentInfoDropDownButton.tag = 1
        mainParentScrollView.addSubview(paymentInfoDropDownButton)
        webview.frame   =   CGRect(x: paymentInfoDropDownButton.frame.origin.x, y: paymentInfoDropDownButton.frame.origin.y + paymentInfoDropDownButton.frame.size.height + 60, width: paymentInfoDropDownButton.frame.width , height: 350)
        webview.scrollView.isScrollEnabled=true
        webview.isHidden=true
        phoneNumber.frame=CGRect(x: paymentInfoDropDownButton.frame.origin.x, y: webview.frame.origin.y-50, width: paymentInfoDropDownButton.frame.width , height: 40)
        phoneNumber.borderStyle =  .line
        phoneNumber.textAlignment = .center
        phoneNumber.keyboardType = .phonePad
        phoneNumber.placeholder="Enter your mobile number"
        phoneNumber.isHidden=true
        paypalLabel.frame = CGRect(x: paymentInfoDropDownButton.frame.origin.x, y: paymentInfoDropDownButton.frame.origin.y + paymentInfoDropDownButton.frame.size.height + 15, width: paymentInfoDropDownButton.frame.width , height: 100)
        paypalLabel.numberOfLines   =   5
        paypalLabel.text = ""
        paypalLabel.isHidden =  true
        
        continueButton.frame = CGRect(x: paymentInfoDropDownButton.frame.origin.x, y: paymentInfoDropDownButton.frame.origin.y + paymentInfoDropDownButton.frame.size.height + 15, width: paymentInfoDropDownButton.frame.width , height: 38)
        if(UserDefaults.standard.bool(forKey: "isLogin")){
            continueButton.addTarget(self, action: #selector(paymentMethodViewController.continueButtonAction1(_:)), for: UIControl.Event.touchUpInside) //*pc*
        }
        else
        {
            continueButton.addTarget(self, action: #selector(paymentMethodViewController.continueButtonAction1(_:)), for: UIControl.Event.touchUpInside)
        }
        continueButton.backgroundColor = Settings().getButtonBgColor()//UIColor(red: (223/255.0), green: (114/255.0), blue: (114/255.0), alpha: 1.0)
        continueButton.layer.cornerRadius = 3.0
        continueButton.setTitle("Submit".localized(), for: UIControl.State())
        continueButton.titleLabel?.font = UIFont(name: "Lato-Bold", size: 20)
        continueButton.titleLabel?.textColor = UIColor(netHex:0xf78f1e)
        continueButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
        continueButton.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        mainParentScrollView.addSubview(continueButton)
        mainParentScrollView.addSubview(paypalLabel)
        mainParentScrollView.addSubview(webview)
        mainParentScrollView.addSubview(phoneNumber)
        mainParentScrollView.contentSize.height = continueButton.frame.origin.y + continueButton.frame.size.height + 100
    }
    
    @objc func allDropDownButtonAction(_ button:UIButton){
        dropDownButtonTagValue = button.tag
        var ypos:CGFloat = 0
        UIView.animate(withDuration: 0.2, animations: {
            self.paymentInfoDropDownButton.imageView!.transform = self.paymentInfoDropDownButton.imageView!.transform.rotated(by: 180 * CGFloat(Double.pi/180))
        }, completion: { _ in
        })
        ypos =  button.frame.origin.y + button.frame.size.height - 3
        
        if(dropDownBooleanValue == 0){
            customdropDownGestureView.removeFromSuperview()
            
            UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions(), animations: {
                self.dropDownTableView.frame.size.height = 0
            }, completion: { _ in
                self.dropDownTableView.isHidden = true
            })
            
            for allSubViews in self.view.subviews{
                allSubViews.isUserInteractionEnabled = true
            }
            
            navigationItem.titleView?.isUserInteractionEnabled = true
            backButton.isUserInteractionEnabled = true
            menuButton.isUserInteractionEnabled = true
            dropDownBooleanValue = 1
        }else{
            customdropDownGestureView.frame.size.height = mainParentScrollView.contentSize.height
            mainParentScrollView.addSubview(customdropDownGestureView)
            
            dropDownTableView.frame.size.width = button.frame.width
            dropDownTableView.frame.origin.x = button.frame.origin.x
            mainParentScrollView.addSubview(dropDownTableView)
            
            dropDownTableView.frame.origin.y = ypos
            UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions(), animations: {
                self.dropDownTableView.frame.size.height = CGFloat(self.paymentMethodList.count) * 40
                if(self.dropDownTableView.frame.size.height > 180){
                    self.dropDownTableView.frame.size.height = 180
                }
            }, completion: { _ in
                self.dropDownTableView.isHidden = false
            })
            
            dropDownTableView.reloadData()
            navigationItem.titleView?.isUserInteractionEnabled = false
            backButton.isUserInteractionEnabled = false
            menuButton.isUserInteractionEnabled = false
            dropDownBooleanValue = 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.paymentMethodList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DropDownCell", for: indexPath) as UITableViewCell
        
        let borderLabel = UILabel(frame: CGRect(x: 10, y: cell.frame.size.height - 1, width: cell.frame.size.width - 20, height: 1))
        borderLabel.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        let count = self.paymentMethodList.count
        
        if((count - 1) != indexPath.row){
            cell.addSubview(borderLabel)
        }
        
        cell.backgroundColor = UIColor(red: (144/255.0), green: (144/255.0), blue: (144/255.0), alpha: 1.0)
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.text = self.paymentMethodList[indexPath.row].title
        cell.textLabel?.textAlignment = .center;
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        paymentInfoDropDownButton.setTitle(self.paymentMethodList[indexPath.row].title, for: UIControl.State())
        paymentCode = self.paymentMethodList[indexPath.row].code
        
        // paymentMethodAccountKey = self.paymentMethodList[indexPath.row].payment_method_account_key
        // paymentMethodAccountId =  self.paymentMethodList[indexPath.row].payment_method_account_id
        //modeOfPayment = self.paymentMethodList[indexPath.row].payment_method_mod
        
        if let url=(paymentmethodArray.object(at: indexPath.row) as? NSDictionary)?.value(forKey: "description") as? String{
            
            webview.loadHTMLString(url, baseURL: nil)
            webview.isHidden=false
            if self.paymentMethodList[indexPath.row].title == "M-PESA" || self.paymentMethodList[indexPath.row].title == "SELCOM PAY"{
                
                phoneNumber.isHidden=false
            }
            else
            {
                phoneNumber.isHidden=true
            }
            continueButton.frame = CGRect(x: paymentInfoDropDownButton.frame.origin.x, y: webview.frame.size.height+150, width: paymentInfoDropDownButton.frame.width , height: 38)
            
        }
        else{
            
            webview.isHidden=true
            phoneNumber.isHidden=true
            continueButton.frame = CGRect(x: paymentInfoDropDownButton.frame.origin.x, y: paymentInfoDropDownButton.frame.origin.y + paymentInfoDropDownButton.frame.size.height + 15, width: paymentInfoDropDownButton.frame.width , height: 38)
        }
        self.cart.paymentMethod = self.paymentMethodList[indexPath.row]
        
        dropDownGesturebuttonAction()
    }
    
    @objc func dropDownGesturebuttonAction(){
        dropDownBooleanValue = 0
        let btn = UIButton()
        btn.tag = dropDownButtonTagValue
        allDropDownButtonAction(btn)
    }
    
    func applePay() {
        let request = PKPaymentRequest()
        let paymentNetworks = [PKPaymentNetwork.amex, PKPaymentNetwork.masterCard, PKPaymentNetwork.visa]
        if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: paymentNetworks) {
            request.supportedNetworks = [PKPaymentNetwork.amex, PKPaymentNetwork.masterCard, PKPaymentNetwork.visa]
            request.countryCode = Config.Instance.getCountryCode()
            request.currencyCode = Config.Instance.getCurrencyCode()
            request.merchantIdentifier = Config.Instance.getApplePayMerchantID()
            request.merchantCapabilities = .capability3DS
            request.paymentSummaryItems = getPayments()
            
            let shippingMethods : [PKShippingMethod] = []
            request.shippingMethods = shippingMethods
            
            let viewController = PKPaymentAuthorizationViewController(paymentRequest: request)
            viewController?.delegate = self
            present(viewController!, animated: true, completion: nil)
        }
    }
    
    @available(iOS 8.0, *)
    func getPayments() -> [PKPaymentSummaryItem] {
        let cart = self.cart
        let totalAmount = NSDecimalNumber(value: cart.getTotalWithShipping() as Double)
        let total = PKPaymentSummaryItem(label: Config.DefaultAppName, amount: totalAmount)
        
        return [total]
    }
    
    @available(iOS 8.0, *)
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didSelect shippingMethod: PKShippingMethod, completion: @escaping (PKPaymentAuthorizationStatus, [PKPaymentSummaryItem]) -> Void) {
        completion(PKPaymentAuthorizationStatus.success, getPayments())
    }
    
    @available(iOS 8.0, *)
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        completion(PKPaymentAuthorizationStatus.success)
    }
    
    @available(iOS 8.0, *)
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        print("Did finish")
        controller.dismiss(animated: true , completion: nil)
        self.placeOrder()
    }
    
    
    func continueButtonAction(_ button:UIButton){
        if(paymentCode != nil){
            loadCartData()
        }
        else{
            alert("Select Payment Method".localized())
        }
    }
    @objc func continueButtonAction1(_ button:UIButton){
        //************PC****************
        
        //******************************
        // self.loadAnonymousQuantity()
        if phoneNumber.isHidden{
            
            finalPaymentCall()
        }
        else{
            
            if phoneNumber.text?.count==0{
                
                Helper().showAlert(self, message: "Please enter your contact number!")
            }
            else{
                
                finalPaymentCall()
            }
        }
    }
    func finalPaymentCall(){
        if(paymentCode != nil){
            self.moveToCheckoutPage1()
        }
        else{
            alert("Select Payment Method".localized())
        }
    }
    func loadAnonymousQuantity()
    {
        var url = WebApiManager.Instance.getProductStockURL()
        
        url =  url! + "&product_id="
        let cart = ShoppingCart.Instance
        for (item , _) in cart
        {
            url = url! + String(item.id) + ","
        }
        url = String(url!.dropLast())
        Utils.fillTheDataFromArray(url, callback: self.processProductStock, errorCallback: self.showError)
    }
    
    func processProductStock(_ dataArray : NSArray){
        defer{self.removeLoader()}
        
        for item in dataArray{
            let dictData = item as! NSDictionary
            let productId = dictData["Product id"] as! String
            let quantity = dictData["Quantity"] as! String
            let item = ShoppingCart.Instance.findItemByHash(Int(productId)!)
            let qty = Double(quantity)
            item?.totalNoInStock = Int(qty!)
            let shoppingCart = ShoppingCart.Instance
            let oldCount = shoppingCart.getCount(item!)
            if(oldCount > item?.totalNoInStock)
            {
                item!.setnumFromStock(Int(qty!))
                ShoppingCart.Instance.addItem(item!, num: Int(qty!))
            }
        }
        
        self.moveToCheckoutPage()
    }
    
    func loadCartData(){
        let url = WebApiManager.Instance.getCartListUrl()
        self.addLoader()
        Utils.fillTheData(url, callback: self.processCartData, errorCallback : self.showError)
    }
    
    fileprivate func processCartData(_ dataDict: NSDictionary){
        
        self.view.isUserInteractionEnabled = true
        
        DispatchQueue.main.async {
            if let products_list = dataDict["data"] as? NSArray{
                
                ShoppingCart.Instance.clear()
                for  item in products_list {
                    let myItem = item as! NSDictionary
                    let quantityInCart = myItem["quantity"] as! Int
                    if let shoppingItem = StoreManager.Instance.createShoppingAccessoryForCartList(myItem){
                        shoppingItem.setnumFromStock(quantityInCart)
                        ShoppingCart.Instance.addItem(shoppingItem, num: quantityInCart)
                        
                    }
                }
                
                
            }
            self.moveToCheckoutPage()
            do{self.removeLoader()}
        }
    }
    
    //*********************PC****************
    func moveToCheckoutPage1(){
        if(paymentCode == "paypal"){
            payPalMethodCall()
        }else if(paymentCode == "apple"){
            self.applePay()
        }else if (paymentCode == "ccavenue"){
            self.placeOrder()
        }
        else{
            self.placeOrder()
        }
    }
   
    //***************************************
    func moveToCheckoutPage(){
        if Utils.isMoveFromCartItem(){
            if(paymentCode == "paypal"){
                payPalMethodCall()
            }else if(paymentCode == "apple"){
                self.applePay()
            }else{
                self.placeOrder()
            }
        }else{
            let refreshAlert = UIAlertController(title: "Alert!", message: "Some product in your cart is out of stock or requested quantity not available.\nPlease refresh your cart.", preferredStyle: UIAlertController.Style.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Go To Cart".localized(), style: .default, handler: { (action: UIAlertAction!) in
                self.moveToCartViewController()
                
            }))
            present(refreshAlert, animated: true, completion: nil)
            self.view.makeToast("Please update required product of cart.")
        }
        
    }
    
    fileprivate func moveToCartViewController(){
        
        if let arrController = self.navigationController?.viewControllers{
            for view in arrController{
                if view.isKind(of: cartViewController.self){
                    let objCart = view as! cartViewController
                    self.navigationController?.popToViewController(objCart, animated: true)
                    break
                }
            }
        }
    }
    
    func placeOrder(){
        self.addLoader()
        
        var url = WebApiManager.Instance.getCombinedPlaceOrderURL(self.cart)
        if phoneNumber.isHidden==false{
            
            url=url!+"&mob=\(phoneNumber.text ?? "")"
        }
        Utils.fillTheData(url, callback: self.processPlaceOrder, errorCallback : self.showError)
    }
    
    fileprivate func processPlaceOrder(_ dataDict : NSDictionary){
        defer{self.removeLoader()}
        let orderId = dataDict["orderId"] as? String
        self.processStatus(true, orderId: orderId, paymentMethod: ShoppingCart.Instance.paymentMethod?.code)
    }
    
    //****************PC*********Change for CCavenue***
    
    fileprivate func processStatus(_ status: Bool, orderId: String?, paymentMethod : String?){
        if status && orderId != nil{
            
            if (paymentCode == "tco"){
                self.openCCAvenuePaymentView(orderId!,status:status,paymentMethod:paymentMethod ?? "")
                
            }else{
                download_link_list = [:]
                self.cartCountLabel.removeFromSuperview()
                let inVoiceObject = self.storyboard?.instantiateViewController(withIdentifier: "inVoiceViewController") as? inVoiceViewController
                inVoiceObject!.orderID = orderId
                
                if paymentMethod == "cashondelivery"{
                    inVoiceObject!.amountToPay = Utils.appendWithCurrencySym(self.cart.getTotalWithShipping())
                }else if paymentMethod == "paypal_standard"{
                    inVoiceObject!.payPalPayment = self.payPalConfirmation
                }
                self.cart.clear()
                self.navigationController?.pushViewController(inVoiceObject!, animated: true)
            }
        }else{
            ErrorHandler.Instance.showError(Constants.FailedPlaceOrder)
        }
    }
    
    
    //**************************************
    func backButtonFunction(){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  PayPal  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    func payPalMethodCall(){
        var payPalLiveId = ""
        var payPalSandboxId = ""
        if modeOfPayment == "0"
        {
            environment = PayPalEnvironmentSandbox
            payPalSandboxId = paymentMethodAccountKey
        }else{
            environment = PayPalEnvironmentProduction
            payPalLiveId = paymentMethodAccountKey
        }
        PayPalMobile.preconnect(withEnvironment: environment)
        PayPalMobile.initializeWithClientIds(forEnvironments: [PayPalEnvironmentProduction: payPalLiveId, PayPalEnvironmentSandbox: payPalSandboxId])
        
        let cart = self.cart
        let total = NSDecimalNumber(value: cart.getTotalWithShipping() as Double)
        let currencyCode =  Config.Instance.getCurrencyCode()
        let payment = PayPalPayment(amount: total, currencyCode: currencyCode, shortDescription: Config.DefaultAppName, intent: .sale)
        
        if (payment.processable) {
            let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
            present(paymentViewController!, animated: true, completion: nil)
        }else {
            // This particular payment will always be processable. If, for
            // example, the amount was negative or the shortDescription was
            // empty, this payment wouldn't be processable, and you'd want
            // to handle that here.
            ErrorHandler.Instance.showError()
        }
    }
    
    
    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
        paymentViewController.dismiss(animated: true, completion: nil)
    }
    
    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
        paymentViewController.dismiss(animated: true, completion: { () -> Void in
            self.payPalConfirmation = completedPayment.confirmation["response"] as? NSDictionary
            self.placeOrder()
        })
    }
    
}

//***********************PC************Push on CCAnvaue ViewController**

extension paymentMethodViewController {
    func openCCAvenuePaymentView(_ orderID:String,status:Bool,paymentMethod:String) {
        let viewController = PayemetWebViewController(nibName:"PayemetWebViewController",bundle: Bundle.main)
        debugPrint("orderID = \(orderID) &status = \(status) & paymentMethod =\(paymentMethod)")
        viewController.orderId = orderID
        viewController.status = status
        viewController.paymentMethod = paymentMethod
        DispatchQueue.main.async(execute: { [unowned self] in
            self.navigationController?.pushViewController(viewController, animated: true)
            
        })
    }
}
//**************************
