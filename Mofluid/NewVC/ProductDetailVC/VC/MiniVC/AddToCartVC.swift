//
//  AddToCartVC.swift
//  Mofluid
//
//  Created by Saurabh Mishra on 7/4/18.
//  Copyright © 2018 Mofluid. All rights reserved.
//

import UIKit
protocol CartDelegate {
    
    func clickedOn(action:buttonAction,sender:UIButton)
}
class AddToCartVC: UIViewController,StackContainable {
    @IBOutlet weak var btnWishList  :   UIButton!
    @IBOutlet weak var btnCart      :   UIButton!
    @IBOutlet weak var btnBuyNow    :   UIButton!
    var delegate                    :   CartDelegate?
    var isStock                     =   true
    var item                        :   ShoppingItem?
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitControlls()
        // Do any additional setup after loading the view.
    }
    func setInitControlls(){
        
        btnBuyNow.backgroundColor     =      Settings().getButtonBgColor()
        btnWishList.isSelected        =      false
        btnBuyNow.isEnabled           =      isStock
        btnCart.isEnabled             =      isStock
        setWishlistButton()
        
    }
    public static func create() -> AddToCartVC {
        
        return AddToCartVC(nibName:"AddToCartVC",bundle: nil)
    }
    //MARK:- IBACTION
    
    @IBAction func clickCart(_ sender: Any) {
        
        delegate?.clickedOn(action: buttonAction.addtoCart,sender:btnCart)
    }
    @IBAction func clickWishlist(_ sender: Any) {
        
        delegate?.clickedOn(action: buttonAction.wishlist,sender:btnWishList)
    }
    
    @IBAction func clickBuyNow(_ sender: Any) {
        
        delegate?.clickedOn(action: buttonAction.buyNow,sender:btnBuyNow)
    }
    func setWishlistButton(){
        
        if ShoppingWishlist.Instance.isContainsItem(item!){
            btnWishList.isSelected = true
            btnWishList.setImage(#imageLiteral(resourceName: "wishList_selected"), for: UIControl.State.normal)
        }else{
            btnWishList.isSelected = false
            btnWishList.setImage(#imageLiteral(resourceName: "love"), for: UIControl.State.normal)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
