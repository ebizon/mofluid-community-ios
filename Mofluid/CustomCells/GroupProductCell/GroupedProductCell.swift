//
//  GroupedProductCell.swift
//  Mofluid
//
//  Created by Saurabh Mishra on 7/13/18.
//  Copyright © 2018 Mofluid. All rights reserved.
//

import UIKit
protocol GroupCellDelegate {
    
    func clickedOnPlus(_ item:ShoppingItem,qty:String,cell:GroupedProductCell)
    func clickedOnMinus(_ item:ShoppingItem,qty:String,cell:GroupedProductCell)
    func clickedOnAddToCart(_ item:ShoppingItem,qty:String,cell:GroupedProductCell)
}
class GroupedProductCell: UITableViewCell {

    @IBOutlet weak var ivProduct    :   UIImageView!
    @IBOutlet weak var lblName      :   UILabel!
    @IBOutlet weak var btnAddtoCart :   UIButton!
    @IBOutlet weak var lblQty       :   UILabel!
    @IBOutlet weak var btnQty       :   UILabel!
    @IBOutlet weak var btnPlus      :   UIButton!
    @IBOutlet weak var btnMinus     :   UIButton!
    @IBOutlet weak var lblPrice     :   UILabel!
    var delegate:GroupCellDelegate?
    var item : ShoppingItem?
    override func awakeFromNib() {
        super.awakeFromNib()
        btnAddtoCart.backgroundColor    =   Settings().getButtonBgColor()
        // Initialization code
    }
    //MARK: IBACTIONS
    @IBAction func clickPlus(_ sender: Any) {
        
        delegate?.clickedOnPlus(item!, qty:btnQty.text!,cell:self)
    }
    @IBAction func clickMinus(_ sender: Any) {
        
        delegate?.clickedOnMinus(item!, qty:btnQty.text!,cell:self)
    }
    @IBAction func clickAddtoCart(_ sender: Any) {
        
        delegate?.clickedOnAddToCart(item!, qty:btnQty.text!,cell:self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
