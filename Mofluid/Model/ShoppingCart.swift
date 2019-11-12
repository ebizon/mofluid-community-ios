//
//  ShoppingCart.swift
//  Mofluid
//
//  Created by Ebizon-mac-2015 on 17/08/15.
//  Copyright © 2015 Ebizon Net. All rights reserved.
//

import Foundation

class ShoppingCart: NSObject, Sequence{
    
    static let ArchiveURL = Utils.DocumentsDirectory.appendingPathComponent("MofluidCart")
    var allCartItemIds = [Int]()
    
    static var Instance = ShoppingCart()
    
    fileprivate var cart:[ShoppingItem : Int] =  [ShoppingItem: Int]()
    fileprivate var stockMap: [ShoppingItem: Int] = [ShoppingItem: Int]()
    
    fileprivate(set) var coupon : String? = nil
    var shippingMethod : ShippingMethod? = nil
    var paymentMethod : PaymentMethod? = nil
    
    fileprivate override init(){
        super.init()
    }
    func reset(){
        
        ShoppingCart.Instance = ShoppingCart()
    }
    func makeIterator() -> DictionaryIterator<ShoppingItem, Int>{
        return self.cart.makeIterator()
    }
    
    func findItemByHash(_ itemHash : Int)->ShoppingItem?{
        let item = self.cart.keys.filter({$0.hashValue == itemHash}).first
        
        return item
    }
    
    func addItem(item:ShoppingItem){
        self.addItem(item, num:1)
    }
    
    func addItem(_ item:ShoppingItem, num:Int, minCount : Int = 1){
        
        //item.totalNoInStock = item.numInStock
        var finalVal = num
        if let val=cart[item]{
            finalVal = finalVal + val
        }else{
            self.stockMap[item] = item.numInStock
        }
        
        finalVal = Swift.max(minCount, finalVal)
        
        if finalVal <= self.getMaxAllowed(item){
            self.cart[item] = finalVal
        }else{
            self.cart[item] = self.getMaxAllowed(item)
        }
        
        updateToServerCart(productId: String(item.id), count: finalVal)
        
        self.cartChanged()
    }
    func addItemForCartSync(_ item:ShoppingItem, num:Int, minCount : Int = 1){
        
        item.totalNoInStock = item.numInStock
        var finalVal = num
        if let val=cart[item]{
            finalVal = finalVal + val
        }else{
            self.stockMap[item] = item.numInStock
        }
        
        finalVal = Swift.max(minCount, finalVal)
        
        if finalVal <= self.getMaxAllowed(item){
            self.cart[item] = finalVal
        }else{
            self.cart[item] = self.getMaxAllowed(item)
        }
        self.cartChanged()
    }
    func updateToServerCart(productId : String, count : Int){
        assert(count > 0)
        
        if let _ = UserManager.Instance.getUserInfo(){
            let url = WebApiManager.Instance.getUpdateCartUrl()
            Utils.fillTheData(url, callback: cartCallback, errorCallback:  showError)
        }
    }
    
    
    func removeFromServerCart(productId : String){
        if let _ = UserManager.Instance.getUserInfo(){
            let url = WebApiManager.Instance.getDeleteFromCartUrl(productId)
            Utils.fillTheData(url, callback: cartCallback, errorCallback:  showError)
        }
    }
    
    func cartCallback(dict : NSDictionary){
        
    }
    
    func showError(){
    }
    
    func loadServerCart(){
        let url = WebApiManager.Instance.getCartListUrl()
        Utils.fillTheDataFromArray(url, callback: processCart, errorCallback: showError)
    }
    
    func processCart(items : NSArray){
        items.forEach {item in
            if let itemDict = item as? NSDictionary{
            let id              =       itemDict["item_id"] as! Int
            let sku             =       itemDict["sku"] as! String
            let qty             =       itemDict["qty"] as! Int
            let name            =       itemDict["name"] as! String
            let price           =       itemDict["price"] as! Double
            var numberInStock   =       0
            if let stock        =       itemDict["stock"] as? Int{
                
                numberInStock   =       stock
            }
            let productType     =       itemDict["product_type"] as! String
                
            if let shoppingItem = ShoppingItem(id: id, name: name, sku: sku, price: String(price), specialPrice: "0.0", inStock: true, image: nil, type: productType, img1: nil){
                    shoppingItem.sku            =   sku
                    shoppingItem.numInStock     =   numberInStock
                    if numberInStock > 0{
                        
                        shoppingItem.inStock    =   true
                    }
                    self.cart[shoppingItem]     =   qty
                }
            }
        }
        self.cartChanged()
    }
    
    func getMaxAllowed(_ item: ShoppingItem)->Int{
        var numInStock = item.numInStock
        if let stockHere = stockMap[item]{
            numInStock = Swift.max(numInStock, stockHere)
        }
        return numInStock
    }
    
    func deleteItem(_ item: ShoppingItem){
        self.cart.removeValue(forKey: item)
        
        if self.isEmpty(){
            self.coupon = nil
        }
        removeFromServerCart(productId: String(item.id))
        self.cartChanged()
    }
    func removeItemFromInstance(_ item:ShoppingItem){
        
        self.cart.removeValue(forKey: item)
        if self.isEmpty(){
            self.coupon = nil
        }
    }
    func getTotalCount()->Int{
        var count = 0
        for(_, val) in self.cart{
            count += val
        }
        
        return count
    }
    
    func getCount(_ item:ShoppingItem)->Int{
        var count = 0
        if let val = self.cart[item]{
            count = val
        }
        
        return count
    }
    
    func getNumDifferentItem()->Int{
        return self.cart.count
    }
    
