//
//  UIImageCache.swift
//  Mofluid
//
//  Created by Ebizon-mac-2015 on 18/08/15.
//  Copyright © 2015 Ebizon Net. All rights reserved.
//

import UIKit
import Foundation
import SDWebImage

class UIImageCache: NSObject {
    
    /********************************************************************************/
    static var Instance : UIImageCache = UIImageCache()
    let uiImageCache = NSCache<AnyObject, AnyObject>()
    let defaultImage = UIImage(named: "product_default_image")
    
    fileprivate override init(){
        super.init()
    }
    /********************************************************************************/
    func reset(){
        
        UIImageCache.Instance   =   UIImageCache()
    }
    func fetchImage(_ url: String, completionHandler:@escaping (_ image: UIImage?, _ url: String) -> ()) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async(execute: {()in
            
            if let uiImage = self.uiImageCache.object(forKey: url as AnyObject) as? UIImage{
                DispatchQueue.main.async(execute: {() in
                    completionHandler(uiImage, url)
                })
                return
            }
            
            URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: {data, response, error -> Void in
                if error != nil{
                    completionHandler(nil, url)
                    return
                }
                
                if data != nil {
                    if let image = UIImage(data: data!){
                        self.uiImageCache.setObject(image, forKey: url as AnyObject)
                        DispatchQueue.main.async(execute: {() in
                            completionHandler(image, url)
                        })
                    }
                    return
                }
                
            }).resume()
        })
    }
    
    static func setImageForSize(_ imageView : UIImageView, image: String?, frame: CGRect? = nil , id:Int , type :String){
        imageView.image = UIImageCache.Instance.defaultImage
        
        if image != nil{
            UIImageCache.Instance.fetchImage(image!, completionHandler:{(uiImage: UIImage?, url: String) in
                if uiImage != nil{
                    imageView.image = uiImage!
                }else{
                    imageView.image = UIImageCache.Instance.defaultImage
                }
                if let frame = frame{
                    imageView.frame = frame
                }
            })
        }
    }
    
    static func setImage(_ imageView : UIImageView, image: String?, iframe: CGSize? = nil){
        
        imageView.image = UIImageCache.Instance.defaultImage
        
        if let imageURL = image{
            //let url = URL(string:imageURL)
            imageView.kf.setImage(with:URL(string: imageURL))
            
            /*
            imageView.sd_setImage(with: url, placeholderImage: UIImageCache.Instance.defaultImage , options: SDWebImageOptions(rawValue: 0), completed: {(image: UIImage?, error: Error?, cacheType: SDImageCacheType, imageURL: URL?) in
                if let image = image {
                    imageView.image = image
                    
                if let frame = iframe{
                        let scaleImage = image.imageByScalingProportionallyToSize(frame)
                       imageView.image = scaleImage
                    
                        }else{
                        imageView.image = image
                    }
                    if (idForSelectedLangauge == Utils.getArebicLanguageCode()){
                        if #available(iOS 9.0, *) {
                            let flippedImage = image.imageFlippedForRightToLeftLayoutDirection()
                            imageView.image = flippedImage
                        }
                    }
                }
            })*/
        }
    }
    
    static func setButtonImage(_ button : UIButton, image: String?, setFrame : Bool){
        button.setImage(UIImageCache.Instance.defaultImage, for: UIControl.State())
        
        if image != nil{
            UIImageCache.Instance.fetchImage(image!, completionHandler:{(uiImage: UIImage?, url: String) in
                button.setImage(uiImage, for: UIControl.State())
                if setFrame && uiImage != nil{
                    button.frame = CGRect(x: 0, y: 0, width: uiImage!.size.width, height: 40) //Hack to fix title button whose height is already 40!
                }
            })
        }
    }
    
    static func setButtonBackgroundImage(_ button : UIButton, image: String?, scale: Bool = false){
        button.setBackgroundImage(UIImageCache.Instance.defaultImage, for: UIControl.State())
        
        if image != nil{
            UIImageCache.Instance.fetchImage(image!, completionHandler:{(uiImage: UIImage?, url: String) in
                if scale{
                    let scaledImage = uiImage?.imageByScalingProportionallyToSize(button.frame.size)
                    button.setBackgroundImage(scaledImage, for: UIControl.State())
                }else{
                    button.setBackgroundImage(uiImage, for: UIControl.State())
                }
            })
        }
    }
}
