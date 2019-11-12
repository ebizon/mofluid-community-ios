//
//  EditButton.swift
//  Mofluid
//
//  Created by Ebizon-mac-2015 on 05/10/15.
//  Copyright © 2015 Mofluid. All rights reserved.
//

import UIKit
import Foundation

class EditButton : UIButton{
    fileprivate let editImage = UIImage(named: "edit")
    
    override init(frame : CGRect){
        super.init(frame: frame)
        
        self.setImage(editImage, for: UIControl.State())
        self.setTitleColor(UIColor.black, for: UIControl.State())
        self.titleLabel?.font = UIFont(name: "Lato", size: 18)
        self.setTitle("Edit".localized(), for: UIControl.State())
        self.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        self.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: editImage!.size.width)
        self.titleEdgeInsets = UIEdgeInsets(top: -1, left: editImage!.size.width , bottom: 0, right: 0)

    }
    
    required init?(coder: NSCoder){
        super.init(coder: coder)
    }
}
