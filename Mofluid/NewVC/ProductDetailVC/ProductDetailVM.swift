//
//  ProductDetailVM.swift
//  Mofluid
//
//  Created by Saurabh Mishra on 7/2/18.
//  Copyright © 2018 Mofluid. All rights reserved.
//

import Foundation
class ProductDetailVM{
    
    var shoppingItem:ShoppingItem?  =   nil

    //parser
    func parseDataForCustomOptions(_ dataDict: NSDictionary)->[CustomOptionSet] {

        var optionSet : [CustomOptionSet] = [CustomOptionSet]()
        if let customOptions = dataDict["custom_option"] as? NSArray{
            if let quantity = dataDict["quantity"] as? String{
                self.shoppingItem?.numInStock = Int(Utils.StringToDouble(quantity))
            }
            for item in customOptions{
                var optionList = [CustomOption]()
                if let itemDict = item as? NSDictionary{
                    let optionId = itemDict["custom_option_id"] as? String
                    let name = itemDict["custom_option_name"] as? String
                    let type = itemDict["custom_option_type"] as? String
                    let isRequired = itemDict["custom_option_is_required"] as? String
                    
                    if let options = itemDict["custom_option_value_array"] as? NSArray{
                        for optionItem in options{
                            if let optionDict = optionItem as? NSDictionary{
                                let id  = optionDict["id"] as? String
                                let price = optionDict["price"] as? String
                                let priceType = optionDict["price_type"] as? String
                                let sku = optionDict["sku"] as? String
                                let sortOrder = optionDict["sort_order"] as? String
                                let title = optionDict["title"] as? String
                                if id != nil && price != nil && title != nil{
                                    let option = CustomOption(id: id!, price: price!, priceType: priceType, sku: sku, sortOrder: sortOrder, title: title!)
                                    optionList.append(option)
                                }
                            }
                        }
                    }
                    if optionId != nil && name != nil && type != nil && isRequired != nil{
                        let bRequired = isRequired! == "1" ? true : false
                        let customSet = CustomOptionSet(id: optionId!, name: name!, type: type!, isRequired: bRequired, options: optionList)
                        
                        if let all = itemDict["all"] as? NSDictionary{
                            if let maxChar = all["max_characters"] as? String{
                                if let maxCharVal = Int(maxChar){
                                    customSet.maxChars = maxCharVal
                                }
                            }
                            if let priceStr = all["price"] as? String{
                                if let priceVal = Int(priceStr){
                                    customSet.priceStr = Utils.DoubleToString(Double(priceVal))
                                }
                            }
                        }
                        optionSet.append(customSet)
                    }
                }
            }
        }
        else{
            //createDownlaodableDataView(dataDict)
        }
        return optionSet
        //createCustomOptionsTable()
    }
    func processRelatedProductData(_ dict : NSDictionary)->[ShoppingItem]{
       
        var productsArray = [ShoppingItem]()
        if let data = dict["products_list"] as? NSArray{
            for item in data{
                
                if let itemDict = item as? NSDictionary{
                    if let shoppingItem = StoreManager.Instance.createShoppingItem(itemDict){
                        productsArray.append(shoppingItem)
                    }
                }
            }
        }
        return productsArray
    }
    
