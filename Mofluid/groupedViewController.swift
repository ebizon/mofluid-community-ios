    //
    //  productDetailsViewController.swift
    //  Mofluid
    //
    //  Created by sudeep goyal on 10/09/15.
    //  Copyright © 2015 Mofluid. All rights reserved.
    //

    import UIKit
    import Foundation

    class groupedViewController: PageViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
        var shoppingItem:ShoppingItem? = nil
        var allGroupedItems = [ShoppingItem]()
        var collectionView: UICollectionView!
        var tempCart = ShoppingCart.Instance.getTempCart()
        
        var productTitleLabel:UILabel = UILabel()
        var imageParentView: UIView = UIView()
        var imageScrollView: UIScrollView = UIScrollView()
        var leftArrowButton: UIButton = UIButton()
        var rightArrowButton: UIButton = UIButton()
        var descriptionTitleLabel: UILabel = UILabel()
        var DescriptionTextView: UITextView = UITextView()
        var configurableAttributeParentScrollView: UIScrollView = UIScrollView()
        var imagesArray = [String]()
        var pageViews: [UIImageView?] = []
        
         var titleString = NSString()
        
        var itemImageView = UIImageView()
        
        var detailsParentView = UIView()
        var productStock = UILabel()
        var addToCartButton = ZFRippleButton()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            self.navigationItem.title = titleString.uppercased as String
            addToCartButton.frame = CGRect(x: mainParentScrollView.frame.width - 170, y: 5,  width: 150, height: 37)
            addToCartButton.addTarget(self, action: #selector(groupedViewController.addToCartButtonAction(_:)), for: UIControl.Event.touchUpInside)
            addToCartButton.backgroundColor = UIColor(red: (223/255.0), green: (114/255.0), blue: (114/255.0), alpha: 1.0)
            addToCartButton.layer.cornerRadius = 3.0
            addToCartButton.setTitle("Add To Cart", for: UIControl.State())
            addToCartButton.titleLabel?.font = UIFont(name: "Lato", size: 17)
            addToCartButton.titleLabel?.textColor = UIColor.white
            mainParentScrollView.addSubview(addToCartButton)
          //  addToCartButton.enabled = false
            addToCartButton.isHidden = true
            createImagesParentView()
            
            loadProduct()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            if(deviceName == "big"){
                UILabel.appearance().font = UIFont(name: "Lato", size: 18)
            }else{
                UILabel.appearance().font = UIFont(name: "Lato", size: 16)
            }
            super.viewWillAppear(animated)
            
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "OptionViewTap"), object: nil)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "selectOptionViewOption"), object: nil)
            
        }

        
        func loadProduct(){
            guard let item = self.shoppingItem else{
                return
            }
            
            self.addLoader()
            
            let url = WebApiManager.Instance.getDescUrl(item.id, type: item.type)
            Utils.fillTheData(url, callback : self.processDetails, errorCallback : self.showError)
        }
        
        
        func processDetails(_ dataDict : NSDictionary){
            defer{self.removeLoader()}
            
            let id = self.shoppingItem!.id
            let type = self.shoppingItem!.type
            if let imgurl = WebApiManager.Instance.getDescImgsUrl(id){
                if let imgData = WebApiManager.Instance.getJSON(imgurl){
                    if let imgDataDict = Utils.parseJSON(imgData){
                        let item = DetailsDictionary(dataDict: dataDict, imgDict: imgDataDict, type: type)
                        self.processGroupedProduct(item)
                    }
                }
            }
        }
        
        func processGroupedProduct(_ itemDetails: DetailsDictionary?){
            if self.shoppingItem != nil{
                guard let item = self.shoppingItem else{
                    return
                }
                
                var description:String?
                var shortdes:String?
                
                productTitleLabel.text = item.name
                if let imagesArrayStr = itemDetails?.dataDict["image"] as? NSArray{
                    for i in 0 ..< imagesArrayStr.count{
                        imagesArray.append(imagesArrayStr[i] as! String)
                    }
                }
                
                if let NameData = itemDetails?.dataDict["general"] as? NSDictionary{
                    let sku = NameData["sku"] as? String
                    shoppingItem?.sku = sku!
                }
                
                if let descriptionData = itemDetails?.dataDict["description"] as? NSDictionary{
                    description = Encoder.decodeBase64String((descriptionData["full"] as? String ?? "")!) as String
                    shortdes = Encoder.decodeBase64String((descriptionData["short"] as? String ?? "")!) as String
                }
                
                if(description != nil && description!.isEmpty){
                    if(shortdes != nil && !shortdes!.isEmpty){
                        description = shortdes
                    }
                }
                
                productDescription(description!, stock: item.inStock)
                createImages()
                
                    if(item.inStock == false){
                        //addToCartButton.enabled = false
                    }
                
                        if let products = itemDetails?.dataDict["products"] as? NSDictionary{
                            if let grouped = products["grouped"] as? NSArray{
                                for item in grouped{
                                    if let itemDict = item as? NSDictionary{
                                    let status = itemDict["status"] as? String
                                    if(status == "1"){
                                        if let groupedItem = StoreManager.Instance.createGroupedShoppingItem(item as! NSDictionary){
                                            self.allGroupedItems.append(groupedItem)
                                        }
                                    }
                                    
                                }
                                }
                            }
                        }
                
                self.createProductListView()
                self.collectionView.reloadData()
                
            }
            
            addToCartButton.isHidden = false
        }
        
        
        /*------------------------------------------Images Scroll Starts---------------------------------------------*/
        func createImagesParentView(){
            
            productTitleLabel = Utils.createTitleLabel(mainParentScrollView,yposition: 10)
            productTitleLabel.font = UIFont(name: "Lato", size: 20)
            imageParentView = Utils.createImageParentView(mainParentScrollView, titLabel: productTitleLabel)
            mainParentScrollView.addSubview(productTitleLabel)
            mainParentScrollView.addSubview(imageParentView)
            imageParentView.backgroundColor = UIColor.white
            
            mainParentScrollView.reloadInputViews()
        }

        func createImages(){
            
            leftArrowButton.frame = CGRect(x: imageParentView.frame.origin.x + 15, y: imageParentView.frame.size.height/2, width: 30, height: 30)
            
            let leftTapGesture = UITapGestureRecognizer(target: self, action: #selector(groupedViewController.leftArrowButtonAction(_:)))
            leftArrowButton.addGestureRecognizer(leftTapGesture)
            
            let image1 = UIImage(named: "left-ArrowBlack.png")
            leftArrowButton.setBackgroundImage(image1, for: UIControl.State())
            
            imageScrollView.frame = CGRect(x: leftArrowButton.frame.origin.x + leftArrowButton.frame.size.width + 10, y: 0, width:imageParentView.frame.size.width - 120, height: imageParentView.frame.size.height)
            
            rightArrowButton.frame = CGRect(x: imageScrollView.frame.origin.x + imageScrollView.frame.size.width + 15, y: imageParentView.frame.size.height/2, width: 30, height: 30)
            
            let rightTapGesture = UITapGestureRecognizer(target: self, action: #selector(groupedViewController.rightArrowButtonAction(_:)))
            rightArrowButton.addGestureRecognizer(rightTapGesture)
            
            let image2 = UIImage(named: "right-ArrowBlack.png")
            rightArrowButton.setBackgroundImage(image2, for: UIControl.State())
            
            imageParentView.addSubview(imageScrollView)
            
            if(imagesArray.count > 1){
                imageParentView.addSubview(leftArrowButton)
                imageParentView.addSubview(rightArrowButton)
            }
            if(imagesArray.count == 0){
                imagesArray.append("product_default_image")
            }
            
            let pageCount = imagesArray.count
            if pageCount > 0{
                for _ in 0..<pageCount {
                    pageViews.append(nil)
                }
                
                let pagesScrollViewSize = imageScrollView.frame.size
                imageScrollView.delegate = self
                
                imageScrollView.contentSize = CGSize(width: pagesScrollViewSize.width * CGFloat(imagesArray.count),
                    height: pagesScrollViewSize.height)
                loadVisiblePages()
            }
            
        }
        
        func loadVisiblePages() {
            for i in 0...imagesArray.count-1{
                loadPage(i)
            }
        }
        
        func loadPage(_ page: Int) {
            if page < 0 || page >= imagesArray.count {
                // If it's outside the range of what you have to display, then do nothing
                return
            }
            
            if let _ = pageViews[page] {
                // Do nothing. The view is already loaded.
            } else {
                var frame = imageScrollView.bounds
                frame.origin.x = frame.size.width * CGFloat(page)
                frame.origin.y = 0.0
                
                let newPageView = UIImageView()
                UIImageCache.setImage(newPageView, image: imagesArray[page])
                
                if page == 0 {
                    
                    itemImageView = newPageView
                    
                }
                newPageView.contentMode = .scaleAspectFit
                newPageView.frame = frame
                imageScrollView.addSubview(newPageView)
            }
            currentPage()
        }
        
        
        @objc func leftArrowButtonAction(_ sender: AnyObject){
            let scrollPoint = CGPoint(x:imageScrollView.contentOffset.x - imageScrollView.frame.size.width, y: 0)
            
            UIView .animate(withDuration: 2, animations: {
                self.imageScrollView.contentOffset = scrollPoint
            })
            
            
            loadVisiblePages()
            
        }
        @objc func rightArrowButtonAction(_ sender: AnyObject){
            let scrollPoint = CGPoint(x:imageScrollView.contentOffset.x + imageScrollView.frame.size.width, y: 0)
            
            UIView .animate(withDuration: 2, animations: {
                self.imageScrollView.contentOffset = scrollPoint
            })
            
            loadVisiblePages()
        }
        
        func currentPage(){
            let pageWidth = imageScrollView.frame.size.width
            let page = Int(floor((imageScrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
            
            leftArrowButton.removeFromSuperview()
            rightArrowButton.removeFromSuperview()
            
            if(imagesArray.count > 1){
                if(page == 0){
                    leftArrowButton.removeFromSuperview()
                    imageParentView.addSubview(rightArrowButton)
                }
                    
                else if(page == imagesArray.count - 1){
                    rightArrowButton.removeFromSuperview()
                    imageParentView.addSubview(leftArrowButton)
                }
                    
                else{
                    imageParentView.addSubview(leftArrowButton)
                    imageParentView.addSubview(rightArrowButton)
                }
            }
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            currentPage()
        }
        /*------------------------------------------Images Scroll End-----------------------------------------------*/
        
        /*------------------------------------------Description Starts---------------------------------------------*/
        func productDescription(_ des: String,stock:Bool){
            
            detailsParentView.frame =  CGRect(x: 20, y: imageParentView.frame.origin.y + imageParentView.frame.size.height + 10, width: imageParentView.frame.size.width - 40, height: 150)
            let border1 = UILabel(frame: CGRect(x: 0, y: 0, width: detailsParentView.frame.width, height: 1))
            border1.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
            detailsParentView.addSubview(border1)
            
            let priceView = UIView(frame: CGRect(x: 0, y: border1.frame.origin.y + border1.frame.height + 10, width: detailsParentView.frame.width/2, height: 50))
            let itemLabel = UILabel()
            itemLabel.frame = CGRect(x: 0, y: 0, width: priceView.frame.width - 10, height: 30)
            itemLabel.text = "Grouped"
            itemLabel.textColor = UIColor.red
            itemLabel.font = UIFont(name: "Lato", size: 20)
            itemLabel.numberOfLines = 0
            itemLabel.sizeToFit()
            priceView.addSubview(itemLabel)
            
            let priceTitleLabel = UILabel(frame: CGRect(x: itemLabel.frame.origin.x, y: itemLabel.frame.origin.y + itemLabel.frame.height+1, width: priceView.frame.width, height: 22))
            priceTitleLabel.text = "Item"
            priceTitleLabel.font = UIFont(name: "Lato-Light", size: 15)
            priceView.addSubview(priceTitleLabel)
            
            priceView.frame.size.height = priceTitleLabel.frame.origin.y + priceTitleLabel.frame.height + 10
            
            let rightborder = CALayer()
            rightborder.frame = CGRect(x: priceView.frame.width - 0.5, y: 0, width: 1, height: priceView.frame.height - 10)
            rightborder.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
            priceView.layer.addSublayer(rightborder)
            
            
            detailsParentView.addSubview(priceView)
            
            productStock.frame = CGRect(x: detailsParentView.frame.width/2 + 5, y: priceView.frame.origin.y, width: detailsParentView.frame.width/2 - 10, height: priceView.frame.height - 7)
            productStock.text = "In Stock"
            productStock.font = itemLabel.font
            productStock.textColor = UIColor.green
            productStock.textAlignment = .center;
            
            if(stock == false){
                productStock.text = "Out of Stock"
                productStock.textColor = UIColor.red
            }
            
            detailsParentView.addSubview(productStock)
            
            let border2 = UILabel(frame: CGRect(x: 0, y: priceView.frame.origin.y + priceView.frame.height, width: detailsParentView.frame.width, height: 1))
            border2.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
            detailsParentView.addSubview(border2)
            
            descriptionTitleLabel = Utils.createTitleLabel(detailsParentView, yposition: border2.frame.origin.y + border2.frame.size.height + 10)
            descriptionTitleLabel.text = "Description"
            descriptionTitleLabel.frame.origin.x = 0
            descriptionTitleLabel.font = UIFont(name: "Lato", size: 17)
            
            DescriptionTextView.frame = CGRect(x: 0, y: descriptionTitleLabel.frame.origin.y + descriptionTitleLabel.frame.size.height, width: detailsParentView.frame.size.width, height: 30)
            DescriptionTextView.text =  des
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
            
            detailsParentView.addSubview(descriptionTitleLabel)
            detailsParentView.addSubview(DescriptionTextView)
            detailsParentView.frame.size.height = DescriptionTextView.frame.origin.y + DescriptionTextView.frame.height + 10
            mainParentScrollView.addSubview(detailsParentView)
        }
        
        func createProductListView(){
            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            var countLength:CGFloat = CGFloat(self.allGroupedItems.count)
            if(Int(countLength) % 2 != 0){
                countLength = countLength + 1
            }
            var extraHeight:CGFloat = 50
            
            if(deviceWidth >= 1025){
                countLength = countLength/4
                layout.itemSize = CGSize(width: 178, height: 250)
            }
            else if(deviceWidth >= 768 && deviceWidth < 1025){
                countLength = countLength/4
                countLength = ceil(countLength)
                extraHeight = 30
                layout.itemSize = CGSize(width: 178, height: 250)
            }
            else if(deviceWidth >= 569 && deviceWidth < 768){
                countLength = countLength/4
                layout.itemSize = CGSize(width: 178, height: 250)
            }
            else if(deviceWidth >= 481 && deviceWidth < 569){
                countLength = countLength/4
                layout.itemSize = CGSize(width: 178, height: 250)
            }
            else if(deviceWidth > 320 && deviceWidth < 481){
                countLength = countLength/2
                layout.itemSize = CGSize(width: mainParentScrollView.frame.size.width/2.19, height: 250)
            }
            else if(deviceWidth <= 320){
                countLength = countLength/2
                layout.itemSize = CGSize(width: mainParentScrollView.frame.size.width/2.209, height: 210)
            }
            
            collectionView = UICollectionView(frame: CGRect(x: 0, y: detailsParentView.frame.origin.y + detailsParentView.frame.size.height, width: mainParentScrollView.frame.size.width, height: mainParentScrollView.frame.size.height - 200), collectionViewLayout: layout)
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
            collectionView.backgroundColor = UIColor(netHex:0xeaeaea)
            
            collectionView.frame.size.height = countLength * layout.itemSize.height + extraHeight
            mainParentScrollView.addSubview(collectionView)
            addToCartButton.frame.origin.y = self.collectionView.frame.origin.y + self.collectionView.frame.size.height + 20
            mainParentScrollView.contentSize.height = self.addToCartButton.frame.origin.y + self.addToCartButton.frame.size.height + 100
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return self.allGroupedItems.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
            for view in cell.contentView.subviews{
                view.removeFromSuperview()
            }
            
            cell.backgroundColor = UIColor.white
            cell.layer.borderWidth = 2
            cell.layer.borderColor = UIColor.white.cgColor
            
            let item = self.allGroupedItems[indexPath.row]
            let count = self.tempCart.getCount(item)
            let productTitle = UILabel()
            productTitle.text = item.name
            productTitle.textColor = UIColor.black
            productTitle.textAlignment = .center;
            productTitle.frame = CGRect(x: 7, y: 5, width:cell.frame.size.width-14, height: 23)
            
            var oldLabel = UILabel()
            if item.isShowSpecialPrice(){
                oldLabel = UILabel(frame: CGRect(x: 1, y: productTitle.frame.origin.y + productTitle.frame.size.height + 1, width:cell.frame.size.width/2, height: 23))
                oldLabel.textColor = UIColor.gray
                oldLabel.font = UIFont(name: "Lato", size: 14)
                oldLabel.textAlignment = .right;
                oldLabel.backgroundColor = UIColor.white
                
                let attributePrice =  NSMutableAttributedString(string: item.originalPriceStr!)
                attributePrice.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributePrice.length))
                
                oldLabel.attributedText = attributePrice
                cell.addSubview(oldLabel)
                
                
                let newLabel = UILabel(frame: CGRect(x: 1+cell.frame.size.width/2, y: oldLabel.frame.origin.y, width:cell.frame.size.width/2, height: 23))
                newLabel.textColor = UIColor.red
                newLabel.font = UIFont(name: "Lato", size: 15)
                newLabel.textAlignment = .left;
                newLabel.text = " "+item.priceStr
                newLabel.backgroundColor = UIColor.white
                cell.addSubview(newLabel)
            }else{
                oldLabel = UILabel(frame: CGRect(x: 1, y: productTitle.frame.origin.y + productTitle.frame.size.height + 1, width:cell.frame.size.width - 2, height: 23))
                oldLabel.textColor = UIColor.red
                oldLabel.font = UIFont(name: "Lato", size: 16)
                oldLabel.textAlignment = .center;
                oldLabel.text = item.priceStr
                oldLabel.backgroundColor = UIColor.white
                cell.addSubview(oldLabel)
            }
            
            let new_img_view = UIImageView()
            UIImageCache.setImage(new_img_view, image: item.image)
            new_img_view.frame = CGRect(x: 20, y: oldLabel.frame.origin.y + oldLabel.frame.size.height + 6, width: cell.frame.size.width-40, height: 140)
            
            
            let quantityParentView = UIView(frame: CGRect(x: 35, y: new_img_view.frame.height + new_img_view.frame.origin.y + 7, width: cell.frame.size.width-70, height: 30))
            quantityParentView.backgroundColor = UIColor.lightGray
            
            let minusButton = UIButton()
            minusButton.tag = item.id
            minusButton.frame = CGRect(x: 0, y: 0, width: 23, height: quantityParentView.frame.height)
            let minusImage = UIImage(named: "minus1")
            minusButton.setImage(minusImage, for:UIControl.State())
            minusButton.addTarget(self, action: #selector(groupedViewController.minusButtonFunction(_:)), for: UIControl.Event.touchUpInside)
            
            let quantityLabel = UILabel(frame: CGRect(x: minusButton.frame.origin.x + minusButton.frame.width + 1, y: 1, width: 50, height: quantityParentView.frame.height - 2))
            quantityLabel.text = String(count)
            quantityLabel.backgroundColor = UIColor.white
            quantityLabel.textColor = UIColor.black
            quantityLabel.textAlignment = .center;
            
            let plusButton = UIButton()
            plusButton.tag = item.id
            plusButton.frame = CGRect(x: quantityLabel.frame.origin.x + quantityLabel.frame.width + 1, y: 0, width: 23, height: quantityParentView.frame.height)
            let plusImage = UIImage(named: "add")
            plusButton.setImage(plusImage, for:UIControl.State())
            plusButton.addTarget(self, action: #selector(groupedViewController.plusButtonFunction(_:)), for: UIControl.Event.touchUpInside)
            quantityParentView.frame.size.width = plusButton.frame.origin.x + plusButton.frame.width
            
            let outOfStock = UILabel(frame: CGRect(x: 2, y: new_img_view.frame.height + new_img_view.frame.origin.y + 7, width: cell.frame.size.width - 4, height: 30))
            outOfStock.textColor = UIColor.red
            outOfStock.font = UIFont(name: "Lato", size: 15)
            outOfStock.textAlignment = .center;
            outOfStock.text = "Out of Stock"
            outOfStock.backgroundColor = UIColor.white
            
            quantityParentView.addSubview(minusButton)
            quantityParentView.addSubview(quantityLabel)
            quantityParentView.addSubview(plusButton)
            
            cell.contentView.addSubview(productTitle)
            cell.contentView.addSubview(new_img_view)
            
            if(item.inStock == true){
                cell.contentView.addSubview(quantityParentView)
            }else{
                cell.contentView.addSubview(outOfStock)
            }
            
            if self.tempCart.getTotalCount() > 0{
                addToCartButton.isEnabled = true
            }else{
                //addToCartButton.enabled = false
            }
            
            return cell
        }
        
        func backButtonFunction(){
            self.navigationController?.popViewController(animated: true)
        }
        
        
        @objc func minusButtonFunction(_ button: UIButton){
            if let item = StoreManager.Instance.getShoppingItem(button.tag){
                self.tempCart.addItem(item, num: -1, minCount : 0)
            }
            
            self.collectionView.reloadData()
        }
        
        @objc func plusButtonFunction(_ button: UIButton){
            if let item = StoreManager.Instance.getShoppingItem(button.tag){
                self.tempCart.addItem(item, num: 1, minCount : 0)
            }
            
            self.collectionView.reloadData()
        }
        
        @objc func addToCartButtonAction(_ button:ZFRippleButton){
            
            if self.tempCart.getTotalCount() <= 0 {
                let alert = UIAlertController(title: "", message: "Please add item to continue".localized(), preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "OK".localized(), style: .default, handler: { (action: UIAlertAction!) in
                    //Nothing
                }))
                self.present(alert, animated: true, completion: nil)
                
                return
            }
            
            for (item, count) in self.tempCart {
                if count > 0{
                    ShoppingCart.Instance.addItem(item, num: count)
                }
            }
            
            self.AddImagetocartWithAnimation(itemImageView)
            
        }
    }




