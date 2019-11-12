//
//  FullImageViewController1.swift
//  Mofluid
//
//  Created by mac on 05/10/16.
//  Copyright © 2016 Mofluid. All rights reserved.
//

import UIKit

class FullImageViewController1: UIViewController {
    var indexOfImage = CGFloat()
    var pageControl = UIPageControl()
    var arrayImages =  [String]()
    var destinationView : UIViewController!
    
    @IBAction func discmissBtn(_ sender: AnyObject) {
        self.view.isUserInteractionEnabled = true
    
//        let firstVCView = destinationView.view as UIView!
//        let thirdVCView = self.view as UIView!
//        
//        let screenHeight = UIScreen.mainScreen().bounds.size.height
        
//        firstVCView.frame = CGRectOffset(firstVCView.frame, 0.0, screenHeight)
//        firstVCView.transform = CGAffineTransformScale(firstVCView.transform, 0.001, 0.001)
        
//        let window = UIApplication.sharedApplication().keyWindow
//        window?.insertSubview(thirdVCView, aboveSubview: firstVCView)
        
        
        
        
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            
            self.imgScrollView.transform = self.imgScrollView.transform.scaledBy(x: 0.001, y: 0.001)
           // thirdVCView.frame = CGRectOffset(thirdVCView.frame, 0.0, -screenHeight)
            
//            firstVCView.transform = CGAffineTransformIdentity
//            firstVCView.frame = CGRectOffset(firstVCView.frame, 0.0, -screenHeight)
            
        }, completion: { (Finished) -> Void in
            
            self.dismiss(animated: false, completion: nil)
        }) 
    
    
    
    
    
    
    
    }
        
//        
//         let productDtail = NewProductDetailePage(nibName: "NewProductDetailePage", bundle: nil)
//        let firstVCView = self.view as UIView!
//        
//        let thirdVCView = productDtail.view as UIView!
//        
//        let window = UIApplication.sharedApplication().keyWindow
//        window?.insertSubview(thirdVCView, belowSubview: firstVCView)
//        
//        
//      //  thirdVCView.transform = CGAffineTransformScale(thirdVCView.transform, 0.001, 0.001)
//        
//        UIView.animateWithDuration(0.5, animations: { () -> Void in
//            
//              firstVCView.transform = CGAffineTransformScale(thirdVCView.transform, 0.001, 0.001)
//            
//        }) { (Finished) -> Void in
//            
//            UIView.animateWithDuration(0.5, animations: { () -> Void in
//                thirdVCView.transform = CGAffineTransformIdentity
//                
//                }, completion: { (Finished) -> Void in
//                    
//                    firstVCView.transform = CGAffineTransformIdentity
//                    //self.navigationController?.pushViewController(productDtail, animated: true)
//                   self.dismissViewControllerAnimated(false, completion: nil)
//            })
//            
//        }
        
    
    @IBOutlet var imgScrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.pageContrl()
        
        var frame = imgScrollView.frame;
        frame.origin.x = UIScreen.main.bounds.size.width * indexOfImage
        frame.origin.y = 20
            imgScrollView.scrollRectToVisible(frame, animated: true)
    //  imgScrollView.backgroundColor = UIColor.redColor()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }

    
    func pageContrl(){
    
    let screenRect = UIScreen.main.bounds
    let screenWidth = screenRect.size.width;
    let screenHeight = screenRect.size.height;
    
    
    for i in 0 ..< arrayImages.count{
        var frame = CGRect()
        
    frame.origin.x = screenWidth * CGFloat(i) + 10;
    frame.origin.y = 60
    frame.size.height = screenHeight - 60
    frame.size.width  = screenWidth - 20;
    //  frame.size = self.scrollView.frame.size;
        let imageView = UIImageView()
        imageView.frame = frame
        imageView.contentMode = .scaleAspectFit
        
       // imageView.backgroundColor = UIColor.redColor()
        UIImageCache.setImage(imageView, image: arrayImages[i])

    
  
    imgScrollView.addSubview(imageView)
    
    }
    
    imgScrollView.contentSize = CGSize(width: screenWidth * CGFloat(arrayImages.count), height: 100);
    
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
