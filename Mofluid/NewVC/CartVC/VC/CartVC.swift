//
//  CartVC.swift
//  Mofluid
//
//  Created by Saurabh Mishra on 19/07/18.
//  Copyright © 2018 Mofluid. All rights reserved.
//

import UIKit
import Stripe
class CartVC: UIViewController {
    
    @IBOutlet weak var viewTotal            :   UIView!
    @IBOutlet weak var btnCheckout          :   UIButton!
    @IBOutlet weak var btnShop              :   UIButton!
    @IBOutlet weak var lblTotalPlaceholder  :   UILabel!
    @IBOutlet weak var tableView            :   UITableView!
    @IBOutlet weak var lblTotal             :   UILabel!
    var isRefresh                           =   false
    //
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(CartVC.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor            =   UIColor.black
        refreshControl.attributedTitle      =   NSAttributedString(string:Settings().refreshCart)
        return refreshControl
    }()
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        isRefresh    =  false
        setInitUi()
        loadCartData()
    }
    //MARK:-Custom Methods
    func setInitUi(){
        
        self.navigationController?.setNavigationBarHidden(false, animated:false)
        self.navigationItem.title           =   Settings().myCart
        self.navigationItem.hidesBackButton =   true
        viewTotal.layer.borderWidth         =   1.0
        viewTotal.layer.borderColor         =   UIColor.black.cgColor
        btnCheckout.backgroundColor         =   Settings().getButtonBgColor()
        lblTotalPlaceholder.font            =   Settings().latoBold
        lblTotal.font                       =   Settings().latoBold
        tableView.register(UINib(nibName: "CartCell" , bundle: nil)  , forCellReuseIdentifier: "CartCell")
        tableView.addSubview(refreshControl)
    }
    func loadCartData(){
        
        if Settings().isUserLoggedIn(){
            
            !isRefresh ? Helper().addLoader(self) :  print("")//do not show loader if user refreshing
            CartRequestHandler().getItemFromCart { (response,status) in
                
                self.reloadCart()
                !self.isRefresh ? Helper().removeLoader() : print("")//do not show loader if user refreshing
            }
        }
        else{
            
            self.reloadCart()
        }
    }
    func reloadCart(){
        if let _ = self.tabBarController{
            
            CartRequestHandler().cartUpdateBadge(self.tabBarController!)
        }
        ShoppingCart.Instance.getAllProducts().count > 0 ? tableView.reloadData() : showEmptyCartView()
        updateTotalAmount()
    }
    func updateTotalAmount(){
        
        lblTotal.text   =   Utils.appendWithCurrencySym(CartVM().getTotalCost())
    }
    func showEmptyCartView(){
        
        self.tableView.reloadData()
        let vc                      =    ShowEmptyCart(nibName: "ShowEmptyCart", bundle: nil)
        vc.delegate                 =    self
        vc.modalPresentationStyle   =    .overCurrentContext
        vc.view.backgroundColor     =    UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.tabBarController?.present(vc, animated: true, completion: {

        })
    }
    func navigateToDiscountVC(){
        
        let discountViewObject = self.storyboard?.instantiateViewController(withIdentifier: "discountViewController") as? discountViewController
        discountViewObject?.cart = ShoppingCart.Instance
        self.navigationController?.pushViewController(discountViewObject!, animated: true)
    }
    func navigateToBuyNow(){
        
        let checkoutObject = self.storyboard?.instantiateViewController(withIdentifier: "buyNowViewController") as? buyNowViewController
        self.navigationController?.pushViewController(checkoutObject!, animated: true)
    }
    func navigateToGuestCheckOut(){
        
        let checkoutObject = self.storyboard?.instantiateViewController(withIdentifier: "guestCheckOutViewController") as? guestCheckOutViewController
        self.navigationController?.pushViewController(checkoutObject!, animated: true)
    }
    func navigateToEditProfile(){
        
        let profileView = ProfileViewController(nibName: "ProfileViewController", bundle: Bundle.main)
        self.navigationController?.pushViewController(profileView, animated: false)
    }
    func emptyAddress(){
        
        Helper().showAlertWithCancel(self, message:Settings().addressMissing) { (item,title) in
            
            if title == Settings().ok{
                
                self.navigateToBuyNow()
            }
        }
    }
    func fetchAddress(){
        
        Helper().addLoader(self)
        CartVM().getUserAddress(completion: { (status) in
            
            Helper().removeLoader()
            if status{
                
                CartVM().checkUserAddress() ? self.navigateToDiscountVC() : self.navigateToGuestCheckOut()
            }
            else{
                
                self.emptyAddress()
            }
        })
    }
    //MARK:-IBACTION
    
    @IBAction func test(_ sender: Any) {
        
        let addCardViewController = STPAddCardViewController()
        addCardViewController.delegate = self
        navigationController?.pushViewController(addCardViewController, animated: true)
        //let add = ShippingAddressVC(nibName: "ShippingAddressVC", bundle: nil)
        //self.navigationController?.pushViewController(add, animated: true)
    }
    
    @IBAction func clickShop(_ sender: Any) {
        
        self.tabBarController?.selectedIndex    =   0
        let delegate                            =   UIApplication.shared.delegate as! AppDelegate
        delegate.tabSelectedIndex               =   0
        NotificationCenter.default.post(name: Notification.Name(rawValue: "popToRoot"), object: nil)
    }
    @IBAction func clickCheckout(_ sender: Any) {
        
        if Settings().isUserLoggedIn(){
            
            CartVM().checkUserAddress() ? navigateToDiscountVC() : fetchAddress()
        }
        else{
            navigateToGuestCheckOut()
        }
    }
    //MARK:- Refresh Handler
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        isRefresh   =   true
        self.loadCartData()
        refreshControl.endRefreshing()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension CartVC:STPAddCardViewControllerDelegate{
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
        StripeClient.shared.completeCharge(with: token, amount: 200) { result in
            switch result {
            // 1
            case .success:
                completion(nil)
                
                let alertController = UIAlertController(title: "Congrats", message: "Your payment was successful!", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self.navigationController?.popViewController(animated: true)
                })
                alertController.addAction(alertAction)
                self.present(alertController, animated: true)
            // 2
            case .failure(let error):
                completion(error)
            }
        }
    }
}
