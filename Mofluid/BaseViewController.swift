//
//  BaseViewController.swift
//  Mofluid
//
//  Created by Ebizon-mac-2015 on 01/10/15.
//  Copyright © 2015 Mofluid. All rights reserved.
//

import UIKit
import Foundation
import TPKeyboardAvoiding
import PopupDialog

class BaseViewController: UIViewController, UIScrollViewDelegate, UISearchBarDelegate,UIGestureRecognizerDelegate, ENSideMenuDelegate{
    var optionView :UIView = UIView()
    var optionButton = UIButton()
    var storeButton = UIButton()
    var menuButton = UIButton()
    var cartCountLabel = UILabel()
    var mainParentScrollView = TPKeyboardAvoidingScrollView()
    var searchParentView = UIView()
    var mainParentView = UIView()
    var gestureSubView = UIGestureRecognizer()
    var loaderCount = 0
    var isOptionAdded : Bool = false
    var activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
    let demoView = UIView()
    
    override func viewDidLoad() {
        
        activityIndicator.color = UIColor.black
        activityIndicator.center = CGPoint(x: UIScreen.main.bounds.size.width / 2, y: UIScreen.main.bounds.size.height / 2 )
        activityIndicator.hidesWhenStopped = true;
        self.view.addSubview(activityIndicator)
        self.mainParentView = Utils.createMainParentView(self.view)
        self.navigationItem.hidesBackButton = true
        
        self.createSearchBar()
        self.createMainView()
        self.createHeader()
        
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.updateCartButton(_:)), name: NSNotification.Name(rawValue: "cartChanged"), object: nil)
        
    }
    
    func createRightBar() {
        if idForSelectedLangauge == Utils.getArebicLanguageCode() {
            navigationItem.leftBarButtonItems = []
            navigationItem.setLeftBarButtonItems([createOptionButton()], animated: false)
        }else{
            navigationItem.rightBarButtonItems = []
            navigationItem.setRightBarButtonItems([createOptionButton()], animated: false)
        }
    }
    
    func createOptionButton()->UIBarButtonItem{
        let optionButtonItem = UIBarButtonItem()
        self.optionButton = Utils.createOptionButton()
        self.optionButton.addTarget(self, action: #selector(BaseViewController.optionBtnPressed), for: .touchUpInside)
        optionButtonItem.customView = self.optionButton
        return optionButtonItem
    }
    
    @objc func optionBtnPressed()  {
        sideMenuController()?.sideMenu?.hideSideMenu()
        if(!isOptionAdded){
            if let parentController :UIViewController = (self.navigationController?.topViewController) {
                let bundle = Bundle(for: type(of: self))
                let nib = UINib(nibName: "RightMenuSideView", bundle: bundle)
                optionView = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
                optionView.frame = CGRect(x: 0, y: 64, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                parentController.view .addSubview(optionView)
            }
        }else{
            optionView .removeFromSuperview()
        }
        isOptionAdded = !isOptionAdded
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.optionBtnPressed), name: NSNotification.Name(rawValue: "OptionViewTap"), object: nil)
        
    }
    
    @objc func methodOfReceivedNotification(_ notification: Notification){
        guard let object = notification.object as? UIButton else{
            return
        }
        self.optionBtnPressed()
        isOptionAdded = true
        if(object.tag == 30){
            let wishList = WishListViewController(nibName: "WishListViewController", bundle: nil)
            self.checkAndPushViewController(wishList)
            optionView.removeFromSuperview()
            isOptionAdded = !isOptionAdded
        }else if(object.tag == 50){
            popupRateTheApp()
        }else if(object.tag == 60){
            object.addTarget(self, action: Selector(("popUpFunc")), for: .touchUpInside)        }
        else{
            let storeDetail = StoreManager.Instance.storeDetail
            let objController = ConstantPageViewController(nibName: "ConstantPageViewController", bundle: Bundle.main)
            var pageId : Int = 0
            if(object.tag==20){  // FOR About US
                if storeDetail.aboutUsId != nil{
                    pageId = Int(storeDetail.aboutUsId!)!
                }
            }else if(object.tag==40){
                
                // FOR Teaem & Condition
                if storeDetail.privacyPloicy != nil{
                    pageId = Int(storeDetail.privacyPloicy!)!
                }
            }
            
            var found = false
            for vc in (self.navigationController?.viewControllers)! {
                if vc.isKind(of: type(of: objController)){
                    let controller = vc as! ConstantPageViewController
                    controller.pageId = pageId
                    controller.loadStoreData()
                    found = true
                    break;
                }
            }
            
            if !found{
                objController.pageId = pageId
                self.navigationController?.pushViewController(objController, animated: true)
            }
        }
    }
    
    func jumpToAppStore() {
        let appID = "1361527269"
        let urlStr = "itms-apps://itunes.apple.com/app/viewContentsUserReviews?id=\(appID)"
        
        if let url = URL(string: urlStr), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    func popupRateTheApp(){
        
            if let url = URL(string: "https://itunes.apple.com/us/app/mofluid-2/id1193197781?mt=8") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)

            }
