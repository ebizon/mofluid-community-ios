//
//  SearchVM.swift
//  Mofluid
//
//  Created by Saurabh Mishra on 20/08/18.
//  Copyright © 2018 Mofluid. All rights reserved.
//

import Foundation
class SearchVM{
    
    func getDataForKeyword(_ keyword:String,completion:@escaping(_ response:AnyObject,_ isSuccess:Bool)->Void){
        
        let url = WebApiManager.Instance.getSearchURL(keyword.lowercased() , pagesize: 5, currentPage: 1) ?? ""
        ApiManager().getApi(url: url) { (response, status) in
            
            status ? completion(response,true) : completion(NSNull(),false)
        }
    }
    func parseData(_ dataDict:NSDictionary)->[ShoppingItem]?{
        
        var shoppingItem    =   [ShoppingItem]()
        if let totalCount = dataDict["total"] as? Int{
            if(totalCount > 0){
                if let products_list = dataDict["data"] as? NSArray{
                    
                    for item in products_list{
                        
                        if let item = StoreManager.Instance.createShoppingAccessoryForSearch(item as! NSDictionary){
                            
                            shoppingItem.append(item)
                        }
                    }
                }
            }
        }
        return shoppingItem
    }
}
extension SearchVC:UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.count>=1{
            
            ivLoader.isHidden               =   false
            SearchVM().getDataForKeyword(searchText) { (response, status) in
                
                self.ivLoader.isHidden      =   true
                if status{
                    
                    self.item               =   SearchVM().parseData((response as? NSDictionary)!)!
                    self.tvList.reloadData()
                }
            }
        }
        else{
            
            self.item.removeAll()
            self.tvList.reloadData()
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
}
