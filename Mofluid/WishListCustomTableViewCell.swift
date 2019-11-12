//
//  WishListCustomTableViewCell.swift
//  Mofluid
//
//  Created by mac on 10/10/16.
//  Copyright © 2016 Mofluid. All rights reserved.
//

import UIKit

class WishListCustomTableViewCell: UITableViewCell {
    
    @IBOutlet var itemIconImageVIew: UIImageView!
    @IBOutlet var productPriceLbl: UILabel!
    @IBOutlet var productTitleLbl: UILabel!
    @IBOutlet var buttonViewOutlet: UIButton!
    @IBOutlet var deleteBtnOutlet: UIButton!
    @IBOutlet var addtoCartBtnOutlet: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //    self.contentView.bringSubviewToFront(buttonViewOutlet)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