//        let ratingVC = RatingViewController(nibName: "RatingViewController", bundle: nil)
//
//        let popup = PopupDialog(viewController: ratingVC, buttonAlignment: .horizontal, transitionStyle: .bounceDown, gestureDismissal: true)
//        present(popup, animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "OptionViewTap"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "selectOptionViewOption"), object: nil)
    }
    
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func addLoader(){
        self.loaderCount += 1
        
        if self.loaderCount == 1{
            self.view.isUserInteractionEnabled=false
            self.view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
        }
    }
    
    func removeLoader(){
        self.loaderCount -= 1
        
        if self.loaderCount == 0{
            DispatchQueue.main.async {
                self.view.isUserInteractionEnabled=true
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    func showError(){
        self.removeLoader()
        ErrorHandler.Instance.showError()
        
    }
    
    func alert(_ text:String){
        let alert = UIAlertController(title: "", message: text.localized(), preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK".localized(), style: .default, handler: { (action: UIAlertAction!) in
            //Nothing
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func checkForOnlyAlpha(_ textField :UITextField, text: String)->Bool{
        var bool = true
        if textField.text == nil {
            bool = false
            self.alert(text+" is required.")
        }else if textField.text!.isEmpty{
            bool = false
            self.alert(text+" is required.")
        }else if !Utils.isOnlyAlpha(textField.text!){
            self.alert("Only alphabets are allowed in \(text)")
            bool = false
        }
        return bool
    }
    
    func checkForOnlyNumericHyphen(_ textField :UITextField, text: String)->Bool{
        var bool = true
        if textField.text == nil {
            bool = false
            self.alert(text+" is required.")
        }else if textField.text!.isEmpty{            bool = false
            self.alert(text+" is required.")
        }else if !Utils.isOnlyNumericHyphen(textField.text!){
            bool = false
            self.alert("Non numbers(or -) are not allowed in \(text)")
        }
        return bool
    }
    
    func checkForStreet(_ textField : UITextField, text: String)->Bool{
        var bool = true
        if textField.text == nil || textField.text!.isEmpty{
            bool = false
            self.alert(text+" is required.")
        }
        return bool
    }
    
    func checkForAddress(_ textField :UITextField, text: String)->Bool{
        var bool = true
        
        if textField.text == nil || textField.text!.isEmpty{
            bool = false
            self.alert(text+" is required.")
        }
        return bool
    }
    
    func checkForPin(_ textField :UITextField, text: String)->Bool{
        var bool = true
        if textField.text == nil {
            bool = false
            self.alert(text + " is required.")
        }else if textField.text!.isEmpty{
            bool = false
            self.alert(text + " is required.")
        }else if !Utils.isValidForPin(textField.text!){
            bool = false
            self.alert("Not a valid zip code")
        }
        return bool
    }
    
    func createTitle(){
        let titleButton = Utils.createTitileButton(StoreManager.Instance.storeDetail.logo)
        titleButton.addTarget(self, action: #selector(BaseViewController.clickOnTitle(_:)), for: UIControl.Event.touchUpInside)
        
        self.navigationItem.titleView = titleButton
    }
    
    func createMainView(){
        mainParentScrollView = Utils.createMainParentScrollView(mainParentView)
        mainParentView.addSubview(mainParentScrollView)
        self.view.addSubview(mainParentView)
        mainParentScrollView.delegate = self
    }
    
    func createSearchBar(){
        searchParentView = Utils.createSearchParentView(mainParentView)
        let searchbox = Utils.createSearchbox(searchParentView)
        searchParentView.addSubview(searchbox)
        mainParentView.addSubview(searchParentView)
        searchParentView.isHidden = true
        Utils.configureSearchBar(searchbox)
        searchbox.delegate = self
    }
    
    func createHeader() {
        navigationController?.navigationBar.barTintColor = UIColor.white
        if navigationItem.leftBarButtonItems == nil {
            navigationItem.leftBarButtonItems = []
        }
        if navigationItem.rightBarButtonItems == nil {
            navigationItem.rightBarButtonItems = []
        }
        
        let spacer = Utils.createSpacer()
        self.addHeaderItem(spacer, callback: self.createMenuButton)
    }
    
    func addHeaderItem(_ spacer: UIBarButtonItem, callback: ()->UIBarButtonItem){        
        if (idForSelectedLangauge == Utils.getArebicLanguageCode()) {
            assert(navigationItem.rightBarButtonItems != nil)
            navigationItem.rightBarButtonItems?.removeAll()
            navigationItem.rightBarButtonItems?.insert(callback(), at: 0)
            navigationItem.rightBarButtonItems?.insert(spacer, at: 0)
        }else{
            assert(navigationItem.leftBarButtonItems != nil)
            navigationItem.leftBarButtonItems?.removeAll()
            navigationItem.leftBarButtonItems?.insert(callback(), at: 0)
            navigationItem.leftBarButtonItems?.insert(spacer, at: 0)
        }
        
    }
    
    func createMenuButton()->UIBarButtonItem{
        let menuButtonButtonItem = UIBarButtonItem()
        self.menuButton = Utils.createMenuButton()
        menuButton.addTarget(self, action: #selector(BaseViewController.sidebarFunction), for: .touchUpInside)
        menuButtonButtonItem.customView = menuButton
        menuButton.isHidden = true
        if(isKind(of: HomeVC.self))
        {
            menuButton.isHidden = false
        }
        
        return menuButtonButtonItem
    }
    
    @objc fileprivate func updateCartButton(_ notification: Notification){
        if self.tabBarController != nil {
            let tabArray = self.tabBarController?.tabBar.items as NSArray?
            let tabItem = tabArray?.object(at: 3) as! UITabBarItem
            Utils.setCartLabel(tabItem)
        }
    }
    
    @objc func clickOnTitle(_ button:UIButton){
        let Object = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController
        self.navigationController?.pushViewController(Object!, animated: true)
    }
    
    @objc func sidebarFunction() {
        optionView .removeFromSuperview()
        if self.sideMenuController() != nil{
            if self.sideMenuController()!.sideMenu != nil{
                self.sideMenuController()?.sideMenu?.delegate = self
                toggleSideMenuView()
            }
        }
        
    }
    
    func sideMenuWillOpen() {
        
        UserDefaults.standard.set(true, forKey: "isOpen")
        gestureSubView = UITapGestureRecognizer(target: self, action: #selector(BaseViewController.sidebarFunction))
        view.addGestureRecognizer(gestureSubView)
        
        demoView.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
        demoView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        for allSubViews in self.view.subviews{
            
            allSubViews.isUserInteractionEnabled = false
            
        }
        
        gestureSubView.view?.isUserInteractionEnabled = true
        navigationItem.titleView?.isUserInteractionEnabled = false
        
        view.addSubview(demoView)
        
    }
    
    func sideMenuWillClose() {
        
        UserDefaults.standard.set(false, forKey: "isOpen")
        demoView.removeFromSuperview()
        navigationItem.titleView?.isUserInteractionEnabled = true
        for allSubViews in self.view.subviews{
            
            allSubViews.isUserInteractionEnabled = true
        }
        
        view.removeGestureRecognizer(gestureSubView)
        
    }
    
    func sideMenuShouldOpenSideMenu() -> Bool {
        return true
    }
    
    @objc func push(_ notification: Notification){
        
        self.navigationController?.popToRootViewController(animated: false)
        
        let objet = notification.object as! NSDictionary?
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let itemObject = delegate.shoGroup
        
        let str1 = objet?.value(forKey: "className") as! String?
        let str2 = "categoryViewController"
        
        let titl = objet?.value(forKey: "title") as! String?
        
        if str1==str2 {
            let Object = self.storyboard?.instantiateViewController(withIdentifier: "categoryViewController") as? categoryViewController
            Object!.shoppingGroup = itemObject
            self.navigationController?.pushViewController(Object!, animated: true)
        }
        else if(str1 == "productListViewController"){
            let Object = self.storyboard?.instantiateViewController(withIdentifier: "productListViewController") as? productListViewController
            let str1 = objet?.value(forKey: "id") as! Int?
            Object!.categoryId = str1 ?? 0
            Object?.titleString = titl!
            self.navigationController?.pushViewController(Object!, animated: true)
        }
        else if (str1 == "SelectStoreViewController"){
            let Object = self.storyboard?.instantiateViewController(withIdentifier: "SelectStoreViewController") as? SelectStoreViewController
            
            Object?.titleString = titl as NSString? ?? ""
            self.navigationController?.pushViewController(Object!, animated: true)
            
        }
    }
}


extension UIViewController{
    func checkAndPushViewController(_ viewController: UIViewController) -> Void {
        var isSet = false
        for vc in (self.navigationController?.viewControllers)! {
            if vc.isKind(of: type(of: viewController)){
                self.navigationController?.popToViewController(vc, animated: true)
                isSet = true
                break;
            }
        }
        
        if !isSet {
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}


