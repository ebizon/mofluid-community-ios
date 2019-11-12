//
//  NewMyOrderViewController.swift
//  Mofluid
//
//  Created by mac on 28/12/16.
//  Copyright © 2016 Mofluid. All rights reserved.
//

import UIKit

class NewMyOrderViewController: PageViewController , UITableViewDelegate , UITableViewDataSource{
    var orderList = [OrderData]()
    @IBOutlet var myOrderTableView: UITableView!
    @IBOutlet var mainView: UIView!
    var currentOrder : OrderData? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "MY ORDERS".localized()
        mainParentScrollView.addSubview(self.mainView)
        mainParentScrollView.contentSize.height = mainView.frame.origin.y + mainView.frame.height + 70
        
        if idForSelectedLangauge == Utils.getArebicLanguageCode() {
            let subMyOrderNib  = UINib(nibName:"subMyOrderTableViewCell_RTL", bundle: Bundle.main)
            myOrderTableView.register(subMyOrderNib, forCellReuseIdentifier: "SUB_MY_ORDER_CELL")
        }else{
            let subMyOrderNib  = UINib(nibName:"subMyOrderTableViewCell", bundle: Bundle.main)
            myOrderTableView.register(subMyOrderNib, forCellReuseIdentifier: "SUB_MY_ORDER_CELL")
        }
        
        myOrderTableView.delegate = self
        myOrderTableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orderList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SUB_MY_ORDER_CELL", for: indexPath) as! subMyOrderTableViewCell
        let orderData = self.orderList[indexPath.row]
        cell.reorderBtnOutlet.tag = indexPath.row
        cell.reorderBtnOutlet.addTarget(self, action: #selector(NewMyOrderViewController.reOrderButtonAction(_:)), for: UIControl.Event.touchUpInside)
        cell.viewOrderBtnOutlet.addTarget(self, action: #selector(NewMyOrderViewController.viewOrderButtonAction(_:)), for: UIControl.Event.touchUpInside)
        cell.viewOrderBtnOutlet.tag = indexPath.row
        cell.timeANdDateLBl.text = "   \(orderData.date)(\(orderData.id))"
        if orderData.items.count > 0{
            cell.setOrder(orderData.items.first!, status: orderData.getStatus())
        }
        
        cell.orderData = orderData
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func backButtonFunction(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func viewOrderButtonAction(_ button:UIButton){
        let index = button.tag
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myOrderDetailObject = storyboard.instantiateViewController(withIdentifier: "orderDetailsViewController") as? orderDetailsViewController
        myOrderDetailObject?.orderData = self.orderList[index]
        myOrderDetailObject?.orderList = self.orderList
        self.navigationController?.pushViewController(myOrderDetailObject!, animated: true)
    }
    
    @objc func reOrderButtonAction(_ button:UIButton){
        let index = button.tag
        self.currentOrder = self.orderList[index]
        let url = self.currentOrder?.getReorderURL()
        self.addLoader()
        Utils.fillTheDataFromArray(url, callback: self.reorderData, errorCallback : self.showError)
    }
    
    func reorderData(_ data: NSArray){
        defer{self.removeLoader()}
        
        if let orderData = self.currentOrder{
            data.forEach{item in
                if let itemDict = item as? NSDictionary{
                    if let reOrderItem =  StoreManager.Instance.createReorderDataItems(itemDict){
                        let qty = orderData.getItemQuantity(reOrderItem.id)
                        if reOrderItem.inStock == false{
                            self.alert("Quantity is out of stock")
                            return
                        }
                        Utils.addItemInCartWithSync(reOrderItem, count: qty, isfromByNow: false, controller: self)
                    }
                }
            }
        }
        
        if UserManager.Instance.getUserInfo() != nil{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let cartView = storyboard.instantiateViewController(withIdentifier: "cartViewController") as? cartViewController
            self.navigationController?.pushViewController(cartView!, animated: true)
        }
    }
}
