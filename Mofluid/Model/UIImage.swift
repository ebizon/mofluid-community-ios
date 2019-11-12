//
//  UIImage.swift
//  Mofluid
//
//  Created by Ebizon-mac-2015 on 05/10/15.
//  Copyright © 2015 Mofluid. All rights reserved.
//

import UIKit
import Foundation

extension UIImage {
    func imageByScalingProportionallyToSize(_ targetSize: CGSize)->UIImage?{
        
        let sourceImage = self
        var newImage : UIImage? = self
        
        let imageSize = sourceImage.size
        let width = imageSize.width
        let height = imageSize.height
        
        let targetWidth = targetSize.width
        let targetHeight = targetSize.height
        
        var scaleFactor : CGFloat = 1.0
        
        var thumbnailPoint = CGPoint(x: 0.0,y: 0.0)
        
        if (!imageSize.equalTo(targetSize)) {
            
            let widthFactor = targetWidth / width
            let heightFactor = targetHeight / height
            
            if (widthFactor < heightFactor){
                scaleFactor = widthFactor;
            }else{
                scaleFactor = heightFactor;
            }
            
            let scaledWidth  = width * scaleFactor
            let scaledHeight = height * scaleFactor
            
            if (widthFactor < heightFactor) {
                thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5
            } else if (widthFactor > heightFactor) {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5
            }
            
            
            UIGraphicsBeginImageContextWithOptions(targetSize, false, 0)
            var thumbnailRect = CGRect.zero
            thumbnailRect.origin = thumbnailPoint;
            thumbnailRect.size.width  = scaledWidth
            thumbnailRect.size.height = scaledHeight
            
            sourceImage.draw(in: thumbnailRect)
            
            newImage = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext();
            
            if newImage == nil{
                newImage = self
            }
        }
        
        return newImage
    }
}

