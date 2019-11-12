//
//  Utils.swift
//  Mobilestic
//
//  Created by Ebizon-mac-2015 on 18/08/15.
//  Copyright © 2015 Ebizon Net. All rights reserved.
// 5s width ---- 320
// 6 width ---- 375
// 6+ ---- 414
//ipad --- 768

import UIKit
import Foundation
import CoreData
import TPKeyboardAvoiding

enum AddressType : Int{
    case billing = 1
    case shipping = 2
}

class Utils : NSObject{
    
    var optionImage = UIImage(named: "rightMenu")
    static let rightArrowBack = UIImage(named: "right-ArrowBlack")
    static let backNavigationImage = UIImage(named: "back")
    /*------------------------------------Common to all Pages-----------------------------------------------------*/
    static func createMainParentView(_ mainView: UIView)->UIView{
        
        let mainParentView = UIView(frame: CGRect(x: 0, y: 62, width: deviceWidth, height: deviceHeight))
        
        if(deviceWidth >= 1025){
            deviceName = "big"
        }
        else if(deviceWidth >= 768 && deviceWidth < 1025){
            deviceName = "big"
        }
        else if(deviceWidth >= 569 && deviceWidth < 768){
            deviceName = "big"
        }
        else if(deviceWidth >= 481 && deviceWidth < 569){
            deviceName = ""
        }
        else if(deviceWidth >= 320 && deviceWidth < 481){
            deviceName = ""
        }
        else if(deviceWidth < 320){
            deviceName = ""
        }
        
        
        return mainParentView
        
    }
    static func createSearchParentView(_ mainView: UIView)->UIView{
        
        let searchParentView = UIView()
        
        if(deviceWidth >= 1025){
            searchParentView.frame = CGRect(x: 0, y: 0, width: mainView.frame.size.width, height: 60)
        }
        else if(deviceWidth >= 768 && deviceWidth < 1025){
            searchParentView.frame = CGRect(x: 0, y: 0, width: mainView.frame.size.width, height: 60)
        }
        else if(deviceWidth >= 569 && deviceWidth < 768){
            searchParentView.frame = CGRect(x: 0, y: 0, width: mainView.frame.size.width, height: 60)
        }
        else if(deviceWidth >= 481 && deviceWidth < 569){
            searchParentView.frame = CGRect(x: 0, y: 0, width: mainView.frame.size.width, height: 50)
        }
        else if(deviceWidth >= 320 && deviceWidth < 481){
            searchParentView.frame = CGRect(x: 0, y: 0, width: mainView.frame.size.width, height: 50)
        }
        else if(deviceWidth < 320){
            searchParentView.frame = CGRect(x: 0, y: 0, width: mainView.frame.size.width, height: 50)
        }
        
        searchParentView.backgroundColor = UIColor(netHex:0xff8b01)
        
        return searchParentView
        
    }
    
    static func createSearchbox(_ mainView: UIView)->UISearchBar{
        
        let searchbox = UISearchBar(frame: CGRect(x: 15, y: 9, width: mainView.frame.size.width - 30, height: mainView.frame.size.height - 16))
        searchbox.backgroundImage = UIImage(named: "background")
        return searchbox
        
    }
    
    static func createMainParentScrollView(_ mainView: UIView)->TPKeyboardAvoidingScrollView{
        let mainParentScrollView = TPKeyboardAvoidingScrollView(frame: CGRect(x: 0, y: 0, width: deviceWidth, height: deviceHeight - 100))
        return mainParentScrollView
    }
    
    static func createFooter(_ mainView: UIView)->UIToolbar{
        let footer = UIToolbar()
        
        if(deviceWidth >= 1025){
            footer.frame = CGRect(x: 0, y: mainView.frame.size.height + mainView.frame.origin.y - 60, width: mainView.frame.size.width, height: 60)
        }
        else if(deviceWidth >= 768 && deviceWidth < 1025){
            footer.frame = CGRect(x: 0, y: mainView.frame.size.height + mainView.frame.origin.y - 60, width: mainView.frame.size.width, height: 60)
        }
        else if(deviceWidth >= 569 && deviceWidth < 768){
            footer.frame = CGRect(x: 0, y: mainView.frame.size.height + mainView.frame.origin.y - 60, width: mainView.frame.size.width, height: 60)
        }
        else if(deviceWidth >= 481 && deviceWidth < 569){
            footer.frame = CGRect(x: 0, y: mainView.frame.size.height + mainView.frame.origin.y - 50, width: mainView.frame.size.width, height: 50)
        }
        else if(deviceWidth >= 320 && deviceWidth < 481){
            footer.frame = CGRect(x: 0, y: mainView.frame.size.height + mainView.frame.origin.y - 50, width: mainView.frame.size.width, height: 50)
        }
        else if(deviceWidth < 320){
            footer.frame = CGRect(x: 0, y: mainView.frame.size.height + mainView.frame.origin.y - 50, width: mainView.frame.size.width, height: 50)
        }
        
        footer.backgroundColor = UIColor(netHex:0xff8b01)
        footer.barTintColor = UIColor(netHex:0xff8b01)
        return footer
    }
    
    static func createTitileButton(_ logo : String?)->UIButton{
        let titleButton =  UIButton()
        if(deviceWidth >= 1025){
            titleButton.frame = CGRect(x: 0, y: 0, width: 100, height: 30) as CGRect
        }
        else if(deviceWidth >= 768 && deviceWidth < 1025){
            titleButton.frame = CGRect(x: 0, y: 0, width: 100, height: 30) as CGRect
        }
        else if(deviceWidth >= 569 && deviceWidth < 768){
            titleButton.frame = CGRect(x: 0, y: 0, width: 100, height: 30) as CGRect
        }
        else if(deviceWidth >= 481 && deviceWidth < 569){
            titleButton.frame = CGRect(x: 0, y: 0, width: 100, height: 30) as CGRect
        }
        else if(deviceWidth >= 320 && deviceWidth < 481){
            titleButton.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        }
        else if(deviceWidth < 320){
            titleButton.frame = CGRect(x: 0, y: 0, width: 100, height: 30) as CGRect
        }
        
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        UIImageCache.setImage(imgView, image: logo)
        imgView.contentMode = UIView.ContentMode.scaleToFill
        imgView.frame = CGRect(x: 0, y: 0, width: titleButton.frame.width, height: titleButton.frame.height)
        titleButton.addSubview(imgView)
        titleButton.bringSubviewToFront(titleButton.imageView!)
        
        return titleButton
    }
    
