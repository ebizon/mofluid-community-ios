//
//  CartCell.swift
//  Mofluid
//
//  Created by Saurabh Mishra on 19/07/18.
//  Copyright © 2018 Mofluid. All rights reserved.
//

import UIKit
protocol CartCellDelegate {
    
    func clickedOnPlus(_ item:ShoppingItem,qty:String,cell:CartCell)
    func clickedOnMinus(_ item:ShoppingItem,qty:String,cell:CartCell)
    func clickedOnDelete(_ item:ShoppingItem,qty:String,cell:CartCell)
    func clickedOnWishlist(_ item:ShoppingItem,cell:CartCell,button:UIButton)
}
class CartCell: UITableViewCell {
    
    @IBOutlet weak var btnWishlist          :   UIButton!
    @IBOutlet weak var btnDelete            :   UIButton!
    @IBOutlet weak var ivImage              :   UIImageView!
    @IBOutlet weak var lblName              :   UILabel!
    @IBOutlet weak var btnMinus             :   UIButton!
    @IBOutlet weak var btnPlus              :   UIButton!
    @IBOutlet weak var lblQtyPlaceholder    :   UILabel!
    @IBOutlet weak var viewQty              :   UIView!
    @IBOutlet weak var lblQty               :   UILabel!
    @IBOutlet weak var lblPrice             :   UILabel!
    @IBOutlet weak var lblWarning           :   UILabel!
    var item        :   ShoppingItem?
    var delegate    :   CartCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        btnWishlist.isHidden    =   true
        // Initialization code
    }
    //MARK: IBACTIONS
    @IBAction func clickPlus(_ sender: Any) {
        
        delegate?.clickedOnPlus(item!, qty:lblQty.text!,cell:self)
    }
    @IBAction func clickMinus(_ sender: Any) {
        
        delegate?.clickedOnMinus(item!, qty:lblQty.text!,cell:self)
    }
    @IBAction func clickedOnDelete(_ sender: Any) {
        
        delegate?.clickedOnDelete(item!, qty:lblQty.text!,cell:self)
    }
    
    @IBAction func clickedOnWish(_ sender: Any) {
        
        delegate?.clickedOnWishlist(item!,cell: self,button:btnWishlist)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
