//
//  GroupProductVM.swift
//  Mofluid
//
//  Created by Saurabh Mishra on 7/13/18.
//  Copyright © 2018 Mofluid. All rights reserved.
//

import Foundation
class GroupProductVM{
    
    //MARK:- APIS
    func getProducts(_ item:ShoppingItem,_ completion:@escaping (_ status:Bool,_ response:AnyObject)->Void){
        
        let productUrl     =    WebApiManager.Instance.getGroupedProduct(item.sku)
        ApiManager().getApi(url: productUrl) { (response, status) in
            
            if status{
                
                completion(true,response)
            }
            else{
                
                completion(false,NSNull())
            }
        }
    }
    //MARK:- Parser
    func parseGroupedData(_ item:ShoppingItem,_ dataDict:NSDictionary)->[ShoppingItem]{
        
        return GroupedModel().parseGroupedData(item,dataDict)
    }
}

extension GroupListVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 123
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return groupedItems.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupedProductCell", for:indexPath) as! GroupedProductCell
        cell.backgroundColor    =   UIColor.clear
        cell.selectionStyle     =   UITableViewCell.SelectionStyle.none
        setDataForCell(cell,indexPath: indexPath)
        return cell
    }
    func setDataForCell(_ cell:GroupedProductCell, indexPath:IndexPath) {
        
        cell.ivProduct?.kf.setImage(with:URL(string: (groupedItems[indexPath.row].image)!))
        cell.lblName.text                    =   groupedItems[indexPath.row].name
        cell.lblPrice.text                   =   groupedItems[indexPath.row].priceStr
        (groupedItems[indexPath.row].inStock) ? (cell.btnAddtoCart.isEnabled = true) : (cell.btnAddtoCart.isEnabled = false)
        cell.btnQty.text                     =   "\(groupedItems[indexPath.row].selectedItemCount)"
        cell.item                            =   groupedItems[indexPath.row]
        cell.delegate                        =   self
        //set data
    }
}
extension GroupListVC:GroupCellDelegate{
    
    func clickedOnPlus(_ item:ShoppingItem,qty:String,cell:GroupedProductCell){
        
        if Int(qty)! <= item.numInStock{
            
            cell.btnQty.text        =   "\(Int(qty)! + 1)"
            item.selectedItemCount  =   Int(qty)! + 1
            //update price
            let newPrice            =   item.price * Double(item.selectedItemCount)
            cell.lblPrice.text      =   Utils.appendWithCurrencySym(newPrice)
        }
        else{
            
            Helper().showAlert(self, message:Settings().maxQty)
        }
    }
    func clickedOnMinus(_ item:ShoppingItem,qty:String,cell:GroupedProductCell){

        if Int(qty)! > 1{

            if Int(qty)! <= item.numInStock{

                cell.btnQty.text        =   "\(Int(qty)! - 1)"
                item.selectedItemCount  =   Int(qty)! - 1
                //update price
                let newPrice            =   item.price * Double(item.selectedItemCount)
                cell.lblPrice.text      =   Utils.appendWithCurrencySym(newPrice)
            }
        }
    }
    func clickedOnAddToCart(_ item:ShoppingItem,qty:String,cell:GroupedProductCell){
        
        addToCart(item,cell.btnQty.text!)
    }
}
