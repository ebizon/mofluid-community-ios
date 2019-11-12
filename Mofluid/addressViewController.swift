//
//  addressViewController.swift
//
//  Created by MANISH on 23/03/18.
//  Copyright © 2016 Mofluid. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class addressViewController : BaseViewController, UITableViewDelegate , UITableViewDataSource, addressTableViewCellDelegate{
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var addressTableView: UITableView!
    var addressTag = 0
    var addressList = [Address]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        mainParentScrollView.addSubview(self.mainView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        uiSetUp()
        
        loadAddresses()
        
        self.addressTableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func openEditPage(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let buyNowObject = storyboard.instantiateViewController(withIdentifier: "buyNowViewController") as? buyNowViewController
        self.navigationController?.pushViewController(buyNowObject!, animated: true)
    }
    
    func removeAddress(id : Int){
        self.addressList = self.addressList.filter{$0.id != id}
        addressTableView.reloadData()
    }
    
    func uiSetUp(){
        self.navigationItem.title = "CHOOSE ADDRESS".localized()
        
        let myOrderNib  = UINib(nibName: "addressViewCell", bundle: Bundle.main)
        addressTableView.register(myOrderNib, forCellReuseIdentifier: "ADDRESS_VIEW")
    }
    
    func loadAddresses(){
        self.addLoader()
        let url = WebApiManager.Instance.getAddressListURL()
        Utils.fillTheDataFromArray(url, callback: self.processAddresses, errorCallback : self.showError)
    }
    
    func processAddresses(_ dataArray: NSArray){
        self.removeLoader()
        self.addressList.removeAll()
        
        dataArray.forEach { item in
            if let itemDict = item as? NSDictionary{
                if let address = Address.processAddress(dataDict: itemDict){
                    self.addressList.append(address)
                }
            }
        }
        addressTableView.reloadData()
    }
    
    //MARK: - TableView protocols
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.addressList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ADDRESS_VIEW", for: indexPath) as! addressViewCell
        cell.delegate = self
        if indexPath.row <  self.addressList.count{
            cell.setAddressData(address: self.addressList[indexPath.row])
        }
        
        return cell
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
        return  190
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let currentCell = tableView.cellForRow(at: indexPath)! as! addressViewCell
        currentCell.doSelect()
        
        if(self.addressTag & AddressType.billing.rawValue != 0){
            UserManager.Instance.getUserInfo()?.billAddress = self.addressList[indexPath.row]
        }
        
        if(self.addressTag & AddressType.shipping.rawValue != 0){
            UserManager.Instance.getUserInfo()?.shipAddress = self.addressList[indexPath.row]
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let discountViewObject = storyboard.instantiateViewController(withIdentifier: "discountViewController") as? discountViewController
        discountViewObject?.cart = ShoppingCart.Instance
        self.navigationController?.pushViewController(discountViewObject!, animated: true)
    }
}
