//
//  ProductVC.swift
//  Mofluid
//
//  Created by Saurabh Mishra on 7/3/18.
//  Copyright © 2018 Mofluid. All rights reserved.
//

import UIKit

class ProductVC: ScrollingStackController {

    //var selectedAttribute   :       [SelectedAttribute]?
    var selectedAttributes                                   =       NSMutableDictionary()
    var customOptionSet     :       [CustomOptionSet]        =       [CustomOptionSet]()
    var shoppingItem        :        ShoppingItem?           =       nil
    var shareURl                                             =       ""
    var productDescription                                   =       ""
    var cartItem            :        ShoppingItem?           =       nil
    var titlesArray                                          =       [String]()
    var righttitlesArray                                     =       [String]()
    var specialPrice        :                                        String!
    var shorDescription     :                                        String!
    //xib to load in scroll view
    
    let imageBanner         :        ImageBanner             =       ImageBanner.create()
    let simpleProduct       :        SimpleProductVC         =       SimpleProductVC.create()
    let descriptionView     :        DescriptionVC           =       DescriptionVC.create()
    let productReview       :        ProductReviewVC         =       ProductReviewVC.create()
    let relatedProduct      :        RelatedProductsListVC   =       RelatedProductsListVC.create()
    let cartButton          :        AddToCartVC             =       AddToCartVC.create()
    let moreDescription     :        MoreInfoVC              =       MoreInfoVC.create()
    let productName         :        ProductNameVC           =       ProductNameVC.create()
    let sizeColor           :        SizeColorVC             =       SizeColorVC.create()
    let groupedProduct      :        GroupedProductVC        =       GroupedProductVC.create()
    let customOptions       :        CustomOptionsVC         =       CustomOptionsVC.create()
    var isBuyNow                                             =       false
    var selectedOptionTitle :        CustomOptionSet?
    var selectedOption      :        CustomOption?
    var simpleProductTuple      :   (shareUrl:String,shortDescription:String,specialPrice:String,result:(basePrice:NSMutableAttributedString?,discount:String,description:String)?,isCustomOption:Bool,titlesArray:[String],righttitlesArray:[String],customOptions:[CustomOptionSet]?)?
    
    var configProductTuple      :   (shareUrl:String,shortDescription:String,specialPrice:String,isCart:Bool,result:(basePrice:NSMutableAttributedString?,discount:String,description:String),optionResult:(childShoppingItems: [Set<AttributePair>: ShoppingItem],configOptionName:[String]),titlesArray:[String],righttitlesArray:[String])?
    
