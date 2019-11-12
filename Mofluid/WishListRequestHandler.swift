//
//  WishListRequestHandler.swift
//  Mofluid
//
//  Created by Saurabh Mishra on 17/07/18.
//  Copyright © 2018 Mofluid. All rights reserved.
//

import Foundation
class WishListRequestHandler{
    
    func getAllProductsForWishList(){
        
        if Settings().isUserLoggedIn(){
            
            let url = WebApiManager.Instance.getWishlistDataUrl()
            ApiManager().getApi(url: url!) { (response,status) in
                
                if status{
                    
                    if let _ = response as? NSArray {
                        
                        self.parseWishlistItems((response as? NSArray)!)
                    }
                }
            }
        }
    }
    func parseWishlistItems(_ response:NSArray){
        
        ShoppingWishlist.Instance.deleteAllItem()
        ShoppingWishlist.Instance.addItemFromArray(Utils.getProductFromDataArray(response))
    }
    func addToWishList(_ item:ShoppingItem,completion:@escaping(_ response:AnyObject,_ isSuccess:Bool)->Void){
        
        ShoppingWishlist.Instance.addItem(item)
        let url = WebApiManager.Instance.getAddWishlistItemUrl(String(item.id))
        ApiManager().getApi(url: url!, completion: { (response, status) in
                
            if status{
                
                completion(response,true)
                self.getAllProductsForWishList()
            }
            else{
                
                completion(NSNull(),false)
            }
        })
    }
    func removeFromWishList(_ item:ShoppingItem,completion:@escaping(_ response:AnyObject,_ isSuccess:Bool)->Void){
        
        let wishlistId  =   ShoppingWishlist.Instance.getItem(item)
        ShoppingWishlist.Instance.deleteItem(item)
        let url = WebApiManager.Instance.getDeleteProductFromWishlistUrl(String(wishlistId))
        ApiManager().getApi(url: url!, completion: { (response, status) in
            
            if status{
                
                completion(response,true)
                self.getAllProductsForWishList()
            }
            else{
                
                completion(NSNull(),false)
            }
        })
    }
}
