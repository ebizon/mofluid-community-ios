//  ShoppingItem.swift
//  Mobilestic
//
//  Created by Ebizon-mac-2015 on 27/07/15.
//  Copyright © 2015 Ebizon Net Info Pvt Ltd. All rights reserved.
//

import Foundation

class ShoppingItem: NSObject{
    var attributeDict : [String : String] = [String : String]()
    var attributeString : String = String()
    var parentId : Int
    var id: Int
    let name: String
    fileprivate(set) var priceStr: String
    var image: String?
    var smallImg: String?
    fileprivate(set) var originalPriceStr: String? = nil
    fileprivate(set) var originalPrice = 0.0
    fileprivate(set) var price: Double = 0.0
    var inStock : Bool
    var numInStock : Int = 0
    var sku : String = ""
    var type: String = ""
    var color: String? = nil
    var manuFacturer: String? = nil
    var selctedNumFromStock : Int = 0
    var totalNoInStock: Int = 0
    var wishListId:Int=0
    var otherImages = [String]()
    var selectedItemCount = 1
    var productDesc:String?
    var customOptions:NSDictionary?
    fileprivate var _productShortDesc:String = ""
    var productShortDesc:String{
        set{
            if !newValue.isEmpty {
                _productShortDesc = newValue
            }
        }
        get{
            return _productShortDesc
        }
    }
    
    init?(id: Int, name: String, sku : String, price:String?, specialPrice: String?, inStock:Bool, image: String?, type: String , img1: String?) {
        self.id = id
        self.parentId = id
        self.sku = sku
        self.name = name
        self.inStock = inStock
        self.image = image ?? ""
        self.type = type
        self.smallImg = img1 ?? ""
        if self.inStock {
           self.numInStock = 1 //At least 1, exact quantity come in product detail page
        }
        
        if self.price <= 0.0{
            if price != nil{
                self.price = Utils.StringToDouble(price!)
                self.originalPriceStr = Utils.appendWithCurrencySym(self.price)
            }
        }
        
        if specialPrice != nil{
            let priceValue  = Utils.StringToDouble(specialPrice!)
            if priceValue > 0.0{
                self.originalPrice = self.price
                self.price = priceValue
            }
        }
        
        self.priceStr = Utils.appendWithCurrencySym(self.price)
        
        super.init()
        if self.image == ""{
            
            //check for image url ---> will removed completely after webapi update
            setImages()
        }
        if id <= 0 || name.isEmpty{
            return nil
        }
    }
    
    override var hash: Int {
        get {
            return self.id.hashValue //Unique id
        }
    }
    
    func isShowSpecialPrice()->Bool{
        let isHaveDiff = self.originalPrice > self.price
        
        return isHaveDiff
    }
    
    func createJSON()->NSMutableDictionary{
        let dataDict = NSMutableDictionary()
        
        dataDict.setObject(self.id, forKey: "id" as NSCopying)
        dataDict.setObject(self.sku, forKey: "sku" as NSCopying)
        dataDict.setObject(self.type, forKey: "type" as NSCopying)
        
        return dataDict
    }
    
    func createJSONForCart()->NSMutableDictionary{
        let dataDict = NSMutableDictionary()
        
        dataDict.setObject(self.sku, forKey: "sku" as NSCopying)
        dataDict.setObject("", forKey: "quote_id" as NSCopying)
        dataDict.setObject(self.selectedItemCount, forKey:"qty" as NSCopying)
        dataDict.setObject(self.type, forKey: "product_type" as NSCopying)
        
        return dataDict
    }

    func setnumFromStock(_ itemNo : Int){
        self.selctedNumFromStock = itemNo
        
        
    }
    
    func setImages(){
        if self.image == nil || self.image!.isEmpty || self.smallImg == nil || self.smallImg!.isEmpty{
            let url = WebApiManager.Instance.getImageURL(sku: self.sku)
            Utils.fillTheData(url, callback: processImage, errorCallback: showError)
        }
    }
    
    func processImage(dataDict : NSDictionary){
        self.image = dataDict["small_image"] as? String ?? ""
        self.smallImg = dataDict["thumbnail"] as? String ?? ""
    }
    
    func showError(){
        //Empty
    }
    
    func setSelectedItemCountValue(_ count:Int) -> Void {
        self.selectedItemCount = count
    }

}

func ==(lhs: ShoppingItem, rhs: ShoppingItem)-> Bool {
    return lhs.hashValue == rhs.hashValue
}
