//
//  sample.swift
//  Mofluid
//
//  Created by sudeep goyal on 10/09/15.
//  Copyright © 2015 Mofluid. All rights reserved.
//

import UIKit
import Foundation

class detailsAdditionalInfoViewController:BaseViewController {
    var titleParentView = UIView()
    var titileLabel = UILabel()
    var detailsParentScrollView = UIScrollView()
    var priceValue = UILabel()
    
    var productTitle:String? = nil
    var productPrice:String? = nil
    var stockBool:Bool = false
    var titlesArray = [String] ()
    var righttitlesArray = [String] ()
    var shoppingItem:ShoppingItem? = nil
    var shortDescription: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        menuButton.isHidden = true
        
        titleParentView.frame = CGRect(x: 0, y: 0, width: mainParentScrollView.frame.width, height: 50)
        titileLabel = Utils.createTitleLabel(titleParentView,yposition: 0)

        titileLabel.font = UIFont(name: "Lato", size: 20)
        titileLabel.text = productTitle
        titileLabel.numberOfLines = 2
              if(idForSelectedLangauge == Utils.getArebicLanguageCode())//ankur
        {
            titileLabel.textAlignment = .right
        }
        titleParentView.addSubview(titileLabel)
        
        priceValue = Utils.createTitleLabel(titleParentView,yposition: titileLabel.frame.origin.y + titileLabel.frame.height - 20 )
        priceValue.text = productPrice
        priceValue.font = titileLabel.font
        priceValue.numberOfLines = 1
       // priceValue.sizeToFit()
        priceValue.textColor = UIColor.red
        if(idForSelectedLangauge == Utils.getArebicLanguageCode()) //ankur
        {
            priceValue.textAlignment = .right
        }
        titleParentView.frame.size.height = priceValue.frame.height + priceValue.frame.origin.y
        titleParentView.addSubview(priceValue)
        
      //  mainParentScrollView.addSubview(titleParentView)
        
        let firstBorder = UILabel(frame: CGRect(x: 0, y: titleParentView.frame.height - 2, width: titleParentView.frame.width, height: 1))
        firstBorder.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
       // titleParentView.addSubview(firstBorder)
        
