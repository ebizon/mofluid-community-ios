//
//  AddressCell.swift
//  Mofluid
//
//  Created by Saurabh Mishra on 5/29/18.
//  Copyright © 2018 Mofluid. All rights reserved.
//

import UIKit

class AddressCell: UITableViewCell {
    
    @IBOutlet weak var viewSeparator: UIView!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var btnSelect: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnRemove: UIButton!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        btnSelect.isSelected=false
        viewSeparator.frame.size.width=1
        viewMain.layer.cornerRadius=4.0
        lblName.font=UIFont (name: "Avenir-Heavy", size: 18)
        lblAddress.font=UIFont (name: "Avenir-Book", size: 17)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
