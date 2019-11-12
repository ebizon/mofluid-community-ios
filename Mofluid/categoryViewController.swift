//
//  sample.swift
//  Mofluid
//
//  Created by sudeep goyal on 10/09/15.
//  Copyright © 2015 Mofluid. All rights reserved.
//

import UIKit
import Foundation

class categoryViewController: PageViewController, UITableViewDataSource, UITableViewDelegate{
    
    var shoppingGroup : ShoppingGroup? = nil
    var imageParentView: UIView = UIView()
    var categoryImageView:UIImageView = UIImageView()
    var categoryTableView:UITableView = UITableView()
    var categoryTableViewYpos:CGFloat? = nil;
    var titleStr = NSString()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = shoppingGroup?.name.uppercased()

//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "swicthHome:",name:"switchToHomeView", object: nil)
        
        self.createCategoryBannerImage()
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "OptionViewTap"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "selectOptionViewOption"), object: nil)
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        
//        if(deviceName == "big"){
//            UILabel.appearance().font = UIFont(name: "Lato", size: 20)
//        }
//        else{
//            UILabel.appearance().font = UIFont(name: "Lato", size: 15)
//        }
        
        super.viewWillAppear(animated)
    }
    
    func swicthHome(_ notification: Notification){
     self.backButtonFunction()
        
    }
    
    func createCategoryBannerImage(){
        imageParentView = Utils.createBannerParentView(mainParentScrollView)
        categoryImageView.frame = imageParentView.frame
        categoryImageView.contentMode = .scaleAspectFit
        //categoryImageView.image = UIImage(named: "images-4.png")
        imageParentView.addSubview(categoryImageView)
        mainParentScrollView.addSubview(imageParentView)
        
        self.fetchBanger()
        
        createCategoryTable()
        
    }
    
    func fetchBanger(){
        assert(shoppingGroup != nil)
        
        var id = self.shoppingGroup!.id
        
        if id < 0{
            if let parentGroup = self.shoppingGroup!.parentGroup{
                id = parentGroup.id
            }
        }
        
        if id > 0{
            self.addLoader()
            let url = WebApiManager.Instance.getSubCategoryUrl(id)
            Utils.fillTheData(url, callback: self.processBanner, errorCallback: self.showError)
        }
    }
    
    func processBanner(_ dataDict : NSDictionary){
        defer{self.removeLoader()}
        
        if let image = dataDict["images"] as? String{
            UIImageCache.setImage(self.categoryImageView, image: image)
        }
        
        else {
            self.categoryImageView.image = UIImageCache.Instance.defaultImage
        }
    }
    
    /*-------------------------------------------Category List Starts--------------------------------*/
    
    func createCategoryTable(){
        
        categoryTableViewYpos = imageParentView.frame.size.height + imageParentView.frame.origin.y
        categoryTableView.frame = CGRect(x: 0, y: categoryTableViewYpos!, width: mainParentScrollView.frame.size.width, height: mainParentScrollView.frame.size.height - categoryTableViewYpos! - 70 )
        
        mainParentScrollView.addSubview(categoryTableView)
        categoryTableView.delegate =   self
        categoryTableView.dataSource =   self
        categoryTableView.register(UITableViewCell.self, forCellReuseIdentifier: "categoryCell")
        categoryTableView.separatorStyle = .none
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = self.shoppingGroup?.getSubgroups().count else{
            return 0
        }
        
        return count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if(tableView == categoryTableView){
            return 1
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as UITableViewCell
        
        let Img = UIImage(named: "cat_arrow")
        let rightIconImageView = UIImageView()
        rightIconImageView.frame = CGRect(x: tableView.frame.size.width - 45, y: 16, width: 30, height: 30)
        rightIconImageView.image = Img
        cell.addSubview(rightIconImageView)
        
        let borderLabel = UILabel(frame: CGRect(x: 10, y: cell.frame.size.height - 1, width: cell.frame.size.width - 20, height: 1))
        borderLabel.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        cell.addSubview(borderLabel)
        
        cell.textLabel?.text = self.shoppingGroup?.getSubgroups()[indexPath.row].name
        
        if(deviceName != "big"){
            rightIconImageView.frame = CGRect(x: tableView.frame.size.width - 35, y: 15, width: 20, height: 20)
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if(tableView == categoryTableView){
            if(deviceName != "big"){
                return 50
            }
            else{
                
                return 60
                
            }
        }
            
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if self.shoppingGroup != nil{
            let item = self.shoppingGroup!.getSubgroups()[indexPath.row]
            if item.getSubgroups().count > 0{
                let destViewController = self.storyboard?.instantiateViewController(withIdentifier: "categoryViewController") as! categoryViewController
                destViewController.shoppingGroup = item
                self.navigationController?.pushViewController(destViewController, animated: true)
                
            }
            
            else{
                
                let productDetailsViewObejct = self.storyboard?.instantiateViewController(withIdentifier: "productListViewController") as? productListViewController
                
                var catId = -1
                
                if item.id > 0{
                    catId = item.id
                }
                
                else if let parent = item.parentGroup {
                    catId = parent.id
                }
                
                if catId > 0{
                    productDetailsViewObejct?.categoryId = catId
                    
                    productDetailsViewObejct?.titleString = item.name
                    self.navigationController?.pushViewController(productDetailsViewObejct!, animated: true)
                }
            }
        }
    }
    
    func backButtonFunction(){
        
        if UserDefaults.standard.bool(forKey: "isOpen") {
            return
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

