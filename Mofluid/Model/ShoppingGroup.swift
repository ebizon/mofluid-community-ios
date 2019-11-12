//
//  ShoppingGroup.swift
//  Mofluid
//
//  Created by Ebizon-mac-2015 on 01/09/15.
//  Copyright (c) 2015 Ebizon Net. All rights reserved.
//

import Foundation

class ShoppingGroup : NSObject{
    let id : Int
    let parentGroup : ShoppingGroup?
    let name : String
    let children : NSArray?
    // MARK: Initialization
    init?(id: Int, parentGroup: ShoppingGroup?, name: String, children : NSArray?) {
        self.id = id
        self.parentGroup = parentGroup
        self.name = name
        self.children = children
        
        super.init()
        
        if name.isEmpty{
            return nil
        }
    }
    
    func getSubgroups()-> [ShoppingGroup]{
        var subgroups = [ShoppingGroup]()
        if id > 0{
            let tempsubgroups = self.getFetchedSubgroups()
            
            if tempsubgroups.count > 0{
                subgroups = tempsubgroups
                let all = "All ".localized()
                let Name = all + self.name
                if let subItem = ShoppingGroup(id: -1, parentGroup: self, name: Name, children: nil){
                    subgroups.insert(subItem, at: 0)
                }
            }
            
        }
            
        else if id == -1{
            if let parentGroup = self.parentGroup{
                subgroups = parentGroup.getFetchedSubgroups()
                
                if let subItem = ShoppingGroup(id: -2, parentGroup: parentGroup, name: "All Products".localized(), children: nil){
                    subgroups.insert(subItem, at: 0)
                }
            }
        }
        
        return subgroups
    }
    
    func getFetchedSubgroups()-> [ShoppingGroup]{
        var id: String? = nil
        var subgroups = [ShoppingGroup]()
        if self.children != nil{
            for item in self.children!{
                if let itemDict = item as? NSDictionary{
                    if (itemDict["id"] as? String != nil) || (itemDict["store_id"] as? String != nil)
                    {
                        if let idStr = itemDict["id"] as? String{
                            id = idStr
                        }else{
                            id = itemDict["store_id"] as? String
                        }
                        
                        var name = itemDict["name"] as? String
                        if(name == nil){
                            name = itemDict["store"] as? String
                        }
                        
                        var subGroupChild = itemDict["children"] as? NSArray
                        
                        if(subGroupChild == nil)
                        {
                            if let dic = itemDict["view"] as? NSDictionary{
                                subGroupChild = dic.allValues as NSArray?
                            }
                            
                            
                            if  name != nil
                            {
                                let pid = Int(id!)
                                if let subItem = ShoppingGroup(id: pid!, parentGroup : self, name: name!, children: subGroupChild)
                                {
                                    subgroups.append(subItem)
                                }
                            }
                        }
                        
                    }
                }
            }
        }
        
        return subgroups
        
    }
}
