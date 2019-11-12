//
//  WebApiManager.swift
//  Mobilestic
//
//  Created by Ebizon-mac-2015 on 04/08/15.
//  Copyright © 2015 Ebizon Net. All rights reserved.
//

import Foundation

class WebApiManager: NSObject {
    /********************************************************************************/
    static var Instance : WebApiManager = WebApiManager()
    fileprivate var shoppingItemsMap:[Int : ShoppingItem] = [Int :ShoppingItem]()
    var webServicesMap:[String: String]? = nil
    /********************************************************************************/
    
    fileprivate override init(){
        super.init()
        
        self.loadWebServicesConfig()
        
        if self.webServicesMap == nil{
            ErrorHandler.Instance.showError(Constants.GenericError)
        }
    }
    func reset(){
        
        WebApiManager.Instance = WebApiManager()
    }
    func getTokenUrl()-> String{
        let url = Config.Instance.getURl() + "service=" + Constants.gettoken + "&authappid=12345"
        return url
    }
    
    func refreshURL(){
        self.loadWebServicesConfig()
    }

    func getFeatureProductsURL()->String?{
        return self.appendCustomerExt(self.webServicesMap![Constants.FeaturedProduct])
    }
    func getProductStockURL()->String?{
        return self.appendCustomerExt(self.webServicesMap![Constants.getProductStock1])
    }
    
    func getBestsellerProductsURL()->String?{
        return self.appendCustomerExt(self.webServicesMap![Constants.BestsellerProducts])
    }
    
    func getRelatedProductURL(_ id:Int)-> String? {
        var url = self.appendCustomerExt(self.webServicesMap![Constants.related_products])
        
        if url != nil{
            url = url! + "&product_id=\(String(id))"
        }
        
        return url
    }
    
    func getCMSPageUrl(_ pageId : Int)->String?{
        var url = self.appendCustomerExt(self.webServicesMap![Constants.getallCMSPages])
        
        if url != nil{
            url = url! + "&pageId=\(String(pageId))"
        }
        
        return url
        
    }
    
    func getSubmitReviewUrl(_ productId:String,QualityRate:String,valueRate:String,priceRate:String,reviewSummary:String,thoughts:String,nickName:String)->String?{
        var url = ""
        
        if let baseURL = Config.Instance.getDiffirentBaseURL(){
            url = url + baseURL + Constants.addProductReview + "&store=1"
            
        }
        if(UserDefaults.standard.bool(forKey: "isLogin")){
            var custId = ""
            if UserManager.Instance.getUserInfo() !=  nil{
                custId = String(UserManager.Instance.getUserInfo()!.id)
            }
            url = url + "&productid=\(productId)" + "&customerid=\(custId)" + "&nickname=\(nickName)" + "&pricerating=\(priceRate)" + "&valuerating=\(valueRate)" + "&qualityrating=\(QualityRate)" + "&reviewsummary=\(reviewSummary)" + "&comment=\(thoughts)"
        }
        
        return url
    }
    
    func getProductReviewUrl(_ id : Int)->String?{
        var url = ""
        
        if let baseURL = Config.Instance.getDiffirentBaseURL(){
            url = url + baseURL + Constants.getProductReviewUrl
        }
        
        url = url + "&productid=\(String(id))"
        
        return url
    }
    
    func getNewProductsURL()->String?{
        return self.appendCustomerExt(self.webServicesMap![Constants.NewProduct])
    }
    
    func getCategoryProductsURL()->String?{
        return self.appendCustomerExt(self.webServicesMap![Constants.CategoryProduct])
    }
    
    func getCategoryNavigatorURL()->String?{
        return self.appendCustomerExt(self.webServicesMap![Constants.CategoryNavigator])
    }
    
    func getLoginAccessURL()->String?{
        return self.webServicesMap![Constants.LoginAccess]
    }
    
    func getForgotPasswordURL()->String?{
        return self.webServicesMap![Constants.ForgotPassword]
    }
    
    func getCreateUserURL()->String?{
        return self.webServicesMap![Constants.CreateUser]
    }
    
    func getCheckOutURL()->String?{
        return self.appendCustomerExt(self.webServicesMap![Constants.CheckOut])
    }
    
    func getSearchURL(_ searchText: String , pagesize:Int, currentPage:Int)->String?{
        var url = self.appendCustomerExt(self.webServicesMap![Constants.SearchData])
        
        url = self.appendUTFEncodeSearch(url, searchText: searchText)
        url = url!  + "&pagesize=\(String(pagesize))" + "&currentpage=\(String(currentPage))" as String?
        return url
    }
    