    func processReviewData(_ dataDict:NSDictionary)->[ProductReviewData]{
        
        var arrReviewData : [ProductReviewData] = [ProductReviewData]()
        var val = 0
        let total = dataDict["total"] as? Int
        if total!>0{
            if  let  all = dataDict["all"] as? NSArray{
                for item in all{
                    
                    let dataItem = item as! NSDictionary
                    if let vote = dataItem["vote"] as? NSArray{
                        for value in vote
                        {
                            let valueItem = value as? NSDictionary ?? [:]
                            let valu = valueItem["value"] as? String ?? ""
                            val = val + Int(valu)!
                        }
                        val = val / 3
                        let reviewData = ProductReviewData(id: dataItem["id"]as? String ?? "", statusId: dataItem["statusid"]as? String ?? "", createDate: dataItem["createdat"]as? String ?? "", details: dataItem["detail"]as? String ?? "", nickName: dataItem["nickname"]as? String ?? "" , value: String(val) , title: dataItem["title"]as? String ?? "")
                        arrReviewData.append(reviewData)
                    }
                }
            }
        }
        return arrReviewData
    }
    func processDetails(item:ShoppingItem,dataDict : NSDictionary)->(detailDict:DetailsDictionary?,type:String){
        
        var detailDict:DetailsDictionary?
        var typeProduct=item.type
        self.shoppingItem = item
        self.shoppingItem?.smallImg = dataDict["img"] as? String
        if self.shoppingItem != nil {
            //let id = self.shoppingItem?.id ?? 0
            let type = self.shoppingItem?.type ?? ""
            let imageDataDict :NSDictionary = NSDictionary()
            detailDict = DetailsDictionary(dataDict: dataDict, imgDict: imageDataDict, type: type)
            if(self.shoppingItem?.type == "configurable"){
                
                typeProduct    =   "configurable"
            }else{
                typeProduct    =    "simple"
            }
        }
        print(typeProduct)
        return (detailDict:detailDict,type:(self.shoppingItem?.type)!)
    }
    
    //MARK: process confuigrable product
    func processConfigurableProduct(_ item:ShoppingItem,_ itemDict : DetailsDictionary?)->(shareUrl:String,shortDescription:String,specialPrice:String,isCart:Bool,result:(basePrice:NSMutableAttributedString?,discount:String,description:String),optionResult:(childShoppingItems: [Set<AttributePair>: ShoppingItem],configOptionName:[String]),titlesArray:[String],righttitlesArray:[String]){
        
        var shareUrl            =   ""
        var shortDescription    =   ""
        var description         =   ""
        var optionResult : (childShoppingItems: [Set<AttributePair>: ShoppingItem],configOptionName:[String])?
        var result       : (basePrice:NSMutableAttributedString?,discount:String,description:String)?
        var isCart              =   false
        self.shoppingItem = item
        let itemDetails =  itemDict!.dataDict
        shareUrl = (itemDetails["url"] as? String) ?? ""
        let img = itemDetails["img"] as? String  ?? "" //ankur test
        self.shoppingItem?.smallImg = img
        let specialPrice = itemDetails["sprice"] as? String ?? ""
        var price =  itemDetails["price"] as? String ?? ""
        description = itemDetails["description"] as? String ?? ""
        description = self.removeHTmltag(description as NSString)
        shortDescription = itemDetails["shortdes"] as? String ?? ""
        if let sku = itemDetails["sku"] as? String{
            self.shoppingItem?.sku = sku
        }
        item.numInStock = Int(itemDetails["quantity"] as! String)!
        if(item.numInStock <= 0){
            
            isCart  =   false
        }
        else{
            
            isCart  =   true
        }
        if let stockStatus = itemDetails["is_in_stock"] as? Int{
            self.shoppingItem?.inStock = stockStatus == 1
        }
        
            if(shortDescription != ""){
                description = shortDescription
            }
        if(Int(Utils.StringToDouble(specialPrice)) > 0 && Int(Utils.StringToDouble(specialPrice)) < Int(Utils.StringToDouble(price))){
            price = specialPrice
        }
        else{
            
            price = item.priceStr
        }
        let descriptionArrays = getTitleArrayForDescription(itemDict)
        description = self.removeHTmltag(description as NSString)
        result = productDescription(description, item : item, stock:self.shoppingItem?.inStock ?? false,type:"Simple")
        optionResult = getAttributeForItem(itemDetails)
        
        return (shareUrl:shareUrl,shortDescription:shortDescription,specialPrice:price,isCart:isCart,result:result!,optionResult:optionResult!,titlesArray:descriptionArrays.titlesArray,righttitlesArray:descriptionArrays.righttitlesArray)
    }
    func getAttributeForItem(_ itemDict : NSDictionary)->(childShoppingItems: [Set<AttributePair>: ShoppingItem],configOptionName:[String]){
        
        var childShoppingItems = [Set<AttributePair>: ShoppingItem]()
        var configOptionName   =    [String]()
        if let attributes = itemDict["config_attributes"] as?  [NSDictionary]{
            attributes.forEach{item in
                let id = item["prod_id"] as? String
                let name = item["name"] as? String
                let price = item["price"] as? String
                let spclprice = item["spclprice"] as? String
                let inStock = item["is_in_stock"] as? Bool
                let type = item["type"] as? String
                let img = item["img"] as? String
                let sku = item["sku"] as? String
                if let shoppingItem = ShoppingItem(id: Int(id!)!, name: name!, sku: sku!, price: price, specialPrice: spclprice, inStock: inStock!, image: img, type: type!, img1: img){
                    shoppingItem.numInStock = item["stock_quantity"] as! Int
                    var identifierSet = Set<AttributePair>()
                    if let data = item["data"] as? [String: [String : String]]{
                        for(key, value) in data{
                            let label = value["label"]
                            let identifier = AttributePair(name: key, value: label!)
                            identifierSet.insert(identifier)
                        }
                    }
                    if(identifierSet.count > 0){
                        childShoppingItems[identifierSet] = shoppingItem
                    }
                }
            }
        }
        
        if let options = itemDict["config_option"] as? [String]{
            configOptionName =  options
            //self.configurableOptions()
        }else{
        }
        return(childShoppingItems: childShoppingItems,configOptionName:configOptionName)
    }
    
