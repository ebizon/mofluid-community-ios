//
//  cartViewController.swift
//  Mofluid
//
//  Created by sudeep goyal on 10/09/15.
//  Copyright © 2015 Mofluid. All rights reserved.
//

import UIKit
import Foundation
import CoreData
import SloppySwiper
import Toast

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


class CartViewData{
    var plusButton : UIButton? = nil
    var minusButton : UIButton? = nil
    var quantityLabel : UILabel? = nil
    var moreQuanityLabel : UILabel? = nil
    var subTotalLabel : UILabel? = nil
    var quantityParentView : UIView? = nil
}

class cartViewController: BaseViewController{
    var emptyShopCartTitle2 = UILabel()
    var emptyShopCartTitle1 = UILabel()
    var scrollViewList = UIScrollView()
    var totalParentView = UIView()
    var cartTitleLabel:UILabel = UILabel()
    var emptyCartParentView: UIView = UIView()
    let lastParentViewtotal = UIView()
    var overDraftMap : [Int: Bool] = [Int: Bool]()
    var cartViewMap : [ShoppingItem: CartViewData] = [ShoppingItem: CartViewData]()
    var subTotalPriceLabel = UILabel()
    var swiper4 = SloppySwiper()
    var allCartItem = [ShoppingItem]()
    
