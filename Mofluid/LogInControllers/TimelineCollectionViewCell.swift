//
//  TimelineCollectionViewCell.swift
//  Daily Jocks
//
//  Created by rohit on 09/06/16.
//  Copyright © 2016 Mofluid. All rights reserved.
//

import UIKit

class TimelineCollectionViewCell: UICollectionViewCell {
    //MARK:- Outlets
    
    @IBOutlet weak var productImageView: UIImageView!
   // var timeLinePost : TimeLinePost?  ankur comment
    weak var delegate : OrdersOrTimeLineTableViewCellDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
      //ankur comment  self.addGesture(self.productImageView)
    }
    // ankur comment
    //    func addGesture(imageView : UIImageView){
//        let tapGesture = UITapGestureRecognizer(target: self, action:#selector(TimelineCollectionViewCell.tappedImageView(_:)))
//        tapGesture.numberOfTapsRequired = 1
//        imageView.userInteractionEnabled = true
//        imageView.addGestureRecognizer(tapGesture)
//    }
//    
//    func tappedImageView(sender: UITapGestureRecognizer) {
//        if let post = timeLinePost{
//            self.delegate?.openShopTheLook(post)
//        }
//    }
}
