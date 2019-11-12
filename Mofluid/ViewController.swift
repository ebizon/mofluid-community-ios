//
//  ViewController.swift
//  Mofluid
//  Created by sudeep goyal on 08/09/15.
//  Copyright © 2015 Mofluid. All rights reserved.

import UIKit
import FirebaseMessaging
import Foundation
import SloppySwiper
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


var deviceName = "big"
var cellHeight : CGFloat = CGFloat()
let screenSize = UIScreen.main.bounds
let deviceHeight = screenSize.height
let deviceWidth = screenSize.width
var menuImage = UIImage(named: "menu")
var moveToLogin = true
var isCurrencyChange=false

class ViewController: BaseViewController,GIDSignInDelegate,GIDSignInUIDelegate ,  UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    let bannerTimeInterval : TimeInterval = 10
    var pageViews: [UIImageView?] = []
    var bannerAnimationStatus = false
    var bannerParentView: UIView = UIView()
    
    var bannerScrollView: UIScrollView = UIScrollView()
    var bannerData : [[String]] = [[String]]()
    var pageControl: UIPageControl = UIPageControl()
    var bestSellerCollectionView : UICollectionView?
    var featureParentCollectionView : UICollectionView?
    var newParentCollectionView : UICollectionView?
    var products : [ProductsType : [ShoppingItem]] = [ProductsType: [ShoppingItem]]()
    
    var swiper = SloppySwiper()
    let kCellReuse = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.delegate = swiper
        
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.push(_:)), name: NSNotification.Name(rawValue: "isPushed"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.rootView(_:)), name: NSNotification.Name(rawValue: "popToRoot"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.swicthHome(_:)),name:NSNotification.Name(rawValue: "switchToHomeView"), object: nil)
        
        searchParentView.isHidden = true
        mainParentScrollView.frame = CGRect(x: 0, y: searchParentView.frame.origin.y, width: self.view.frame.size.width, height: self.view.frame.size.height-110)
        mainParentScrollView.backgroundColor = UIColor(netHex:0xeaeaea)
        Utils.loadCartFromDB()
        self.createRightBar()
        self.createTitle()
        self.createBanner()
        self.showStoreDetails()
        self.loadProductSections()
        self.loadLogin()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(deviceName == "big"){
            //UILabel.appearance().font = UIFont(name: "Lato", size: 18)
            cartCountLabel.font = UIFont(name: "Open Sans", size: 15)
        }else{
            //UILabel.appearance().font = UIFont(name: "Lato", size: 15)
            cartCountLabel.font = UIFont(name: "Open Sans", size: 12)
        }
        super.viewWillAppear(animated)
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
            self.addLoader()
            if let url = WebApiManager.Instance.getStoreDetailURL(){
                self.fetchStoreDetails(url)
            }
        }else{
            self.ViewStoreDetails()
        }
    }
    
    fileprivate func fetchStoreDetails(_ url: String){
        Utils.fillTheData(url, callback: self.addStroeDetails, errorCallback : self.showError)
    }
    
    fileprivate func addStroeDetails(_ dataDict: NSDictionary){
        defer{self.removeLoader()}
        self.populateStoreDetails(dataDict)
        self.ViewStoreDetails()
    }
    
    fileprivate func ViewStoreDetails(){
        self.setTitle()
        self.processBanners()
        self.view.reloadInputViews()
    }
    
    
    fileprivate func populateStoreDetails(_ dataDict: NSDictionary){
        let storeDetail = StoreManager.Instance.storeDetail
        storeDetail.banners.removeAll(keepingCapacity: true)
        
        if let store = dataDict["store"] as? NSDictionary{
            let aboutUs = store["about_us"] as! String
            let privacyPolicy = store["privacy_policy"] as! String
            storeDetail.privacyPloicy = privacyPolicy
            storeDetail.aboutUsId = aboutUs
        }
        
        if let theme = dataDict["theme"] as? NSDictionary{
            if let logo = theme["logo"] as? NSDictionary{
                if let image = logo["image"] as? NSArray{
                    if let imageDict = image as? [NSDictionary]{
                        if let logoImage = imageDict[0]["mofluid_image_value"] as? String{
                            storeDetail.logo = logoImage
                        }
                    }
                }
            }
            
            if let banner = theme["banner"] as? NSDictionary{
                if let images = banner["image"] as? NSArray{
                    images.forEach{image in
                        if let imageDict = image as? NSDictionary{
                            storeDetail.bannersDict.append(imageDict)
                            if let mofluid_image_value = imageDict["mofluid_image_value"] as? String{
                                storeDetail.banners.append(mofluid_image_value)
                            }
                        }
                    }
                }
            }
        }
    }
    
    fileprivate func setTitle(){
        assert(StoreManager.Instance.storeDetail.logo != nil)
        let titleButton = Utils.createTitileButton(StoreManager.Instance.storeDetail.logo)
        self.navigationItem.titleView = titleButton
        titleButton.isUserInteractionEnabled = false
    }
    
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
                Utils.loadWishlistItemData()
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
                Utils.loadWishlistItemData()
            }
        }else {
            self.removeLoader()
        }
    }
    
    func loginWithMofluid(_ loginDict : [String : String]){
        if let email = loginDict["email"]{
            if let passwd = loginDict["password"]{
                self.addLoader()
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
        self.removeLoader()
        
        let _ = UserInfo.createUserInfo(dataDict, loginType : LoginType.Mofluid)
        if(UserDefaults.standard.bool(forKey: "isLogin")){
            Utils.loadWishlistItemData()
        }
    }
    
    
    /*-----------------------------------Banner Starts---------------------------------------------------------------*/
    
    fileprivate func loadProductSections() {
        if let newProductUrl = WebApiManager.Instance.getNewProductsURL() ,let featureProductUrl = WebApiManager.Instance.getFeatureProductsURL(),let bestProductUrl = WebApiManager.Instance.getBestsellerProductsURL() {
            let dispatchGroup = DispatchGroup()
            dispatchGroup.enter()
            addLoader()
            Utils.fillTheData(newProductUrl, callback: parseNewProduct, errorCallback: showError)
            Utils.fillTheData(featureProductUrl, callback: parseFeatureProduct, errorCallback: showError)
            Utils.fillTheData(bestProductUrl, callback:parseBestSellerProduct, errorCallback: showError)
            dispatchGroup.leave()
            self.removeLoader()
            dispatchGroup.notify(queue: DispatchQueue.main) { // 2
                //self.removeLoader()
                print("all done")
            }
        }
    }
    /*
    func hitAPIForNewProducts(_ url:String) {
        addLoader()
        Utils.fillTheData(url, callback: parseNewProduct, errorCallback: showError)
    }
    
    func hitAPIForFeatureProduct(_ url:String) {
        addLoader()
        Utils.fillTheData(url, callback: parseFeatureProduct, errorCallback: showError)
    }
    
    func hitAPIForBestSellerProduct(_ url:String) {
        addLoader()
        Utils.fillTheData(url, callback:parseBestSellerProduct, errorCallback: showError)
    }
    */
    func parseNewProduct(_ newProductDict:NSDictionary) {
        self.products[ProductsType.new ] = self.addProducts(newProductDict)
        if products[ProductsType.new]?.count > 0 { createDynamicUI(ProductsType.new)}
        removeLoader()
    }
    
    func parseFeatureProduct(_ featureProductDict:NSDictionary) {
        self.products[ProductsType.feature] = self.addProducts(featureProductDict)
        if products[ProductsType.feature]?.count > 0 { createDynamicUI(ProductsType.feature)}
        removeLoader()
        
    }
    
    func parseBestSellerProduct(_ bestSellerProduct:NSDictionary) {
        self.products[ProductsType.bestseller] = self.addProducts(bestSellerProduct)
        if products[ProductsType.bestseller]?.count > 0 { createDynamicUI(ProductsType.bestseller)}
        removeLoader()
    }
    
    fileprivate func createDynamicUI(_ producttype:ProductsType) {
        DispatchQueue.main.async {
            switch producttype {
                
            case .feature:
                if let lastUI = self.getlastUIInViewStack() {
                    let _ = self.createFeatureProducts(lastUI)
                    self.featureParentCollectionView!.reloadData()
                }
                break
            case .bestseller:
                if let lastUI = self.getlastUIInViewStack() {
                    let _ = self.createBestsellerProducts(lastUI)
                    self.bestSellerCollectionView?.reloadData()
                }
                break
            case .new:
                if let lastUI = self.getlastUIInViewStack() {
                    let _ = self.createNewProducts(lastUI)
                    self.newParentCollectionView?.reloadData()
                }
                break
                
            }
        }
    }
    
    fileprivate func getlastUIInViewStack() ->UIView? {
        let clilds = mainParentScrollView.subviews as [UIView]
        var lastVwInstack:UIView? = nil
        for vw in clilds {
            if vw.tag == 10 {
                lastVwInstack = vw
            }
        }
        return lastVwInstack
    }
    
    func createBanner(){
        bannerData.removeAll()
        mainParentScrollView.backgroundColor = UIColor.white
        
        bannerParentView = Utils.createBannerParentView(mainParentScrollView)
        bannerParentView.tag = 10
        bannerScrollView = Utils.createBannerScrollView(bannerParentView)
        
        pageControl = Utils.createPageControl(bannerParentView)
        
        bannerParentView.addSubview(bannerScrollView)
        
        bannerParentView.addSubview(pageControl)
        
        mainParentScrollView.addSubview(bannerParentView)
    }
    func processBanners(){
        let pageCount = StoreManager.Instance.storeDetail.banners.count
        
        if pageCount > 0{
            for _ in 0..<pageCount {
                pageViews.append(nil)
            }
            
            let pagesScrollViewSize = bannerScrollView.frame.size
            bannerScrollView.delegate = self
            bannerScrollView.isPagingEnabled=true;
            bannerScrollView.contentOffset = CGPoint(x: UIScreen.main.bounds.size.width, y: 0)
            bannerScrollView.contentSize = CGSize(width: pagesScrollViewSize.width * CGFloat(StoreManager.Instance.storeDetail.banners.count), height: pagesScrollViewSize.height)
            
            loadVisiblePages()
            
            pageControl.numberOfPages = pageCount
            Timer.scheduledTimer(timeInterval: bannerTimeInterval, target: self, selector: #selector(ViewController.timerimages), userInfo: nil, repeats: true)
        }
        
        pageControl.isHidden = false
    }
    
    
    func loadVisiblePages() {
        let pageWidth = bannerScrollView.frame.size.width
        let page = Int(floor((bannerScrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        
        pageControl.currentPage = page
        pageControl.tintColor = UIColor(netHex:0xff8b01)
        pageControl.pageIndicatorTintColor = UIColor.gray
        pageControl.currentPageIndicatorTintColor = UIColor.black
        
        for (index, _) in StoreManager.Instance.storeDetail.banners.enumerated(){
            loadPage(index)
        }
        
        bannerScrollView.delegate = self
    }
    
    
    func loadPage(_ page: Int) {
        if page < 0 || page >= StoreManager.Instance.storeDetail.banners.count {
            // If it's outside the range of what you have to display, then do nothing
            return
        }
        
        var frame = UIScreen.main.bounds
        frame.origin.x = (frame.size.width  ) * CGFloat(page)
        frame.origin.y = 0.0
        frame.size.width = frame.size.width
        frame.size.height = bannerScrollView.bounds.size.height
        let newPageView = UIImageView()
        newPageView.frame = frame
        let arr = getBannerArr(page)
        if arr.count > 0{
            if arr[0] as! String == "category"
            {
                newPageView.tag = Int(arr[1] as! String)!
            }
        }else{
            newPageView.tag = 0
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(imageTapped(_:)))
        newPageView.isUserInteractionEnabled = true
        newPageView.addGestureRecognizer(tapGestureRecognizer)
        
        
        UIImageCache.setImage(newPageView, image: StoreManager.Instance.storeDetail.banners[page])
        newPageView.contentMode = .scaleAspectFit
        bannerScrollView.addSubview(newPageView)
        pageViews[page] = newPageView
    }
    
    @objc func imageTapped(_ sender : UITapGestureRecognizer)
    {
        if let img1 = sender.view as? UIImageView
        {
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
            let destViewController = mainStoryboard.instantiateViewController(withIdentifier: "productListViewController") as! productListViewController
            if img1.tag != 0 {
                destViewController.categoryId = img1.tag
                for item in bannerData{
                    if Int(item[1]) == img1.tag{
                        destViewController.titleString = item[2]
                    }
                }
                self.navigationController?.pushViewController(destViewController, animated: true)
            }
        }
    }
    
    func getBannerArr(_ index : Int) -> NSArray{
        var bannerArr : [String] = []
        let banner = StoreManager.Instance.storeDetail.bannersDict[index]
        if  let mofluidImageAction = banner["mofluid_image_action"] as? String{
            let dict = Encoder.decodeBase64ToDictionary(mofluidImageAction)
            if let base = dict["base"] as? String{
                bannerArr.insert(base, at: 0)
            }
            if let id = dict["id"] as? String{
                bannerArr.insert(id, at: 1)
            }
            if let productName = dict["name"] as? String{
                bannerArr.insert(productName, at: 2)
            }
            bannerData.append(bannerArr)
        }
        return bannerArr as NSArray
    }
    
    @objc func timerimages(){
        let pageCount = StoreManager.Instance.storeDetail.banners.count
        if pageCount <= 1 {
            return
        }
        
        let scrsize = Int(mainParentScrollView.frame.size.width) * pageCount
        
        if(Int(bannerScrollView.contentOffset.x) == 0){
            bannerAnimationStatus = false
        }else if(Int(bannerScrollView.contentOffset.x) == Int(scrsize) - Int(mainParentScrollView.frame.size.width)){
            bannerAnimationStatus = true
            
            let scrollPoint = CGPoint(x:0 , y: 0)
            
            UIView .animate(withDuration: 2, animations: {
                
                self.bannerScrollView.contentOffset = scrollPoint
                
            })
        }
        
        if(bannerAnimationStatus == false){
            let scrollPoint = CGPoint(x:bannerScrollView.contentOffset.x + mainParentScrollView.frame.size.width, y: 0)
            
            UIView .animate(withDuration: 2, animations: {
                self.bannerScrollView.contentOffset = scrollPoint
            })
        }else{
            bannerAnimationStatus = false
            bannerScrollView.contentOffset.x = 0
            let scrollPoint = CGPoint(x:bannerScrollView.contentOffset.x, y: 0)
            
            UIView .animate(withDuration: 2, animations: {
                self.bannerScrollView.contentOffset = scrollPoint
            })
        }
        
        loadVisiblePages()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool){
        let width = scrollView.frame.size.width
        let expectedX = Double(width) * Double(self.pageControl.currentPage)
        
        if Double(scrollView.contentOffset.x) > expectedX{
            self.pageControl.currentPage += 1
        }else{
            self.pageControl.currentPage -= 1
        }
    }
    
    /*-----------------------------------Banner Ends---------------------------------------------------------------*/
    
    fileprivate func showProductSections(){
        if  UserDefaults.standard.bool(forKey: "isFeaturedEmpty") {
            UserDefaults.standard.set(false, forKey: "isFeaturedEmpty")
        }
    }
    
    func createNewP()-> UIView{
        let featureParentView = Utils.createProductsParentView(bannerParentView)
        let featureTitleLabel = Utils.createProductHeaderTitleLabel(featureParentView)
        let featureParentCollectionView = Utils.createProductCollectionView(featureParentView, titLabel: featureTitleLabel)// need to change
        featureParentView.addSubview(featureTitleLabel)
        featureParentView.addSubview(featureParentCollectionView)
        mainParentScrollView.addSubview(featureParentView)
        
        featureTitleLabel.text = "FEATURED PRODUCTS".localized()
        featureTitleLabel.font = UIFont(name:"OpenSans-Bold", size: 18.0)
        featureTitleLabel.textColor = UIColor(netHex:0x000000)
        featureParentCollectionView.backgroundColor = UIColor.white
        featureParentView.backgroundColor = UIColor.white
        cellHeight = newParentCollectionView!.frame.height
        featureParentCollectionView.delegate = self
        featureParentCollectionView.dataSource = self
        
        let layout = featureParentCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        featureParentCollectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: kCellReuse)
        
        return featureParentView
    }
    
    /*-----------------------------------New Products Starts-----------------------------------------------------*/
    
    func createNewProducts(_ lastView : UIView)-> UIView{
        let newParentView = Utils.createProductsParentView(lastView)
        newParentView.tag = 10
        
        let newTitleLabel = Utils.createProductHeaderTitleLabel(newParentView)
        newParentCollectionView = Utils.createProductCollectionView(newParentView, titLabel: newTitleLabel)
        let lineLbl = UILabel()
        lineLbl.frame = CGRect(x: 5 , y: newTitleLabel.frame.origin.y + newTitleLabel.frame.height + 10 , width: newParentView.frame.width - 10 , height: 1)
        lineLbl.backgroundColor = UIColor(netHex:0x909090)
        
        newParentView.addSubview(lineLbl)
        newParentView.addSubview(newTitleLabel)
        newParentView.addSubview(newParentCollectionView!)
        mainParentScrollView.addSubview(newParentView)
        newTitleLabel.text =  "NEW PRODUCTS".localized()
        
        newTitleLabel.font = UIFont(name:"OpenSans-Bold", size: 18.0)
        newTitleLabel.textColor = UIColor(netHex:0x000000)
        
        if (idForSelectedLangauge == Utils.getArebicLanguageCode()) {
            newTitleLabel.textAlignment = .right
        }else{
            newTitleLabel.textAlignment = .left
        }
        
        newParentCollectionView!.backgroundColor = UIColor.white
        newParentView.backgroundColor = UIColor.white
        cellHeight = newParentCollectionView!.frame.height
        newParentCollectionView!.delegate = self
        newParentCollectionView!.dataSource = self
        
        let layout = newParentCollectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        newParentCollectionView!.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: kCellReuse)
        
        if(deviceName == "big"){
            mainParentScrollView.contentSize.height = newParentView.frame.origin.y + newParentView.frame.size.height + 70
        }else{
            mainParentScrollView.contentSize.height = newParentView.frame.origin.y + newParentView.frame.size.height + 60
        }
        return newParentView
    }
    
    /*-----------------------------------New Products Ends-----------------------------------------------------*/
    /*-----------------------------------Feature Products Starts-----------------------------------------------------*/
    
    func createFeatureProducts(_ lastUI:UIView)-> UIView{
        let featureParentView = Utils.createProductsParentView(lastUI)
        featureParentView.tag = 10
        let featureTitleLabel = Utils.createProductHeaderTitleLabel(featureParentView)
        
        featureParentCollectionView = Utils.createProductCollectionView(featureParentView, titLabel: featureTitleLabel)
        featureParentCollectionView!.backgroundColor = UIColor.white
        featureParentView.backgroundColor = UIColor.white
        cellHeight = featureParentCollectionView!.frame.height
        featureParentCollectionView!.delegate = self
        featureParentCollectionView!.dataSource = self
        
        let layout = featureParentCollectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        featureParentCollectionView!.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: kCellReuse)
        let lineLbl = UILabel()
        lineLbl.frame = CGRect(x: 5 , y: featureTitleLabel.frame.origin.y + featureTitleLabel.frame.height + 10 , width: featureParentView.frame.width - 10 , height: 1)
        lineLbl.backgroundColor = UIColor(netHex:0x909090)
        
        featureParentView.addSubview(lineLbl)
        featureParentView.addSubview(featureTitleLabel)
        featureParentView.addSubview(featureParentCollectionView!)
        mainParentScrollView.addSubview(featureParentView)
        
        featureTitleLabel.text =  "FEATURED PRODUCTS".localized()
        
        featureTitleLabel.font = UIFont(name:"OpenSans-Bold", size: 18.0)
        featureTitleLabel.textColor = UIColor(netHex:0x000000)
        
        if (idForSelectedLangauge == Utils.getArebicLanguageCode()) {
            featureTitleLabel.textAlignment = .right
        }else{
            featureTitleLabel.textAlignment = .left
        }
        
        
        if(deviceName == "big"){
            mainParentScrollView.contentSize.height =  featureParentView.frame.origin.y + featureParentView.frame.size.height + 70
        }else{
            mainParentScrollView.contentSize.height = featureParentView.frame.origin.y + featureParentView.frame.size.height + 60
        }
        
        return featureParentView
        
    }
    
    /*-----------------------------------Feature Products Ends-----------------------------------------------------*/
    
    /*----------------------------------Best Seller
     Starts-----------------------------------------------------*/
    
    
    func createBestsellerProducts(_ lastView : UIView)-> UIView{
        
        let newParentView = Utils.createProductsParentView(lastView)
        newParentView.tag = 10
        let newTitleLabel = Utils.createProductHeaderTitleLabel(newParentView)
        
        bestSellerCollectionView = Utils.createProductCollectionView(newParentView, titLabel: newTitleLabel)
        bestSellerCollectionView!.backgroundColor = UIColor.white
        newParentView.backgroundColor = UIColor.white
        cellHeight = bestSellerCollectionView!.frame.height
        bestSellerCollectionView!.delegate = self
        bestSellerCollectionView!.dataSource = self
        let lineLbl = UILabel()
        lineLbl.frame = CGRect(x: 5 , y: newTitleLabel.frame.origin.y + newTitleLabel.frame.height + 10 , width: newParentView.frame.width - 10 , height: 1)
        lineLbl.backgroundColor = UIColor(netHex:0x909090)
        
        let layout = bestSellerCollectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        bestSellerCollectionView!.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: kCellReuse)
        
        newParentView.addSubview(lineLbl)
        
        newParentView.addSubview(newTitleLabel)
        
        newParentView.addSubview(bestSellerCollectionView!)
        
        mainParentScrollView.addSubview(newParentView)
        
        
        newTitleLabel.text = "BEST SELLER".localized()
        
        if (idForSelectedLangauge == Utils.getArebicLanguageCode()) {
            newTitleLabel.textAlignment = .right
        }else{
            newTitleLabel.textAlignment = .left
        }
        
        newTitleLabel.font = UIFont(name:"OpenSans-Bold", size: 18.0)
        newTitleLabel.textColor = UIColor.black
        
        if(deviceName == "big"){
            mainParentScrollView.contentSize.height =  newParentView.frame.origin.y + newParentView.frame.size.height + 70
        }else{
            mainParentScrollView.contentSize.height = newParentView.frame.origin.y + newParentView.frame.size.height + 60
        }
        
        return newParentView
    }
    
    
    /*-----------------------------------Best Seller
     
     Ends-----------------------------------------------------*/
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        var size : CGSize
        
        if (UIDevice.current.model.range(of: "iPad") != nil){
            size = CGSize(width: (width/4)   , height: cellHeight)
        }else {
            size = CGSize(width: (width/3)  , height: cellHeight)
        }
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.products.count > 0 {
            if collectionView == featureParentCollectionView {
                return self.products[ProductsType.feature]!.count
            }else if collectionView == newParentCollectionView {
                return self.products[ProductsType.new]!.count
            }else if collectionView == bestSellerCollectionView {
                return self.products[ProductsType.bestseller]!.count
            }
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellReuse, for: indexPath) as! CustomCollectionViewCell
        var arr = [ShoppingItem]()
        
        if collectionView == featureParentCollectionView {
            arr = self.products[ProductsType.feature]!
        }else if collectionView == newParentCollectionView {
            arr = self.products[ProductsType.new]!
        }else if collectionView == bestSellerCollectionView {
            arr = self.products[ProductsType.bestseller]!
        }
        
        let item =  arr[indexPath.row]
        
        if item.isShowSpecialPrice(){
            let attributePrice =  NSMutableAttributedString(string: item.originalPriceStr!)
            
            attributePrice.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributePrice.length))
            attributePrice.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: NSMakeRange(0, attributePrice.length))
            var priseString = NSMutableAttributedString()
            priseString = NSMutableAttributedString(string: "  \(item.priceStr)")
            attributePrice.append(priseString)
            cell.costTitle.attributedText = attributePrice
            
        }else{
            cell.costTitle.text = item.priceStr
        }
        
        UIImageCache.setImage(cell.new_img_view, image: item.image)
        
        cell.productTitle.text = item.name
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        var arr = [ShoppingItem]()
        
        if collectionView == featureParentCollectionView {
            arr = self.products[ProductsType.feature]!
        }else if collectionView == newParentCollectionView {
            arr = self.products[ProductsType.new]!
        }
        else if collectionView == bestSellerCollectionView {
            arr = self.products[ProductsType.bestseller]!
        }
        
        if(arr.count > 0){
            let item =  arr[indexPath.row]
            
            if let data = StoreManager.Instance.getShoppingItem(item.id){
                if(data.type == "grouped"){
                    let groupProductObject = GroupedProductDetailViewController(nibName: "GroupedProductDetailViewController", bundle: nil)
                    groupProductObject.shoppingItem = data
                    self.navigationController?.pushViewController(groupProductObject, animated: true)
                }else{
                    DispatchQueue.main.async(execute: {
                        let productDtail = NewProductDetailePage(nibName: "NewProductDetailePage", bundle: nil)
                        
                        let def = UserDefaults.standard
                        let idItem =  def.integer(forKey: "intKey") as Int
                        let def1 = UserDefaults.standard
                        let idIt = def1.integer(forKey: "intKy") as Int
                        
                        productDtail.shoppingItem?.id = data.value(forKey: "id") as! Int
                        
                        if data.id == idIt {
                            productDtail.shoppingItem?.id = idItem
                            data.setValue(idItem, forKey: "id")
                        }
                        productDtail.shoppingItem = StoreManager.Instance.getShoppingItem(item.id)
                        
                        self.navigationController?.pushViewController(productDtail, animated: true)
                    })
                }
            }
        }
    }
    
    fileprivate func addProducts(_ dataDict: NSDictionary)->[ShoppingItem]{
        defer{self.removeLoader()}
        var products = [ShoppingItem]()
        
        if let status = dataDict["status"] as? NSArray{
            if let statusDict = status as? [NSDictionary]{
                if let showStatus = statusDict[0]["Show_Status"] as? NSString{
                    if(showStatus == "1"){
                        if let products_list = dataDict["products_list"] as? NSArray{
                            products_list.forEach{item in
                                if let shoppingItem = StoreManager.Instance.createShoppingItem(item as! NSDictionary){
                                    products.append(shoppingItem)
                                }
                            }
                        }
                    }
                }
            }
        }
        return products
    }
}