    let quantity                                            =       1
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationItem.title = self.shoppingItem?.name.uppercased()
        self.navigationController?.navigationBar.tintColor = .black
        setDataInVM()
        loadProduct()
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    //MARK:- INIT UI
    func loadScreens(){
        
        setDelegateToSelf()
        setShoppingItemToViews()
        switch self.shoppingItem?.type {
        case "simple":
            
            if (simpleProductTuple?.isCustomOption)!{
                
                customOptions.optionsValue   =   simpleProductTuple?.customOptions
                self.viewControllers    = [productName,imageBanner,simpleProduct,customOptions,cartButton,descriptionView,moreDescription]
            }
            else{
                self.viewControllers = [productName,imageBanner,simpleProduct,cartButton,descriptionView,moreDescription]
            }
            break
            
        case "configurable":
            
            self.viewControllers = [productName,imageBanner,simpleProduct,sizeColor,cartButton,descriptionView,moreDescription]
            break
            
        case "grouped":
            
            self.viewControllers = [productName,imageBanner,groupedProduct,cartButton,descriptionView,moreDescription]
            break
            
        case "downloadable":
            
            self.viewControllers = [productName,imageBanner,simpleProduct,cartButton,descriptionView,moreDescription]
            break
            
        default:
            print("")
            break
        }
    }
    //MARK:- Set Data VM
    func setDataInVM(){
        
        //set shoping item on vm
    }
    func setShoppingItemToViews(){
        
        imageBanner.shoppingItem            =       self.shoppingItem
        //
        cartButton.isStock                  =       self.shoppingItem?.numInStock == 0 ? false : true
        cartButton.item                     =       self.shoppingItem
        //
        productReview.shoppingItem          =       self.shoppingItem
        //
        relatedProduct.shoppingItem         =       self.shoppingItem
        //
        productName.name                    =       self.shoppingItem?.name
        //
        simpleProduct.isStock               =       self.shoppingItem?.inStock
    }
    //MARK:- Custom Methods
    func setDelegateToSelf(){
        
        moreDescription.delegate            =       self
        cartButton.delegate                 =       self
        productReview.delegate              =       self
        //imageBanner.delegate                =       self
        sizeColor.delegate                  =       self
        groupedProduct.delegate             =       self
        customOptions.delegate              =       self
    }
    func checkForCustomOptions(){
        
        if (self.simpleProductTuple?.isCustomOption)!{
            
            let url = WebApiManager.Instance.getDescUrl((self.shoppingItem?.id)!, type: (self.shoppingItem?.type)!)
            ApiManager().getApi(url: url!) { (response,status) in
                
                if status{
                    
                    self.customOptionSet    =   ProductDetailVM().parseDataForCustomOptions((response as? NSDictionary)!)
                }
            }
        }
    }
    func processResult(_ result:(detailDict:DetailsDictionary?,type:String)){
        
        let type = result.detailDict?.dataDict.value(forKey:"type") as? String
        switch type {
        case "simple":
            
            self.simpleProductTuple             =       ProductDetailVM().processSimpleProduct(self.shoppingItem!,result.detailDict)
            //self.checkForCustomOptions()
            descriptionView.shortDescription    =       self.simpleProductTuple?.shortDescription
            simpleProduct.basePrice             =       self.simpleProductTuple?.result?.basePrice
            simpleProduct.specialPrice          =       self.simpleProductTuple?.specialPrice
            simpleProduct.discountValue         =       self.simpleProductTuple?.result?.discount
            simpleProduct.customOptionSet       =       self.customOptionSet
            self.righttitlesArray               =       (self.simpleProductTuple?.righttitlesArray)!
            self.titlesArray                    =       (self.simpleProductTuple?.titlesArray)!
            self.shorDescription                =        self.simpleProductTuple?.shortDescription
            self.specialPrice                   =        self.simpleProductTuple?.specialPrice
            break
        
        case "configurable":
            
            self.configProductTuple             =   ProductDetailVM().processConfigurableProduct(self.shoppingItem!,result.detailDict)
            descriptionView.shortDescription    =   self.configProductTuple?.result.description
            simpleProduct.specialPrice          =   self.configProductTuple?.specialPrice
            sizeColor.optionResult              =   self.configProductTuple?.optionResult
            self.righttitlesArray               =   (self.configProductTuple?.righttitlesArray)!
            self.titlesArray                    =   (self.configProductTuple?.titlesArray)!
            self.shorDescription                =   self.configProductTuple?.shortDescription
            self.specialPrice                   =   self.configProductTuple?.specialPrice
            break
            
        case "grouped":
            
            break
        case "downloadable":
            self.simpleProductTuple             =       ProductDetailVM().processSimpleProduct(self.shoppingItem!,result.detailDict)
            self.checkForCustomOptions()
            descriptionView.shortDescription    =       self.simpleProductTuple?.shortDescription
            simpleProduct.basePrice             =       self.simpleProductTuple?.result?.basePrice
            simpleProduct.specialPrice          =       self.simpleProductTuple?.specialPrice
            simpleProduct.discountValue         =       self.simpleProductTuple?.result?.discount
            simpleProduct.customOptionSet       =       self.customOptionSet
            self.righttitlesArray               =       (self.simpleProductTuple?.righttitlesArray)!
            self.titlesArray                    =       (self.simpleProductTuple?.titlesArray)!
            self.shorDescription                =        self.simpleProductTuple?.shortDescription
            break
        default:
            print("")
            break
        }
        self.loadScreens()
    }
    func loadProduct(){
        
        guard let item = self.shoppingItem else{
            return
        }
        let url = WebApiManager.Instance.getDescUrl(item.id, type: item.type)
        self.getProductDescription(url!)
    }
    