    func getImageURL(sku : String)->String?{
        var url = self.appendCustomerExt(self.webServicesMap![Constants.GetImage])
        if(url != nil){
            url = "\(url!)&sku=\(sku)"
        }
        
        return url
    }
    
    func getPlaceOrderURL()->String?{
        return self.appendCustomerExt(self.webServicesMap![Constants.PlaceOrder])
    }
    
    func getMyOrderURL()->String?{
        return self.appendCustomerExt(self.webServicesMap![Constants.MyOrder])
    }
    
    func getAddressListURL()->String?{
        return self.appendCustomerExt(self.webServicesMap![Constants.addressList])
    }
    
    func getBillingAddressURL()->String?{
        return self.appendCustomerExt(self.webServicesMap![Constants.getBillingAddress])
    }
    
    func getShippingAddressURL()->String?{
        return self.appendCustomerExt(self.webServicesMap![Constants.getShippingAddress])
    }
    
    func getCountryListURL()->String?{
        return self.webServicesMap![Constants.CountryList]
    }
    
    func getStateListURL(_ countryCode: String)->String?{
        var url = self.webServicesMap![Constants.StateList]
        
        if url != nil{
            url = url! + "&country=\(countryCode)"
        }
        
        return url
    }
    
    func changePasswordURL()->String?{
        return self.appendCustomerExt(self.webServicesMap![Constants.changePassword])
    }
    
    /********************************************************************************/
    
    func getStoreDetailURL()->String?{
        return self.appendCustomerExt(self.webServicesMap![Constants.StoreDetail])
    }
    
    /********************************************************************************/
    
    func appendUTFEncodeSearch(_ url: String?, searchText: String)->String?{
        var serviceURL = url
        
        if serviceURL != nil{
            //if let searchText = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics){
                let search = Encoder.encodeBase64(searchText)
                serviceURL = serviceURL! + "&search_data=\(search)"
           // }
        }
        return serviceURL
    }
    
    func imageUrl(_ id : Int, type:String, width:Int,height:Int,store:Int)->String?{
        var url = self.appendCustomerExt(self.webServicesMap![Constants.ImageVal])
        
        if url != nil{
            url = url! + "&id=\(Int(id))" + "&type=\(String(describing: String(type)))" + "&width=\(Int(width))" + "&height=\(Int(height))" + "&store=\(Int(store))"
        }
        return url
    }
    
    func getAccessurl(_ id : Int, pagesize:Int, currentPage:Int)->String?{
        var url = self.appendCustomerExt(self.webServicesMap![Constants.getProductCategory])
        
        if url != nil{
            url = url! + "&categoryid=\(String(id))" + "&pagesize=\(String(pagesize))" + "&currentpage=\(String(currentPage))" + "&filterdata=null"
        }
        return url
    }
    
    func getProductFilterAttribute(_ catId : String)->String?{
        var url = self.appendCustomerExt(self.webServicesMap![Constants.getFilter])
        
        if url != nil{
            url = url! + "&categoryid=\(String(describing: String(catId)))"
        }
        
        return url
    }
    
    func getProductSearchFilterAttribute(_ searchText : String)->String?{
        var url = self.appendCustomerExt(self.webServicesMap![Constants.searchFilter])
        url = self.appendUTFEncodeSearch(url, searchText: searchText)
        
        return url
    }
    
    func getProductFilterList(_ catid : String, filterData:String , pagesize:Int, currentPage:Int)->String?{
        //var url = self.appendCustomerExt(self.webServicesMap![Constants.filter])
        var url = self.appendCustomerExt(self.webServicesMap![Constants.getProductCategory])
        if url != nil{
            url = url! + "&categoryid=\(String(describing: String(catid)))" + "&filterdata=\(filterData)" + "&pagesize=\(String(pagesize))" + "&currentpage=\(String(currentPage))"
        }
        
        return url
    }
    
    func getSearchProductFilterList(_ searchText : String, filterData:String , pagesize:Int, currentPage:Int)->String?{
        var url = self.appendCustomerExt(self.webServicesMap![Constants.getProductCategory])
        
        url = self.appendUTFEncodeSearch(url, searchText: searchText)
        url = url!  + "&pagesize=\(String(pagesize))" + "&currentpage=\(String(currentPage))" +  "&filterdata=\(filterData)" as String?
        return url
    }
    
