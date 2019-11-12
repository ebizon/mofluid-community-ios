
//
//  GroupProductCellRTL.swift
//  ForDentist
//
//  Created by Shitanshu on 29/12/16.
//  Copyright © 2016 Mofluid. All rights reserved.
//

import UIKit

protocol GroupProductCellDelegateRTL {

    func shouldItemAddToCartdRTL(_ itemId:Int) -> Void
    
    func shouldShowAlertMessageRTL(_ msg : String) -> Void
}



class GroupProductCellRTL: UITableViewCell {
    
    @IBOutlet weak var quntityStaticLbl: UILabel!
    @IBOutlet var productImage: UIImageView!
    @IBOutlet var productName: UILabel!
    @IBOutlet var quantityLabel: UILabel!
    @IBOutlet var specialPriceLabel: UILabel!
    
    @IBOutlet var addToCartButton:UIButton!
    @IBOutlet var plusButton:UIButton!
    @IBOutlet var minusButton:UIButton!
    
    var delegate:GroupProductCellDelegateRTL?
    //var selectedQuantity = 1
    //    var canAddToCart:Bool{
    //        set{
    //            addToCartButton.enabled = newValue
    //        }
    //        get{
    //            return addToCartButton.enabled
    //        }
    //    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addToCartButton.layer.cornerRadius = 3
        quntityStaticLbl.text = "Quantity".localized()
        addToCartButton.setTitle("add_to_cart".localized(), for: UIControl.State())
        // Initialization code
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func configureCell(_ item:ShoppingItem, selectedQuantity: Int) {
        productName.text = item.name
        specialPriceLabel.text = Utils.appendWithCurrencySym((item.price * Double(selectedQuantity)))
        if let imageurl = item.image {
            productImage.sd_setImage(with: URL(string:imageurl))
        }
        
        
        minusButton.tag = item.id
        plusButton.tag = item.id
        addToCartButton.tag = item.id
        quantityLabel.text = String(selectedQuantity)
        //  self.selectedQuantity = selectedQuantity
        
        plusButton.isEnabled = true
        minusButton.isEnabled = true
        
        addToCartButton.isEnabled = true
        addToCartButton.backgroundColor = UIColor.init(netHex: 0xDF7272)
        if item.numInStock == 0 || !item.inStock {
            plusButton.isEnabled = false
            minusButton.isEnabled = false
            addToCartButton.isEnabled = false
            addToCartButton.backgroundColor = UIColor.lightGray
        }
    }
    
    
    @IBAction func onTapMinus(_ sender: UIButton){
        var count = 1
        if let item = StoreManager.Instance.getShoppingItem(sender.tag){
            count = item.selectedItemCount
            if count > 1{
                count -= 1
            }else{
                self.delegate?.shouldShowAlertMessageRTL("Quantity is not less then 1.")
            }
            item.setSelectedItemCountValue(count)
            quantityLabel.text = String(count)
            specialPriceLabel.text = Utils.appendWithCurrencySym((item.price * Double(count)))
        }
        
        //        if delegate != nil{
        //            let quantity = (delegate?.didItemQuantityDecreased(sender.tag))!
        //            quantityLabel.text = String(quantity)
        //        }
    }
    
    @IBAction func onTapPlus(_ sender: UIButton){
        var count = 1
        if let item = StoreManager.Instance.getShoppingItem(sender.tag){
            count = item.selectedItemCount
            if count != item.numInStock{
                count += 1
            }else{
                self.delegate?.shouldShowAlertMessageRTL("Quantity is not available or max limit is \(item.numInStock)")
            }
            item.setSelectedItemCountValue(count)
            quantityLabel.text = String(count)
            specialPriceLabel.text = Utils.appendWithCurrencySym((item.price * Double(count)))
        }
        
        
        //        if delegate != nil{
        //            let quantity = (delegate?.didItemQuantityIncrease(sender.tag))!
        //            quantityLabel.text = String(quantity)
        //
        //        }
    }
    
    @IBAction func onTapAddToCart(_ sender: UIButton){
        if delegate != nil{
            delegate?.shouldItemAddToCartdRTL(sender.tag)
        }
    }
}



