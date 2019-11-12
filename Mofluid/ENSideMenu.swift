//
//  SideMenu.swift
//  SwiftSideMenu
//
//  Created by Evgeny on 24.07.14.
//  Copyright (c) 2014 Evgeny Nazarov. All rights reserved.
//

import UIKit

@objc public protocol ENSideMenuDelegate {
    @objc optional func sideMenuWillOpen()
    @objc optional func sideMenuWillClose()
    @objc optional func sideMenuDidOpen()
    @objc optional func sideMenuDidClose()
    @objc optional func sideMenuShouldOpenSideMenu () -> Bool
    
}

@objc public protocol ENSideMenuProtocol {
    var sideMenu : ENSideMenu? { get }
    func setContentViewController(_ contentViewController: UIViewController)
}

public enum ENSideMenuAnimation : Int {
    case none
    case `default`
}

public enum ENSideMenuPosition : Int {
    case left
    case right
}

public extension UIViewController {
    
    // mahesh
    var className: String {
     
        return NSStringFromClass(self.classForCoder).components(separatedBy: ".").last!
    }
    // mahesh end

    
    func toggleSideMenuView () {
        
        sideMenuController()?.sideMenu?.toggleMenu()
    }
    
    func hideSideMenuView () {
        sideMenuController()?.sideMenu?.hideSideMenu()
    }
    
    func showSideMenuView () {
        
        sideMenuController()?.sideMenu?.showSideMenu()
    }
    
    func isSideMenuOpen () -> Bool {
        let sieMenuOpen = self.sideMenuController()?.sideMenu?.isMenuOpen
           return sieMenuOpen ?? false
    }
    
    func fixSideMenuSize() {
        if let navController = self.navigationController as? ENSideMenuNavigationController {
            navController.sideMenu?.updateFrame()
        }
    }
    
    func sideMenuController () -> ENSideMenuProtocol? {
        var iteration : UIViewController? = self.parent
        if (iteration == nil) {
            return topMostController()
        }
        repeat {
            if (iteration is ENSideMenuProtocol) {
                return iteration as? ENSideMenuProtocol
            } else if (iteration?.parent != nil && iteration?.parent != iteration) {
                iteration = iteration!.parent
            } else {
                iteration = nil
            }
        } while (iteration != nil)
        
        return iteration as? ENSideMenuProtocol
    }
    
    internal func topMostController () -> ENSideMenuProtocol? {
        var topController : UIViewController? = UIApplication.shared.keyWindow?.rootViewController
        if (topController is UITabBarController) {
            topController = (topController as! UITabBarController).selectedViewController
        }
        while (topController?.presentedViewController is ENSideMenuProtocol) {
            topController = topController?.presentedViewController
        }
        
        return topController as? ENSideMenuProtocol
    }
}

open class ENSideMenu : NSObject, UIGestureRecognizerDelegate {
    open var menuWidth : CGFloat = 160.0 {
        didSet {
            needUpdateApperance = true
            updateFrame()
        }
    }
    fileprivate var menuPosition:ENSideMenuPosition = .left
    open var bouncingEnabled :Bool = false
    open var animationDuration = 0.4
    fileprivate let sideMenuContainerView =  UIView()
    fileprivate var menuViewController : UIViewController!
    fileprivate var animator : UIDynamicAnimator!
    fileprivate var sourceView : UIView!
    fileprivate var needUpdateApperance : Bool = false
    open weak var delegate : ENSideMenuDelegate?
    fileprivate(set) var isMenuOpen : Bool = false
    open var allowLeftSwipe : Bool = true
    open var allowRightSwipe : Bool = true
    
    public init(sourceView: UIView, menuPosition: ENSideMenuPosition) {
        super.init()
        self.sourceView = sourceView
        self.menuPosition = menuPosition
        self.setupMenuView()
        
        animator = UIDynamicAnimator(referenceView:sourceView)
        animator.delegate = self
        
        let rightSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(ENSideMenu.handleGesture(_:)))
        rightSwipeGestureRecognizer.delegate = self
        rightSwipeGestureRecognizer.direction =  UISwipeGestureRecognizer.Direction.right
        