    func getAddWishlistItemUrl(_ productId:String)->String?{
        var url = ""
        
        if let baseURL = Config.Instance.getBaseURL(){
            url = url + baseURL + "addtoWishlist"
        }
        
        if UserManager.Instance.getUserInfo() != nil {
            let custId : String = String(UserManager.Instance.getUserInfo()!.id)
            
            url = url + "&customerid=\(custId)" + "&pid=\(productId)"
        }
        
        return url
    }
    
    func getDeleteProductFromWishlistUrl(_ productId:String)->String?{
        var url = ""
        
        if let baseURL = Config.Instance.getBaseURL(){
            url = url + baseURL + "removefromWishlist"
            
        }
        if UserManager.Instance.getUserInfo() != nil{
            let custId : String = String(UserManager.Instance.getUserInfo()!.id)
            
            url = url + "&customerid=\(custId)" + "&itemid=\(productId)"
        }
        
        return url
    }
    
    func getWishlistDataUrl()->String?{
        var url = ""
        
        if let baseURL = Config.Instance.getBaseURL(){
            url = url + baseURL + Constants.getWishlist
        }
        if(UserDefaults.standard.bool(forKey: "isLogin")){
            var custId = ""
            if UserManager.Instance.getUserInfo() != nil{
                custId =  String(UserManager.Instance.getUserInfo()!.id)
            }
            url = url + "&customerid=\(custId)"
        }
        
        return url
    }
    func billService(_ url:String,addData:String,emailData:String)-> String{
        let serviceUrl = url+"&billaddress=\(addData)&shippaddress=&profile=\(emailData)&shipbillchoice=billingaddress"
        
        return serviceUrl
    }
    func getUpdateProfileURL()->String?{
        return self.appendCustomerExt(self.webServicesMap![Constants.UpdateProfile])
    }
    func getUrlForCategory()->String?{
        var baseURL = Config.Instance.getURl()
        baseURL.remove(at: baseURL.index(before: baseURL.endIndex))
        let url = baseURL + Constants.staoreinfo
        return url
    }
    
    func getAccessoryUrl(_ id : Int)->String?{
        var url = self.appendCustomerExt(self.webServicesMap![Constants.Accessories])
        
        if url != nil{
            url = url! + "&categoryid=\(String(id))"
        }
        
        return url
    }
    
    func getSubCategoryUrl(_ id : Int)->String?{
        var url = self.appendCustomerExt(self.webServicesMap![Constants.SubCategory])
        
        if url != nil{
            url = url! + "&categoryid=\(String(id))"
        }
        
        return url
    }
    
    func getSocialLoginUrl()->String?{
        return self.webServicesMap![Constants.LoginWithSocial]
    }
    
    func getReorderURL()->String?{
        return self.webServicesMap![Constants.Reorder]
    }
    
    func appendCustomerExt(_ url : String?)->String?{
        var appendedURL = url
        
        if appendedURL != nil{
            if let userLogged = UserManager.Instance.getUserInfo(){
                appendedURL = appendedURL! + "&customerid=\(userLogged.id)"
            }
        }
        return appendedURL
    }
    
    func appendCouponExt(_ url:String?, coupon : String?)->String?{
        var appendedURL = url
        
        if appendedURL != nil{
            if coupon != nil{
                appendedURL = appendedURL! + "&couponCode=\(coupon!)"
            }
        }
        
        return appendedURL
    }
    
    func appendProductExt(_ url: String?, data: Data)->String?{
        var appendedURL = url
        
        if let encoded = Encoder.encodeBase64(data){
            appendedURL = appendedURL! + "&products=\(encoded)"
        }
        
        return appendedURL
    }
    
    func getPaymentMethodsURL()->String?{
        return self.webServicesMap![Constants.PaymentMethods]
    }
    
    func getCheckOutAndPaymentMethodsURL() -> String?{
        assert(self.appendCustomerExt(self.webServicesMap![Constants.CheckOutAndPaymentMethods]) != nil)
        var url =  self.appendCustomerExt(self.webServicesMap![Constants.CheckOutAndPaymentMethods])!
        
        if let shipMethod = ShoppingCart.Instance.shippingMethod{
            url = "\(url)&shipmethod=\(shipMethod.id)&shipcarrier=\(shipMethod.code!)"
        }
        
        return url
    }
    
    func getMyDownloadsURL()->String?{
        return self.appendCustomerExt(self.webServicesMap![Constants.MyDownloads])
    }
    
