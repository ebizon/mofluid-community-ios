//
//  MyDownloadViewController.swift
//  Mofluid
//
//  Created by mac on 08/08/16.
//  Copyright © 2016 Mofluid. All rights reserved.
//

import Foundation

import UIKit

class MyDownloadsViewController: PageViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var myDownloadsArray: NSArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainParentView.isHidden = true
        mainParentScrollView.isHidden = true
        searchParentView.isHidden = true
        
        
        self.navigationItem.title = "My Downloads".localized().uppercased()
        self.loadMyDownloads()
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
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(myDownloadsArray != nil )
        {
            return myDownloadsArray!.count
        }
        else
        {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell :UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "downloadcell")!
        
        
        let productName: UILabel = (cell.viewWithTag(101) as! UILabel)
        let orderDate: UILabel = (cell.viewWithTag(102) as! UILabel)
        let orderStatus: UILabel = (cell.viewWithTag(103) as! UILabel)
        let orderRemain: UILabel = (cell.viewWithTag(104) as! UILabel)
        
        productName.text = (myDownloadsArray![indexPath.row] as AnyObject).object(forKey: "product_name") as? String
        orderDate.text = (myDownloadsArray![indexPath.row] as AnyObject).object(forKey: "order_date") as? String
        orderStatus.text = (myDownloadsArray![indexPath.row] as AnyObject).object(forKey: "status") as? String
        orderRemain.text = (myDownloadsArray![indexPath.row] as AnyObject).object(forKey: "remaining_download") as? String
        
        
        
        return cell
    }
    
    
    
    
    @IBAction func downloadURL(_ sender: AnyObject) {
        
        var rowIndex:IndexPath?
        
        if let button = sender as? UIButton {
            if let superview = button.superview {
                if let cell = superview.superview as? UITableViewCell {
                    rowIndex = tableView.indexPath(for: cell)
                }
            }
        }
        
        if let url = (myDownloadsArray![rowIndex!.row] as AnyObject).object(forKey: "download_url") as? String{
            UIApplication.shared.open(URL(string:url)!, options: [:], completionHandler: nil)
        }
    }
    
    func selectItem(_ sender:UIButton){
        if let url = (myDownloadsArray![sender.tag] as AnyObject).object(forKey: "download_url") as? String{
            UIApplication.shared.open(URL(string:url)!, options: [:], completionHandler: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func loadMyDownloads(){
        self.addLoader()
        let url = WebApiManager.Instance.getMyDownloadsURL()
        Utils.fillTheData(url, callback: self.processOrders, errorCallback : self.showError)
    }
    
    func processOrders(_ dataDict: NSDictionary){
        defer{self.removeLoader()}
        
        if let myDonloadsArray = dataDict["mydownloads"] as? NSArray{
            self.myDownloadsArray = myDonloadsArray
            self.tableView.reloadData()
            
        }else{
            
            let emptyLabel = UILabel()
            emptyLabel.frame = CGRect(x: 20, y: 150, width: mainParentScrollView.frame.width - 40, height: 25)
            emptyLabel.text = "No Orders are placed yet".localized()
            emptyLabel.font = UIFont(name: "Lato", size: 20)
            emptyLabel.textAlignment = .center;
            emptyLabel.textColor = UIColor.black
            mainParentScrollView.addSubview(emptyLabel)
            
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    func backButtonFunction(){
        self.navigationController?.popViewController(animated: true)
    }
}
