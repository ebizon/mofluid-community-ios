//
//  Constants.swift
//  Mobilestic
//
//  Created by Ebizon-mac-2015 on 19/08/15.
//  Copyright © 2015 Ebizon Net. All rights reserved.
//

import Foundation

class Constants : NSObject{
    //Config
    static let AppURL = "AppURL"
    static let AppBaseURL = "AppBaseURL"
    static let BaseURL = "BaseURL"
    static let StoreID = "StoreID"
    static let CurrencyCode = "CurrencyCode"
    static let CountryCode = "CountryCode"
    static let ApplePayMerchantID = "ApplePayMerchantID"
    static let GoogleClientID = "GoogleClientID"
    static let PayPalIDSandbox = "PayPalIDSandbox"
    static let PayPalIDLive = "PayPalIDLive"
    static let getFilter = "getFilter"
    static let searchFilter = "searchfilter"
    static let filter = "filter"  //ankur
    static let staoreinfo = "/api?&cmd=storeinfo"
    static let allreadyAddedWishlistMsg = "Product is already added in Wishlist!"
    static let addToWishlist = "addToWishlist"
    static let removeWishlist = "removeWishlist"
    static let getWishlist = "getWishlist"
    static let deleteMsgOfWishlist = "Are you sure want to delete product from Wishlist?"
    static let getallCMSPages = "getallCMSPages"
    //Web Services
    static let getProductStock1 = "getProductStock1"
    static let gettoken = "gettoken"
    static let getProductReviewUrl = "getProductReview"
    static let addProductReview = "addProductReview"
    static let related_products = "related_products"
    static let StoreDetail = "StoreDetail"
    static let BestsellerProducts = "BestsellerProducts"  // best seller
    static let FeaturedProduct = "FeaturedProduct"
    static let NewProduct = "NewProduct"
    static let CategoryProduct = "CategoryProduct"
    static let ProductDetail = "ProductDetail"
    static let ProductDetailConfigurable = "ProductDetailConfigurable"
    static let ProductDetailGrouped = "ProductDetailGrouped"
    static let ProductDetailImages = "ProductDetailImages"
    static let getGroupedProductDetail  =   "getGroupedProductDetail"
    static let Accessories = "Accessories"
    static let getProductCategory   =   "getProductCategory"
    static let CategoryNavigator = "CategoryNavigator"
    static let LoginAccess = "LoginAccess"
    static let ForgotPassword = "ForgotPassword"
    static let changePassword = "changePassword"
    static let CreateUser = "CreateUser"
    static let CheckOut = "CheckOut"
    static let SearchData = "SearchData"
    static let PlaceOrder = "PlaceOrder"
    static let MyOrder = "MyOrder"
    static let MyDownloads =  "MyDownloads"
    static let SearchFilteredProduct = "SearchFilteredProduct"
    static let CountryList = "CountryList"
    static let StateList = "StateList"
    static let PaymentMethods = "PaymentMethods"
    static let Reorder = "Reorder"
    static let SubCategory = "SubCategory"
    static let ImageVal = "ImageVal"
    static let LoginWithSocial = "LoginWithSocial"
    static let mofluidAppExtension = "mofluidapi2?callback"
    static let removeCartItem = "removeCartItem"
    static let addCartItem = "addCartItem"
    static let clearCart = "clearCart"
    static let getCartItems = "getCartItems"
    static let addressList = "addressList"
    static let getAddress = "getAddress"
    static let updateAddress = "updateAddress"
    static let addNewAddress = "addNewAddress"
    static let getBillingAddress = "getBillingAddress"
    static let getShippingAddress = "getShippingAddress"
    static let getShippingMethod = "getShippingMethod"
    static let CheckOutAndPaymentMethods = "CheckOutAndPaymentMethods"
    static let GetImage = "GetImage"
    static let UpdateProfile = "UpdateProfile"
    //Errors
    static let GenericError = "GenericError"
    static let NoInternetConnection = "NoInternetConnection"
    static let NoDescription = "NoDescription"
    static let FailedPlaceOrder = "FailedPlaceOrder"
    static let OutOfStockError = "OutOfStock"
    
    
    // mahesh
    static let quantityNotAvailable = "quantityNotAvailable"
    static let AddToCart = "AddToCart"
    static let DeleteCart = "DeleteCart"
    
    static let TwoCheckoutURL = "TwoCheckoutURL"
    static let AppAccessKey = "AppAccessKey"
}
