//
//  myOrderTableViewCell.swift
//  Daily Jocks
//
//  Created by rohit on 07/06/16.
//  Copyright © 2016 Mofluid. All rights reserved.
//

import UIKit

class myOrderTableViewCell: UITableViewCell , UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       self.scrollView.delegate = self
       self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width * 2, height: 0)


    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
//
        // Configure the view for the selected state
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
        
    {
        if scrollView.contentOffset.x >  (UIScreen.main.bounds.size.width)/2 {
            var point  =  scrollView.contentOffset
            point.x = self.frame.size.width
            scrollView.setContentOffset(point, animated: true)
        }else{
            var point  =  scrollView.contentOffset
            point.x = 0
            scrollView.setContentOffset(point, animated: true)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool){
        if(!decelerate) {
            if scrollView.contentOffset.x >  (UIScreen.main.bounds.size.width)/2 {
                var point  =  scrollView.contentOffset
                point.x = self.frame.size.width
                scrollView.setContentOffset(point, animated: true)
            }else{
                var point  =  scrollView.contentOffset
                point.x = 0
                scrollView.setContentOffset(point, animated: true)
            }
        }
    }
    

}
