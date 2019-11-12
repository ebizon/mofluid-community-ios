//
//  CustomShoppingItem.swift
//  Mofluid
//
//  Created by MANISH on 28/10/15.
//  Copyright © 2015 Mofluid. All rights reserved.
//

import Foundation

class CustomShoppingItem : ShoppingItem{
    let customOptionsSet : [CustomOptionSet]
    
    init?(item: ShoppingItem, customOptionsSet: [CustomOptionSet]){
        self.customOptionsSet = customOptionsSet
        
        super.init(id: item.id, name: item.name, sku: item.sku, price: String(item.price), specialPrice: nil, inStock: item.inStock, image: item.image, type: item.type , img1: item.smallImg)
        
        super.numInStock = item.numInStock
        super.sku = item.sku
        
        if customOptionsSet.count == 0{
            return nil
        }
    }
    
    func getSelectedOptions()->[CustomOption]{
        var allSelected = [CustomOption]()
        
        for item in self.customOptionsSet{
            let selectedOption = item.options.filter({$0.selected == true})
            allSelected += selectedOption
        }
        
        return allSelected
    }

    override var price: Double {
        get {
            var priceVal = super.price
            
            let selectedOptions = self.getSelectedOptions()
            
            for option in selectedOptions{
                priceVal += Utils.StringToDouble(option.price)
            }
            
            for item in self.customOptionsSet{
                if let text = item.textBox?.text{
                    if text.count > 0 && item.priceStr != nil{
                        priceVal +=  Utils.StringToDouble(item.priceStr!)
                    }
                }
            }

            return priceVal
        }
    }
    
    override var priceStr: String {
        get {
            return Utils.appendWithCurrencySym(self.price)
        }
    }
    
     override var hash: Int {
        var hashValue = self.id.hashValue ^ self.price.hashValue
        let selectedOptions = self.getSelectedOptions()
        
        for option in selectedOptions{
            hashValue ^= option.id.hashValue
        }
        
        return hashValue
    }
    
    override func createJSON()->NSMutableDictionary{
        let dataDict = super.createJSON()
        let optionMap = self.createOptionMap()
        
        dataDict.setObject(optionMap, forKey: "options" as NSCopying)
        
        return dataDict
    }
    
    func createOptionMap()->NSDictionary{
        let dataDict = NSMutableDictionary()
        
        for item in self.customOptionsSet{
            if let text = item.textBox?.text{
                dataDict.setObject(text, forKey: item.id as NSCopying)
            }else{
                let selected = item.options.filter({$0.selected == true}).map({String($0.id)})
                dataDict.setObject(selected, forKey: item.id as NSCopying)
            }
        }
        
        return dataDict
    }
}