    func getDownloadableShippingURL(_ cart : ShoppingCart)->String?{
        var serviceURL : String? = nil
        
        if let url = cart.getCouponURL(cart.coupon){
            if let addressEncode =  getBillingShippingEncoded(){
                serviceURL = url + "&address=" + addressEncode + "&is_create_quote=0&shipmethod=Select&theme=modern"
            }
        }
        return serviceURL
    }
    
    /********************************************************************************/
    func getGroupedProduct(_ sku:String)->String{

        let url = self.appendCustomerExt(self.webServicesMap![Constants.getGroupedProductDetail])
        return url! + "&sku=\(sku)"
    }
    func getDescUrl(_ id : Int, type: String)->String?{
        var url = self.appendCustomerExt(self.webServicesMap![Constants.ProductDetail])
        
        if(type == "grouped"){
            url = self.appendCustomerExt(self.webServicesMap![Constants.ProductDetailGrouped])
        }
        
        if url != nil{
            url = url! + "&productid=\(String(id))"
        }
        
        return url
    }
    
    func getDescImgsUrl(_ id : Int)->String?{
        var url = self.appendCustomerExt(self.webServicesMap![Constants.ProductDetailImages])
        
        if url != nil{
            url = url! + "&productid=\(String(id))"
        }
        
        return url
    }
    
    /********************************************************************************/
    
    func getJSON(_ urlToRequest: String) -> Data?{
        let request = Utils.createRequest(nsurl: URL(string: urlToRequest)!)
        let appAccessKey = Config.Instance.getAppAccessKey()
        request.addValue(appAccessKey , forHTTPHeaderField: "Authorization")
        
        var jsonData : Data? = nil
        //TODO : This is blocking, replace all flows with async calls.
        let ds = DispatchSemaphore( value: 0 )
        let task = URLSession.shared.dataTask(with: request as URLRequest,
                                              completionHandler: { data, response, error -> Void in
                                                jsonData = data
                                                ds.signal()
        })
        task.resume()
        ds.wait()
        return jsonData
    }
    
    /********************************************************************************/
    fileprivate func loadWebServicesConfig(){
        if let path = Bundle.main.path(forResource: "webServices", ofType: "plist") {
            self.webServicesMap = NSDictionary(contentsOfFile: path) as? [String:String]
            self.extendWithMainService()
        }
    }
    
    fileprivate func extendWithMainService(){
        if let baseURL = Config.Instance.getBaseURL(){
            for(key, value) in self.webServicesMap!{
                self.webServicesMap![key] = baseURL + value
            }
        }
    }
    
    /********************************************************************************/
    func getShoppingItem(_ id: Int)->ShoppingItem?{
        return self.shoppingItemsMap[id]
    }
    
    
    func getShippingURL()->String?{
        let url = self.appendCustomerExt(self.webServicesMap![Constants.getShippingMethod])
        
        return url
    }
    
    func getBillingShippingEncoded()->String?{
        let addressJSON = createAddressJSON()
        let billingShippingEncoded = Encoder.encodeBase64(addressJSON)
        
        return billingShippingEncoded
    }
    
    fileprivate func createAddressJSON()->NSDictionary{
        let dataDict = NSMutableDictionary()
        
        if Config.guestCheckIn{
            if let billingJSON = UserInfo.guestBillAddress?.createMap(customerId: 0){
                dataDict.setObject(billingJSON, forKey: "billing" as NSCopying)
            }
            
            if let shippingJSON = UserInfo.guestShipAddress?.createMap(customerId: 0){
                dataDict.setObject(shippingJSON, forKey: "shipping" as NSCopying)
            }
        }else{
            if let user = UserManager.Instance.getUserInfo(){
                if let billingJSON = user.billAddress?.createMap(customerId: user.id){
                    dataDict.setObject(billingJSON, forKey: "billing" as NSCopying)
                }
                if let shippingJSON = user.shipAddress?.createMap(customerId: user.id){
                    dataDict.setObject(shippingJSON, forKey: "shipping" as NSCopying)
                }
            }
        }
        
        return dataDict
    }
    
    func getCombinedPlaceOrderURL(_ cart : ShoppingCart)->String?{
        var serviceURL : String? = nil
        
        if let url = self.getPlaceOrderURL(){
            if let shippingMethod = cart.shippingMethod{
                if let paymentMethod = cart.paymentMethod{
                    serviceURL = "\(url)&paymentmethod=\(paymentMethod.code)&shipmethod=\(shippingMethod.id)&shipcarrier=\(shippingMethod.code!)"
                }
            }
        }
        return serviceURL
    }
    
