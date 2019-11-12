//
//  GroupedModel.swift
//  Mofluid
//
//  Created by Saurabh Mishra on 7/13/18.
//  Copyright © 2018 Mofluid. All rights reserved.
//

import Foundation
class GroupedModel{

    var relatedProducts     =   [ShoppingItem]()
    
    func parseGroupedData(_ item:ShoppingItem,_ dataDict:NSDictionary)->[ShoppingItem]{
        
        //data for main products
        let products            =       dataDict.value(forKey: "product_links") as! NSArray
        for value in products{
            
            let productDetail   =       (value as? NSDictionary)?.value(forKey:"detail") as? NSDictionary
            let name            =       productDetail?.value(forKey:"name") as! String
            let id              =       productDetail?.value(forKey:"id") as! Int
            let sku             =       productDetail?.value(forKey:"sku") as! String
            let price           =       productDetail?.value(forKey:"price") as! Int
            let type            =       productDetail?.value(forKey: "type_id") as! String
            //get the stock values
            let stock           =   self.parseStockData((productDetail?.value(forKey:"extension_attributes") as! NSDictionary).value(forKey:"stock_item") as! NSDictionary)
            let imageDesc       =   getImageUrl(productDetail!)
            let groupedItem     =   ShoppingItem(id:id,name:name,sku:sku,price:"\(price)",specialPrice: getSpecialPrice(productDetail?.value(forKey:"custom_attributes") as! NSArray), inStock:stock.isStock, image: imageDesc, type: type, img1: nil)
            groupedItem?.productDesc        =   getProductDescription(productDetail?.value(forKey:"custom_attributes") as! NSArray)
            groupedItem?.numInStock         =   stock.qty
            groupedItem?.totalNoInStock     =   stock.qty
            relatedProducts.append(groupedItem!)
        }
        return relatedProducts
    }
    func getProductDescription(_ dict:NSArray)->String{
        
        var description = ""
        for item in dict{
            
            if (((item as? NSDictionary)?.value(forKey:"description")) != nil){
                
                description = (item as? NSDictionary)?.value(forKey: "description") as! String
                break
            }
        }
        return description
    }
    func getSpecialPrice(_ dict:NSArray)->String{
        
        var specialPrice = ""
        for item in dict{
            
            if (((item as? NSDictionary)?.value(forKey:"special_price")) != nil){
                
                specialPrice = (item as? NSDictionary)?.value(forKey: "special_price") as! String
                break
            }
        }
        return specialPrice
    }
    func getImageUrl(_ dict:NSDictionary)->String{
        
        let imageDesc   =   dict.value(forKey: "media_gallery_entries") as? NSArray
        var filePath    =   ""
        for item in imageDesc!{
            
            filePath    =   (item as? NSDictionary)?.value(forKey: "file")  as! String
        }
        return Config.Instance.getRawBaseUrl() + "/pub/media/catalog/product/" + filePath
    }
    
    func parseStockData(_ dict:NSDictionary)->(isStock:Bool,qty:Int){
        
        let isInStock   =   dict.value(forKey: "is_in_stock") as? Bool
        let qty         =   dict.value(forKey: "qty") as? Int
        return(isStock:isInStock!,qty:qty!)
    }
}
