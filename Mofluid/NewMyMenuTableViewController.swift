
//
//  NewMyMenuTableViewController.swift
//  Mofluid
//
//  Created by mac on 25/07/16.
//  Copyright © 2016 Mofluid. All rights reserved.
//

import UIKit
import FirebaseMessaging

class NewMyMenuTableViewController: UITableViewController,UITabBarControllerDelegate {
    var sectionSelected = -1
    var IsTrue : Bool = Bool ()
    var sectionEnableArray : [Bool] = [Bool]()
    let plusImage = UIImage(named: "plusx16.png")
    let minusImage = UIImage(named: "minusx16.png")
    var shoppingGroups : [ShoppingGroup] =  [ShoppingGroup]()
    let maxStringLen = 100
    var myActivityIndicator1 = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myActivityIndicator1.color = UIColor.black
        myActivityIndicator1.center = CGPoint(x: view.frame.size.width  / 2, y: view.frame.size.height / 2 )
        myActivityIndicator1.hidesWhenStopped = true;
        self.view.addSubview(myActivityIndicator1)
        
        
        // Customize apperance of table view
        tableView.contentInset = UIEdgeInsets(top: 40.0, left: 0, bottom: 0, right: 0)
        tableView.separatorStyle = .none
        
        tableView.backgroundColor = UIColor.white
        tableView.superview?.backgroundColor = UIColor.clear
        tableView.layer.borderColor = UIColor.lightGray.cgColor
        tableView.layer.borderWidth = 0.5
        tableView.scrollsToTop = true
        
        self.clearsSelectionOnViewWillAppear = false
        NotificationCenter.default.addObserver(self, selector: #selector(NewMyMenuTableViewController.loadList(_:)),name:NSNotification.Name(rawValue: "load"), object: nil)
        
        if  UserDefaults.standard.value(forKey: "appid") == nil{
            Utils.getAuthentication()
        }
        
        
        self.loadData()
        //setFooterViewForDemo()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Empty
    }
    
    func setFooterViewForDemo(){
        
        let btnExit = UIButton()
        btnExit.frame.size.width = self.tableView.frame.size.width
        btnExit.frame.size.height = 50
        btnExit.backgroundColor = UIColor.black
        btnExit.setTitleColor(UIColor.white, for: .normal)
        btnExit.addTarget(self, action: #selector(self.exitPreviewMode), for: UIControl.Event.touchUpInside)
        self.tableView.tableFooterView = btnExit
        if UserDefaults.standard.string(forKey: "isDemo") != nil {
            
            btnExit.setTitle("Exit Demo", for: UIControl.State.normal)
        }
        else{
            
            btnExit.setTitle("Exit Preview", for: UIControl.State.normal)
        }
    }
    @objc func exitPreviewMode(){
        
        UserDefaults.standard.removeObject(forKey: Constants.AppBaseURL)
        UserDefaults.standard.removeObject(forKey: "isDemo")
        UserDefaults.standard.synchronize()
        let applogin = AppLoginVC(nibName:"AppLoginVC",bundle: nil)
        self.present(applogin, animated: true, completion: nil)
    }
    func addLoader(){
        
        self.view.isUserInteractionEnabled=false
        view.addSubview(myActivityIndicator1)
        DispatchQueue.main.async {
            self.myActivityIndicator1.startAnimating()
        }
    }
    
    
    func removeLoader(){
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled=true
            self.myActivityIndicator1.stopAnimating()
        }
    }
    
    
    func showError(){
        self.removeLoader()
        
        ErrorHandler.Instance.showError()
    }
    
    func loadData()
    {
        self.addLoader()
        let url =  WebApiManager.Instance.getCategoryNavigatorURL()
        Utils.fillTheData(url, callback: self.loadCateoryData, errorCallback : self.showError)
    }
    