    func updateAddressURL(addressId : Int, addressData : String)-> String?{
        var url = self.appendCustomerExt(self.webServicesMap![Constants.updateAddress])
        
        if url != nil{
            url = url! + "&addressid=\(addressId)&address_data=\(addressData)"
        }
        
        return url
    }
    
    func addNewAddressURL(addressData : String)-> String?{
        var url = self.appendCustomerExt(self.webServicesMap![Constants.addNewAddress])
        
        if url != nil{
            url = url! + "&address_data=\(addressData)"
        }
        
        return url
    }
    
    func getCartListUrl()->String?{
        let url = self.appendCustomerExt(self.webServicesMap![Constants.getCartItems])
        return url
    }
    
    func getUpdateCartUrl()->String?{
        assert( self.appendCustomerExt(self.webServicesMap![Constants.addCartItem]) != nil)
        
        var url = self.appendCustomerExt(self.webServicesMap![Constants.addCartItem])!
        
        if let cartJson = ShoppingCart.Instance.getSyncCartEncodedJson(){
            url = "\(url)&item_data=\(cartJson)"
        }
        
        return url
    }
    
    func getAddItemToServer(_ item:ShoppingItem)->String?{
        
        var url = self.appendCustomerExt(self.webServicesMap![Constants.addCartItem])!
        
        if let cartJson = ShoppingCart.Instance.getLastProductEncodedJson(item){
            url = "\(url)&item_data=\(cartJson)"
        }
        return url
    }
    
    func getDeleteFromCartUrl(_ productId:String)->String?{
        var url = self.appendCustomerExt(self.webServicesMap![Constants.removeCartItem])
        
        if url != nil{
            url = url! + "&itemid=\(productId)"
        }
        return url
    }
    
    func getAddToCartUrl(_ productId:String, itemCount:String)->String?{
        var url = self.appendCustomerExt(self.webServicesMap![Constants.AddToCart])
        
        if url != nil{
            url = url! + "&product_id=\(productId)" + "&qty=\(itemCount)" as String?
        }
        
        return url
    }
    
    fileprivate func addLoaderWithClassType(_ controller:UIViewController){
        switch controller.className {
        case "NewProductDetailePage":
            if let obj = controller as? NewProductDetailePage{
                DispatchQueue.main.async {
                    obj.loaderCount = 0
                    obj.addLoaderNew()
                }
            }
            break
        case "WishListViewController":
            if let obj = controller as? WishListViewController{
                DispatchQueue.main.async {
                    obj.loaderCount = 0
                    obj.addLoader()
                }
            }
            break
        default:
            break
        }
        
    }
    
    fileprivate func removeLoaderWithClassType(_ controller:UIViewController){
        switch controller.className {
        case "NewProductDetailePage":
            if let obj = controller as? NewProductDetailePage{
                DispatchQueue.main.async {
                    obj.loaderCount = 1
                    obj.removeLoaderNew()
                }
            }
            break
        case "WishListViewController":
            if let obj = controller as? WishListViewController{
                DispatchQueue.main.async {
                    obj.loaderCount = 1
                    obj.removeLoader()
                }
            }
            break
        default:
            break
        }
    }
    
    func callRequestForAddCart(_ item: ShoppingItem, count : Int, controller:UIViewController,isFromByNow:Bool, callback: @escaping (NSDictionary,Bool,UIViewController,ShoppingItem) -> Void, errorCallback: @escaping () -> Void){
        if let addCartUrl = WebApiManager.Instance.getAddToCartUrl(String(item.id), itemCount: String(count)){
            addLoaderWithClassType(controller)
            let request: NSMutableURLRequest = Utils.createRequest(nsurl: URL(string: addCartUrl)!)
            let appAccessKey = Config.Instance.getAppAccessKey()
            request.addValue(appAccessKey , forHTTPHeaderField: "Authorization")
            
            let task = URLSession.shared.dataTask(with: request as URLRequest){(data, response, error) -> Void in
                
                self.removeLoaderWithClassType(controller)
                guard error == nil && data != nil else {
                    errorCallback()
                    print("error=\(String(describing: error))")
                    return
                }
                
                if let dataDict = Utils.parseJSON(data!){
                    callback(dataDict,isFromByNow,controller,item)
                }else{
                    errorCallback()
                }
                
            }
            task.resume()
        }
    }
    
    func getDeleteProductFromCartUrl( _ productId:String)->String?{
        var url = self.appendCustomerExt(self.webServicesMap![Constants.DeleteCart])
        
        if url != nil{
            url = url! + "&product_id=\(productId)"
        }
        
        return url
    }
}



