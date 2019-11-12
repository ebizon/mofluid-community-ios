//
//  StoreManager.swift
//  Mofluid
//
//  Created by MANISH on 03/08/16.
//  Copyright © 2016 Mofluid. All rights reserved.
//

import Foundation
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class StoreManager: NSObject {
    /********************************************************************************/
    static var Instance : StoreManager = StoreManager()
    fileprivate var shoppingItemsMap:[Int : ShoppingItem] = [Int :ShoppingItem]()
    var storeDetail:StoreDetail = StoreDetail()
    /********************************************************************************/
    
    fileprivate override init(){
        super.init()
    }
    
    /********************************************************************************/
    func isShoppingItemsFound()->Bool{
        return shoppingItemsMap.count > 0
    }
    /********************************************************************************/
    
    func cacheShoppingItem(_ item: ShoppingItem?){
        if item != nil{
            self.shoppingItemsMap[item!.id] = item!
        }
    }
    
    /********************************************************************************/
    func getShoppingItem(_ id: Int)->ShoppingItem?{
        return self.shoppingItemsMap[id]
    }
    /********************************************************************************/
    func reset(){
        
        StoreManager.Instance = StoreManager()
    }
    /********************************************************************************/
    func createWishListShoppingItem(_ itemDict : NSDictionary,itemId:String)-> ShoppingItem?{
        var shoppingItem : ShoppingItem? = nil
        let idStr   =   itemDict["entity_id"] as? String
        let name    =   itemDict["name"] as? String
        let image   =   Config.Instance.getRawBaseUrl() + "/pub/media/catalog/product/" + (itemDict["image"] as? String)!
        let price   =   itemDict["price"] as? String
        let sku     =   itemDict["sku"] as? String
        let type    =   itemDict["type_id"] as? String
        if idStr != nil && name != nil{
            let pid = Int(idStr!)
            shoppingItem = ShoppingItem(id: pid!, name: name!, sku: sku!, price: price, specialPrice: nil, inStock : false, image: image, type: type! , img1: nil)
            shoppingItem?.wishListId=Int(itemId)!
            shoppingItem?.inStock = true
            StoreManager.Instance.cacheShoppingItem(shoppingItem)
        }
        
        if shoppingItem == nil{
            self.alert("Creating WishList Shopping Item is Empty")
            return nil
        }
        
        return shoppingItem!
    }

    func createShoppingItem(_ itemDict : NSDictionary)->ShoppingItem?{
        var shoppingItem : ShoppingItem? = nil
        let idStr = itemDict["id"] as? String
        
        let specialPrice = itemDict["special_price"] as? String
        let price =  itemDict["price"] as? String
        let img = itemDict["img"] as? String ?? "" // ankur test
        let name = itemDict["name"] as? String
        let image = itemDict["image"] as? String
        let type = itemDict["type"] as? String ?? ""
        let inStock = itemDict["is_stock_status"]as? String == "1" ? true : false
        let sku = itemDict["sku"] as? String ?? ""
        
        if idStr != nil && name != nil{
            let pid = Int(idStr!)
            shoppingItem = ShoppingItem(id: pid!, name: name!, sku : sku, price: price, specialPrice: specialPrice, inStock:inStock, image: image, type: type , img1: img)
            
            StoreManager.Instance.cacheShoppingItem(shoppingItem)
        }
        if shoppingItem == nil{
            self.alert("Creating Shopping Item is Empty")
            return nil
        }
        
        return shoppingItem
    }
    
    /********************************************************************************/
    func createGroupedShoppingItem(_ itemDict: NSDictionary)->ShoppingItem?{
        var shoppingItem : ShoppingItem? = nil
        var idStr = itemDict["id"] as? String
        if idStr == nil {
            idStr = itemDict["product_Id"] as? String
        }
        var price:String?
        var specialPrice:String?
        var name:String?
        var image:String?
        var sku:String?
        var quantity:String?
        var inStock:Bool?
        var img1 : String? //ankur test
        if let imagesArrayStr = itemDict["image"] as? String {
            image = imagesArrayStr
        }
        
        if let imagesArrayStr = itemDict["img"] as? NSArray{   // ankur test
            if let imgStr = imagesArrayStr.firstObject as? String{
                img1 = imgStr
            }
            
        }
        
        if let NameData = itemDict["general"] as? NSDictionary{
            sku = NameData["sku"] as? String
            name =  NameData["name"] as? String
        }
        
        if sku == nil {
            sku = itemDict["sku"] as? String
        }
        
        if name == nil {
            name = itemDict["product_name"] as? String
        }
        
        if let priceData = itemDict["price"] as? NSDictionary{
            price = String(Double(priceData["regular"] as! Int))
            specialPrice =  String(Double(priceData["final"] as! Int))
        }
        
        if price == nil {
            price = itemDict["price"] as? String
        }
        
        if specialPrice == nil {
            specialPrice = itemDict["sprice"] as? String
        }
        
        inStock = false
        quantity = itemDict["quantity"] as? String
        inStock =  Utils.stringToInt(itemDict["isInStock"] as? String ?? "0")  == 1 ? true : false
        
        if quantity == nil {
            quantity = String(itemDict["maxsQty"] as! Int)
        }
        
        if idStr != nil && name != nil && price != nil && specialPrice != nil{
            let pid = Int(idStr!)
            shoppingItem = ShoppingItem(id: pid!, name: name!, sku: sku!, price: price, specialPrice: specialPrice, inStock:inStock!, image: image, type: "grouped" , img1: img1)
            
            if shoppingItem != nil{
                if let qty = quantity{
                    shoppingItem!.numInStock =  Int(Utils.StringToDouble(qty))
                }
                shoppingItem?.smallImg = image
                StoreManager.Instance.cacheShoppingItem(shoppingItem)
            }
        }
        
        return shoppingItem
    }
    
    func createFilterShoppingItem(_ itemDict:NSDictionary)->ShoppingItem?{
        
        var shoppingItem    :   ShoppingItem?   =   nil
        let idStr = itemDict["id"] as? Int
        let price =  itemDict["price"] as? Double
        
        let name = itemDict["name"] as? String
        //let image = itemDict["imageurl"] as? String
       // let inStock = itemDict["is_in_stock"]as? String == "1" ? true : false
        //let color = itemDict["color"] as? String
        //let manufact = itemDict["cat_name"] as? String
        let type = itemDict["type_id"] as? String ?? ""
        //let img1 = itemDict["img"] as? String
        let sku = itemDict["sku"] as? String
        
        if name != nil{
            // let pid = Int(idStr!)
            shoppingItem = ShoppingItem(id: idStr!, name: name!, sku: sku!, price: "\(price!)", specialPrice: "\(price!)" , inStock: true, image: "", type: type , img1: "")
            //shoppingItem?.color = color
            //shoppingItem?.manuFacturer = manufact
            StoreManager.Instance.cacheShoppingItem(shoppingItem)
        }
        if shoppingItem == nil{
            self.alert("Creating Product List Shopping Item is Empty")
            return nil
        }
        return shoppingItem
    }
    
    func createShoppingAccessory(_ itemDict : NSDictionary)->ShoppingItem?{
        var shoppingItem : ShoppingItem? = nil
        let idStr = itemDict["id"] as? Int ?? 0
        let specialPrice = itemDict["spclprice"] as? String
        let price =  itemDict["price"] as? Double
        let name = itemDict["name"] as? String
        let image = itemDict["imageurl"] as? String
        let inStock = itemDict["is_in_stock"]as? String == "1" ? true : false
        let color = itemDict["color"] as? String
        let manufact = itemDict["cat_name"] as? String
        let type = itemDict["type_id"] as? String ?? ""
        let img1 = itemDict["img"] as? String
        let sku = itemDict["sku"] as? String
        if name != nil && sku != nil && price != nil {
           // let pid = Int(idStr!)
            shoppingItem = ShoppingItem(id: idStr, name: name!, sku: sku!, price: String(price!), specialPrice: specialPrice, inStock:inStock, image: image, type: type , img1: img1)
            shoppingItem?.color = color
            shoppingItem?.manuFacturer = manufact
            StoreManager.Instance.cacheShoppingItem(shoppingItem)
        }
        if shoppingItem == nil{
            self.alert("Creating Product List Shopping Item is Empty")
            return nil
        }
        return shoppingItem
    }
    func createShoppingAccessoryForSearch(_ itemDict : NSDictionary)->ShoppingItem?{
        var shoppingItem : ShoppingItem? = nil
        let idStr = itemDict["id"] as? String ?? ""
        let specialPrice = itemDict["spclprice"] as? String
        let price =  itemDict["price"] as? String
        
        let name = itemDict["name"] as? String
        let image = itemDict["imageurl"] as? String
        let inStock = itemDict["is_in_stock"] as? String == "1" ? true : false
        let color = itemDict["color"] as? String
        let manufact = itemDict["cat_name"] as? String
        let type = itemDict["type"] as? String ?? ""
        let img1 = itemDict["img"] as? String
        let sku = itemDict["sku"] as? String
        
        if name != nil{
            // let pid = Int(idStr!)
            shoppingItem = ShoppingItem(id: Int(idStr)!, name: name!, sku: sku!, price: String(price!), specialPrice: specialPrice, inStock:inStock, image: image, type: type , img1: img1)
            
            shoppingItem?.color = color
            shoppingItem?.manuFacturer = manufact
            StoreManager.Instance.cacheShoppingItem(shoppingItem)
        }
        if shoppingItem == nil{
            self.alert("Creating Product List Shopping Item is Empty")
            return nil
        }
        
        
        return shoppingItem
    }
    func createReorderDataItems(_ item: NSDictionary)->ShoppingItem?{
        var addToCartItem : ShoppingItem? = nil
        let idStr = item["id"] as? String
        let id = Int(Utils.StringToDouble(idStr!))
        let name = item["name"] as? String
        let specialPriceInt = item["sprice"] as? Int ?? 0
        let specialPrice = Utils.DoubleToString(Double(specialPriceInt))
        let price =  item["price"] as? String
        let sku = item["sku"] as? String
        var quantity: Int? = 0
        let image = item["image"] as? String
        let type = item["type"] as? String ?? ""
        if let quan = item["quantity"] as? NSDictionary{
            if let available = quan["available"] as? String{
                quantity = Int(Utils.StringToDouble(String(available)))
            }
        }
        
        let inStock = quantity > 0
        
        if(idStr != nil && name != nil){
            addToCartItem = ShoppingItem(id: id, name: name!, sku: sku!, price: price, specialPrice: specialPrice, inStock:inStock, image: image, type: type ,  img1: image)
            addToCartItem?.numInStock = quantity!
            
            StoreManager.Instance.cacheShoppingItem(addToCartItem)
        }
        if addToCartItem == nil{
            self.alert("Reorder Shopping Item is Empty")
            return nil
        }
        
        return addToCartItem
    }
    // mahesh start
    func createShoppingAccessoryForCartList(_ itemDict : NSDictionary)->ShoppingItem?{
        let parentId = itemDict["parentId"] as? String
        var shoppingItem : ShoppingItem? = nil
        let idStr = itemDict["item_id"] as? Int
        let specialPrice = itemDict["spclprice"] as? String
        let price =  itemDict["price"] as? Int
        let sku = itemDict["sku"] as? String ?? ""
        let name = itemDict["name"] as? String
        let image = itemDict["imageurl"] as? String
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
                shoppingItem!.selctedNumFromStock  = quantity!
            }
            
            if totalNumInStock != nil{
                shoppingItem!.totalNoInStock  =     Int(Utils.StringToDouble("\(totalNumInStock!)"))
                shoppingItem?.numInStock      =     Int(Utils.StringToDouble("\(totalNumInStock!)"))
            }
            if parentId != nil{
              shoppingItem?.parentId = Int(parentId!)!
            }
            StoreManager.Instance.cacheShoppingItem(shoppingItem)
        }
        
        if shoppingItem == nil{
            self.alert("Creating Shopping Item is Empty")
          return nil
        }
        
        return shoppingItem
    }
  // mahesh end
    
    func alert(_ text:String){
        Utils.showAlert(text)
    }
}
