//
//  ProfileViewController.swift
//  Daily Jocks
//
//  Created by MANISH on 27/05/16.
//  Copyright © 2016 Mofluid. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ProfileViewController: BaseViewController , UITableViewDelegate , UITableViewDataSource, OrdersOrTimeLineTableViewCellDelegate, OrderTableViewCellDelegate , SubOrderTableViewCellDelegate{
    var currentOrder : OrderData? = nil
    
    @IBOutlet var mainView: UIView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var orderList = [OrderData]()
    var userProfileCell : userProfileTableViewCell?
    
    @IBOutlet weak var userProfileTableView: UITableView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        mainParentScrollView.addSubview(self.mainView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        uiSetUp()
        
        loadOrders()
        
        self.userProfileTableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func uiSetUp(){
        self.navigationItem.title = "USER PROFILE".localized()
        if idForSelectedLangauge == Utils.getArebicLanguageCode() {
            let userProfileNib  = UINib(nibName: "userProfileTableViewCell_RTL", bundle: Bundle.main)
            userProfileTableView.register(userProfileNib, forCellReuseIdentifier: "USER_PROFILE")
            
            let myOrderNib  = UINib(nibName: "myOrderTableViewCell_RTL", bundle: Bundle.main)
            userProfileTableView.register(myOrderNib, forCellReuseIdentifier: "MY_ORDER_CELL")
        }else{
            let userProfileNib  = UINib(nibName: "userProfileTableViewCell", bundle: Bundle.main)
            userProfileTableView.register(userProfileNib, forCellReuseIdentifier: "USER_PROFILE")
            
            let myOrderNib  = UINib(nibName: "myOrderTableViewCell", bundle: Bundle.main)
            userProfileTableView.register(myOrderNib, forCellReuseIdentifier: "MY_ORDER_CELL")
            
        }
        
        let orderOrTimelineNib  = UINib(nibName: "OrdersOrTimeLineTableViewCell", bundle: Bundle.main)
        userProfileTableView.register(orderOrTimelineNib, forCellReuseIdentifier: "ORDER_OR_TIMELINE")
        
        let seeMoreNib  = UINib(nibName: "SeeMoreTableViewCell", bundle: Bundle.main)
        userProfileTableView.register(seeMoreNib, forCellReuseIdentifier: "SeeMoreTableViewCell")
        
    }
    
    func loadOrders(){
        self.addLoader()
        let url = WebApiManager.Instance.getMyOrderURL()
        Utils.fillTheData(url, callback: self.processOrders, errorCallback : self.showError)
    }
    
    func parseAddress(dict : NSDictionary) -> Address?{
        var address: Address?
        if let id = dict["entity_id"] as? Int{
            let city = dict["city"] as! String
            let countryId = dict["country_id"] as! String
            let firstName = dict["firstname"] as! String
            let lastName = dict["lastname"] as! String
            let postCode = dict["postcode"] as! String
            let region = dict["region"] as! String
            let region_code = dict["region_code"] as! String
            let street = dict["street"]  as! [String]
            var phone=""
            if let telePhone=dict["telephone"] as? String{
                
                phone = telePhone
            }
            
           // let telePhone = dict["telephone"] as! String
            let addressRegion = AddressRegion(id: 0, code: region_code, name: region)
            address = Address(id: id, firstName: firstName, lastName: lastName, telePhone: phone, street: street, city: city, regionId: 0, region: addressRegion, postCode: postCode, countryCode: countryId)
        }
        
        return address
    }
    
    func processOrders(_ dataDict: NSDictionary){
        self.removeLoader()
        self.orderList.removeAll()
        let dateFormatterGet = DateFormatter()
        if let data = dataDict["items"] as? NSArray{
            for item in data{
                if let itemDict = item as? NSDictionary{
                    dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let orderID = itemDict["entity_id"] as? Int
                    let orderDateString = itemDict["created_at"] as? String
                    let dateFromServer=dateFormatterGet.date(from: orderDateString!)
                    dateFormatterGet.dateFormat = "dd-MM-yyyy HH:mm:ss"
                    let orderDate = dateFormatterGet.string(from: dateFromServer!)
                    let orderStatus = itemDict["status"] as? String
                    if orderID != nil  && orderStatus != nil{
                        let orderData = OrderData(id: String(orderID!), date : orderDate, status: orderStatus!)
                        if let items = itemDict["items"] as? NSArray{
                            orderData.items = self.createOrderItems(items)
                        }
                        
                        if let extensionAttributes = itemDict["extension_attributes"] as? NSDictionary{
                            if let shippingAssignments = extensionAttributes["shipping_assignments"] as? NSArray{
                                if shippingAssignments.count > 0{
                                    if let ship = shippingAssignments.firstObject as? NSDictionary{
                                        if let shipping = ship["shipping"] as? NSDictionary{
                                            if let shippingAddress = shipping["address"] as? NSDictionary{
                                                orderData.shippingAddress = parseAddress(dict: shippingAddress)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        if let billingAddress = itemDict["billing_address"] as? NSDictionary{
                            orderData.billingAddress = parseAddress(dict: billingAddress)
                        }
                        if let payMethods = itemDict["payment"] as? NSDictionary{
                            if let payTitle = payMethods["method"] as? String{
                                orderData.paymentMethod = payTitle
                            }
                        }
                        if let shipAmount = itemDict["shipping_amount"] as? Int{
                            orderData.shippingAmount = String(shipAmount)
                        }
                        if let taxAmount = itemDict["tax_amount"] as? Double{
                            orderData.taxAmount = String(taxAmount)
                        }
                        if let grandTotal = itemDict["grand_total"] as? Double{
                            orderData.grandTotal = String(grandTotal)
                        }
                        if let shipMethod = itemDict["shipping_description"] as? String{
                            orderData.shipMethod = shipMethod
                        }
                        
                        if let couponUsed = itemDict["couponUsed"] as? Int{
                            if couponUsed == 1{
                                if let couponCode = itemDict["couponCode"] as? String{
                                    orderData.couponCode = couponCode
                                    
                                    if let discountAmount = itemDict["discount_amount"] as? Double{
                                        orderData.discountAmount = discountAmount
                                    }
                                }
                            }
                        }
                        
                        orderData.orderStatus = orderStatus!
                        self.orderList.append(orderData)
                    }
                }
            }
        }
        
        userProfileTableView.reloadData()
    }
    
    func createOrderItems(_ products : NSArray)->[OrderItem]{
        var orderItems = [OrderItem]()
        
        for item in products{
            if let productDict = item as? NSDictionary{
                let id = productDict["quote_item_id"] as! Int
                let name = productDict["name"] as! String
                let sku = productDict["sku"] as! String
                let image = productDict["thumbnail"] as! String
                let price = productDict["price"] as! Double
                let qty = productDict["qty_ordered"] as! Int
                
                let orderItem = OrderItem(id: id, name: name, image: image, quantity: qty, sku: sku, price: String(price))
                orderItems.append(orderItem)
            }
        }
        
        return orderItems
    }
    
    //MARK: - TableView protocols
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            switch indexPath.row {
                
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "USER_PROFILE", for: indexPath) as! userProfileTableViewCell
                cell.logOutButton.addTarget(self, action: #selector(self.logOutAct), for: .touchUpInside)
                cell.editButton.addTarget(self, action: #selector(self.navigateToEditProfile), for: .touchUpInside)
                cell.logOutButton.backgroundColor=Settings().getButtonBgColor()
                cell.changePasswordBtn.addTarget(self, action: #selector(ProfileViewController.changePasswordButtonAction(_:)), for: UIControl.Event.touchUpInside)
                
                self.userProfileCell = cell
                
                return cell
                
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ORDER_OR_TIMELINE", for: indexPath)
                    as! OrdersOrTimeLineTableViewCell
                cell.tableDelegate = self
                cell.myOrderButton.addTarget(self, action: #selector(self.clickedOnMyOrder), for: .touchUpInside)
                cell.timeLineButton.addTarget(self, action: #selector(self.clickedOnMyTimeLine), for: .touchUpInside)
                cell.delegate = self
                cell.setOrderList(self.orderList)
                
                return cell
            default :
                let cell = tableView.dequeueReusableCell(withIdentifier: "SeeMoreTableViewCell", for: indexPath)
                    as! SeeMoreTableViewCell
                cell.seeMoreBtnclicked.addTarget(self , action: #selector(self.clickedOnSeeMore) , for: .touchUpInside)
                if self.orderList.count > 3
                {
                    cell.seeMoreBtnclicked.isEnabled = true
                    cell.seeMoreBtnclicked.setTitle("See More >>", for: UIControl.State())
                    
                }
                else if self.orderList.count == 0
                {
                    cell.seeMoreBtnclicked.isEnabled = false
                    cell.seeMoreBtnclicked.setTitle("No orders placed", for: UIControl.State())
                }
                else
                {
                    cell.seeMoreBtnclicked.isEnabled = false
                    cell.seeMoreBtnclicked.setTitle("", for: UIControl.State())
                    
                }
                return cell
            }
            
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MY_ORDER_CELL", for: indexPath) as!myOrderTableViewCell
        return cell
    }
    @objc func changePasswordButtonAction(_ button:UIButton){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let changePwdObject = storyboard.instantiateViewController(withIdentifier: "changePasswordViewController") as? changePasswordViewController
        self.navigationController?.pushViewController(changePwdObject!, animated: true)
    }
    
    @objc func clickedOnSeeMore()
    {
        let myOrderView = NewMyOrderViewController(nibName: "NewMyOrderViewController", bundle: Bundle.main)
        
        myOrderView.orderList = self.orderList
        self.navigationController?.pushViewController(myOrderView, animated: false)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let footerView = UIView()
            footerView.backgroundColor = UIColor.white
            return footerView
        default:
            return nil
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0
        {
            switch indexPath.row {
            case 0:
                tableView.estimatedRowHeight = 68.0
                return  UITableView.automaticDimension
            case 1:
                var count = self.orderList.count
                if count > 3
                {
                    count = 3
                }
                return CGFloat((count * 140) + 38 ) // 38 is height of order and timeLine button , 5 is no of cells
            default:
                return 66.0
            }
        }
        return 200
        
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    //MARK: TableView Cell Helper Method
    @objc func clickedOnMyOrder()
    {
        print("clickedOnMyOrder")
    }
    @objc func clickedOnMyTimeLine()
    {
        print("clickedOnMyTimeLine")
    }
    @IBAction func logoutAction(_ sender: AnyObject) {
        logOutAct()
    }
    @objc func logOutAct()
    {
        Utils.deleteAllDataFromDB("Cart")
        ShoppingCart.Instance.clear()
        UserManager.Instance.setUserInfo(nil)
        UserDefaults.standard.set(false, forKey: "isLogin")
        UserDefaults.standard.set("0"
            , forKey: "StripeCustomerID")
        FBSDKLoginManager().logOut()
        NotificationCenter.default.post(name: Notification.Name(rawValue: "isLoggedOut"), object: nil)
        if self.navigationController!.viewControllers.count > 2
        {
            self.navigationController?.popToRootViewController(animated: true)
        }else{
            insertController()
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    func insertController()
    {
        var vcs = self.navigationController!.viewControllers
        let loginObject =  LoginVC(nibName:"LoginVC",bundle: nil)
        //let loginObject = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "loginViewController") as? loginViewController
        vcs.insert(loginObject, at: 0)
        self.navigationController!.viewControllers = vcs
    }
    
    @objc func navigateToEditProfile()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let editProfileObject = storyboard.instantiateViewController(withIdentifier: "editProfileViewController") as? editProfileViewController
        //     ankur comment
        if UserManager.Instance.getUserInfo() !=  nil{
            editProfileObject?.address = UserManager.Instance.getUserInfo()?.billAddress
        }
        
        editProfileObject?.addressType = .billing
        
        self.navigationController?.pushViewController(editProfileObject!, animated: true)
    }
    
    func callCancelFunc(){}
    func callViewDetailFunc(){}
    
    func Reorder(_ order : OrderData){
        self.currentOrder = order
        let url = self.currentOrder?.getReorderURL()
        print(url ?? "")
        self.addLoader()
        Utils.fillTheDataFromArray(url, callback: self.reorderData, errorCallback : self.showError)
        
    }
    
    func viewDetailsOrder(_ order : OrderData){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myOrderDetailObject = storyboard.instantiateViewController(withIdentifier: "orderDetailsViewController") as? orderDetailsViewController
        if myOrderDetailObject != nil{
            myOrderDetailObject?.orderData = order
            myOrderDetailObject!.orderList = self.orderList
            self.navigationController?.pushViewController(myOrderDetailObject!, animated: true)
        }
    }
    
    func reorderData(_ data: NSArray){
        defer{self.removeLoader()}
        
        if let orderData = self.currentOrder{
            for item in data{
                if let itemDict = item as? NSDictionary{
                    if let reOrderItem =  StoreManager.Instance.createReorderDataItems(itemDict){
                        let qty = orderData.getItemQuantity(reOrderItem.id)
                        if reOrderItem.inStock == false{
                            self.alert("Quantity is out of stock")
                            return
                        }
                        Utils.addItemInCartWithSync(reOrderItem, count: qty, isfromByNow: false, controller: self)
                    }
                }
            }
        }
        
        if UserManager.Instance.getUserInfo() != nil{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let cartView = storyboard.instantiateViewController(withIdentifier: "cartViewController") as? cartViewController
            self.navigationController?.pushViewController(cartView!, animated: true)
        }
    }
    
    func imageCreated(_ image : UIImage?){
        self.userProfileCell?.userProfilePic.contentMode = .scaleAspectFit
        self.userProfileCell?.userProfilePic.image = image
    }
}
