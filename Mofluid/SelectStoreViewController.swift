//
//  SelectStoreViewController.swift
//  Mofluid
//
//  Created by mac on 04/10/16.
//  Copyright © 2016 Mofluid. All rights reserved.
//

import UIKit

class SelectStoreViewController : PageViewController ,UITableViewDelegate,UITableViewDataSource{
    @IBOutlet var StoreTableView: UITableView!
    var titleString = NSString ()
    var langaugeList = NSArray()
    var dataArray = NSMutableArray()
    var shoppingGroups : [ShoppingGroup] =  [ShoppingGroup]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainParentView.isHidden = true
        mainParentScrollView.isHidden = true
        searchParentView.isHidden = true
        self.title = "Choose Store".localized()
        
        self.getChooseStoreData()
        let item = ShoppingGroup( id: 12, parentGroup : nil, name:"Choose Strore".localized(), children: dataArray)!
        print(item)
        print(shoppingGroups)
        self.shoppingGroups.append(item)
        
    }
    
    
    func getChooseStoreData(){
        addLoader()
        let url = WebApiManager.Instance.getUrlForCategory()
        Utils.fillTheData(url, callback: self.convertIntoArray, errorCallback : self.showError)
    }
    
    func convertIntoArray(_ dataDict: NSDictionary)
    {
        
        if let data = dataDict["1"] as? NSDictionary{
            
            if let categories = data["webside"] as? NSDictionary{
                for (_, value) in categories {
                    dataArray.add(value)
                }
                
                StoreTableView.reloadData()
            }
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "OptionViewTap"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "selectOptionViewOption"), object: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = (dataArray[indexPath.row] as AnyObject).object(forKey: "store") as? String
        cell?.imageView?.image = UIImage(named: "briefcase.png")
        
        removeLoader()
        return cell!
    }
    
    func backButtonFunction(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
        
        print(self.shoppingGroups)
        
        let item = self.shoppingGroups[indexPath.section].getSubgroups()[indexPath.row]
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.shoGroup = item
        
        var id = item.id
        if id < 0{
            
            if let parentGroup = item.parentGroup{
                
                id = parentGroup.id
            }
        }
        storeId = (dataArray[indexPath.row] as AnyObject).object(forKey: "store_id") as? String
        
         if item.parentGroup != nil && item.parentGroup!.id == 12
            
        {
            let selectlanguageObj = mainStoryboard.instantiateViewController(withIdentifier: "SelectLangaugeViewController") as! SelectLangaugeViewController
            let title = (dataArray[indexPath.row] as! NSDictionary).value(forKey: "store")
            selectlanguageObj.titleString = (title as? NSString)!
            
            self.navigationController?.pushViewController(selectlanguageObj, animated: true)
        }
        
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
}