    func getAttributesForValue(value:String,set:[Set<AttributePair>: ShoppingItem])->[String]{
        
        var attributeSet = Set<AttributePair>()
        var options = [String]()
        set.keys.forEach{itemSet in
            itemSet.forEach{item in
                
                if item.name == value{
                    
                    options.append(item.value)
                    attributeSet.insert(item)
                }
            }
        }
        return Array(Set(options))//to make it unique values
    }
    //MARK:- Simple products
    func processSimpleProduct(_ item:ShoppingItem,_ itemDetails: DetailsDictionary?)->(shareUrl:String,shortDescription:String,specialPrice:String,result:(basePrice:NSMutableAttributedString?,discount:String,description:String)?,isCustomOption:Bool,titlesArray:[String],righttitlesArray:[String],customOptions:[CustomOptionSet]?){
        
        var shareUrl            =   ""
        var shortDescription    =   ""
        var specialPriceValue   =   ""
        var isCustomOption      =   false
        var customOptions        =   [CustomOptionSet]()
        var result : (basePrice:NSMutableAttributedString?,discount:String,description:String)?
       
        shareUrl = (itemDetails?.dataDict["url"] as? String) ?? ""
        let img = itemDetails?.dataDict["img"] as? String  //ankur test
        item.smallImg = img
        let specialPrice = itemDetails?.dataDict["sprice"] as? String ?? ""
        var price =  itemDetails?.dataDict["price"] as? String ?? ""
        var description = itemDetails?.dataDict["shortdes"] as? String
        shortDescription = (itemDetails?.dataDict["description"] as? String)!
        if let sku = itemDetails?.dataDict["sku"] as? String{
            item.sku = sku
        }
        
        item.numInStock =  1//Int(itemDetails?.dataDict["quantity"] as? String ?? "0")!
        if let stockStatus = itemDetails?.dataDict["is_in_stock"] as? Int{
            item.inStock = stockStatus == 1
        }
        let descriptionArrays = getTitleArrayForDescription(itemDetails)
        if(description == nil || description == "downloadable"){  //ankur
            if(shortDescription != ""){
                description = shortDescription
            }
        }
        
        if(Int(Utils.StringToDouble(specialPrice)) > 0 && Int(Utils.StringToDouble(specialPrice)) < Int(Utils.StringToDouble(price))){
            price = specialPrice
        }
        if description != nil{
            description = self.removeHTmltag(description! as NSString)
            specialPriceValue = item.priceStr
            result = productDescription(description!, item : item, stock:item.inStock ,type:"Simple")
        }
        if let has_custom_option = itemDetails?.dataDict["has_custom_option"] as? Int{
            
            if(has_custom_option > 0 || item.type == "downloadable"){
                
                isCustomOption  =   true
                itemType = shoppingItem?.type ?? ""
                customOptions    =   parseDataForCustomOptions((itemDetails?.dataDict)!)
            }else{
                itemType = shoppingItem?.type ?? ""
            }
        }
        //isCustomOption  =   true
        return (shareUrl:shareUrl,shortDescription:shortDescription,specialPrice:specialPriceValue,result:result,isCustomOption:isCustomOption,titlesArray:descriptionArrays.titlesArray,righttitlesArray:descriptionArrays.righttitlesArray,customOptions:customOptions)
    }
    
