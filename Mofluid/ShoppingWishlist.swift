

import UIKit

class ShoppingWishlist: NSObject{
    
    static let ArchiveURL = Utils.DocumentsDirectory.appendingPathComponent("MofluidWishlist")
    
    static var Instance = ShoppingWishlist()
    
    fileprivate var wishList:[ShoppingItem : Int] =  [ShoppingItem: Int]()
    
    fileprivate override init(){
        super.init()
    }
    
    func addItem(_ item:ShoppingItem){
        self.wishList[item] = 1
    }
    func reset(){
    
        ShoppingWishlist.Instance = ShoppingWishlist()
    }
    func addItemFromArray(_ arrItem:[ShoppingItem]){
        for item in arrItem{
            self.wishList[item] = 1
        }
    }
    
    func deleteItem(_ item: ShoppingItem){
        if let myItem = self.wishList.keys.filter({$0.id == item.id}).first {
            self.wishList.removeValue(forKey: myItem)
        }
    }
    
    func deleteAllItem(){
        self.wishList.removeAll()
    }
    
    func isContainsItem(_ item:ShoppingItem) -> Bool {
        return self.wishList.keys.filter({$0.id == item.id}).first != nil
    }
    func isContainsItemByName(_ item:ShoppingItem)->Bool{
        
        return self.wishList.keys.filter({$0.name    ==  item.name}).first != nil
    }
    func getItem(_ item:ShoppingItem)->Int{
        
        var id = 0
        if let myItem = self.wishList.keys.filter({$0.id == item.id}).first {
            
            id = myItem.wishListId
        }
        return id
    }
}
