//
//  FlipFlopButton.swift
//  Mofluid
//
//  Created by Ebizon-mac-2015 on 05/10/15.
//  Copyright © 2015 Mofluid. All rights reserved.
//

import UIKit
import Foundation

class FlipFlopButton : UIButton{
    
    var selectedImage : UIImage? = nil{
        didSet {
            self.setImage(selectedImage, for: UIControl.State.selected)
            
            if selectedImage != nil{
                self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: selectedImage!.size.width)
                self.titleEdgeInsets = UIEdgeInsets(top: 0, left: selectedImage!.size.width + 10, bottom: 0, right: 0)
            }
          //  self.imageEdgeInsets = UIEdgeInsetsMake(0, 5, 0, selectedImage!.size.width)
           // self.titleEdgeInsets = UIEdgeInsetsMake(0, selectedImage!.size.width + 10, 0, 0)
        }
    }
    
    var unselectedImage : UIImage? = nil{
        didSet{
            self.setImage(unselectedImage, for: UIControl.State())
        }
    }
    
    override init(frame : CGRect){
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder){
        super.init(coder: coder)
    }
    
    func on(){
        self.isSelected = true
    }
    
    func off(){
        self.isSelected = false
    }
    
    func flip(){
        self.isSelected = self.isSelected != true
    }
}
