//
//  CustomCollectionViewCell.swift
//  Mofluid
//
//  Created by mac on 20/09/16.
//  Copyright © 2016 Mofluid. All rights reserved.
//
// Custom Cell for home page
import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    
    var productTitle = UILabel()
    var costTitle = UILabel()
    var new_img_view = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        let buttonView = UIView()
        let newListView = UIView()
        newListView.layer.borderColor = UIColor.white.cgColor
        newListView.layer.borderWidth = 2
        
        
        
        
        productTitle.textColor = UIColor.black
        costTitle.font = UIFont(name: "Lato", size: 14)
        productTitle.font = UIFont(name: "Lato", size: 14)
        productTitle.textColor = UIColor(netHex:0x1c1c1c)
        productTitle.textAlignment = .center;
        costTitle.textColor = UIColor(netHex:0xf7543e)
        costTitle.textAlignment = .center;
        new_img_view.contentMode = .scaleAspectFit
        
        new_img_view.image = UIImage(named: "product_default_image")
        
        if(deviceName == "big"){
            
            buttonView.frame = CGRect(x: 0, y: 0,width: 170, height: cellHeight)
            productTitle.frame = CGRect(x: 7, y: buttonView.frame.height - 23 , width:buttonView.frame.size.width-14, height: 23)
            costTitle.frame = CGRect(x: 1, y: buttonView.frame.height - 46 , width:buttonView.frame.size.width, height: 23)
            new_img_view.frame = CGRect(x: 0, y: 5, width: buttonView.frame.size.width, height: buttonView.frame.height - 51 )
            
        }
            
        else{
            buttonView.frame = CGRect(x: 0, y: 0, width: 120, height: cellHeight)
            
            productTitle.frame = CGRect(x: 7, y: buttonView.frame.height - 34 , width:buttonView.frame.size.width-14, height: 17)
            costTitle.frame = CGRect(x: 1, y: buttonView.frame.height - 17 , width:buttonView.frame.size.width, height: 17)
            new_img_view.frame = CGRect(x: 0, y: 5, width: buttonView.frame.size.width, height: buttonView.frame.size.height - 39)
                  costTitle.font = UIFont(name: "Lato", size: 12)
            productTitle.font = UIFont(name: "Lato", size: 12)
      
        }
//        buttonView.backgroundColor = UIColor.grayColor()
//        productTitle.backgroundColor = UIColor.redColor()
//        costTitle.backgroundColor = UIColor.blueColor()
//        new_img_view.backgroundColor = UIColor.cyanColor()
//        
        
        buttonView.addSubview(productTitle)
        buttonView.addSubview(costTitle)
        buttonView.addSubview(new_img_view)
        
        contentView.backgroundColor = UIColor.white
        contentView.addSubview(buttonView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
