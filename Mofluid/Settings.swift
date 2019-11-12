//
//  Settings.swift
//  Mofluid
//
//  Created by Saurabh Mishra on 6/25/18.
//  Copyright © 2018 Mofluid. All rights reserved.
//

import Foundation
enum buttonAction{
    
    case buyNow
    case addtoCart
    case wishlist
}
class Settings{
    
    //MARK:- Fonts
    let headerFont          =   UIFont(name: "Ubuntu", size: 14)
    let titleFont           =   UIFont(name: "Ubuntu-Light", size: 17)
    let boldFont            =   UIFont(name: "Ubuntu-Bold", size: 21)
    let sectionFont         =   UIFont(name: "Ubuntu-Bold", size: 17)
    let oldFont             =   UIFont(name:"Lato-Regular",size:17)
    let latoBold            =   UIFont(name: "Lato-Bold", size: 18)
    //MARK:- Hardcoded String
    let cancel                  =   "Cancel".localized()
    let ok                      =   "OK".localized()
    let forgetUserNameSuccess   =   "You will receive an email with a link to reset your password.".localized()
    let forgetUserError         =   "There is no account associated with".localized()
    let signUpSuccess           =   "You have successfully signed up!".localized()
    let errorMessage            =   "Something went wrong!".localized()
    let selectAttributeMessage  =   "Please select all options to add into cart".localized()
    let credentialMessage       =   "Wrong Crdentails!".localized()
    let addToCart               =   "Your product is addded to cart".localized()
    let maxQty                  =   "Product reached to its maximum available quantity".localized()
    //cart
    let alreadyAddedInCart      =   "Product is already added in cart!".localized()
    let outofStock              =   "Quantity Out of Stock".localized()
    let myCart                  =   "MY CART".localized()
    let deleteFromCart          =   "Are you sure you want to delete this product from Cart?".localized()
    let shopnow                 =   "SHOP NOW".localized()
    let emptyCart               =   "Your Cart is Empty!".localized()
    let addItem                 =   "Add items to it now?".localized()
    let askForLoginWishlist     =   "Please login to add product into wishlist".localized()
    let askForLoginCheckout     =   "Please login to proceed".localized()
    let refreshCart             =   "Refreshing Cart!".localized()
    let addressMissing          =   "Address is empty , please fill the required information!".localized()
    //
    //address
    let select                  =   "Select".localized()
    let shippingAddress         =   "SHIPPING ADDRESS".localized()
    let sameAddress             =   "Billing & Shipping address".localized()
    let diffAddress             =   "Shipping to different address".localized()
    let erFirstname             =   "First Name is missing!".localized()
    let erLastname              =   "Last Name is missing!".localized()
    let erNumber                =   "Contact Number is missing!".localized()
    let erAdd1                  =   "Address1 is missing!".localized()
    let erAdd2                  =   "Address2 is missing!".localized()
    let erCity                  =   "City is missing!".localized()
    let erCountry               =   "Country is missing!".localized()
    let erState                 =   "State is missing!".localized()
    let erZipcode               =   "ZipCode is missing!".localized()
    //
    //search
    let search                  =   "SEARCH".localized()
    //
    let liveUrl                 =   "https://store2.mofluid.com/"
    let demoUrl                 =   "http://test.store2.mofluid.com/"
    let testUrl                 =   "http://test.store2.mofluid.com/"
    
    //1. background color
    enum addressForm{
        case country
        case state
    }
    func getBackgroundColor()->UIColor{
        
        return UIColor(red: 250/255.0, green: 250/255.0, blue: 252/255.0, alpha: 1.0)
    }
    //2.Text color
    func getTextColor()->UIColor{
        
        return UIColor(red: 0/255.0, green: 120.0/255.0, blue: 108.0/255.0, alpha: 1.0)
    }
    //3.button bg color
    func getButtonBgColor()->UIColor{
        
        return UIColor(red: 239/255.0, green: 170.0/255.0, blue: 47.0/255.0, alpha: 1.0)
    }
    func isUserLoggedIn()->Bool{
        
        var status = false
        if UserDefaults.standard.bool(forKey: "isLogin"){
            
            status  =    true
        }
        return status
    }
}
