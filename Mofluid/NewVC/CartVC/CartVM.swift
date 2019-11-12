//
//  CartVM.swift
//  Mofluid
//
//  Created by Saurabh Mishra on 19/07/18.
//  Copyright © 2018 Mofluid. All rights reserved.
//

import Foundation
class CartVM{
    
    func updateProductQuantityOnWeb(_ item:ShoppingItem){
        
        CartRequestHandler().updateCartToServer(item) { (response, status) in }
    }
    func getTotalCost()->Double{
        
        var totalCost:Double    =   0.0
        for item in ShoppingCart.Instance.getAllProducts(){
            
            totalCost=totalCost + (Double(item.selectedItemCount)*item.price)
        }
        return totalCost
    }
    func checkUserAddress()->Bool{
        
        var returnValue =   true
        //let url = WebApiManager.Instance.getBillingAddressURL()
        if let userInfo = UserManager.Instance.getUserInfo(){
            if userInfo.billAddress == nil || userInfo.shipAddress == nil{
                returnValue =   false
                //self.addLoader()
                //Utils.fillTheData(url, callback: self.processBillingAddress, errorCallback : self.billingError)
            }
        }
        return returnValue
    }
    func getUserAddress(completion:@escaping(_ isSuccess:Bool)->Void){
        
        let billingUrl      =       WebApiManager.Instance.getBillingAddressURL()
        let shippingUrl     =       WebApiManager.Instance.getShippingURL()
        var isSuccess       =       true
        let dispatchGroup   =       DispatchGroup()
        dispatchGroup.enter()
        ApiManager().getApi(url: billingUrl!) { (response, status) in
            
            if status{
                
                if ((response as? NSDictionary)! .value(forKey: "status") as? String == "not exist"){
                    isSuccess = false
                }
                UserManager.Instance.setBillingAddress((response as? NSDictionary)!)
            }
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        ApiManager().getApi(url: shippingUrl!) { (response, status) in
            
            if status{
                if ((response as? NSDictionary)! .value(forKey: "status") as? String == "not exist"){
                    isSuccess = false
                }
                UserManager.Instance.setShippingAddress((response as? NSDictionary)!)
            }
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: DispatchQueue.main) { // 2
            
            completion(isSuccess)
        }
    }
}
extension CartVC:UITableViewDelegate,UITableViewDataSource{
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ShoppingCart.Instance.getAllProducts().count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell
        cell.backgroundColor        =   UIColor.clear
        cell.selectionStyle         =   UITableViewCell.SelectionStyle.none
        setDataForCell(cell,indexPath: indexPath)
        return cell
    }
    func setDataForCell(_ cell:CartCell, indexPath:IndexPath) {
        
        let shoppingItem            =       ShoppingCart.Instance.getAllProducts()[indexPath.row]
        cell.lblName.text           =       shoppingItem.name
        cell.lblQty.text            =       "\(shoppingItem.selectedItemCount)"
        cell.item                   =       shoppingItem
        cell.lblPrice.text          =       shoppingItem.priceStr
        cell.lblWarning.isHidden    =       true
        cell.delegate               =       self
        cell.ivImage?.kf.setImage(with:URL(string: shoppingItem.image!))
        //ShoppingWishlist.Instance.isContainsItemByName(shoppingItem) ? (cell.btnWishlist.isHidden = false) :   (cell.btnWishlist.isHidden = true)
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return tableView == tableView ? UITableView.automaticDimension : 132
        return 132
    }
}
extension CartVC:CartCellDelegate{
    
        func clickedOnPlus(_ item: ShoppingItem, qty: String, cell: CartCell) {
            
            let quantity = Int(qty)! + 1
            if Int(quantity) <= item.numInStock{
                
                cell.lblQty.text        =   "\(Int(qty)! + 1)"
                item.selectedItemCount  =   Int(qty)! + 1
                //update price
                let newPrice            =   item.price * Double(item.selectedItemCount)
                cell.lblPrice.text      =   Utils.appendWithCurrencySym(newPrice)
                updateTotalAmount()
                CartVM().updateProductQuantityOnWeb(item)
            }
            else{
                
                Helper().showAlert(self, message:Settings().maxQty)
            }
        }
        
        func clickedOnMinus(_ item: ShoppingItem, qty: String, cell: CartCell) {
            
            if Int(qty)! > 1{
                
                if Int(qty)! <= item.numInStock{
                    
                    cell.lblQty.text        =   "\(Int(qty)! - 1)"
                    item.selectedItemCount  =   Int(qty)! - 1
                    //update price
                    let newPrice            =   item.price * Double(item.selectedItemCount)
                    cell.lblPrice.text      =   Utils.appendWithCurrencySym(newPrice)
                    updateTotalAmount()
                    CartVM().updateProductQuantityOnWeb(item)
                }
            }
        }

    
    func clickedOnDelete(_ item: ShoppingItem, qty: String, cell: CartCell) {
        
        Helper().showAlertWithCancel(self, message:Settings().deleteFromCart) { (index, title) in
            
            if title == Settings().ok{
                
                CartRequestHandler().deleteItemFromCart(item)
                self.tableView.reloadData()
                self.reloadCart()
            }
        }
    }
    func clickedOnWishlist(_ item: ShoppingItem, cell: CartCell,button:UIButton) {
        
        if (Settings().isUserLoggedIn()){
            
            if button.isHidden==false{
                
                ShoppingWishlist.Instance.deleteItem(item)
                button.isHidden        =       true
                WishListRequestHandler().removeFromWishList(item) { (response,status) in}
            }
        }
    }
}
extension CartVC:EmptyCartDelegate{
    
    func clickedOnShowNow(){
        
        self.tabBarController?.selectedIndex = 0
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.tabSelectedIndex = 0
        self.navigationController?.popToRootViewController(animated: true)
    }
}