    func getTitleArrayForDescription(_ item:DetailsDictionary?)->(titlesArray:[String],righttitlesArray:[String]){
        
        var titlesArray         =   [String]()
        var righttitlesArray    =   [String]()
        var custom_attr_len: Int? = nil
        var custom_attr_data = [NSDictionary]()
        if let custom_attr = item?.dataDict["custom_attribute"] as? NSDictionary{
            custom_attr_len = custom_attr["total"] as? Int
            if(custom_attr_len! > 0){
                custom_attr_data = (custom_attr["data"] as? NSArray ?? []) as! [Any] as! [NSDictionary]
                for i in 0 ..< custom_attr_data.count{
                    if let value = custom_attr_data[i]["attr_value"] as? String{
                        if(value != "No"){
                            if let leftValue = custom_attr_data[i]["attr_label"] as? String{
                                if(leftValue != "featured"){
                                    titlesArray     .append(leftValue)
                                    righttitlesArray.append(value)
                                }
                            }
                        }
                    }
                }
            }
        }
        return(titlesArray:titlesArray,righttitlesArray:righttitlesArray)
    }
    func productDescription(_ des: String, item : ShoppingItem, stock:Bool,type:String)->(basePrice:NSMutableAttributedString?,discount:String,description:String){
        
        var basePriceValue      :   NSMutableAttributedString!
        var discountValue       =   ""
        var descriptionText     :   String?
        if item.isShowSpecialPrice(){
            
            var basePrice = ""
            if item.originalPriceStr != nil {
                basePrice =  "Price  " + item.originalPriceStr!
                
                let linkTextWithColor = "Price  "
                let range1 = (basePrice as NSString).range(of: linkTextWithColor)
                let attributePrice =  NSMutableAttributedString(string: basePrice)
                let range = (basePrice as NSString).range(of: item.originalPriceStr!)
                attributePrice.addAttribute( NSAttributedString.Key.foregroundColor, value:  UIColor(red: 90/255, green: 90/255, blue: 90/255, alpha: 1.0) , range: range1)
                attributePrice.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: range)
                basePriceValue   =   attributePrice
            }
        }
        
        if(item.price < item.originalPrice)
        {
            var percent = 0.0
            percent = ((item.originalPrice - item.price ) / item.originalPrice) * 100
            let offvalue:Int = Int(percent)
            let sel = "Selling by price".localized()
            let of = "% off".localized()
            discountValue = sel + " \(offvalue) " + of
        }
        let len = des.count
        descriptionText =  des
        if(len == 0){
            descriptionText = "No Description Provided".localized()
        }
        
