//
//  OptionCell.swift
//  Mofluid
//
//  Created by Saurabh Mishra on 17/08/18.
//  Copyright © 2018 Mofluid. All rights reserved.
//

import UIKit
protocol OptionDelegate {
    
    func clickedOnItem(_ tag:Int)
}
class OptionCell: UITableViewCell {

    @IBOutlet weak var btnSelect    :   UIButton!
    @IBOutlet weak var ivCircle     :   UIImageView!
    var option                      :   CustomOption?
    var delegate                    :   OptionDelegate?
    override func awakeFromNib() {
        
        btnSelect.isSelected    =   false
        ivCircle.image          =   #imageLiteral(resourceName: "unselect")
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func clickBtn(_ sender: Any) {
        
        delegate?.clickedOnItem(self.tag)
    }
}