        createTableForm()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        if(deviceName == "big"){
//            UILabel.appearance().font = UIFont(name: "Lato", size: 20)
//        }else{
//            UILabel.appearance().font = UIFont(name: "Lato", size: 15)
//        }
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "OptionViewTap"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "selectOptionViewOption"), object: nil)
        
    }

    
    func removeHTmltag(_ descString: NSString) -> String{
        
        let data = descString.data(using: String.Encoding.utf8.rawValue)
        if data == nil {
            return descString as String
        }
        let htmlStringData = data!
 
        let attributedHTMLString = try! NSAttributedString(data: htmlStringData, options: [.documentType: NSAttributedString.DocumentType.html,
                                                                                           .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        let descriptionAttributedString = attributedHTMLString.string
        
        return descriptionAttributedString
    }
    
    func createTableForm(){
        
        let detailsTitleLabel = UILabel()
        detailsTitleLabel.frame = CGRect(x: 15, y: 10 ,  width: mainParentScrollView.frame.width - 30, height: 24)
        detailsTitleLabel.text = "Additional Information".localized()
        detailsTitleLabel.font = UIFont(name: "Lato", size: 18)
        detailsTitleLabel.textColor = UIColor.black
        if(idForSelectedLangauge == Utils.getArebicLanguageCode())//ankur
        {
            detailsTitleLabel.textAlignment = .right
        }
        mainParentScrollView.addSubview(detailsTitleLabel)
        
        var requiredFrame = detailsTitleLabel.frame
        
        if(self.shortDescription != nil || self.shortDescription != ""){
            let DescriptionTextView = UITextView()
            DescriptionTextView.frame = CGRect(x: 15, y: detailsTitleLabel.frame.origin.y + detailsTitleLabel.frame.height + 5, width: mainParentScrollView.frame.width - 30, height: 30)
            if(idForSelectedLangauge == Utils.getArebicLanguageCode())//ankur
            {
                DescriptionTextView.textAlignment = .right
            }

            
            DescriptionTextView.text =  self.removeHTmltag(self.shortDescription! as NSString)
            DescriptionTextView.font = UIFont(name: "Lato-Light", size: 15.5)
            DescriptionTextView.textColor = UIColor.black
            DescriptionTextView.isUserInteractionEnabled = false
            
            let fixedWidth = DescriptionTextView.frame.size.width
            DescriptionTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
            let newSize = DescriptionTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
            var newFrame = DescriptionTextView.frame
            newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
            DescriptionTextView.frame = newFrame;
            DescriptionTextView.isScrollEnabled = false
            
            mainParentScrollView.addSubview(DescriptionTextView)
            
            requiredFrame = DescriptionTextView.frame
        }
        
        
        detailsParentScrollView.frame = CGRect(x: 15, y: requiredFrame.origin.y + requiredFrame.height + 20, width: mainParentScrollView.frame.width - 30, height: 150)
        
        var posy:CGFloat = 0
        
        for i in 0 ..< titlesArray.count{  //ankur
            let singleParentView = UIView(frame: CGRect(x: 0, y: posy, width: detailsParentScrollView.frame.width, height: 150))
            
            let leftTitleLabel = UILabel()
            if(idForSelectedLangauge == Utils.getArebicLanguageCode())//ankur
            {
                leftTitleLabel.frame = CGRect(x: singleParentView.frame.width/2 + 5, y: 10, width: singleParentView.frame.width/2 - 10, height: 20)
                leftTitleLabel.textAlignment = .right
            }
            else{
                leftTitleLabel.frame = CGRect(x: 10, y: 10, width: singleParentView.frame.width/2 - 20, height: 20)
            }
            leftTitleLabel.textColor = UIColor.black
            leftTitleLabel.font = UIFont(name: "Lato-Light", size: 16)
            leftTitleLabel.text = titlesArray[i]
            leftTitleLabel.numberOfLines = 0
            leftTitleLabel.adjustsFontSizeToFitWidth = true
            // leftTitleLabel.sizeToFit()
            singleParentView.addSubview(leftTitleLabel)
            
            let rightTitleLabel = UILabel()
            if(idForSelectedLangauge == Utils.getArebicLanguageCode()) //ankur
            {
                rightTitleLabel.frame =  CGRect(x: 10, y: 10, width: singleParentView.frame.width/2 - 20, height: 20)
                rightTitleLabel.textAlignment = .right
            }
            else
            {
                rightTitleLabel.frame = CGRect(x: singleParentView.frame.width/2 + 5, y: 10, width: singleParentView.frame.width/2 - 10, height: 20)
            }
            rightTitleLabel.textColor = UIColor.black
            rightTitleLabel.font = UIFont(name: "Lato-Light", size: 16)
            rightTitleLabel.text =  righttitlesArray[i]
            rightTitleLabel.numberOfLines = 0
            rightTitleLabel.adjustsFontSizeToFitWidth = true
            //  rightTitleLabel.sizeToFit()
            
            singleParentView.addSubview(rightTitleLabel)
            
            if(rightTitleLabel.frame.height > leftTitleLabel.frame.height){
                singleParentView.frame.size.height = rightTitleLabel.frame.origin.y + rightTitleLabel.frame.height + 10
            }else{
                singleParentView.frame.size.height = leftTitleLabel.frame.origin.y + leftTitleLabel.frame.height + 10
            }
            let bottomborder = UILabel(frame: CGRect(x: 0, y: singleParentView.frame.height - 2, width: singleParentView.frame.width, height: 1))
            bottomborder.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
            singleParentView.addSubview(bottomborder)
            
            
            let border = CALayer()
            border.frame = CGRect(x: -10, y: -9, width: 1, height: singleParentView.frame.height)
            border.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
            rightTitleLabel.layer.addSublayer(border)
            
            
            detailsParentScrollView.addSubview(singleParentView)
            detailsParentScrollView.frame.size.height = singleParentView.frame.origin.y + singleParentView.frame.height
            
            posy = posy + singleParentView.frame.height
        }
        mainParentScrollView.addSubview(detailsParentScrollView)
        
//        let addToCartButton = ZFRippleButton()
//        addToCartButton.frame = CGRect(x: detailsParentScrollView.frame.origin.x, y: detailsParentScrollView.frame.origin.y + detailsParentScrollView.frame.size.height + 20, width: detailsParentScrollView.frame.size.width, height: 38)
//        addToCartButton.addTarget(self, action: #selector(detailsAdditionalInfoViewController.addToCartButtonAction(_:)), for: UIControl.Event.touchUpInside)
//        addToCartButton.backgroundColor = UIColor(red: (223/255.0), green: (114/255.0), blue: (114/255.0), alpha: 1.0)
//        addToCartButton.layer.cornerRadius = 3.0
//        addToCartButton.setTitle("Add To Cart", for: UIControl.State())
//        addToCartButton.titleLabel?.textColor = UIColor(netHex:0xf78f1e)
//
//        mainParentScrollView.addSubview(addToCartButton)
        //addToCartButton.isHidden = true
        //mainParentScrollView.contentSize.height = addToCartButton.frame.origin.y + addToCartButton.frame.size.height + 100
        
        if(stockBool == false){
            //addToCartButton.isEnabled = false
        }
    }
    
    @objc func addToCartButtonAction(_ button:ZFRippleButton){
        //Empty
    }
    
    @IBAction func close(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    func backButtonFunction(){
        self.navigationController?.popViewController(animated: true)
    }
}

