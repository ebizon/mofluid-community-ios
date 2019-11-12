//
//  ProductCell.swift
//  Mofluid
//
//  Created by Saurabh Mishra on 26/06/18.
//  Copyright © 2018 Mofluid. All rights reserved.
//

import UIKit

class ProductCell: UICollectionViewCell {

    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var ivProduct: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        //lblPrice.font   =   Settings().titleFont
        //lblName.font    =   Settings().titleFont
        // Initialization code
    }
}
