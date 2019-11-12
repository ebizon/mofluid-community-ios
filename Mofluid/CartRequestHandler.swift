//
//  CartRequestHandler.swift
//  Mofluid
//
//  Created by Saurabh Mishra on 7/11/18.
//  Copyright © 2018 Mofluid. All rights reserved.
//

import Foundation
class CartRequestHandler{
    
    func isAlreadyAddedInCart(_ item : ShoppingItem)->(status:Bool,message:String){
        
        var status  =   false
        var message =   ""
        let cart : ShoppingCart = ShoppingCart.Instance
        if cart.isContainsItem(item){
            
            message = Settings().alreadyAddedInCart
            status  =   true
        }
        if !item.inStock {
            message =   Settings().outofStock
            status  =   true
        }
        return (status:status,message:message)
    }
    func getItemFromCart(completion:@escaping(_ response:AnyObject,_ isSuccess:Bool)->Void){
        
        let url = WebApiManager.Instance.getCartListUrl()
        ApiManager().getApi(url: url!) { (response,status) in
            
            if status{
                
                self.parseCartData((response as? NSArray)!)
                completion(response,true)
            }
            else{
                
                completion(NSNull(),false)
            }
        }
    }
    func parseCartData(_ products_list:NSArray){
        
       // if let products_list = dataDict["data"] as? NSArray{
            ShoppingCart.Instance.clear()
            for  item in products_list {
                let myItem = item as! NSDictionary
                if let quantityInCart = myItem["qty"] as? Int {
                    if let shoppingItem = createShoppingItemForCartList(myItem){
                        
                        ShoppingCart.Instance.allCartItemIds += [shoppingItem.id]
                        let type = myItem["product_type"] as! String
                        if type != "configurable"
                        {   
                            shoppingItem.setnumFromStock(quantityInCart)
                            ShoppingCart.Instance.addItemForCartSync(shoppingItem, num: quantityInCart)
                        }
                    }
                }
            }
        //}
    }
    func updateCartToServer(_ item:ShoppingItem,completion:@escaping(_ response:AnyObject,_ isSuccess:Bool)->Void){
        
        if Settings().isUserLoggedIn(){
            
            var url = WebApiManager.Instance.appendCustomerExt(WebApiManager.Instance.webServicesMap![Constants.addCartItem])!
            url = "\(url)&item_data=\(self.createJSONForUpdateCart(item))"
            ApiManager().getApi(url: url) { (response,status) in
                
            }
        }
        else{
            
        }
        /*
        if let _ = UserManager.Instance.getUserInfo(){
            let url = WebApiManager.Instance.getAddItemToServer(item)
            ApiManager().getApi(url: url!) { (response,status) in
              
                if status{
                    
                    completion(response,true)
                }
                else{
                    completion(NSNull(),false)
                }
            }
        }
        else{
            completion(NSNull(),false)
        }
 */
    }
    func cartUpdateBadge(_ tabBarController:UITabBarController){
        
            let tabArray = tabBarController.tabBar.items as NSArray?
            let tabItem = tabArray?.object(at: 3) as! UITabBarItem
            let cartCountValue = ShoppingCart.Instance.getNumDifferentItem()
            if cartCountValue > 0{
                tabItem.badgeValue = String(cartCountValue)
            }else{
                tabItem.badgeValue = nil
            }
    }
    func deleteItemFromCart(_ item:ShoppingItem){
        
        ShoppingCart.Instance.removeItemFromInstance(item)
        if let _ = UserManager.Instance.getUserInfo(){
            let url = WebApiManager.Instance.getDeleteFromCartUrl(String(item.id))
            ApiManager().getApi(url: url!) { (response,status) in
                
            }
        }
    }
    func addToCart(_ item:ShoppingItem,_ qty:Int,vc:UIViewController,tabBar:UITabBarController,completion:@escaping(_ response:AnyObject,_ isSuccess:Bool,_ message:String?)->Void){
        
        //1.validate the item
        let isValidate  =   self.isAlreadyAddedInCart(item)
        if isValidate.status{
            
            Helper().showAlert(vc, message: isValidate.message)
            completion(NSNull(),false,isValidate.message)
        }
        else{
            //2. add to local array
            ShoppingCart.Instance.addItemForCartSync(item, num: qty)
            //3. sync cart to server
            if Settings().isUserLoggedIn(){
                
                self.updateCartToServer(item) { (response, status) in
                    
                    if status{
                        
                        completion(response,true,nil)
                        CartRequestHandler().cartUpdateBadge(tabBar)
                        vc.view.makeToast(Settings().addToCart)
                    }
                    else{
                        
                        completion(NSNull(),false,Settings().errorMessage)
                    }
                }
            }
            else{
                
                CartRequestHandler().cartUpdateBadge(tabBar)
                vc.view.makeToast(Settings().addToCart)
                completion(NSNull(),true,nil)
            }
        }
    }
    //parse shopping item for cart
    func createShoppingItemForCartList(_ itemDict : NSDictionary)->ShoppingItem?{
        let parentId = itemDict["parentId"] as? String
        var shoppingItem : ShoppingItem? = nil
        let idStr = itemDict["item_id"] as? Int
        let specialPrice = itemDict["spclprice"] as? String
        let price =  itemDict["price"] as? Double
        let sku = itemDict["sku"] as? String ?? ""
        let name = itemDict["name"] as? String
        //let image = itemDict["imageurl"] as? String
        let imageDict   =   itemDict["image"] as? NSDictionary
        let image       =   imageDict?.value(forKey: "small_image") as? String
        let img1 = itemDict["img"] as? String
        var inStock = itemDict["is_in_stock"]as? Bool
        if inStock == nil{
            inStock = itemDict["is_in_stock"]as? String == "1" ? true : false
        }
        if let attribute = itemDict["option"] as? String{
            shoppingItem?.attributeString = attribute
        }
        
        let quantity = itemDict["qty"] as? Int
        let type = itemDict["product_type"] as? String ?? ""
        let totalNumInStock = itemDict["stock"] as? Int
        if idStr != nil && name != nil{
            let pid = Int(idStr!)
            shoppingItem = ShoppingItem(id: pid, name: name!, sku: sku, price: "\(price!)", specialPrice: specialPrice , inStock: inStock!, image: image, type: type , img1: img1)
            
            if quantity != nil{
                shoppingItem!.selctedNumFromStock   =   quantity!
                shoppingItem!.selectedItemCount     =   quantity!
            }
            
            if totalNumInStock != nil{
                shoppingItem!.totalNoInStock  =     Int(Utils.StringToDouble("\(totalNumInStock!)"))
                shoppingItem?.numInStock      =     Int(Utils.StringToDouble("\(totalNumInStock!)"))
            }
            if parentId != nil{
                shoppingItem?.parentId = Int(parentId!)!
            }
            if let customOptions = itemDict["product_option"] as? NSDictionary{
                
                shoppingItem?.customOptions=customOptions

            }
            StoreManager.Instance.cacheShoppingItem(shoppingItem)
        }
        if shoppingItem == nil{
            return nil
        }
        
        return shoppingItem
    }
    func createJSONForCart(_ item:ShoppingItem,options:(title:CustomOptionSet,selectedOption: CustomOption))->String{
        let dataDict = NSMutableDictionary()
        dataDict.setObject(item.sku, forKey: "sku" as NSCopying)
        dataDict.setObject("", forKey: "quote_id" as NSCopying)
        dataDict.setObject(item.selectedItemCount, forKey:"qty" as NSCopying)
        dataDict.setObject(item.type, forKey: "product_type" as NSCopying)
        let selectedOptionDic   =   ["optionId":options.title.id,"optionValue":options.selectedOption.id]
        let customOptions       =   ["customOptions":[selectedOptionDic]]
        let extensionDic        =   ["extensionAttributes":customOptions]
        dataDict.setValue(extensionDic, forKey: "productOption")
        return (Encoder.encodeBase64(dataDict))!
    }
    //temp
    func createJSONForUpdateCart(_ item:ShoppingItem)->String{
        let dataDict = NSMutableDictionary()
        dataDict.setObject(item.sku, forKey: "sku" as NSCopying)
        dataDict.setObject("", forKey: "quote_id" as NSCopying)
        dataDict.setObject(item.selectedItemCount, forKey:"qty" as NSCopying)
        dataDict.setObject(item.type, forKey: "product_type" as NSCopying)
        dataDict.setValue(item.customOptions, forKey: "productOption")
        return (Encoder.encodeBase64(dataDict))!
    }
    func addToCartForCustomProduct(_ item:ShoppingItem,vc:UIViewController,tabBar:UITabBarController,options:(title:CustomOptionSet,selectedOption: CustomOption),completion:@escaping(_ response:AnyObject,_ isSuccess:Bool,_ message:String?)->Void){
    
        //1.validate the item
        let isValidate  =   self.isAlreadyAddedInCart(item)
        if isValidate.status{
            
            Helper().showAlert(vc, message: isValidate.message)
            completion(NSNull(),false,isValidate.message)
        }
        else{
            //2. add to local array
            ShoppingCart.Instance.addItemForCartSync(item, num: 1)
            //3. sync cart to server
            if Settings().isUserLoggedIn(){
                
                var url = WebApiManager.Instance.appendCustomerExt(WebApiManager.Instance.webServicesMap![Constants.addCartItem])!
                url = "\(url)&item_data=\(self.createJSONForCart(item,options: options))"
                ApiManager().getApi(url: url) { (response,status) in
                    
                    if status{
                        
                        completion(response,true,nil)
                        CartRequestHandler().cartUpdateBadge(tabBar)
                        vc.view.makeToast(Settings().addToCart)
                    }
                    else{
                        completion(NSNull(),false,Settings().errorMessage)
                    }
                }
            }
            else{
                
                CartRequestHandler().cartUpdateBadge(tabBar)
                vc.view.makeToast(Settings().addToCart)
                completion(NSNull(),true,nil)
            }
        }
    }
    //
}
