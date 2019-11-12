//
//  PageViewController.swift
//  Mofluid
//
//  Created by Ebizon-mac-2015 on 01/10/15.
//  Copyright © 2015 Mofluid. All rights reserved.
//

import UIKit
import Foundation

class PageViewController: BaseViewController, UITextFieldDelegate{
    
    var backButton = UIButton()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.SetViewFrame()
        
        searchParentView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        self.createHeader()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "OptionViewTap"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "selectOptionViewOption"), object: nil)
        
    }
    
    override func createHeader() {
        super.createHeader()
        let spacer = Utils.createSpacer()
        super.addHeaderItem(spacer, callback: self.createBackButton)
    }
    
    func SetViewFrame(){
        mainParentScrollView.frame = CGRect(x: 0, y: searchParentView.frame.origin.y, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height-60)
    }
    
    func createBackButton()->UIBarButtonItem{
        let backButtonButtonItem = UIBarButtonItem()
        self.backButton = Utils.createBackButton()
        
        backButton.addTarget(self, action: #selector(backButtonFunction(_:)), for: .touchUpInside)
        backButtonButtonItem.customView = backButton
        
        return backButtonButtonItem
    }
    
    override func clickOnTitle(_ button: UIButton) {
        self.goToHomePage()
    }
    
    @objc func backButtonFunction(_ button:UIButton) {
        self.navigationController?.popViewController(animated: true)
        
    }
    func goToHomePage(){
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func FlipButton(_ button: FlipFlopButton?){
        if let button = button{
            for view in button.superview!.subviews{
                (view as? FlipFlopButton)?.off()
            }
            
            button.on()
        }
    }
    
    func AddImagetocartWithAnimation(_ itemImageView : UIImageView) {
        
//itemImageView.contentMode = .ScaleAspectFit
        var rect : CGRect =  itemImageView.superview!.convert(itemImageView.frame, from: nil)
        
        rect = CGRect(x: 5, y: (rect.origin.y * -1)-10, width: itemImageView.frame.size.width, height: itemImageView.frame.size.height)
        
        let starView : UIImageView = UIImageView(image: itemImageView.image)
        starView.frame = rect
        starView.layer.cornerRadius=5;
        starView.layer.borderWidth=1;
        self.view.addSubview(starView)
        let endPoint:CGPoint = CGPoint(x: 280+rect.size.width/2, y: 790+rect.size.height/2);
        
        let pathAnimation = CAKeyframeAnimation(keyPath: "position")
        pathAnimation.calculationMode = CAAnimationCalculationMode.paced
        pathAnimation.fillMode = CAMediaTimingFillMode.forwards
        pathAnimation.isRemovedOnCompletion = false
        pathAnimation.duration = 1.00
     //   pathAnimation.delegate=self
        
        let curvedPath:CGMutablePath = CGMutablePath()
        curvedPath.move(to: CGPoint(x : 1.0, y : 1.0))
        curvedPath.move(to: starView.frame.origin)
        curvedPath.addCurve(to: CGPoint(x : endPoint.x, y : starView.frame.origin.y), control1: CGPoint(x : endPoint.x, y : starView.frame.origin.y), control2: endPoint)
            
        pathAnimation.path = curvedPath
        
        // apply transform animation
        let basic : CABasicAnimation = CABasicAnimation(keyPath: "transform");
        let transform : CATransform3D = CATransform3DMakeScale(2,2,1 ) //0.25, 0.25, 0.25);
        basic.setValue(NSValue(caTransform3D: transform), forKey: "scaleText");
        basic.duration = 1.00
        
        starView.layer.add(pathAnimation, forKey: "curveAnimation")
        starView.layer.add(basic, forKey: "transform");
        
        let control: UIControl = UIControl()
        
        let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.70 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
            control.sendAction(#selector(UIView.removeFromSuperview), to: starView, for: nil)
            control.sendAction(#selector(PageViewController.reloadBadgeNumber), to: self, for: nil)
        })
        
    }
    
    @objc func reloadBadgeNumber(){
    }
    
    func navigationMenuDisable(_ boolean:Bool){
        if(boolean == true){
            self.menuButton.isUserInteractionEnabled = false
            self.backButton.isUserInteractionEnabled = false
            navigationItem.titleView?.isUserInteractionEnabled = false
        }
            
        else{
            self.menuButton.isUserInteractionEnabled = true
            self.backButton.isUserInteractionEnabled = true
            navigationItem.titleView?.isUserInteractionEnabled = true
        }
    }
    
}
