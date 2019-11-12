//
//  HomeVC.swift
//  Mofluid
//
//  Created by Saurabh Mishra on 26/06/18.
//  Copyright © 2018 Mofluid. All rights reserved.
//

import UIKit
import FSPagerView

class HomeVC: BaseViewController,GIDSignInDelegate,GIDSignInUIDelegate {

    @IBOutlet var bannerView: UIView!
    @IBOutlet var tableView: UITableView!
    var featureProducts         =   [ShoppingItem]()
    var newProducts             =   [ShoppingItem]()
    var bestSeller              =   [ShoppingItem]()
    var bannerUrls: [String]    =   []
    let reuseIdentifier         =   "ProductTableViewCell"
    var productList             =   [FinalProduct]()
    // Offset to Create parallax Effect
    var imageOffset             :   CGPoint!
    let SectionHeaderHeight: CGFloat = 30
    @IBOutlet weak var pagerView: FSPagerView! {
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.pagerView.transformer = FSPagerViewTransformer(type: FSPagerViewTransformerType.overlap)
            //let transform = CGAffineTransform(scaleX: 0.7, y: 0.9)
            //self.pagerView.itemSize = .zero//
            //self.pagerView.frame.size.applying(transform)
            self.pagerView.automaticSlidingInterval =  5.0
        }
    }
    
    @IBOutlet weak var pageControl: FSPageControl! {
        didSet {
            self.pageControl.currentPage = 0
            self.pageControl.numberOfPages = bannerUrls.count
            self.pageControl.contentHorizontalAlignment = .center
            self.pageControl.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialUi()
        setDataInUi()
        callApi()
        loadLogin()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.methodOfReceivedNotification(_:)), name: NSNotification.Name(rawValue: "selectOptionViewOption"), object: nil)
        UILabel.appearance().font = UIFont(name: "Lato", size: 15)
        self.navigationController?.setNavigationBarHidden(false, animated:false)
        self.setNotification()
    }
    //MARK:- INIT UI
    func setInitialUi(){
        
        searchParentView.removeFromSuperview()
        mainParentScrollView.removeFromSuperview()
        mainParentView.removeFromSuperview()
        pagerView.delegate = self
        pagerView.dataSource = self
        self.createRightBar()
        self.createTitle()
        self.createHeader()
        tableView.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductTableViewCell")
        tableView.estimatedRowHeight = UITableView.automaticDimension
        //tableView.contentInset  = UIEdgeInsets(top: self.view.frame.width/2, left: 0, bottom: 0, right: 0)
    }
    //MARK:- Custom Methods
    func setNotification(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.push(_:)), name: NSNotification.Name(rawValue: "isPushed"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeVC.rootView(_:)), name: NSNotification.Name(rawValue: "popToRoot"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeVC.swicthHome(_:)),name:NSNotification.Name(rawValue: "switchToHomeView"), object: nil)
    }
    func setDataInUi(){
        
        showStoreDetails()
        //fetchProductsSection()
    }
    @objc func rootView(_ notification: Notification){
        self.navigationController?.popToRootViewController(animated: false)
    }
    
    @objc func swicthHome(_ notification: Notification){
        self.navigationController?.popToRootViewController(animated: false)
    }
    func showStoreDetails(){
        
        let storeDetail = StoreManager.Instance.storeDetail
        if storeDetail.logo == nil{
            let url = WebApiManager.Instance.getStoreDetailURL()
            self.fetchStoreDetails(url!)
        }else{
            self.viewStoreDetails()
        }
    }
    func viewStoreDetails(){
    
        self.setTitle()
        self.processBanners()
    }
    fileprivate func setTitle(){

        let titleButton = Utils.createTitileButton(StoreManager.Instance.storeDetail.logo)
        self.navigationItem.titleView = titleButton
        titleButton.isUserInteractionEnabled = false
    }
    fileprivate func processBanners(){
        
        if StoreManager.Instance.storeDetail.banners.count>0{
            
            bannerUrls = StoreManager.Instance.storeDetail.banners
            self.pageControl.numberOfPages = bannerUrls.count
            pagerView.reloadData()
        }
    }
    //MARK:- Api Methods
    func fetchStoreDetails(_ url:String){
        
        HomeVM().callForStoreDetails(url) { (status,response) in
            
            if status{
                //parse data
                HomeVM().populateStoreDetails((response as? NSDictionary)!)
                self.viewStoreDetails()
                self.fetchProductsSection()
            }
            else{
                
            }
        }
    }
    func callApi(){
        
        
    }
    func fetchProductsSection(){
        
        Helper().addLoader(self)
        HomeVM().callForProducts { (status,response) in
            
            self.productList = (response as? [FinalProduct])!
            self.tableView.reloadData()
            Helper().removeLoader()
        }
    }
    //MARK:- Load UserInformation
    func loadLogin(){
        if UserManager.Instance.getUserInfo() == nil {
            if let dict = NSKeyedUnarchiver.unarchiveObject(withFile: UserInfo.ArchiveURL!.path) as? [String : String]{
                if let loginType = dict["logintype"]{
                    if let loginValue = LoginType(rawValue: loginType){
                        self.login(loginValue, loginDict: dict)
                    }
                }
            }
        }else{
            if(UserDefaults.standard.bool(forKey: "isLogin")){
                WishListRequestHandler().getAllProductsForWishList()
            }
        }
    }
    
    func login(_ loginType: LoginType, loginDict : [String : String]){
        if loginType == LoginType.Mofluid{
            self.loginWithMofluid(loginDict)
        }else if loginType == LoginType.FacebookLogin{
            self.loginWithFacebook()
        }else if loginType == LoginType.GooglePlus{
            assert(loginType == LoginType.GooglePlus)
            
            self.loginWithGooglePlus()
        }
    }
    func loginWithGooglePlus(){
        
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        GIDSignIn.sharedInstance().clientID = Config.Instance.getGoogleClientID()
        
        GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/plus.login")
        
        GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/plus.me")
        
        GIDSignIn.sharedInstance().delegate = self
        
        GIDSignIn.sharedInstance().signInSilently()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            let googleLogin = GooglePlusLogin()
            googleLogin.googlePlusData(user)
            if(UserDefaults.standard.bool(forKey: "isLogin")){
                WishListRequestHandler().getAllProductsForWishList()
            }
        }else {
            
            UserDefaults.standard.set(false, forKey: "isLogin")
        }
    }
    func loginWithMofluid(_ loginDict : [String : String]){
        if let email = loginDict["email"]{
            if let passwd = loginDict["password"]{
                if let url = WebApiManager.Instance.getLoginAccessURL(){
                    let serviceURL = url + "&username=" + email + "&password=" + passwd
                    Utils.fillTheData(serviceURL, callback: self.createUserInfo, errorCallback : self.showError)
                }
            }
        }
    }
    
    func loginWithFacebook(){
        FbLoginManager().faceBookUserData()
    }
    
    func createUserInfo(_ dataDict : NSDictionary){
        
        let _ = UserInfo.createUserInfo(dataDict, loginType : LoginType.Mofluid)
        if(UserDefaults.standard.bool(forKey: "isLogin")){
            WishListRequestHandler().getAllProductsForWishList()
        }
    }
    
    ///////////////////////////////////
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

