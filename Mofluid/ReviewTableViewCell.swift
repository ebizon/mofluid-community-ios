//
//  ReviewTableViewCell.swift
//  SultanCenter
//
//  Created by mac on 18/07/16.
//  Copyright © 2016 mac. All rights reserved.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {
    @IBOutlet var productNameLbl: UILabel!
    @IBOutlet var nameAndDateLbl: UILabel!
    @IBOutlet var descriptionLbl: UILabel!
    @IBOutlet var ratingControlView: RatingControl!
    @IBOutlet var lb: UILabel!
  
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        ratingControlView.isUserInteractionEnabled = false
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