        let leftSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(ENSideMenu.handleGesture(_:)))
        leftSwipeGestureRecognizer.delegate = self
        leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizer.Direction.left
    }
    
    public convenience init(sourceView: UIView, menuViewController: UIViewController, menuPosition: ENSideMenuPosition) {
        self.init(sourceView: sourceView, menuPosition: menuPosition)
        self.menuViewController = menuViewController
        self.menuViewController.view.frame = sideMenuContainerView.bounds
        self.menuViewController.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        sideMenuContainerView.addSubview(self.menuViewController.view)
    }
    
    func updateFrame() {
        var width:CGFloat
        var height:CGFloat
        (width, height) = adjustFrameDimensions( sourceView.frame.size.width, height: sourceView.frame.size.height)
        let menuFrame = CGRect(
            x: (menuPosition == .left) ?
                isMenuOpen ? 0 : -menuWidth-1.0 :
                isMenuOpen ? width - menuWidth : width+1.0,
            y: sourceView.frame.origin.y,
            width: menuWidth,
            height: height
        )
        sideMenuContainerView.frame = menuFrame
    }
    
    fileprivate func adjustFrameDimensions( _ width: CGFloat, height: CGFloat ) -> (CGFloat,CGFloat) {
        if floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1 &&
            (UIApplication.shared.statusBarOrientation == UIInterfaceOrientation.landscapeRight ||
                UIApplication.shared.statusBarOrientation == UIInterfaceOrientation.landscapeLeft) {
            // iOS 7.1 or lower and landscape mode -> interchange width and height
            return (height, width)
        }
        else {
            return (width, height)
        }
        
    }
    
    fileprivate func setupMenuView() {
        updateFrame()
        
        sideMenuContainerView.backgroundColor = UIColor.clear
        sideMenuContainerView.clipsToBounds = false
        sideMenuContainerView.layer.masksToBounds = false
        sideMenuContainerView.layer.shadowOffset = (menuPosition == .left) ? CGSize(width: 1.0, height: 1.0) : CGSize(width: -1.0, height: -1.0)
        sideMenuContainerView.layer.shadowRadius = 1.0
        sideMenuContainerView.layer.shadowOpacity = 0.125
        sideMenuContainerView.layer.shadowPath = UIBezierPath(rect: sideMenuContainerView.bounds).cgPath
        
        sourceView.addSubview(sideMenuContainerView)
        
        if (NSClassFromString("UIVisualEffectView") != nil) {
            let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light)) as UIVisualEffectView
            visualEffectView.frame = sideMenuContainerView.bounds
            visualEffectView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            sideMenuContainerView.addSubview(visualEffectView)
            
        }
        else {
            // TODO: add blur for ios 7
        }
    }
    
    fileprivate func toggleMenu (_ shouldOpen: Bool) {
        if (shouldOpen && delegate?.sideMenuShouldOpenSideMenu?() == false) {
            return
        }
        updateSideMenuApperanceIfNeeded()
        isMenuOpen = shouldOpen
        var width:CGFloat
        var height:CGFloat
        (width, height) = adjustFrameDimensions( sourceView.frame.size.width, height: sourceView.frame.size.height - 50)
        if (bouncingEnabled) {
            
            animator.removeAllBehaviors()
            
            var gravityDirectionX: CGFloat
            var pushMagnitude: CGFloat
            var boundaryPointX: CGFloat
            var boundaryPointY: CGFloat
            
            if (menuPosition == .left) {
                gravityDirectionX = (shouldOpen) ? 1 : -1
                pushMagnitude = (shouldOpen) ? 20 : -20
                boundaryPointX = (shouldOpen) ? menuWidth : -menuWidth-2
                boundaryPointY = 20
            }
                
            else {
                gravityDirectionX = (shouldOpen) ? -1 : 1
                pushMagnitude = (shouldOpen) ? -20 : 20
                boundaryPointX = (shouldOpen) ? width-menuWidth : width+menuWidth+2
                boundaryPointY =  -20
            }
            
            let gravityBehavior = UIGravityBehavior(items: [sideMenuContainerView])
            gravityBehavior.gravityDirection = CGVector(dx: gravityDirectionX,  dy: 0)
            animator.addBehavior(gravityBehavior)
            
            let collisionBehavior = UICollisionBehavior(items: [sideMenuContainerView])
            collisionBehavior.addBoundary(withIdentifier: "menuBoundary" as NSCopying, from: CGPoint(x: boundaryPointX, y: boundaryPointY),
                                                        to: CGPoint(x: boundaryPointX, y: height))
            animator.addBehavior(collisionBehavior)
            
            let pushBehavior = UIPushBehavior(items: [sideMenuContainerView], mode: UIPushBehavior.Mode.instantaneous)
            pushBehavior.magnitude = pushMagnitude
            animator.addBehavior(pushBehavior)
            
            let menuViewBehavior = UIDynamicItemBehavior(items: [sideMenuContainerView])
            menuViewBehavior.elasticity = 0.25
            animator.addBehavior(menuViewBehavior)
            
        }
            
        else {
            var destFrame :CGRect
            if (menuPosition == .left) {
                destFrame = CGRect(x: (shouldOpen) ? -2.0 : -menuWidth, y: 0, width: menuWidth, height: height)
            }
            else {
                destFrame = CGRect(x: (shouldOpen) ? width-menuWidth : width+2.0,
                                       y: 0,
                                       width: menuWidth,
                                       height: height)
            }
            
            UIView.animate(
                withDuration: animationDuration,
                animations: { () -> Void in
                    self.sideMenuContainerView.frame = destFrame
                },
                completion: { (Bool) -> Void in
                    if (self.isMenuOpen) {
                        self.delegate?.sideMenuDidOpen?()
                    } else {
                        self.delegate?.sideMenuDidClose?()
                    }
            })
        }
        
        if (shouldOpen) {
            
            delegate?.sideMenuWillOpen?()
        } else {
            delegate?.sideMenuWillClose?()
        }
    }
    
    open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UISwipeGestureRecognizer {
            let swipeGestureRecognizer = gestureRecognizer as! UISwipeGestureRecognizer
            if !self.allowLeftSwipe {
                if swipeGestureRecognizer.direction == .left {
                    return false
                }
            }
            
            if !self.allowRightSwipe {
                if swipeGestureRecognizer.direction == .right {
                    return false
                }
            }
        }
        return true
    }
    
    @objc internal func handleGesture(_ gesture: UISwipeGestureRecognizer) {
        toggleMenu((self.menuPosition == .right && gesture.direction == .left)
            || (self.menuPosition == .left && gesture.direction == .right))
    }
    
    fileprivate func updateSideMenuApperanceIfNeeded () {
        if (needUpdateApperance) {
            var frame = sideMenuContainerView.frame
            frame.size.width = menuWidth
            sideMenuContainerView.frame = frame
            sideMenuContainerView.layer.shadowPath = UIBezierPath(rect: sideMenuContainerView.bounds).cgPath
            
            needUpdateApperance = false
        }
    }
    
    open func toggleMenu () {
        if (isMenuOpen) {
            toggleMenu(false)
        }
        else {
            updateSideMenuApperanceIfNeeded()
            toggleMenu(true)
        }
    }
    
    open func showSideMenu () {
        if (!isMenuOpen) {
            toggleMenu(true)
        }
    }
    
    open func hideSideMenu () {
        if (isMenuOpen) {
            toggleMenu(false)
        }
    }
}

extension ENSideMenu: UIDynamicAnimatorDelegate {
    public func dynamicAnimatorDidPause(_ animator: UIDynamicAnimator) {
        if (self.isMenuOpen) {
            self.delegate?.sideMenuDidOpen?()
        } else {
            self.delegate?.sideMenuDidClose?()
        }
    }
}