    var isLoadCartFromPrceedBtn : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "MY CART".localized()
        NotificationCenter.default.addObserver(self, selector: #selector(cartViewController.psuh(_:)), name: NSNotification.Name(rawValue: "isPushedtoCart"), object: nil)
        mainParentScrollView.backgroundColor = UIColor.white
        self.navigationController?.delegate = swiper4
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        if(deviceName == "big"){
//            UILabel.appearance().font = UIFont(name: "Lato", size: 20)
//        }
//        else{
//            UILabel.appearance().font = UIFont(name: "Lato", size: 15)
//        }
        super.viewWillAppear(animated)
       // DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // change 2 to desired number of seconds
            // Your code with delay
            self.displayCart()
       // }
    }
    
    @objc func psuh(_ notification: Notification){
        
        self.navigationController?.popToRootViewController(animated: false)
        if notification.object == nil{
            return
        }
        let objet = notification.object as! NSDictionary?
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let itemObject = delegate.shoGroup
        
        let str1 = objet?.value(forKey: "className") as! String?
        let str2 = "categoryViewController"
        
        if str1==str2 {
            
            let Object = self.storyboard?.instantiateViewController(withIdentifier: "categoryViewController") as? categoryViewController
            Object!.shoppingGroup = itemObject
            self.navigationController?.pushViewController(Object!, animated: true)
        }
            
        else{
            
            let Object = self.storyboard?.instantiateViewController(withIdentifier: "productListViewController") as? productListViewController
            let str1 = objet?.value(forKey: "id") as! Int?
            Object!.categoryId = str1!
            self.navigationController?.pushViewController(Object!, animated: true)
        }
        
    }
    
    
    func displayCart(){
        self.clearCart()
        if ShoppingCart.Instance.getTotalCount() > 0{
            showEmptyCart(false)
            lastParentViewtotal.backgroundColor = UIColor.white
            totalParentView.backgroundColor = UIColor.white
            scrollViewList.backgroundColor = UIColor.white
            self.displayCartList()
        }
            
        else{
            showEmptyCart(true)
            lastParentViewtotal.backgroundColor = UIColor.white
            totalParentView.backgroundColor = UIColor.white
            scrollViewList.backgroundColor = UIColor.white
        }
    }
    
    func clearCart(){
        for view in totalParentView.subviews{
            view.removeFromSuperview()
        }
        for view in scrollViewList.subviews{
            view.removeFromSuperview()
        }
        
        for view in lastParentViewtotal.subviews{
            view.removeFromSuperview()
        }
    }
    
    
    func showEmptyCart(_ status:Bool){
        
        if status{
            emptyCartParentView.frame = mainParentScrollView.frame
            
            let imgView = UIImageView()
            imgView.frame = CGRect(x: emptyCartParentView.frame.width/2 - 35, y: 120, width: 70, height: 70)
            imgView.image = UIImage(named: "cart")
            emptyCartParentView.addSubview(imgView)
            emptyShopCartTitle1.frame = CGRect(x: 20, y: imgView.frame.origin.y + imgView.frame.size.height + 10, width: emptyCartParentView.frame.width - 40, height: 30)
            emptyShopCartTitle1.text = "Your Cart is Empty!".localized()
            emptyShopCartTitle1.font = UIFont(name: "Lato", size: 20)
            emptyShopCartTitle1.textColor = UIColor.darkGray
            emptyShopCartTitle1.textAlignment = .center
            emptyCartParentView.addSubview(emptyShopCartTitle1)
            
            emptyShopCartTitle2.frame = CGRect(x: 20, y: emptyShopCartTitle1.frame.origin.y + emptyShopCartTitle1.frame.size.height + 7, width: emptyCartParentView.frame.width - 40, height: 22)
            emptyShopCartTitle2.text = "Add items to it now?".localized()
            emptyShopCartTitle2.font = UIFont(name: "Lato", size: 15)
            emptyShopCartTitle2.textColor = UIColor.lightGray
            emptyShopCartTitle2.textAlignment = .center
            emptyCartParentView.addSubview(emptyShopCartTitle2)
            
            let emptyClickHereOutlet = UIButton()
            emptyClickHereOutlet.frame = CGRect(x: emptyCartParentView.frame.width/2 - 60, y: emptyShopCartTitle2.frame.origin.y + emptyShopCartTitle2.frame.size.height + 10, width: 120, height: 30)
            emptyClickHereOutlet.addTarget(self, action: #selector(cartViewController.continueShoppingAction), for: UIControl.Event.touchUpInside)
            emptyClickHereOutlet.backgroundColor = UIColor(red: (223/255.0), green: (114/255.0), blue: (114/255.0), alpha: 1.0)
            
            emptyClickHereOutlet.setTitle("SHOP NOW".localized(), for: UIControl.State())
            emptyClickHereOutlet.titleLabel?.font = UIFont(name: "Lato-Bold", size: 17)
            emptyClickHereOutlet.titleLabel?.textColor = UIColor(netHex:0xf78f1e)
            emptyClickHereOutlet.layer.cornerRadius = 2
            emptyCartParentView.addSubview(emptyClickHereOutlet)
            
            mainParentScrollView.addSubview(emptyCartParentView)
        }
            
        else{
            emptyCartParentView.removeFromSuperview()
        }
    }
    
    func displayCartList(){
        self.addCart()
        self.createCheckOut()
    }
    
    func addCart(){
        var isContainSet : Set<Int> = Set()
        scrollViewList.frame = CGRect(x: 0, y: cartTitleLabel.frame.origin.y + cartTitleLabel.frame.size.height + 10, width: mainParentScrollView.frame.size.width, height: 180)
        var posY:CGFloat = CGFloat(0)
        let cart = ShoppingCart.Instance
        
        
        
        //   for id in ShoppingCart.Instance.allCartItemIds {       
        
        //********************PC**************
        for (item, count) in cart {
            if !isContainSet.contains(item.id){
                isContainSet.insert(item.id)
                //             if !isContainSet.contains(id){                           //********************PC**************
                //                isContainSet.insert(id)
                //                let filtered = cart.filter {
                //                    $0.0.id == id
                //                }
                //                if filtered.isEmpty {
                //                    continue
                //                }
                // let (item,count) = filtered[0]                        //**********************************
                
                let cartListParentView = UIView(frame: CGRect(x: 0, y: posY, width: scrollViewList.frame.size.width, height: 170))
                let cartView = CartViewData()
                self.cartViewMap[item] = cartView
                
                cartListParentView.tag = item.hashValue
                let buttonView = UIButton()
                
                NSLog("%ld", item.id.hashValue)
                buttonView.tag = item.id.hashValue
                if(idForSelectedLangauge == Utils.getArebicLanguageCode())
                {
                    buttonView.frame = CGRect(x: cartListParentView.frame.width  - 115, y: 20, width: 100, height: 140)
                }
                else
                {
                    buttonView.frame = CGRect(x: 15, y: 20, width: 100, height: 140)
                }
                
                let icon_img_view = UIImageView()
                UIImageCache.setImage(icon_img_view, image: item.smallImg)
                if (idForSelectedLangauge == Utils.getArebicLanguageCode()) {
                    icon_img_view.frame = CGRect(x: 200 - buttonView.frame.size.width, y: 0, width: buttonView.frame.size.width, height: buttonView.frame.size.height)
                }
                else{
                    icon_img_view.frame = CGRect(x: 0, y: 0, width: buttonView.frame.size.width, height: buttonView.frame.size.height)
                }
                icon_img_view.contentMode = .scaleAspectFit
                
                buttonView.addSubview(icon_img_view)
                buttonView.addTarget(self, action: #selector(cartViewController.productDetails(_:)), for: UIControl.Event.touchUpInside)
                
                if item.type == "grouped" {
                    buttonView.isUserInteractionEnabled = false
                    
                }else {
                    buttonView.isUserInteractionEnabled = true
                    
                }
                
                let productTitleLabel = UILabel()
                if(idForSelectedLangauge == Utils.getArebicLanguageCode())
                {
                    productTitleLabel.frame = CGRect(x: 115, y: 20, width:300, height: 10)
                }
                else
                {
                    productTitleLabel.frame = CGRect(x: buttonView.frame.origin.x + buttonView.frame.size.width + 20, y: 20, width:300, height: 10)
                }
                
                productTitleLabel.text = item.name
                productTitleLabel.numberOfLines = 0
                productTitleLabel.sizeToFit()
                
                let htmlString = "<font color=\"black\"> \(item.name)</font><br /><font color=\"gray\"> \(item.attributeString)</font>"
                
                let encodedData = htmlString.data(using: String.Encoding.utf8)!
                do {
                    let attributedString = try NSAttributedString(data: encodedData, options: [.documentType : NSAttributedString.DocumentType.html,  .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
                    productTitleLabel.attributedText = attributedString
                    productTitleLabel.font = UIFont(name: "Lato", size: 15)
                    
                    
                } catch _ {
                    print("Cannot create attributed String")
                }
                
                
                let unitPriceLabel = UILabel()
                unitPriceLabel.frame = CGRect(x: 310 + productTitleLabel.frame.origin.x, y: productTitleLabel.frame.origin.y, width: 95, height: 25)
                unitPriceLabel.text = item.priceStr
                
                
                let quantityParentView = UIView(frame: CGRect(x: unitPriceLabel.frame.width + unitPriceLabel.frame.origin.x + 5 , y: productTitleLabel.frame.origin.y, width: 75, height: 30))
                quantityParentView.backgroundColor = UIColor.lightGray
                
                let minusButton = UIButton()
                minusButton.tag = item.hashValue
                if(idForSelectedLangauge == Utils.getArebicLanguageCode())
                {
                    minusButton.frame = CGRect(x: 52, y: 0, width: 23, height: 30)
                }
                else{
                    minusButton.frame = CGRect(x: 0, y: 0, width: 23, height: 30)
                }
                let minusImage = UIImage(named: "minus1")
                minusButton.setImage(minusImage, for:UIControl.State())
                minusButton.addTarget(self, action: #selector(cartViewController.minusButtonFunction(_:)), for: UIControl.Event.touchUpInside)
                cartView.minusButton = minusButton
                //**********************************************///////////////
                if 1 == count{
                    minusButton.isEnabled = false
                }
                
                let quantityLabel = UILabel(frame: CGRect(x: 24, y: 1, width: 27, height: 28))
                quantityLabel.text = String(count)
                quantityLabel.backgroundColor = UIColor.white
                quantityLabel.textColor = UIColor.black
                quantityLabel.textAlignment = .center;
                cartView.quantityLabel = quantityLabel
                
                let plusButton = UIButton()
                plusButton.tag = item.hashValue
                if(idForSelectedLangauge == Utils.getArebicLanguageCode())
                {
                    plusButton.frame = CGRect(x: 0, y: 0, width: 23, height: 30)
                }
                else
                {
                    plusButton.frame = CGRect(x: 52, y: 0, width: 23, height: 30)
                }
                let plusImage = UIImage(named: "add")
                plusButton.setImage(plusImage, for:UIControl.State())
                if(UserDefaults.standard.bool(forKey: "isLogin")){
                    plusButton.addTarget(self, action: #selector(cartViewController.plusButtonFunction1(_:)), for: UIControl.Event.touchUpInside)
                }
                else
                {
                    
                    plusButton.addTarget(self, action: #selector(cartViewController.plusButtonFunction1(_:)), for: UIControl.Event.touchUpInside)
                }
                
                cartView.plusButton = plusButton
                
                quantityParentView.addSubview(minusButton)
                quantityParentView.addSubview(quantityLabel)
                quantityParentView.addSubview(plusButton)
                cartView.quantityParentView = quantityParentView
                let subTotalProductpriceLabel = UILabel()
                if(idForSelectedLangauge == Utils.getArebicLanguageCode())
                {
                    subTotalProductpriceLabel.frame = CGRect(x: 7 , y: productTitleLabel.frame.origin.y, width: 100, height: 21)
                    subTotalProductpriceLabel.textAlignment = .left
                    
                }
                else
                {
                    subTotalProductpriceLabel.frame = CGRect(x: quantityParentView.frame.origin.x + quantityParentView.frame.size.width + 7, y: productTitleLabel.frame.origin.y, width: 100, height: 21)
                    subTotalProductpriceLabel.textAlignment = .right;
                    
                }
                subTotalProductpriceLabel.text = Utils.appendWithCurrencySym(cart.getSubTotal(item))
                subTotalProductpriceLabel.textColor = UIColor.black
                cartView.subTotalLabel = subTotalProductpriceLabel
                
                let deleteButton = UIButton()
                deleteButton.tag = item.hashValue
                if(idForSelectedLangauge == Utils.getArebicLanguageCode())
                {
                    deleteButton.frame = CGRect(x: 10, y: productTitleLabel.frame.origin.y, width: 20, height: 20)
                }
                else{
                    deleteButton.frame = CGRect(x: subTotalProductpriceLabel.frame.origin.x + subTotalProductpriceLabel.frame.size.width - 5, y: productTitleLabel.frame.origin.y, width: 50, height: 50)
                }
                
                let deleteImage = UIImage(named: "delete")
                deleteButton.setImage(deleteImage, for: UIControl.State())
                deleteButton.addTarget(self, action: #selector(cartViewController.deleteProductFunction(_:)), for: UIControl.Event.touchUpInside)
                
                let wishListButton = UIButton()
                wishListButton.tag = item.hashValue
                if(idForSelectedLangauge == Utils.getArebicLanguageCode())
                {
                    wishListButton.frame = CGRect(x: 10, y: productTitleLabel.frame.origin.y + 10, width: 20, height: 20)
                }
                else{
                    wishListButton.frame = CGRect(x: cartListParentView.frame.size.width - 30, y: productTitleLabel.frame.origin.y + 50, width: 20, height: 20)
                }
                
                let wishListImage = UIImage(named: "love")
                let wishListSelectedImage = UIImage(named: "wishList_selected")
                self.setWishListStatus(wishListButton)
                wishListButton.setImage(wishListImage, for: UIControl.State())
                wishListButton.setImage(wishListSelectedImage, for: .selected)
                wishListButton.addTarget(self, action: #selector(cartViewController.wishListIconClicked(_:)), for: UIControl.Event.touchUpInside)
                
                
                let skuLabel = UILabel()
                skuLabel.frame = CGRect(x: productTitleLabel.frame.origin.x, y: productTitleLabel.frame.origin.y + productTitleLabel.frame.height + 5, width: 300, height: 25)
                skuLabel.text = "Sku : "+item.sku
                
                if(deviceWidth >= 320 && deviceWidth < 481){
                    buttonView.frame.size.width = 80
                    buttonView.frame.size.height = 110
                    icon_img_view.frame = CGRect(x: 0, y: 0, width: buttonView.frame.size.width, height: buttonView.frame.size.height)
                    if(idForSelectedLangauge == Utils.getArebicLanguageCode())
                    {
                        productTitleLabel.frame =  CGRect(x: 115, y: 20, width:170, height: 10)
                    }
                    else
                    {
                        productTitleLabel.frame =  CGRect(x: buttonView.frame.origin.x + buttonView.frame.size.width + 20, y: 20, width:170, height: 10)
                    }
                    productTitleLabel.sizeToFit()
                    unitPriceLabel.frame = CGRect(x: productTitleLabel.frame.origin.x, y: productTitleLabel.frame.origin.y + productTitleLabel.frame.height + 5, width: 170, height: 25)
                    skuLabel.frame = CGRect(x: productTitleLabel.frame.origin.x, y: unitPriceLabel.frame.origin.y + unitPriceLabel.frame.height + 5, width: 170, height: 25)
                    quantityParentView.frame.origin.x = productTitleLabel.frame.origin.x
                    quantityParentView.frame.origin.y =  skuLabel.frame.origin.y + 15
                    if(idForSelectedLangauge == Utils.getArebicLanguageCode())
                    {
                        deleteButton.frame.origin.x = 35
                        subTotalProductpriceLabel.frame.origin.x = 15
                        
                    }
                    else
                    {
                        deleteButton.frame.origin.x = cartListParentView.frame.size.width - 50
                        subTotalProductpriceLabel.frame.origin.x = cartListParentView.frame.size.width - subTotalProductpriceLabel.frame.size.width - 15
                    }
                    
                    
                    subTotalProductpriceLabel.frame.origin.y = quantityParentView.frame.origin.y + 5
                    cartListParentView.frame.size.height = quantityParentView.frame.size.height + quantityParentView.frame.origin.y + 30
                }
                
                deleteButton.frame.origin.y = productTitleLabel.frame.origin.y
                cartListParentView.addSubview(buttonView)
                cartListParentView.addSubview(productTitleLabel)
                cartListParentView.addSubview(quantityParentView)
                cartListParentView.addSubview(subTotalProductpriceLabel)
                cartListParentView.addSubview(deleteButton)
                cartListParentView.addSubview(wishListButton)
                
                let moreQuantityLabel = UILabel()
                moreQuantityLabel.frame = CGRect(x: 15, y: cartListParentView.frame.size.height - 23, width: cartListParentView.frame.width - 30, height: 20)
                moreQuantityLabel.text = "you have reached to final quantity of this product.".localized()
                moreQuantityLabel.font = UIFont(name: "Lato", size: 15)
                moreQuantityLabel.textColor = UIColor.red
                cartListParentView.addSubview(moreQuantityLabel)
                moreQuantityLabel.isHidden = true
                cartView.moreQuanityLabel = moreQuantityLabel
                
                let border2 = UILabel()
                border2.frame = CGRect(x: 0, y: cartListParentView.frame.size.height - 2, width: cartListParentView.frame.size.width, height: 1)
                border2.backgroundColor = UIColor.lightGray
                
                cartListParentView.addSubview(border2)
                
                scrollViewList.addSubview(cartListParentView)
                scrollViewList.frame.size.height = cartListParentView.frame.size.height + cartListParentView.frame.origin.y + 20
                posY = posY + cartListParentView.frame.size.height
            }
        }
        
        mainParentScrollView.addSubview(scrollViewList)
        
    }
    
    fileprivate func createCheckOut(){
        
        
        lastParentViewtotal.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height - 195 , width: scrollViewList.frame.size.width, height: 180)
        
        
        let border3 = UILabel()
        border3.frame = CGRect(x: 0, y: 0, width: lastParentViewtotal.frame.size.width, height: 1)
        border3.backgroundColor = UIColor.lightGray
        
        let subTotalTitleLabel = UILabel()
        if(idForSelectedLangauge == Utils.getArebicLanguageCode())
        {
            subTotalTitleLabel.frame = CGRect(x: lastParentViewtotal.frame.width - 70 , y: 5, width: 50, height: 25)
        }
        else
        {
            subTotalTitleLabel.frame = CGRect(x: 20, y: 5, width: 50, height: 22)
        }
        subTotalTitleLabel.text = "Total".localized()
        subTotalTitleLabel.font = UIFont(name: "Lato-Bold", size: 18)
        
        subTotalTitleLabel.textColor = UIColor.red
        let xpos = subTotalTitleLabel.frame.size.width + 20
        if(idForSelectedLangauge == Utils.getArebicLanguageCode())
        {
            subTotalPriceLabel.frame = CGRect(x: 20 , y: subTotalTitleLabel.frame.origin.y, width: lastParentViewtotal.frame.size.width - xpos * 1.2, height: 25)
            subTotalPriceLabel.textAlignment = .left
        }
        else{
            subTotalPriceLabel.frame = CGRect(x: xpos, y: subTotalTitleLabel.frame.origin.y, width: lastParentViewtotal.frame.size.width - xpos * 1.2, height: 25)
            subTotalPriceLabel.textAlignment = .right;
        }
        
        subTotalPriceLabel.text = Utils.appendWithCurrencySym(ShoppingCart.Instance.getSubTotal())
        subTotalPriceLabel.font = UIFont(name: "Lato-Bold", size: 18)
        
        subTotalPriceLabel.textColor = UIColor.red
        
        
        let border2 = UILabel()
        border2.frame = CGRect(x: 0, y: subTotalPriceLabel.frame.size.height + subTotalPriceLabel.frame.origin.y + 3, width: lastParentViewtotal.frame.size.width, height: 1)
        border2.backgroundColor = UIColor.lightGray
        
        
        let proceedCheckOutButton = ZFRippleButton()
        proceedCheckOutButton.frame = CGRect(x: 20, y: border2.frame.origin.y + border2.frame.size.height + 15, width: lastParentViewtotal.frame.size.width - 40, height: 38)
        proceedCheckOutButton.addTarget(self, action: #selector(cartViewController.proceedCheckOutAction(_:)), for: UIControl.Event.touchUpInside)
        proceedCheckOutButton.backgroundColor = UIColor(red: (223/255.0), green: (114/255.0), blue: (114/255.0), alpha: 1.0)
        proceedCheckOutButton.layer.cornerRadius = 3.0
        proceedCheckOutButton.setTitle("Proceed To Checkout".localized(), for: UIControl.State())
        proceedCheckOutButton.titleLabel?.font = UIFont(name: "Lato-Bold", size: 18)
        proceedCheckOutButton.titleLabel?.textColor = UIColor(netHex:0xf78f1e)
        
        let continueShoppingButton = ZFRippleButton()
        continueShoppingButton.frame = CGRect(x: proceedCheckOutButton.frame.origin.x, y: proceedCheckOutButton.frame.origin.y + proceedCheckOutButton.frame.size.height + 15, width: proceedCheckOutButton.frame.size.width, height: proceedCheckOutButton.frame.size.height)
        continueShoppingButton.addTarget(self, action: #selector(cartViewController.continueShoppingAction), for: UIControl.Event.touchUpInside)
        continueShoppingButton.backgroundColor = UIColor(red: (144/255.0), green: (144/255.0), blue: (144/255.0), alpha: 1.0)
        continueShoppingButton.layer.cornerRadius = 3.0
        continueShoppingButton.setTitle("Continue Shopping".localized(), for: UIControl.State())
        continueShoppingButton.titleLabel?.font = UIFont(name: "Lato-Bold", size: 18)
        continueShoppingButton.titleLabel?.textColor = UIColor(netHex:0xf78f1e)
        
        lastParentViewtotal.addSubview(subTotalTitleLabel)
        lastParentViewtotal.addSubview(subTotalPriceLabel)
        lastParentViewtotal.addSubview(border2)
        lastParentViewtotal.addSubview(border3)
        lastParentViewtotal.addSubview(proceedCheckOutButton)
        lastParentViewtotal.addSubview(continueShoppingButton)
        
        view.addSubview(lastParentViewtotal)
        mainParentScrollView.contentSize.height = scrollViewList.frame.origin.y + scrollViewList.frame.size.height + 180
    }
    
    func productDetailsFunction(_ button: UIButton){
        let productDtail = NewProductDetailePage(nibName: "NewProductDetailePage", bundle: nil)
        self.navigationController?.pushViewController(productDtail, animated: true)
    }
    
    
    func reloadCart(_ item: ShoppingItem){
        if let cartView = self.cartViewMap[item]{
            let shoppingCart = ShoppingCart.Instance
            let count = shoppingCart.getCount(item)
            cartView.quantityLabel?.text = String(count)
            cartView.subTotalLabel?.text = Utils.appendWithCurrencySym(shoppingCart.getSubTotal(item))
            
            let minusButton = UIButton()
            minusButton.tag = item.hashValue
            if(idForSelectedLangauge == Utils.getArebicLanguageCode())
            {
                minusButton.frame = CGRect(x: 52, y: 0, width: 23, height: 30)
            }
            else
            {
                minusButton.frame = CGRect(x: 0, y: 0, width: 23, height: 30)
            }
            let minusImage = UIImage(named: "minus1")
            minusButton.contentMode = .scaleAspectFit
            minusButton.setImage(minusImage, for:UIControl.State())
            minusButton.addTarget(self, action: #selector(cartViewController.minusButtonFunction(_:)), for: UIControl.Event.touchUpInside)
            
            let plusButton = UIButton()
            plusButton.tag = item.hashValue
            if(idForSelectedLangauge == Utils.getArebicLanguageCode())
            {
                plusButton.frame = CGRect(x: 0, y: 0, width: 23, height: 30)
            }
            else
            {
                plusButton.frame = CGRect(x: 52, y: 0, width: 23, height: 30)
            }
            let plusImage = UIImage(named: "add")
            plusButton.setImage(plusImage, for:UIControl.State())
            if(UserDefaults.standard.bool(forKey: "isLogin")){
                plusButton.addTarget(self, action: #selector(cartViewController.plusButtonFunction1(_:)), for: UIControl.Event.touchUpInside)
            }
            else
            {
                
                plusButton.addTarget(self, action: #selector(cartViewController.plusButtonFunction1(_:)), for: UIControl.Event.touchUpInside)
            }
            
            cartView.plusButton?.removeFromSuperview()
            cartView.minusButton?.removeFromSuperview()
            
            cartView.quantityParentView?.addSubview(minusButton)
            cartView.quantityParentView?.addSubview(plusButton)
            cartView.plusButton = plusButton
            cartView.minusButton = minusButton
            cartView.moreQuanityLabel?.isHidden = true
            
            if 1==count{
                cartView.minusButton?.isEnabled = false
            }else{
                cartView.minusButton?.isEnabled = true
            }
            if(UserDefaults.standard.bool(forKey: "isLogin")){
                self.overDraftMessage1(item, moreQuantityLabel: cartView.moreQuanityLabel, plusButton: cartView.plusButton)
            }
            else{
                self.overDraftMessage1(item, moreQuantityLabel: cartView.moreQuanityLabel, plusButton: cartView.plusButton)
            }
            self.subTotalPriceLabel.text = Utils.appendWithCurrencySym(shoppingCart.getSubTotal())
        }
        
    }
    
    @objc func productDetails(_ button: UIButton){
        
        var item = ShoppingCart.Instance.findItemByHash(button.tag)
        
        let cart = ShoppingCart.Instance
        
        for (itemNew, _) in cart {
            
            if itemNew.id == button.tag {
                
                item = itemNew
            }
        }
        
        if(item?.type == "grouped"){
            let groupProductObject = self.storyboard?.instantiateViewController(withIdentifier: "groupedViewController") as? groupedViewController
            groupProductObject?.shoppingItem = item
            groupProductObject?.titleString = (item?.name as NSString?)!
            self.navigationController?.pushViewController(groupProductObject!, animated: true)
        }
        else if (item?.type == "configurable" || item?.type == "simple"){
            let productDtail = NewProductDetailePage(nibName: "NewProductDetailePage", bundle: nil)
            
            item?.id = (item?.parentId)!
            productDtail.shoppingItem = item
            
            self.navigationController?.pushViewController(productDtail, animated: true)
        }
    }
    
    @objc func continueShoppingAction(){
        
        self.tabBarController?.selectedIndex = 0
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.tabSelectedIndex = 0
        NotificationCenter.default.post(name: Notification.Name(rawValue: "popToRoot"), object: nil)
    }
    
    func backButtonFunction(){
        if tabBarController?.selectedIndex == 3 {
            let delegate = UIApplication.shared.delegate as! AppDelegate
            self.tabBarController?.selectedIndex = delegate.previousSelected ?? 0
            delegate.previousSelected = delegate.currentSelected
            delegate.currentSelected = self.tabBarController?.selectedIndex
            delegate.tabSelectedIndex =  delegate.currentSelected
            
        }else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func overDraftMessage(_ item: ShoppingItem, moreQuantityLabel: UILabel?, plusButton: UIButton?){
        if let isOverDraft = self.overDraftMap[item.id]{
            let shoppingCart = ShoppingCart.Instance
            let count = shoppingCart.getCount(item)
            var errorMsg = ""
            if item.inStock{
                if count > item.totalNoInStock{
                    errorMsg = ErrorHandler.Instance.getQuantityNotAvailableError()
                }
            }else{
                errorMsg = ErrorHandler.Instance.getOutOfStockError()
            }
            if isOverDraft == true{
                moreQuantityLabel?.isHidden = false
                
                moreQuantityLabel?.text =  errorMsg
                
                self.overDraftMap[item.id] = false
                if shoppingCart.getMaxAllowed(item) == count{
                    plusButton?.isEnabled = false
                }
            }
        }
    }
    
    func overDraftMessage1(_ item: ShoppingItem, moreQuantityLabel: UILabel?, plusButton: UIButton?){
        if let isOverDraft = self.overDraftMap[item.id]{
            let shoppingCart = ShoppingCart.Instance
            let count = shoppingCart.getCount(item)
            
            if isOverDraft == true{
                moreQuantityLabel?.isHidden = false
                
                moreQuantityLabel?.text =  ErrorHandler.Instance.getOutOfStockError()
                
                self.overDraftMap[item.id] = false
                if shoppingCart.getMaxAllowed(item) == count{
                    plusButton?.isEnabled = false
                }
            }
        }
    }
    
    
    @objc func proceedCheckOutAction(_ button: ZFRippleButton){
        
        
        self.displayCart()
        
        if(UserDefaults.standard.bool(forKey: "isLogin")){
            checkAndProcessUserAddress()
        }else{
            let checkoutObject = self.storyboard?.instantiateViewController(withIdentifier: "guestCheckOutViewController") as? guestCheckOutViewController
            self.navigationController?.pushViewController(checkoutObject!, animated: true)
        }
    }
    
    func checkAndProcessUserAddress(){
        let url = WebApiManager.Instance.getBillingAddressURL()
        
        if let userInfo = UserManager.Instance.getUserInfo(){
            if userInfo.billAddress == nil || userInfo.shipAddress == nil{
                self.addLoader()
                Utils.fillTheData(url, callback: self.processBillingAddress, errorCallback : self.billingError)
            }else{
               moveToDiscountPage()
            }
        }
    }
    
    func billingError(){
        self.removeLoader()
        getShippingAddress()
    }
    
    func processBillingAddress(_ dataDict : NSDictionary){
        defer{self.removeLoader()}
        UserManager.Instance.setBillingAddress(dataDict)
        getShippingAddress()
    }
    
    func getShippingAddress(){
        self.addLoader()
        let url = WebApiManager.Instance.getShippingAddressURL()
        Utils.fillTheData(url, callback: self.processShippingAddress, errorCallback : self.showError)
    }
    
    func processShippingAddress(_ dataDict : NSDictionary){
        defer{self.removeLoader()}
        UserManager.Instance.setShippingAddress(dataDict)
        
        if let userInfo = UserManager.Instance.getUserInfo(){
            if(userInfo.billAddress != nil || userInfo.shipAddress != nil){
                moveToDiscountPage()
            }else{
                let checkoutObject = self.storyboard?.instantiateViewController(withIdentifier: "buyNowViewController") as? buyNowViewController
                self.navigationController?.pushViewController(checkoutObject!, animated: true)
            }
        }
    }
    
    func moveToDiscountPage(){
        let discountViewObject = self.storyboard?.instantiateViewController(withIdentifier: "discountViewController") as? discountViewController
        discountViewObject?.cart = ShoppingCart.Instance
        self.navigationController?.pushViewController(discountViewObject!, animated: true)
    }
    
    func loadAnonymousQuantity()
    {
        var url = WebApiManager.Instance.getProductStockURL()
        
        url =  url! + "&product_id="
        let cart = ShoppingCart.Instance
        for (item , _) in cart
        {
            url = url! + String(item.id) + ","
        }
        url = String(url!.dropLast())
        self.addLoader()
        Utils.fillTheDataFromArray(url, callback: self.processProductStock, errorCallback: self.showError)
    }
    
    func processProductStock(_ dataArray : NSArray){
        defer{self.removeLoader()}
        for item in dataArray{
            let dictData = item as! NSDictionary
            let productId = dictData["Product id"] as! String
            let quantity = dictData["Quantity"] as! String
            let item = ShoppingCart.Instance.findItemByHash(Int(productId)!)
            let qty = Double(quantity)
            item?.totalNoInStock = Int(qty!)
            let shoppingCart = ShoppingCart.Instance
            let oldCount = shoppingCart.getCount(item!)
            if(oldCount > item?.totalNoInStock)
            {
                item!.setnumFromStock(Int(qty!))
                self.allCartItem.append(item!)
                ShoppingCart.Instance.addItem(item!, num: Int(qty!))
                self.displayCart()
                isLoadCartFromPrceedBtn = true
                moveToCheckoutPage()
            }
            else
            {
                let checkoutObject = self.storyboard?.instantiateViewController(withIdentifier: "guestCheckOutViewController") as? guestCheckOutViewController
                self.navigationController?.pushViewController(checkoutObject!, animated: true)
            }
        }
    }
    
    func plusButtonFunction(_ button: UIButton){
        
        if let item = ShoppingCart.Instance.findItemByHash(button.tag){
            
            if item.inStock{
                let shoppingCart = ShoppingCart.Instance
                var oldCount = shoppingCart.getCount(item)
                
                if(UserDefaults.standard.bool(forKey: "isLogin")){
                    if item.selctedNumFromStock > item.totalNoInStock{
                        oldCount = item.totalNoInStock
                        
                    }else{
                        oldCount = oldCount+1
                        
                    }
                    
                    self.increseDicreseCartServiceAction(item, count: oldCount)
                    
                }
                else{
                    oldCount = oldCount+1
                    if oldCount >= item.totalNoInStock{
                        self.overDraftMap[item.id] = true
                        self.reloadCart(item)
                    }else{
                        
                        shoppingCart.addItem(item, num: oldCount)
                        self.reloadCart(item)
                    }
                }
            }else{
                self.view.makeToast(ErrorHandler.Instance.getOutOfStockError())
            }
        }
    }
    
    @objc func plusButtonFunction1(_ button: UIButton){
        
        if let item = ShoppingCart.Instance.findItemByHash(button.tag){
            let shoppingCart = ShoppingCart.Instance
            let oldCount = shoppingCart.getCount(item)
            shoppingCart.addItem(item: item)
            let newCount = shoppingCart.getCount(item)
            
            if newCount <= oldCount{
                self.overDraftMap[item.id] = true
            }
            
            self.reloadCart(item)
        }
    }
    
    
    @objc func minusButtonFunction(_ button: UIButton){
        if let item = ShoppingCart.Instance.findItemByHash(button.tag){
            
            if item.inStock{
                let shoppingCart = ShoppingCart.Instance
                var oldCount = shoppingCart.getCount(item)
                if oldCount == 1{
                    
                }else{
                    oldCount = oldCount-1
                    shoppingCart.addItem(item, num: oldCount)
                    self.reloadCart(item)
                }
            }else{
                self.view.makeToast(ErrorHandler.Instance.getOutOfStockError())
            }
            
        }
    }
    
    func increseDicreseCartServiceAction(_ item:ShoppingItem,count:Int ){
        if let cartUrl = WebApiManager.Instance.getAddToCartUrl(String(item.id), itemCount: String(count)){
            let request: NSMutableURLRequest = NSMutableURLRequest(url: URL(string: cartUrl)!)
            self.addLoader()
            request.timeoutInterval = 180.0
            let appAccessKey = Config.Instance.getAppAccessKey()
            request.addValue(appAccessKey , forHTTPHeaderField: "Authorization")
            
            let task = URLSession.shared.dataTask(with: request as URLRequest){(data, response, error) -> Void in
                
                DispatchQueue.main.async {
                    do{self.removeLoader()}
                }
                
                if error == nil && data != nil {
                    if let dataDict = Utils.parseJSON(data!){
                        if let status = dataDict["status"] as? String {
                            if status == "success" {
                                DispatchQueue.main.async {
                                    self.increseDicreseCartItemAction(item, quantity: count)
                                }
                                
                            }else{
                                DispatchQueue.main.async {
                                    self.view.makeToast(status)
                                }
                            }
                            
                        }
                        
                    }else{
                        
                    }
                }else{
                    
                }
                
            }
            task.resume()
            
        }
    }
    
    fileprivate func increseDicreseCartItemAction(_ item:ShoppingItem,quantity : Int){
        item.selctedNumFromStock = quantity
        let shoppingCart = ShoppingCart.Instance
        DispatchQueue.main.async {
            shoppingCart.addItem(item, num: quantity)
            self.reloadCart(item)
        }
    }
    
    
    func loadCartData(){
        let url = WebApiManager.Instance.getCartListUrl()
        self.addLoader()
        Utils.fillTheData(url, callback: self.processCartData, errorCallback : self.showError)
    }
    
    fileprivate func processCartData(_ dataDict: NSDictionary){
        self.view.isUserInteractionEnabled = true
        self.allCartItem.removeAll()
        DispatchQueue.main.async {
            if let products_list = dataDict["data"] as? NSArray{
                
                ShoppingCart.Instance.clear()
                for  item in products_list {
                    let myItem = item as! NSDictionary
                    if let quantityInCart = myItem["quantity"] as? Int {
                        if let shoppingItem = StoreManager.Instance.createShoppingAccessoryForCartList(myItem){
                            
                            ShoppingCart.Instance.allCartItemIds += [shoppingItem.id]
                            
                            let type = myItem["type"] as! String
                            if type != "configurable"
                            {
                                shoppingItem.setnumFromStock(quantityInCart)
                                self.allCartItem.append(shoppingItem)
                                ShoppingCart.Instance.addItem(shoppingItem, num: quantityInCart)
                            }
                        }
                    }
                }
                
                
            }
            
            self.displayCart()
            self.moveToCheckoutPage()
            do{self.removeLoader()}
        }
    }
    
    func moveToCheckoutPage(){
        if isLoadCartFromPrceedBtn{
            
            if Utils.isMoveFromCartItem(){
                
                if ShoppingCart.Instance.getTotalCount()>0{
                    if(UserDefaults.standard.bool(forKey: "isLogin")){
                        let checkoutObject = self.storyboard?.instantiateViewController(withIdentifier: "buyNowViewController") as? buyNowViewController
                        self.navigationController?.pushViewController(checkoutObject!, animated: true)
                    }
                    else
                    {
                        let checkoutObject = self.storyboard?.instantiateViewController(withIdentifier: "guestCheckOutViewController") as? guestCheckOutViewController
                        self.navigationController?.pushViewController(checkoutObject!, animated: true)
                        
                    }
                }
                
                
                
            }else{
                
                self.view.makeToast("Please update required product of cart.")
            }
        }
        
    }
    
    
    
    
    @objc func deleteProductFunction(_ button: UIButton){
        
        let refreshAlert = UIAlertController(title: "", message: "Are you sure want to delete product from Cart?".localized(), preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "YES".localized(), style: .default, handler: { (action: UIAlertAction!) in
            if let item = ShoppingCart.Instance.findItemByHash(button.tag){
                ShoppingCart.Instance.deleteItem(item)
                self.deleteFeed(Int32(item.id))
            }
            
            self.displayCart()
        }))
        refreshAlert.addAction(UIAlertAction(title: "NO".localized(), style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        present(refreshAlert, animated: true, completion: nil)
        
    }
    
    
    @objc func wishListIconClicked(_ button: UIButton){
        if let item = ShoppingCart.Instance.findItemByHash(button.tag){
            Utils.addItemToMyWishlist(item, btnWish: button, controller: self)
        }
    }
    
    func setWishListStatus(_ button: UIButton){
        if let item = ShoppingCart.Instance.findItemByHash(button.tag){
            button.isSelected = ShoppingWishlist.Instance.isContainsItem(item)
        }
    }
    
    func deleteFeed(_ id:Int32)
    {
        let appDelegate =
            UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate?.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Cart")
        fetchRequest.predicate = NSPredicate(format: "id = %@", "\(id)")
        do
        {
            let fetchedResults =  try managedContext!.fetch(fetchRequest) as? [NSManagedObject]
            
            for entity in fetchedResults! {
                
                managedContext?.delete(entity)
            }
            
            try managedContext!.save()
        }
        catch _ {
            print("Could not delete")
            
        }
    }
    
    
    
    func deleteItemCartServiceAction(_ item:ShoppingItem,tag:Int){
        if let deleteCartUrl = WebApiManager.Instance.getDeleteProductFromCartUrl(String(item.id)){
            print(deleteCartUrl)
            let request: NSMutableURLRequest = NSMutableURLRequest(url: URL(string: deleteCartUrl)!)
//            if  let authappid = UserDefaults.standard.value(forKey: "appid"){
//                request.addValue(authappid as! String, forHTTPHeaderField: "authappid")
//            }
//            if  let token = UserDefaults.standard.value(forKey: "token"){
//                request.addValue(token as! String , forHTTPHeaderField: "token")}
//            if let secretkey = UserDefaults.standard.value(forKey: "secretkey")
//            {
//                request.addValue( secretkey as! String  , forHTTPHeaderField: "secretkey")
//            }
            let appAccessKey = Config.Instance.getAppAccessKey()
            request.addValue(appAccessKey , forHTTPHeaderField: "Authorization")
            
            self.addLoader()
            request.timeoutInterval = 180.0
            
            
            let task = URLSession.shared.dataTask(with: request as URLRequest){(data, response, error) -> Void in
                
                DispatchQueue.main.async {
                    do{self.removeLoader()}
                }
                
                if error == nil && data != nil {
                    if let dataDict = Utils.parseJSON(data!){
                        if let status = dataDict["status"] as? String {
                            if status == "success" {
                                DispatchQueue.main.async {
                                    self.deleteCartItem(tag)
                                }
                            }else{
                                self.view.makeToast(status)
                            }
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    
    fileprivate func deleteCartItem(_ tag:Int){
        DispatchQueue.main.async {
            if let item = ShoppingCart.Instance.findItemByHash(tag){
                ShoppingCart.Instance.deleteItem(item)
            }
            self.displayCart()
        }
    }
}

