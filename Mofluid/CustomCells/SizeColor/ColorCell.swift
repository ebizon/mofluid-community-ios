//
//  ColorCell.swift
//  Mofluid
//
//  Created by Saurabh Mishra on 7/10/18.
//  Copyright © 2018 Mofluid. All rights reserved.
//

import UIKit

class ColorCell: UICollectionViewCell {

    @IBOutlet weak var btnCell: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        btnCell.layer.borderColor       =       UIColor.gray.cgColor
        btnCell.layer.borderWidth       =       2.0
        // Initialization code
    }
}
