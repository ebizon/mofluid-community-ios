//
//  selectFilterTableViewCell.swift
//  Mofluid
//
//  Created by Vivek Shukla on 11/07/16.
//  Copyright © 2016 Mofluid. All rights reserved.
//

import UIKit

class selectFilterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var btnRadio: UIButton!
    @IBOutlet weak var selectFilterItemLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