    static func createHomeButton()->UIButton{
        let homeButton: UIButton = UIButton()
        
        if(deviceWidth >= 1025){
            homeButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34) as CGRect
        }
        else if(deviceWidth >= 768 && deviceWidth < 1025){
            homeButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34) as CGRect
        }
        else if(deviceWidth >= 569 && deviceWidth < 768){
            homeButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30) as CGRect
        }
        else if(deviceWidth >= 481 && deviceWidth < 569){
            homeButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25) as CGRect
        }
        else if(deviceWidth >= 320 && deviceWidth < 481){
            homeButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25) as CGRect
        }
        else if(deviceWidth < 320){
            homeButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25) as CGRect
        }
        
        let homeImg = UIImage(named: "home")
        homeButton.setBackgroundImage(homeImg, for: UIControl.State())
        return homeButton
    }
    static func createSearchButton()->UIButton{
        let searchButton: UIButton = UIButton()
        
        if(deviceWidth >= 1025){
            searchButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34) as CGRect
        }
        else if(deviceWidth >= 768 && deviceWidth < 1025){
            searchButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34) as CGRect
        }
        else if(deviceWidth >= 569 && deviceWidth < 768){
            searchButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30) as CGRect
        }
        else if(deviceWidth >= 481 && deviceWidth < 569){
            searchButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25) as CGRect
        }
        else if(deviceWidth >= 320 && deviceWidth < 481){
            searchButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25) as CGRect
        }
        else if(deviceWidth < 320){
            searchButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25) as CGRect
        }
        
        let searchImg = UIImage(named: "search")
        searchButton.setBackgroundImage(searchImg, for: UIControl.State())
        return searchButton
    }
    static func createUserButton()->UIButton{
        let userButton: UIButton = UIButton()
        
        if(deviceWidth >= 1025){
            userButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34) as CGRect
        }
        else if(deviceWidth >= 768 && deviceWidth < 1025){
            userButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34) as CGRect
        }
        else if(deviceWidth >= 569 && deviceWidth < 768){
            userButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30) as CGRect
        }
        else if(deviceWidth >= 481 && deviceWidth < 569){
            userButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25) as CGRect
        }
        else if(deviceWidth >= 320 && deviceWidth < 481){
            userButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25) as CGRect
        }
        else if(deviceWidth < 320){
            userButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25) as CGRect
        }
        
        let userImg = UIImage(named: "user")
        userButton.setBackgroundImage(userImg, for: UIControl.State())
        return userButton
    }
    
    
    static func createCartParentView()->UIView{
        
        let cartParentView = UIView()
        
        if(deviceWidth >= 1025){
            cartParentView.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        }
        else if(deviceWidth >= 768 && deviceWidth < 1025){
            cartParentView.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        }
        else if(deviceWidth >= 569 && deviceWidth < 768){
            cartParentView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        }
        else if(deviceWidth >= 481 && deviceWidth < 569){
            cartParentView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        }
        else if(deviceWidth >= 320 && deviceWidth < 481){
            cartParentView.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        }
        else if(deviceWidth < 320){
            cartParentView.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        }
        
        cartParentView.backgroundColor = UIColor.clear
        
        return cartParentView
        
    }
    
    static func createCartButton(_ mainView: UIView)->UIButton{
        let cartButton: UIButton = UIButton()
        let widt = mainView.frame.size.width
        let heit = mainView.frame.size.height
        
        cartButton.frame = CGRect(x: 0, y: 0, width: widt, height: heit) as CGRect
        
        let cartImg = UIImage(named: "cart")
        cartButton.setBackgroundImage(cartImg, for: UIControl.State())
        return cartButton
    }
    
    static func createFooterSpacer()->UIBarButtonItem{
        
        let negativeSpacer:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: nil, action: nil)
        
        if(deviceWidth >= 1025){
            negativeSpacer.width = 118;
        }
        else if(deviceWidth >= 768 && deviceWidth < 1025){
            negativeSpacer.width = 110;
        }
        else if(deviceWidth >= 569 && deviceWidth < 768){
            negativeSpacer.width = 62;
        }
        else if(deviceWidth >= 481 && deviceWidth < 569){
            negativeSpacer.width = 32;
        }
        else if(deviceWidth >= 320 && deviceWidth < 481){
            negativeSpacer.width = 40;
        }
        else if(deviceWidth < 320){
            negativeSpacer.width = 20;
        }
        
        return negativeSpacer
    }
    
    
    
    static func configureSearchBar(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.showsBookmarkButton = false
        searchBar.tintColor = UIColor.gray
        searchBar.layer.cornerRadius = 10.0
        searchBar.layer.borderWidth = 0
    }
    
    
    
    static func createBackButton()->UIButton{
        let x = CGFloat(0)
        
        let backButton: UIButton = UIButton()
        if(deviceWidth >= 1025){
            backButton.frame = CGRect(x: x, y: 0, width: 64, height: 34) as CGRect
        }
        else if(deviceWidth >= 768 && deviceWidth < 1025){
            backButton.frame = CGRect(x: x, y: 0, width: 64, height: 34) as CGRect
        }
        else if(deviceWidth >= 569 && deviceWidth < 768){
            backButton.frame = CGRect(x: x, y: 0, width: 60, height: 30) as CGRect
        }
        else if(deviceWidth >= 481 && deviceWidth < 569){
            backButton.frame = CGRect(x: 0, y: 0, width: 55, height: 25) as CGRect
        }
        else if(deviceWidth >= 320 && deviceWidth < 481){
            backButton.frame = CGRect(x: 0, y: 0, width: 55, height: 25) as CGRect
        }
        else if(deviceWidth < 320){
            backButton.frame = CGRect(x: 0, y: 0, width: 55, height: 25) as CGRect
        }
        backButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        
        if (idForSelectedLangauge == Utils.getArebicLanguageCode()) {
            backButton.setImage(Utils.rightArrowBack, for: UIControl.State())}
        else{
            backButton.setImage(backNavigationImage, for: UIControl.State())
        }
        
        return backButton
    }
    
    
    static func createMenuButton()->UIButton{
        let menuButton: UIButton = UIButton()
        
        if(deviceWidth >= 1025){
            menuButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34) as CGRect
        }else if(deviceWidth >= 768 && deviceWidth < 1025){
            menuButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34) as CGRect
        }else if(deviceWidth >= 569 && deviceWidth < 768){
            menuButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30) as CGRect
        }else if(deviceWidth >= 481 && deviceWidth < 569){
            menuButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25) as CGRect
        }else if(deviceWidth >= 320 && deviceWidth < 481){
            menuButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25) as CGRect
        }else if(deviceWidth < 320){
            menuButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25) as CGRect
        }
        
        menuButton.setBackgroundImage(menuImage, for: UIControl.State())
        
        return menuButton
    }
    
    static func createSpacer()->UIBarButtonItem{
        let negativeSpacer:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: nil, action: nil)
        
        negativeSpacer.width = -5;
        
        return negativeSpacer
    }
    
    static func getArebicLanguageCode()->String{
        return "ar"
    }
    
    
    /*------------------------------------Common to all Pages-----------------------------------------------------*/
    
    
    /*------------------------------------Home Page-----------------------------------------------------*/
    
    static func createBannerParentView(_ mainView: UIView)->UIView{
        let bannerParentView = UIView()
        if(deviceWidth >= 1025){
            bannerParentView.frame = CGRect(x: 0, y: 0, width:mainView.frame.size.width, height: 256)
        }else if(deviceWidth >= 768 && deviceWidth < 1025){
            bannerParentView.frame = CGRect(x: 0, y: 0, width:mainView.frame.size.width, height: 385)
        }else if(deviceWidth >= 569 && deviceWidth < 768){
            bannerParentView.frame = CGRect(x: 0, y: 0, width:mainView.frame.size.width, height: 192)
        }else if(deviceWidth >= 481 && deviceWidth < 569){
            bannerParentView.frame = CGRect(x: 0, y: 0, width:mainView.frame.size.width, height: 142)
        }else if(deviceWidth >= 320 && deviceWidth < 481){
            bannerParentView.frame = CGRect(x: 0, y: 0, width:mainView.frame.size.width, height: 188)
        }else if(deviceWidth < 320){
            bannerParentView.frame = CGRect(x: 0, y: 0, width:mainView.frame.size.width, height: 100)
        }
        
        return bannerParentView
    }
    
    static func createBannerScrollView(_ mainView: UIView)->UIScrollView{
        let bannerScrollView = UIScrollView()
        bannerScrollView.frame = CGRect(x: 0, y: 0, width:mainView.frame.size.width   , height: mainView.frame.size.height)
        bannerScrollView.backgroundColor = UIColor(netHex:0xeaeaea)
        return bannerScrollView
    }
    
    static func createPageControl(_ mainView: UIView)->UIPageControl{
        let pageControl = UIPageControl(frame: CGRect(x: 0, y: mainView.frame.size.height + mainView.frame.origin.y - 28, width: mainView.frame.size.width , height: 28))
        pageControl.tintColor = UIColor(netHex:0xff8b01)
        pageControl.pageIndicatorTintColor = UIColor.gray
        pageControl.currentPageIndicatorTintColor = UIColor.black
        pageControl.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        return pageControl
    }
    
    static func createProductsParentView(_ mainView: UIView)->UIView{
        let productsParentView = UIView()
        if(deviceWidth >= 1025){
            productsParentView.frame = CGRect(x: 0, y: mainView.frame.size.height + mainView.frame.origin.y
                , width:mainView.frame.size.width , height: 256)
        }
        else if(deviceWidth >= 768 && deviceWidth < 1025){
            productsParentView.frame = CGRect(x: 0, y: mainView.frame.size.height + mainView.frame.origin.y , width:mainView.frame.size.width  , height: 302)
        }
        else if(deviceWidth >= 569 && deviceWidth < 768){
            productsParentView.frame = CGRect(x: 0, y: mainView.frame.size.height + mainView.frame.origin.y , width:mainView.frame.size.width , height: 256)
        }
        else if(deviceWidth >= 481 && deviceWidth < 569){
            productsParentView.frame = CGRect(x: 0, y: mainView.frame.size.height + mainView.frame.origin.y , width:mainView.frame.size.width , height: 220)
        }
        else if(deviceWidth >= 320 && deviceWidth < 481){
            productsParentView.frame = CGRect(x: 0, y: mainView.frame.size.height + mainView.frame.origin.y , width:mainView.frame.size.width  , height: 220)
        }
        else if(deviceWidth < 320){
            productsParentView.frame = CGRect(x: 0, y: mainView.frame.size.height + mainView.frame.origin.y , width:mainView.frame.size.width , height: 120)
        }
        productsParentView.backgroundColor = UIColor.white
        return productsParentView
    }
    
    
    static func createProductHeaderTitleLabel(_ mainView: UIView)->UILabel{
        let productHeaderTitleLabel: UILabel = UILabel()
        let widt = mainView.frame.size.width
        let heit = mainView.frame.size.height
        
        productHeaderTitleLabel.frame = CGRect(x: 15, y: 10, width: widt - 30, height: heit/10.413)
        if(deviceWidth >= 1025){
            productHeaderTitleLabel.font = UIFont(name: "Lato", size: 24)
        }
        else if(deviceWidth >= 768 && deviceWidth < 1025){
            productHeaderTitleLabel.font = UIFont(name: "Lato", size: 24)
        }
        else if(deviceWidth >= 569 && deviceWidth < 768){
            productHeaderTitleLabel.font = UIFont(name: "Lato", size: 20)
        }
        else if(deviceWidth >= 481 && deviceWidth < 569){
            productHeaderTitleLabel.font = UIFont(name: "Lato", size: 20)
        }
        else if(deviceWidth >= 320 && deviceWidth < 481){
            productHeaderTitleLabel.font = UIFont(name: "Lato", size: 20)
        }
        else if(deviceWidth < 320){
            productHeaderTitleLabel.font = UIFont(name: "Lato", size: 18)
        }
        
        return productHeaderTitleLabel
    }
    
    
    // ankur for collectionView
    
    static func createProductCollectionView(_ mainView: UIView, titLabel: UILabel)-> UICollectionView
    {
        let widt = mainView.frame.size.width
        let heit = mainView.frame.size.height
        
        
        let productsCollectionView : UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        productsCollectionView.frame = CGRect(x: 0, y: titLabel.frame.size.height + titLabel.frame.origin.y + 11, width: widt , height: heit/1.301)
        productsCollectionView.showsHorizontalScrollIndicator = false
        return productsCollectionView
    }
    
    
    static func createProductsScrollView(_ mainView: UIView,titLabel: UILabel)->UIScrollView{
        let widt = mainView.frame.size.width
        let heit = mainView.frame.size.height
        let productsScrollView = UIScrollView()
        
        productsScrollView.frame = CGRect(x: 0, y: titLabel.frame.size.height + titLabel.frame.origin.y + 15, width: widt, height: heit/1.301)
        
        return productsScrollView
    }
    
    static func createOptionButton()->UIButton{
        let optionButton: UIButton = UIButton()
        
        if(deviceWidth >= 1025){
            optionButton.frame = CGRect(x: 0, y: 0, width: 35, height: 35) as CGRect
        }
            
        else if(deviceWidth >= 768 && deviceWidth < 1025){
            optionButton.frame = CGRect(x: 0, y: 0, width: 35, height: 35) as CGRect
        }
            
        else if(deviceWidth >= 569 && deviceWidth < 768){
            optionButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30) as CGRect
            
        }
        else {
            optionButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25) as CGRect
        }
        
        
        let optionImage = UIImage(named: "rightMenu")
        optionButton.setImage(optionImage, for: UIControl.State())
        return optionButton
    }
    
    
    /*------------------------------------Details Page-----------------------------------------------------*/
    
    static func createTitleLabel(_ mainView: UIView, yposition: CGFloat)->UILabel{
        
        let productHeaderTitleLabel: UILabel = UILabel()
        productHeaderTitleLabel.numberOfLines = 3
        
        let widt = mainView.frame.size.width
        
        productHeaderTitleLabel.frame = CGRect(x: 15, y: yposition, width: widt - 30, height:60)
        if(deviceWidth >= 1025){
            productHeaderTitleLabel.font = UIFont(name: "Lato", size: 24)
        }
        else if(deviceWidth >= 768 && deviceWidth < 1025){
            productHeaderTitleLabel.font = UIFont(name: "Lato", size: 18)
        }
        else if(deviceWidth >= 569 && deviceWidth < 768){
            productHeaderTitleLabel.font = UIFont(name: "Lato", size: 18)
        }
        else if(deviceWidth >= 481 && deviceWidth < 569){
            productHeaderTitleLabel.font = UIFont(name: "Lato", size: 16)
        }
        else if(deviceWidth >= 320 && deviceWidth < 481){
            productHeaderTitleLabel.font = UIFont(name: "Lato", size: 16)
        }
        else if(deviceWidth < 320){
            productHeaderTitleLabel.font = UIFont(name: "Lato", size: 16)
        }
        
        return productHeaderTitleLabel
        
    }
    
    static func createImageParentView(_ mainView: UIView,titLabel: UILabel)->UIView{
        let imageParentView = UIView()
        if(deviceWidth >= 1025){
            imageParentView.frame = CGRect(x: 0, y: titLabel.frame.size.height + titLabel.frame.origin.y + 10, width:mainView.frame.size.width, height: 356)
        }
        else if(deviceWidth >= 768 && deviceWidth < 1025){
            imageParentView.frame = CGRect(x: 0, y: titLabel.frame.size.height + titLabel.frame.origin.y + 10, width:mainView.frame.size.width, height: 356)
        }
        else if(deviceWidth >= 569 && deviceWidth < 768){
            imageParentView.frame = CGRect(x: 0, y: titLabel.frame.size.height + titLabel.frame.origin.y + 10, width:mainView.frame.size.width, height: 292)
        }
        else if(deviceWidth >= 481 && deviceWidth < 569){
            imageParentView.frame = CGRect(x: 0, y: titLabel.frame.size.height + titLabel.frame.origin.y + 10, width:mainView.frame.size.width, height: 242)
        }
        else if(deviceWidth >= 320 && deviceWidth < 481){
            imageParentView.frame = CGRect(x: 0, y: titLabel.frame.size.height + titLabel.frame.origin.y + 10, width:mainView.frame.size.width, height: 350)
        }
        else if(deviceWidth < 320){
            imageParentView.frame = CGRect(x: 0, y: titLabel.frame.size.height + titLabel.frame.origin.y + 10, width:mainView.frame.size.width, height: 120)
        }
        
        return imageParentView
    }
    
    /*------------------------------------------------------Profile Page--------------------------------------*/
    
    
    static func profileLabel(_ mainView: UIView, label: UILabel)->UILabel{
        let TitleLabel: UILabel = UILabel()
        let widt = mainView.frame.size.width - 40
        
        TitleLabel.frame = CGRect(x: 20, y: label.frame.height + label.frame.origin.y + 10, width: widt, height:23)
        TitleLabel.textColor = UIColor.black
        TitleLabel.font = UIFont(name: "Lato-Light", size: 18)
        if(deviceName != "big"){
            TitleLabel.font = UIFont(name: "Lato-Light", size: 16)
        }
        
        
        return TitleLabel
    }
    
    /*------------------------------------------------changePassword-----------------------------------------------*/
    static func titleLabels(_ mainView: UIView)->UILabel{
        let TitleLabel: UILabel = UILabel()
        let widt = mainView.frame.size.width
        
        TitleLabel.frame = CGRect(x: 20, y: mainView.frame.height + mainView.frame.origin.y + 10, width: widt, height:35)
        TitleLabel.textColor = UIColor.gray
        TitleLabel.font = UIFont(name: "Lato", size: 20)
        return TitleLabel
    }
    static func titleTextFields(_ mainView: UIView)->UITextField{
        let TitleText: UITextField = UITextField()
        let widt = mainView.frame.size.width
        
        let spaceLabel1 = UILabel()
        spaceLabel1.frame = CGRect(x: 10, y: 0, width: 7, height: 26)
        spaceLabel1.backgroundColor = UIColor.clear
        
        TitleText.frame = CGRect(x: 20, y: mainView.frame.height + mainView.frame.origin.y + 10, width: widt, height:40)
        TitleText.textColor = UIColor.gray
        TitleText.font = UIFont(name: "Lato", size: 20)
        TitleText.layer.borderColor = UIColor.lightGray.cgColor
        TitleText.layer.borderWidth = 1
        TitleText.backgroundColor = UIColor.white
        TitleText.layer.cornerRadius = 4
        TitleText.leftView = spaceLabel1
        TitleText.leftViewMode = UITextField.ViewMode.always
        TitleText.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        
        return TitleText
    }
    
    /*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Service Functions  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*/
    static let DocumentsDirectory : NSURL = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first! as NSURL
    
    static func appendWithCurrencySym(_ value : Double)->String{
        let priceStr = Utils.formatPrice(Config.Instance.getCurrencyCode(), price: value)
        assert(priceStr != nil)
        
        return priceStr!
    }
    
    static func appendWithCurrencySymStr(_ value : String)->String{
        return Utils.appendWithCurrencySym(Utils.StringToDouble(value))
    }
    
    static func DoubleToString(_ value : Double)->String{
        return String(format:"%.2f", value)
    }
    
    static func StringToDouble(_ value: String)->Double{
        return (value as NSString).doubleValue
    }
    
    static func setCartLabel(_ label:UITabBarItem){
        let cartCountValue = ShoppingCart.Instance.getNumDifferentItem()
        
        if cartCountValue > 0{
            //label.hidden = false
            label.badgeValue = String(cartCountValue)
        }else{
            label.badgeValue = nil
        }
    }
    
    static func parseJSONToAnyObject(_ data: Data)->AnyObject?{
        do {
            let data = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            return data as AnyObject?
            
        } catch{
            ErrorHandler.Instance.showError()
            return nil
        }
    }
    
    static func parseJSON(_ data: Data)->NSDictionary?{
        do {
            let dataDict = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
            return dataDict
        } catch{
            ErrorHandler.Instance.showError()
            return nil
        }
    }
    
    static func post(url : String, dict : [String : Any], callback: @escaping (Data) -> Void, errorCallback: @escaping (Error) -> Void){
        let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        let url = URL(string: url)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let appAccessKey = Config.Instance.getAppAccessKey()
        request.addValue(appAccessKey , forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async{
                    errorCallback(error!)
                }
                return
            }
            DispatchQueue.main.async{
                callback(data)
            }
        }
        
        task.resume()
    }
    
    static func fillTheData(_ url: String?, callback: @escaping (NSDictionary) -> Void, errorCallback: @escaping () -> Void){
        if url != nil{
            if let nsurl = URL(string: url!){
                let request = Utils.createRequest(nsurl: nsurl)
                let appAccessKey = Config.Instance.getAppAccessKey()
                request.addValue(appAccessKey , forHTTPHeaderField: "Authorization")
                
                let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
                    if error == nil && data != nil{
                        if let dataDict = Utils.parseJSON(data!){
                            DispatchQueue.main.async{
                                callback(dataDict)
                            }
                        }else{
                            DispatchQueue.main.async{
                                errorCallback()
                            }
                        }
                    }else{
                        DispatchQueue.main.async{
                            errorCallback()
                        }
                    }
                })
                task.resume()
            }else{
                errorCallback()
            }
        }else{
            errorCallback()
        }
    }
    
    static func parseJSONArray(_ data: Data)->NSArray?{
        do {
            let dataDict = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSArray
            return dataDict
        } catch let error as NSError {
            print("json error: \(error.localizedDescription)")
            return nil
        }
    }
    
    static func createRequest(nsurl : URL)->NSMutableURLRequest{
        let request = NSMutableURLRequest(url: nsurl)
        if  let authappid = UserDefaults.standard.value(forKey: "appid"){
            request.addValue(authappid as! String, forHTTPHeaderField: "authappid")
        }
        if  let token = UserDefaults.standard.value(forKey: "token"){
            request.addValue(token as! String , forHTTPHeaderField: "token")}
        if let secretkey = UserDefaults.standard.value(forKey: "secretkey"){
            request.addValue( secretkey as! String  , forHTTPHeaderField: "secretkey")
        }
        
        request.httpMethod = "GET"
        
        return request
    }
    
    static func fillTheDataFromArray(_ url: String?, callback: @escaping (NSArray) -> Void, errorCallback: @escaping () -> Void){
        if url != nil{
            if let nsurl =  URL(string: url!){
                let request = Utils.createRequest(nsurl: nsurl)
                let appAccessKey = Config.Instance.getAppAccessKey()
                request.addValue(appAccessKey , forHTTPHeaderField: "Authorization")
                
                let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
                    if error == nil && data != nil{
                        if let dataArray = Utils.parseJSONArray(data!){
                            DispatchQueue.main.async{
                                callback(dataArray)
                            }
                        }else{
                            DispatchQueue.main.async{
                                errorCallback()
                            }
                        }
                    }else{
                        DispatchQueue.main.async{
                            errorCallback()
                        }
                    }
                })
                task.resume()
            }else{
                errorCallback()
            }
        }else{
            errorCallback()
        }
    }
    
    static func actOnSearch(_ searchText : String, viewCtrl : UIViewController){
        if !searchText.isEmpty{
            let productListObject = viewCtrl.storyboard?.instantiateViewController(withIdentifier: "productListViewController") as? productListViewController
            productListObject?.categoryId = -1
            productListObject?.categoryName = searchText
            
            viewCtrl.navigationController?.pushViewController(productListObject!, animated: true)
        }
    }
    
    static func isValidEmail(_ email : String)->Bool{
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        let testEmail = NSPredicate(format:"SELF MATCHES %@", regex)
        let status =  testEmail.evaluate(with: email)
        
        return status
    }
    
    static func isOnlyAlpha(_ text: String)->Bool{
        do {
            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z]\\s.*", options: NSRegularExpression.Options(rawValue: 0))
            let status = regex.firstMatch(in: text, options:[],
                                          range: NSMakeRange(0, text.count)) == nil
            return status
            
        } catch{
            return false
        }
    }
    
    static func isOnlyNumericHyphen(_ text: String)->Bool{
        do {
            let regex = try NSRegularExpression(pattern: ".*[^0-9-].*", options: NSRegularExpression.Options.caseInsensitive)
            let status = regex.firstMatch(in: text, options:[],
                                          range: NSMakeRange(0, text.count)) == nil
            return status
            
        } catch{
            return false
        }
    }
    
    static func isAlphaNumeric(_ text: String)->Bool{
        do {
            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z0-9._-]\\s.*", options: NSRegularExpression.Options(rawValue: 0))
            let status = regex.firstMatch(in: text, options:[],
                                          range: NSMakeRange(0, text.count)) == nil
            return status
            
        } catch{
            return false
        }
    }
    
    static func isValidForPin(_ text: String)->Bool{
        do {
            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z0-9._-].*", options: NSRegularExpression.Options(rawValue: 0))
            let status = regex.firstMatch(in: text, options:[],
                                          range: NSMakeRange(0, text.count)) == nil
            return status
            
        } catch{
            return false
        }
    }
    
    static func fadeButton(_ button:UIButton){
        UIView.animate(withDuration: 3.0, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            button.alpha = 0.3
        }, completion: {
            (finished: Bool) -> Void in
            // Fade in
            UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                button.alpha = 1.0
            }, completion: nil)
        })
    }
    
    static func formatPrice(_ code : String, price: Double)->String?{
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = code
        formatter.locale = Locale(identifier: Locale.current.identifier)
        let priceStr = formatter.string(from: NSNumber(value : price))
        
        return priceStr
    }
    
    // ********* WishList methodes *********** //
    static func addItemToMyWishlist(_ productItem:ShoppingItem,btnWish:UIButton,controller:UIViewController){
        if(UserDefaults.standard.bool(forKey: "isLogin"))
        {
            if !btnWish.isSelected{
                Utils.addItemToWishlist(productItem, btnWish: btnWish,controller: controller)
                
            }else{
                Utils.deleteItemFromWishlist(productItem, btnWish: btnWish)
                
            }
            btnWish.isSelected = !btnWish.isSelected
        }
        else{
            
            
            let refreshAlert = UIAlertController(title: "", message: "Please login to add product into wishlist", preferredStyle: UIAlertController.Style.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "OK".localized(), style: .default, handler: { (action: UIAlertAction!) in
                UserDefaults.standard.set(true, forKey: "isLoginForWishListPage")
                let loginObject =  LoginVC(nibName:"LoginVC",bundle: nil)
                //let loginObject = mainStoryboard.instantiateViewController(withIdentifier: "loginViewController") as? loginViewController
                //loginObject.wishListShoppingItem = productItem
                controller.navigationController?.pushViewController(loginObject, animated: true)
            }))
            controller.present(refreshAlert, animated: true, completion: nil)
        }
        
    }
    
    
    fileprivate  static func addItemToWishlist(_ item:ShoppingItem,btnWish:UIButton,controller:UIViewController) {
        
        let wishlist : ShoppingWishlist = ShoppingWishlist.Instance
        if wishlist.isContainsItem(item){
            let alertController = UIAlertController(title: "", message: Constants.allreadyAddedWishlistMsg, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            controller.present(alertController, animated: true, completion: nil)
            return
        }
        
        ShoppingWishlist.Instance.addItem(item)
        Utils.addWishListOnServer(item, btnWish: btnWish)
        
    }
    
    
    static func addWishListOnServer(_ item:ShoppingItem,btnWish:UIButton){
        if let addCartUrl = WebApiManager.Instance.getAddWishlistItemUrl(String(item.id)){
            let request = Utils.createRequest(nsurl: URL(string: addCartUrl)!)
            let appAccessKey = Config.Instance.getAppAccessKey()
            request.addValue(appAccessKey , forHTTPHeaderField: "Authorization")
            
            let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
                if error == nil{
                    if let dataDict = Utils.parseJSON(data!){
                        let status = dataDict.value(forKey: "status") as! String
                        if status == "ERROR"{
                            // btnWish.selected = false
                        }else{
                            //  ShoppingWishlist.Instance.addItem(item)
                        }
                    }else{
                        //btnWish.selected = false
                    }
                }else{
                    //btnWish.selected = false
                }
            })
            task.resume()
        }
    }
    
    private static func deleteItemFromWishlist(_ item:ShoppingItem,btnWish:UIButton) {
        let wishlist : ShoppingWishlist = ShoppingWishlist.Instance
        
        wishlist.deleteItem(item)
        Utils.deleteWishListOnServer(item, btnWish: btnWish)
    }
    
    
    static func deleteWishListOnServer(_ item:ShoppingItem,btnWish:UIButton){
        if let deleteWishListUrl = WebApiManager.Instance.getDeleteProductFromWishlistUrl(String(item.wishListId)){
            let request = Utils.createRequest(nsurl: URL(string: deleteWishListUrl)!)
            let appAccessKey = Config.Instance.getAppAccessKey()
            request.addValue(appAccessKey , forHTTPHeaderField: "Authorization")
            
            let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
                if error == nil{
                    if let dataDict = Utils.parseJSON(data!){
                        let status = dataDict.value(forKey: "status") as! String
                        if status == "ERROR"{
                            // btnWish.selected = false
                        }else{
                            
                            // ShoppingWishlist.Instance.deleteItem(item)
                        }
                    }else{
                        //  btnWish.selected = false
                    }
                }else{
                    // btnWish.selected = false
                }
            })
            task.resume()
        }
    }
    
    static func getProductFromDataArray(_ products_list: NSArray)->[ShoppingItem]{
        
        var isContainSet : Set<Int> = Set()
        var products = [ShoppingItem]()
        for item in products_list{
            
            let myItem = (item as! NSDictionary).value(forKey:"product") as? NSDictionary
            if let item = StoreManager.Instance.createWishListShoppingItem(myItem!,itemId:((item as! NSDictionary).value(forKey:"wishlist_item_id") as? String)!){
                if !isContainSet.contains(item.id)
                {
                    isContainSet.insert(item.id)
                    products.insert(item, at: 0)
                }
            }
        }
        return products
        
    }
  
    static func loadWishlistItemData(){
        let url = WebApiManager.Instance.getWishlistDataUrl()
        Utils.fillTheData(url, callback: Utils.processWishlistData, errorCallback : self.showError)
    }
    
    static func showError(){
        ErrorHandler.Instance.showError()
    }
    
    static func processWishlistData(_ dataDict: NSDictionary){
        if let products_list = dataDict["items"] as? NSArray{
            
            ShoppingWishlist.Instance.deleteAllItem()
            for  item in products_list {
                let myItem = item as! NSDictionary
                
                if let wishlistItemItem = StoreManager.Instance.createWishListShoppingItem(myItem,itemId:((item as! NSDictionary).value(forKey:"wishlist_item_id") as? String)!){
                    ShoppingWishlist.Instance.addItem(wishlistItemItem)
                }
            }
        }
    }
    
    static func getDateStringFromStringWithDateFormage(_ date:NSString) -> NSString {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myDate :Date = dateFormatter.date(from: date as String) ?? Date()
        dateFormatter.dateFormat = "d"
        let day = dateFormatter.string(from: myDate)
        dateFormatter.dateFormat = "MMM"
        let month = dateFormatter.string(from: myDate)
        dateFormatter.dateFormat = "yyyy"
        let year = dateFormatter.string(from: myDate)
        
        let finalDate : NSString = "\(year) - \(month) - \(day)" as NSString
        return finalDate
    }
    
    
    // mahesh start
    
    static func addItemInCartWithSync(_ item : ShoppingItem ,count : Int, isfromByNow : Bool, controller:UIViewController){
        let cart : ShoppingCart = ShoppingCart.Instance
        if cart.isContainsItem(item){
            controller.view.makeToast("Product is already added in cart!")
            return
        }
        
        if !item.inStock {
            controller.view.makeToast("Quantity Out of Stock")
            return
        }
        
        if let obj = controller as? NewProductDetailePage{
            DispatchQueue.main.async {
                obj.backButton.isEnabled = true
                obj.reloadBadgeNumber()
            }
        }
        
        ShoppingCart.Instance.addItem(item, num: 1)
        Utils.addItemDataBase(item)
        Utils.applyActionAfterAddToCart(isfromByNow, controller: controller , item: item)
    }
    
    static func addItemInCartWithSyncAnonym(_ item : ShoppingItem ,count : Int){
        let sample = UIViewController()
        WebApiManager.Instance.callRequestForAddCart(item, count: count, controller: sample, isFromByNow: false, callback: Utils.processAddCartData, errorCallback: self.showError)
    }
    
    
    static func processAddCartData(_ dataDict : NSDictionary, isfromByNow : Bool, controller:UIViewController,item:ShoppingItem){
        
        if let status = dataDict["status"] as? String {
            if status == "success" {
                DispatchQueue.main.async {
                    ShoppingCart.Instance.addItem(item, num: 1)
                    Utils.applyActionAfterAddToCart(isfromByNow, controller: controller , item : item)
                    if let obj = controller as? NewProductDetailePage{
                        
                        DispatchQueue.main.async {
                            obj.backButton.isEnabled = true
                        }
                    }
                }
                
            }else{
                controller.view.makeToast(status)
            }
            
        }
        
        if let obj = controller as? NewProductDetailePage{
            DispatchQueue.main.async {
                obj.reloadBadgeNumber()
            }
        }
    }
    
    static func applyActionAfterAddToCart(_ isfromByNow : Bool,controller:UIViewController , item : ShoppingItem){
        ShoppingCart.Instance.allCartItemIds.insert(item.id, at: 0)
        if isfromByNow{
            DispatchQueue.main.async {
                let cartObject = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "cartViewController") as! cartViewController
                controller.navigationController?.pushViewController(cartObject, animated: true)
            }
        }else{
            let alertController = UIAlertController(title: "", message: "Your product is addded to cart", preferredStyle: .alert)
            controller.present(alertController, animated: true, completion: nil)
            let delay = 1.0 * Double(NSEC_PER_SEC)
            let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: time, execute: {
                alertController.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    static func isMoveFromCartItem()-> Bool{
        let cart = ShoppingCart.Instance
        for (item, count) in cart {
            
            if item.inStock {
                if count > item.totalNoInStock{
                    return false
                }
            }else{
                
                return false
            }
        }
        return true
    }
    
    
    static func getAuthentication(){
        let url =  WebApiManager.Instance.getTokenUrl()
        
        
        if let data = WebApiManager.Instance.getJSON(url){
            if let dataDict = Utils.parseJSON(data){
                self.loadAuthentication(dataDict)
            }
        }
        
    }
    
    func showError(){}
    static  func loadAuthentication(_ dataDict: NSDictionary) {
        
        if let appId = dataDict["appid"] as? String
        {
            UserDefaults.standard.setValue(appId, forKeyPath: "appid")
        }
        
        if let token = dataDict["token"] as? String{
            UserDefaults.standard.setValue(token, forKeyPath: "token")
        }
        if let secretkey = dataDict["secretkey"] as? String
        {
            UserDefaults.standard.setValue(secretkey, forKeyPath: "secretkey")
        }
    }
    
    static func loadCartFromDB()
    {
        var cart = [NSManagedObject]()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        
        //3
        do {
            let results = try managedContext.fetch(fetchRequest)
            print(results)
            cart = results as! [NSManagedObject]
            for i in 0  ..< cart.count  {
                let item = cart[i]
                var cartItem : ShoppingItem? = nil
                let image = item.value(forKey: "image") as? String
                let name = item.value(forKey: "name") as? String
                let id = item.value(forKey: "id") as? Int
                let smallImg = item.value(forKey: "smallImg") as? String
                let type = item.value(forKey: "type") as? String
                let attributeSting = item.value(forKey: "attributeString") as? String
                let originalPrice = item.value(forKey: "originalPrice") as? Double
                let price = item.value(forKey: "price") as? Double
                let numInStock = item.value(forKey: "numInStock") as? Int
                let parentId = item.value(forKey: "parentId") as? Int
                let sku = item.value(forKey: "sku") as? String
                
                cartItem  = ShoppingItem (id: id!, name: name!, sku: sku!, price: String(originalPrice!), specialPrice: String(price!), inStock: true, image: image, type: type! , img1: smallImg)!
                cartItem!.parentId = parentId!
                cartItem!.numInStock = numInStock!
                cartItem?.attributeString = attributeSting!
                
                ShoppingCart.Instance.allCartItemIds.insert(id!, at: 0)
                ShoppingCart.Instance.addItem(item: cartItem!)
                
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }}
    
    static func addItemDataBase(_ item: ShoppingItem) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let entity =  NSEntityDescription.entity(forEntityName: "Cart", in:managedContext)
        
        let cartItem = NSManagedObject(entity: entity!, insertInto: managedContext)
        cartItem.setValue(item.parentId, forKey: "parentId")
        cartItem.setValue(item.name, forKey: "name")
        cartItem.setValue(item.id, forKey: "id")
        cartItem.setValue(item.image, forKey: "image")
        cartItem.setValue(item.smallImg, forKey: "smallImg")
        cartItem.setValue(item.priceStr, forKey: "priceStr")
        cartItem.setValue(item.inStock, forKey: "inStock")
        cartItem.setValue(item.type, forKey: "type")
        cartItem.setValue(item.originalPriceStr, forKey: "originalPriceStr")
        cartItem.setValue(item.originalPrice, forKey: "originalPrice")
        cartItem.setValue(item.price, forKey: "price")
        cartItem.setValue(item.numInStock, forKey: "numInStock")
        cartItem.setValue(item.attributeString, forKey: "attributeString")
        cartItem.setValue(item.sku, forKey: "sku")
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    static func deleteAllDataFromDB(_ entity: String)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not delete \(error), \(error.userInfo)")
        }
    }
    
    static func stringToInt(_ value:String) ->Int {
        return Int((value as NSString).intValue)
    }
    static func intToString(_ value:Int) ->String {
        return String(format:"%d", value)
    }
    
    //***************PC********
    static func showAlert(_ alertStr:String, title : String = "") {
        let alertVc = UIAlertController.init(title: title, message: alertStr, preferredStyle: .alert)
        let action = UIAlertAction.init(title: "OK".localized(), style: .destructive, handler: nil)
        alertVc.addAction(action)
        alertVc.show()
        
    }
    //*********************
    
}

extension UIAlertController {
    
    func show() {
        present(true, completion: nil)
    }
    
    func present(_ animated: Bool, completion: (() -> Void)?) {
        if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
            presentFromController(rootVC, animated: animated, completion: completion)
        }
    }
    
    fileprivate func presentFromController(_ controller: UIViewController, animated: Bool, completion: (() -> Void)?) {
        if let navVC = controller as? UINavigationController,
            let visibleVC = navVC.visibleViewController {
            presentFromController(visibleVC, animated: animated, completion: completion)
        } else
            if let tabVC = controller as? UITabBarController,
                let selectedVC = tabVC.selectedViewController {
                presentFromController(selectedVC, animated: animated, completion: completion)
            } else {
                controller.present(self, animated: animated, completion: completion);
        }
    }
    
}

extension Dictionary {
    func get(_ key: Key, defaultValue: Value) -> Value {
        if let value = self[key] {
            return value
        } else {
            return defaultValue
        }
    }
}


