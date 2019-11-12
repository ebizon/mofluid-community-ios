//
//  ShippingCell.swift
//  Mofluid
//
//  Created by Saurabh Mishra on 30/07/18.
//  Copyright © 2018 Mofluid. All rights reserved.
//

import UIKit
protocol ShippingCellDelegate {
    
    func tappedOnButton(title:String,cell:ShippingCell)
}
class ShippingCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tfTextfield: UITextField!
    @IBOutlet weak var btnSelect: UIButton!
    var isButton    =   false
    var delegate    :   ShippingCellDelegate?
    var tagIndex    :   Int?
    var isMandotory =   true
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnSelect.layer.borderColor     =   UIColor.black.cgColor
        btnSelect.layer.borderWidth     =   1.0
        if isButton{
            btnSelect.isHidden      =   false
            tfTextfield.isHidden    =   true
        }
        else{
            
            btnSelect.isHidden      =   true
            tfTextfield.isHidden    =   false
        }
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func clickButton(_ sender: Any) {
        
        self.delegate?.tappedOnButton(title: lblTitle.text!,cell: self)
    }
}