    func getSubTotal(_ item:ShoppingItem)->Double{
        var subTotal = 0.0
        
        if let val = cart[item]{
            subTotal = Double(val) * item.price
        }
        
        return subTotal
    }
    
    func getSubTotal()->Double{
        var subTotal = 0.0
        
        for (item, _) in self.cart{
            subTotal += self.getSubTotal(item)
        }
        
        return subTotal
    }
    
    func getTotalWithDiscount()->Double{
        var total = self.getSubTotal()
        total += self.getDiscount()
        return total
    }
    
    func getTotalWithShipping()->Double{
        var total = self.getTotalWithDiscount()
        total +=  self.getTaxAmount()
        total += self.getShippingCharge()
        
        return total
    }
    
    func getShippingCharge()->Double{
        return  self.shippingMethod?.price ?? 0.0
    }
    
    func getTaxAmount()->Double{
        return self.shippingMethod?.tax ?? 0.0
    }
    
    func applyCoupon(_ coupon:String?){
        self.coupon = coupon
    }
    
    func getCouponURL(_ coupon : String?)->String?{
        var serviceURL : String? = nil
        
        var url = WebApiManager.Instance.getCheckOutURL()
        
        if let data = self.createJSON(){
            url = WebApiManager.Instance.appendCouponExt(url, coupon: coupon)
            url = WebApiManager.Instance.appendProductExt(url, data: data)
        }
        if let addressEncode = WebApiManager.Instance.getBillingShippingEncoded(){
            serviceURL = url! + "&address=" + addressEncode + "&is_create_quote=0&find_shipping=1"
        }
        
        return serviceURL
    }
    
    func refreshCart(){
        self.coupon = nil
    }
    
    func getSyncCartEncodedJson()->String?{
        var encodedJson : String? = nil
        
        for (item, val) in self.cart{
            
            var qt=val
            if val==0{
                
                qt=1
            }
            let dataDict = self.createCartJSON(item, qty: qt)
            encodedJson = Encoder.encodeBase64(dataDict)
        }
        return encodedJson
    }
    func getLastProductEncodedJson(_ item:ShoppingItem)->String?{
        
        let dataDict = self.createCartJSON(item, qty: item.selectedItemCount)
        return Encoder.encodeBase64(dataDict)
    }
    func getPlaceOrderURL()->String?{
        var placeURL : String? = nil
        
        if let url = WebApiManager.Instance.getPlaceOrderURL(){
            if let data = self.createJSON(){
                if let encoded = Encoder.encodeBase64(data){
                    var ext = ""
                    if coupon != nil{
                        ext +=  "&couponCode=" + coupon!
                    }
                    placeURL = url + ext + "&products=\(encoded)"
                }
            }
        }
        
        return placeURL
    }
    
    fileprivate func fetchDiscount()->Double{
        var discount = 0.0
        
        if let url = self.getCouponURL(self.coupon){
            if let data = WebApiManager.Instance.getJSON(url){
                if let dataDict = Utils.parseJSON(data){
                    if let couponStatus = dataDict["coupon_status"] as? Int{
                        if couponStatus == 1{
                            if let disc = dataDict["coupon_discount"] as? String{
                                discount = Utils.StringToDouble(disc)
                            }
                        }
                    }
                }
                
            }
        }
        
        return discount
    }
    
    func getDiscount()->Double{
        var discount = 0.0
        
        if let coupn = self.coupon{
            if !coupn.isEmpty{
                discount = self.fetchDiscount()
            }
        }
        
        if getTotalCount() == 0{
            discount = 0.0
        }
        
        return discount
    }
    func getAllProducts()->[ShoppingItem]{
        
        var returnValue=[ShoppingItem]()
        for item in cart{
            
            returnValue.append(item.key)
        }
        return returnValue
    }

    func getDiscountStr()->String{
        let discount = abs(self.getDiscount())
        let discountStr = "-" + Utils.appendWithCurrencySym(discount)
        
        return discountStr
    }
    
    func isEmpty()->Bool{
        return self.cart.count <= 0
    }
    
    func clear(){
        self.cart.removeAll()
        self.coupon = nil
        self.cartChanged()
    }
    
    func createJSON()->Data?{
        let data : NSMutableArray = NSMutableArray()
        
        for (item, val) in self.cart{
            let dataDict = self.createJSON(item, qty: val)
            
            if dataDict.count > 0{
                data.add(dataDict)
            }
        }
        
        let jsondData = Encoder.createJSON(data)
        
        return jsondData
    }
    
    func createJSON(_ item : ShoppingItem, qty : Int)->NSDictionary{
        let dataDict = item.createJSON()
        
        dataDict.setObject(qty, forKey: "quantity" as NSCopying)
        
        if(itemType == "downloadable")
        {
            
            dataDict.setObject(download_link_list[item.name]!, forKey: "down_link_options" as NSCopying)
            
        }
        
        return dataDict
    }
 
    func createCartJSON(_ item : ShoppingItem, qty : Int)->NSDictionary{
        let dataDict = item.createJSONForCart()
        
        dataDict.setObject(qty, forKey: "qty" as NSCopying)
        
        return dataDict
    }
    
    
    func getTempCart()->ShoppingCart{
        return ShoppingCart()
    }
    
    func cartChanged(){
        NotificationCenter.default.post(name: Notification.Name(rawValue: "cartChanged"), object: nil)
    }
    
    func isContainsItem(_ item:ShoppingItem) -> Bool {
        if let item = self.cart.keys.filter({$0.id == item.id}).first {
            print(item.id)
            return true
        }else{
            return false
        }
    }
}
