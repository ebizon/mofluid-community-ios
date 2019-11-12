//
//  SearchCell.swift
//  Mofluid
//
//  Created by Saurabh Mishra on 20/08/18.
//  Copyright © 2018 Mofluid. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var ivProduct: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        lblName.font    =   Settings().latoBold
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
