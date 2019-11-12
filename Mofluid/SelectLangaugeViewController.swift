//
//  SelectLangaugeViewController.swift
//  Mofluid
//
//  Created by Vivek_ebizon on 28/04/16.
//  Copyright © 2016 Mofluid. All rights reserved.
//

import UIKit

class SelectLangaugeViewController: PageViewController ,UITableViewDelegate,UITableViewDataSource{
    @IBOutlet var languageTableView: UITableView!
    var titleString = NSString ()
    var langaugeList = NSArray()
    var dataArray = NSMutableArray()
    var shoppingGroups : [ShoppingGroup] =  [ShoppingGroup]()

 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainParentView.isHidden = true
        mainParentScrollView.isHidden = true
        searchParentView.isHidden = true
        
        self.title =  titleString as String
        self.getChooseStoreData()
      
        
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
                if let testStore = categories[storeId!] as? NSDictionary{
                    if let testStoreViews = testStore["view"] as? NSDictionary{
                        
                        for (key, value) in testStoreViews {
                            print(key, value)
                            dataArray.add(value)
                            print(dataArray)
                        }
                        
                        languageTableView.reloadData()
                    }
                }
            
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
        cell?.textLabel?.text = (dataArray[indexPath.row] as AnyObject).object(forKey: "name") as? String
        cell?.imageView?.image = UIImage(named: "briefcase.png")
        
        if idForSelectedLangauge == (dataArray[indexPath.row] as AnyObject).object(forKey: "store_lang_code") as! String{
            cell?.accessoryType = .checkmark
        }
        removeLoader()
        return cell!
    }
    
    func applyLanguage(){
        self.navigationController?.popToRootViewController(animated: true)
    }

    
    func backButtonFunction(){
        
        self.navigationController?.popViewController(animated: true)

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        if let lang = (dataArray[indexPath.row] as AnyObject).object(forKey: "store_lang_code") as? String{
            idForSelectedLangauge = lang
            
            let currencyCode = (dataArray[indexPath.row] as AnyObject).object(forKey: "current_currency_code") as! String
            let storeID = (dataArray[indexPath.row] as AnyObject).object(forKey: "store_id") as! String
            
            Config.Instance.setStoreId(storeID)
            Config.Instance.setCurrencyCode(currencyCode)
            WebApiManager.Instance.refreshURL()
            
            Localize.setCurrentLanguage(lang)
        }
        applyLanguage()
    }
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
    
}