    //MARK:- Call Api
    func getProductDescription(_ url:String){
        
        Helper().addLoader(self)
        ApiManager().getApi(url: url) { (response,status) in
            
            if status{
                
                let result  =   ProductDetailVM().processDetails(item: self.shoppingItem!,dataDict:(response as? NSDictionary)!)
                self.processResult(result)
                
            }
            Helper().removeLoader()
        }
    }
    //MARK:- Handle delegates call from VM
    func hitAddToCartButton(_ isBuyNow:Bool){
        
        self.isBuyNow   =   isBuyNow
        switch self.shoppingItem?.type {
        case "simple":
            
            addToCartForSimpleProduct(self.shoppingItem!)
            break
            
        case "configurable":
            
            addToCartForConfigProduct()
            break
            
        case "grouped":
            //diff flow
            break
        case "downloadable":
            addToCartForSimpleProduct(self.shoppingItem!)
            break
        default:
            print("")
            break
        }
    }
    func addToCart(_ item:ShoppingItem){
        
        item.totalNoInStock = (self.shoppingItem?.numInStock)!
        Helper().addLoader(self)
        CartRequestHandler().addToCart(item,quantity,vc:self, tabBar:self.tabBarController!) { (response, status,message) in
            
            Helper().removeLoader()
            if status{
                
                self.navigateToCart(self.isBuyNow)
            }
        }
    }
    
    func addToCartForSimpleProduct(_ item:ShoppingItem){
        
        if (simpleProductTuple?.isCustomOption)!{
            
            let isValidated =   ProductDetailVM().validateOptionsForSimpleProduct(givenOptions:simpleProductTuple?.customOptions,selectedOptionsSet:selectedOptionTitle,selectedOption:selectedOption)
            isValidated ? addToCartForCustom(item,options:(title:selectedOptionTitle!,selectedOption:selectedOption!)) : Helper().showAlert(self, message: Settings().selectAttributeMessage)
        }
        else{
            
            addToCart(item)
        }
    }
    func addToCartForCustom(_ item:ShoppingItem,options:(title:CustomOptionSet,selectedOption: CustomOption)){
        
        Helper().addLoader(self)
        CartRequestHandler().addToCartForCustomProduct(item,vc:self,tabBar:self.tabBarController!,options: options) { (response, status,message) in
            
            Helper().removeLoader()
            self.navigateToCart(self.isBuyNow)
        }
    }
    func addToCartForConfigProduct(){
        
        if ProductDetailVM().isOptionsSelected(selectedAttributes,(self.configProductTuple?.optionResult.configOptionName)!){
            
                self.shoppingItem?.attributeString   =   ProductDetailVM().getAttributedString(self.selectedAttributes,keys: (self.configProductTuple?.optionResult.configOptionName)!)
                let cartItem  =  ProductDetailVM().getCartItem(self.shoppingItem!,(self.shoppingItem?.attributeString)!)
                self.addToCart(cartItem)
        }
        else{
            
            Helper().showAlert(self, message:Settings().selectAttributeMessage)
        }
    }
    func navigateToCart(_ isBuyNow:Bool){
        
        if isBuyNow{
            
            let vc = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CartVC") as? CartVC)!
            self.navigationController?.pushViewController(vc, animated:true)
        }
    }
    func clickedOnWishlist(_ sender:UIButton){
       
        if (Settings().isUserLoggedIn()){
            
            if sender.isSelected{
                
                sender.isSelected      =       false
                sender.setImage(#imageLiteral(resourceName: "love"), for: UIControl.State.normal)
                WishListRequestHandler().removeFromWishList(self.shoppingItem!) { (response,status) in}
            }
            else{
                
                sender.isSelected      =       true
                sender.setImage(#imageLiteral(resourceName: "wishList_selected"), for: UIControl.State.normal)
                WishListRequestHandler().addToWishList(self.shoppingItem!) { (response, status) in}
            }
        }
        else{
                Helper().showAlert(self, message:Settings().askForLoginWishlist)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