        return (basePrice:basePriceValue,discount:discountValue,description:descriptionText!)
    }
    
    func removeHTmltag(_ descString: NSString) -> String{
        let htmlStringData = descString.data(using: String.Encoding.utf8.rawValue)!
        let attributedHTMLString = try! NSAttributedString(data: htmlStringData, options: [.documentType : NSAttributedString.DocumentType.html,  .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        
        let descriptionAttributedString = attributedHTMLString.string
        
        return descriptionAttributedString
    }
    func isOptionsSelected(_ dict:NSMutableDictionary,_ options:[String])->Bool{
        
        var returnValue     =   true
        for item in options{
            
            if (dict.value(forKey:item) == nil){
                
                returnValue =   false
                break
            }
        }
        return returnValue
    }
    func validateOptionsForSimpleProduct(givenOptions:[CustomOptionSet]?,selectedOptionsSet:CustomOptionSet?,selectedOption:CustomOption?)->Bool{
        
        var returnValue     =   true
        if let _ = givenOptions{
            
            if givenOptions![0].isRequired && selectedOption==nil{
                
                returnValue = false
            }
        }
        return returnValue
    }
    //MARK:- CART
    func addToCart(_ item:ShoppingItem,_ number:Int){
        
        ShoppingCart.Instance.addItemForCartSync(item, num: number)
    }
    func getAttributedString(_ dict:NSMutableDictionary,keys:[String])->String{
        
        var value   =   ""
        for key in keys{
            
            value = value + (dict.value(forKey:key) as! String) + ","
        }
        return "\(value.dropLast())"
    }
    func getCartItem(_ item:ShoppingItem,_ attributedString:String)->ShoppingItem{
        
        let cartItem : ShoppingItem! = ShoppingItem(id: item.id, name: item.name, sku: item.sku, price:String(item.originalPrice), specialPrice:String(item.price) , inStock:item.inStock, image:item.image , type:item.type , img1:item.smallImg)
        cartItem.numInStock = item.numInStock
        cartItem.totalNoInStock = item.numInStock
        cartItem.sku = item.sku + "-" + attributedString.replacingOccurrences(of:",", with:"-")
        return cartItem
    }
}

//MARK:-MoreInfo Delegate
extension ProductVC:MoreInfoDelegate{
    
    func clickOnMoreInfoButton(_ title:String){
        
        let addInfoObject = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "detailsAdditionalInfoViewController") as! detailsAdditionalInfoViewController
        
        addInfoObject.productTitle              =   self.shoppingItem?.name
        addInfoObject.productPrice              =   self.specialPrice
        addInfoObject.stockBool                 =   self.shoppingItem?.inStock ?? false
        addInfoObject.titlesArray               =   self.titlesArray
        addInfoObject.righttitlesArray          =   self.righttitlesArray
        addInfoObject.shortDescription          =   self.shorDescription != nil ? self.shorDescription : ""
        //addInfoObject.modalTransitionStyle      =   .crossDissolve
        //addInfoObject.modalPresentationStyle    =   .overCurrentContext
        self.present(addInfoObject, animated: true, completion: nil)
    }
}
//MARK:-Cart Delegate
extension ProductVC:CartDelegate{
    
    func clickedOn(action: buttonAction,sender:UIButton) {
        
        switch action {
        case .buyNow:
            hitAddToCartButton(true)
            print("buynow")
            break
        case .addtoCart:
            hitAddToCartButton(false)
            print("add to cart")
            break
        case .wishlist:
            self.clickedOnWishlist(sender)
            break
        //default:
           // print("")
        }
    }
}
//MARK:- Product Review Delegate
extension ProductVC:ReviewDelegate{
    
    func clickedOnReadAll(_ arrReviewData:[ProductReviewData]){
        
        print("read all reviews")
    }
    func clickedOnAddReview(_ title:String){
        
        let writeReview = WriteReviewViewController(nibName:"WriteReviewViewController",bundle:nil)
        writeReview.shoppingItem    =   self.shoppingItem
        self.navigationController?.pushViewController(writeReview, animated: true)
    }
}
//MARK:- ImageBanner Delegates
extension ProductVC:ImageBannerDelegate{
    
    func clickedOnShare(_ image: String) {
        
        print("share")
    }
}
extension ProductVC:SizeColorDelegate{
    
    func clickedOnSizeColorDelegate(title: String, value: String) {
        
        selectedAttributes.setValue(value, forKey:title)
    }
}
extension ProductVC:GroupProductDelegate{
    
    func clickedOnButton(_ sender: UIButton) {
        
        let vc                      =    GroupListVC(nibName: "GroupListVC", bundle: nil)
        vc.shoppingItem             =    self.shoppingItem
        //vc.modalTransitionStyle     =   .partialCurl
        vc.myTabBarController       =    self.tabBarController
        vc.modalPresentationStyle   =   .overCurrentContext
        vc.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.tabBarController?.present(vc, animated: true, completion: {
            
        })
    }
}
extension ProductVC:CustomOptionDelegate{
    
    func selectedValue(_ title: CustomOptionSet, _ selectedOption: CustomOption) {
        
        self.selectedOptionTitle    =   title
        self.selectedOption         =   selectedOption
    }
}