    func loadCateoryData(_ dataDict: NSDictionary){
        defer{self.removeLoader()}
        
        if let categories = dataDict["categories"] as? NSArray{
            for catSet in categories{
                if let itemDict = catSet as? NSDictionary{
                    let idStr = itemDict["id"] as? String
                    let name = itemDict["name"] as? String
                    let children = itemDict["children"] as? NSArray
                    
                    if idStr != nil && name != nil{
                        let pid = Int(idStr!)
                        if let item = ShoppingGroup(id: pid!, parentGroup : nil, name: name!, children: children){
                            self.shoppingGroups.append(item)
                        }
                    }
                }
            }
        }
        
        
        self.sectionEnableArray = [Bool](repeating: false, count: self.shoppingGroups.count)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    
    override func viewDidAppear(_ animated: Bool){
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.shoppingGroups.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if  self.sectionEnableArray[section] {
            
            return self.shoppingGroups[section].getSubgroups().count
        }
            
        else {
            
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.white
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "CELL") as UITableViewCell?
        
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "CELL")
            
            let selectedBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: cell!.frame.size.width, height: cell!.frame.size.height))
            selectedBackgroundView.backgroundColor = UIColor.white
            cell?.selectedBackgroundView = selectedBackgroundView
            cell?.selectedBackgroundView!.backgroundColor = UIColor.white
            cell?.selectedBackgroundView!.layer.shadowOffset = CGSize(width: 0, height: 0)
            cell?.selectedBackgroundView!.layer.shadowOpacity = 0
            cell?.selectedBackgroundView!.layer.shadowRadius = 0
        }
        
        if self.sectionEnableArray[indexPath.section]{
            
            let subgroups : [ShoppingGroup] = self.shoppingGroups[indexPath.section].getSubgroups()
            let nameStr = subgroups[indexPath.row].name
            let space = "      "
            cell?.textLabel?.text = space + nameStr
            cell?.textLabel?.textColor = UIColor.black
            cell?.textLabel?.font = UIFont(name: "Lato", size: 16)
            
            if (idForSelectedLangauge == Utils.getArebicLanguageCode()) {
                cell?.textLabel?.textAlignment = .right
            }
            else{
                cell?.textLabel?.textAlignment = .left
            }
        }
        return cell!
    }
    
    func addRightArrow(_ cell : UITableViewCell?){
        let Img = UIImage(named: "siderightarrow")
        let rightIconImageView = UIImageView()
        rightIconImageView.frame = CGRect(x: tableView.frame.size.width - 35, y: 19, width: 20, height: 20)
        rightIconImageView.image = Img
        cell?.addSubview(rightIconImageView)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50.0
        
    }
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
        
        let item = self.shoppingGroups[indexPath.section].getSubgroups()[indexPath.row]
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.shoGroup = item
        
        var id = item.id
        if id < 0{
            
            if let parentGroup = item.parentGroup{
                
                id = parentGroup.id
            }
        }
        var myDict : NSDictionary?
        
        if item.parentGroup!.id == 12
            
        {
            myDict = ["className": "SelectLangaugeViewController","id": item.parentGroup!.id, "title":item.name]
            
            let destViewController = mainStoryboard.instantiateViewController(withIdentifier: "SelectLangaugeViewController") as! SelectLangaugeViewController
            
            
            
            if let languages = item.children{
                
                
                UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: languages), forKey: "langaugeListArray")
            }
            
            sideMenuController()?.setContentViewController(destViewController)
            self.navigationController?.pushViewController(destViewController, animated: true)
        }
        else if id > 0{
            
            myDict = ["className": "productListViewController","id": id,"title":item.name]
            let destViewController = mainStoryboard.instantiateViewController(withIdentifier: "productListViewController") as! productListViewController
            //  print(destViewController)
            destViewController.categoryId = id
            destViewController.titleString = item.name
//            if self.navigationController == nil{
//
//                let tabView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabViewController")
//                self.navigationController?.viewControllers.insert(tabView, at: 0)
//            }
            sideMenuController()?.setContentViewController(destViewController)
            //NotificationCenter.default.post(name: Notification.Name(rawValue: "isPushed"), object: myDict)
            //self.navigationController?.pushViewController(destViewController, animated: true)
            //NotificationCenter.default.post(name: Notification.Name(rawValue: "isPushed"), object: myDict)
        }
        
        if(delegate.tabSelectedIndex == 0){
            NotificationCenter.default.post(name: Notification.Name(rawValue: "isPushed"), object: myDict)
            
        }
            
        else if(delegate.tabSelectedIndex == 2){
            NotificationCenter.default.post(name: Notification.Name(rawValue: "isPushedtoUser"), object: myDict)
            
        }
            
        else if(delegate.tabSelectedIndex == 3){
            NotificationCenter.default.post(name: Notification.Name(rawValue: "isPushedtoCart"), object: myDict)
            
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 50
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
        headerView.backgroundColor = UIColor.white
        headerView.tag = section
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor(netHex:0xf0f0f0).cgColor
        border.frame = CGRect(x: 0, y: headerView.frame.size.height - width, width:  headerView.frame.size.width, height: headerView.frame.size.height)
        border.borderWidth = width
        let headerString = UILabel(frame: CGRect(x: 15, y: 10, width: headerView.frame.width - 30, height: 30)) as UILabel
        headerString.text = self.shoppingGroups[section].name
        headerString.adjustsFontSizeToFitWidth = true
        headerString.textColor = UIColor.black
        headerString.font = UIFont(name: "Lato", size: 18)
        headerView .addSubview(headerString)
        
        let iconImageView = UIImageView()
        if (idForSelectedLangauge == Utils.getArebicLanguageCode()) {
            headerString.textAlignment = .right
            iconImageView.frame = CGRect(x: 35, y: 19, width: 15, height: 15)
        }
        else
        {
            headerString.textAlignment = .left
            iconImageView.frame = CGRect(x: headerView.frame.width - 35, y: 19, width: 15, height: 15)
        }
        
        if(self.shoppingGroups[section].getSubgroups().count > 0)
        {
            if self.sectionEnableArray[section]{
                iconImageView.image = minusImage
                headerView.addSubview(iconImageView)
            }else {
                iconImageView.image = plusImage
                iconImageView.frame.origin.y = 17
                headerView.addSubview(iconImageView)
            }
        }
        
        headerString.center             =   headerView.center
        iconImageView.frame.origin.y    =   headerView.frame.size.height/2
        
        let buttonView = UIButton()
        buttonView.frame = headerView.frame
        buttonView.backgroundColor = UIColor.clear
        buttonView.tag = section
        buttonView.addTarget(self, action: #selector(NewMyMenuTableViewController.sectionHeaderTapped(_:)), for:UIControl.Event.touchUpInside)
        headerView.addSubview(buttonView)
        headerView.layer.addSublayer(border)
        headerView.layer.masksToBounds = true
        
        return headerView
        
    }
    
    
    @objc func sectionHeaderTapped(_ tapped: AnyObject){
        
        let section = tapped.tag
        
        if ( self.shoppingGroups[section!].getSubgroups().count > 0)
        {
            for i in 0 ..< sectionEnableArray.count  {
                
                if i == section {
                    self.sectionEnableArray[section!] = !self.sectionEnableArray[section!]
                }else{
                    
                    self.sectionEnableArray[i] = false
                    
                }
            }
            
            tableView.reloadData()
            
        }
        else{
            
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
            
            //    print(self.shoppingGroups)
            
            let item = self.shoppingGroups[section!]
            
            let delegate = UIApplication.shared.delegate as! AppDelegate
            delegate.shoGroup = item
            
            var id = item.id
            if id < 0{
                
                if let parentGroup = item.parentGroup{
                    
                    id = parentGroup.id
                }
            }
            var myDict : NSDictionary?
            
            if id > 0{
                
                myDict = ["className": "productListViewController","id": id,"title":item.name]
                let destViewController = mainStoryboard.instantiateViewController(withIdentifier: "productListViewController") as! productListViewController
                //    print(destViewController)
                destViewController.categoryId = id
                destViewController.titleString = item.name
                //   print(destViewController.titleString)
                sideMenuController()?.setContentViewController(destViewController)
                self.navigationController?.pushViewController(destViewController, animated: true)
            }
            
            if(delegate.tabSelectedIndex == 0){
                NotificationCenter.default.post(name: Notification.Name(rawValue: "isPushed"), object: myDict)
            }else if(delegate.tabSelectedIndex == 2){
                NotificationCenter.default.post(name: Notification.Name(rawValue: "isPushedtoUser"), object: myDict)
            }else if(delegate.tabSelectedIndex == 3){
                NotificationCenter.default.post(name: Notification.Name(rawValue: "isPushedtoCart"), object: myDict)
            }
        }
    }
    
    func closeTheViews(){
        toggleSideMenuView()
    }
    
    @objc func loadList(_ notification: Notification){
        self.tableView.reloadData()
    }
    
    
}
