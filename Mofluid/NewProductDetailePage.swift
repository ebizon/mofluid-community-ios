//
//  NewProductDetailePage.swift
//  This file is created by Ankur
//
//  Created by Ebizon Netinfo Pvt Ltd on 14/06/16.
//
//

import UIKit
import Crashlytics
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l <= r
    default:
        return !(rhs < lhs)
    }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l >= r
    default:
        return !(lhs < rhs)
    }
}

class NewProductDetailePage: PageViewController  ,UITableViewDelegate  ,UITableViewDataSource , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout , UITextViewDelegate{
    var hasCustomOption : Bool = false
    
    @IBOutlet var imgScrollViewHeightConstraints: NSLayoutConstraint!
    @IBOutlet var reviewViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var beTheFirstReviewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var readAllReviewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var readAllReviewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var readMoreLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var readAllReviewBtnOutlet: UIButton!
    @IBOutlet var beFirstReviewLbl: UILabel!
    @IBOutlet var reviewView: UIView!
    @IBOutlet var reviewTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var reviewTableView: UITableView!
    
    @IBOutlet var writeReviewOutlet: UIButton!
    @IBOutlet var writeReviewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var productReviewLabel: UILabel!
    
    @IBOutlet var relatedProductParenView: UIView!
    @IBOutlet var relatedProductCollectionVIew: UICollectionView!
    @IBOutlet var getDiscountHeightConstraint: NSLayoutConstraint!
    @IBOutlet var line3View: UIView!
    @IBOutlet var line2Lbl: UIView!
    @IBOutlet var readMoreHeightConstraint: NSLayoutConstraint!
    @IBOutlet var lineLBl: UILabel!
    @IBOutlet var mainScrollView: UIScrollView!
    @IBOutlet var rtlBuyNowOutlet: UIButton!
    @IBOutlet var rtlView: UIView!
    @IBOutlet var arrowBtnTrailingConstrint: NSLayoutConstraint!
    @IBOutlet var wishListBtnOutlet: UIButton!
    @IBOutlet var cartBtnOutlet: UIButton!
    @IBOutlet var shareBtnOutlet: UIButton!
    @IBOutlet var shareBtnRTLOutlet: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet var arrowBtn: UIButton!
    @IBOutlet var rtlback: UIButton!
    @IBOutlet var productSpecificationLbl: UILabel!
    @IBOutlet var buyNowOutlet: UIButton!
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var basePriceLbl: UILabel!
    @IBOutlet weak var textViewHightConstant: NSLayoutConstraint!
    @IBOutlet weak var specialPriceLbl: UILabel!
    @IBOutlet weak var getDiscountPercentLbl: UILabel!
    @IBOutlet weak var imgscrollview: UIScrollView!
    @IBOutlet weak var readMore: UIButton!
    @IBOutlet weak var viewForLabel: NSLayoutConstraint!
    @IBOutlet weak var viewForLabels: UIView!
    @IBOutlet weak var viewForOption: UIView!
    @IBOutlet weak var pageControll: UIPageControl!
    @IBOutlet weak var viewForOptionHightConstraint: NSLayoutConstraint!
    @IBOutlet weak var colourDecriptionLbl: UILabel!
    
    var SelectedAttributeTextDict : [String : Set<String>] = [:]
    var configOptionName = [String]()
    var configAttributeArr = [NSDictionary]()
    var selectedAttributes:[String:String] = [:]
    var tempSet = Set<String>()
    var shareURl = ""
    let kCellReuse : String = "Cell"
    var relatedProducts:[ShoppingItem] = []
    var detailsDict : DetailsDictionary? = nil
    var childShoppingItems = [Set<AttributePair>: ShoppingItem]()
    var allShoppingItems = [ShoppingItem]()
    let supportedOptions = ["drop_down", "checkbox", "multiple", "radio", "field", "area"]
    var titleParentView = UIView()
    var titileLabel = UILabel()
    var customTableListParentView = UIView()
    var priceValue = UILabel()
    var optionSet : [CustomOptionSet] = [CustomOptionSet]()
    var productTitle:String? = nil
    var productPrice:String? = nil
    var stockBool:Bool = false
    var readMoreBttonClicked:Bool = false
    var dropDownTableView = UITableView()
    var dropDownButtonTagValue = 0
    var customdropDownGestureView = UIButton()
    var dropDownBooleanValue = 1
    var dropDownTableViewXPos:CGFloat? = nil
    var dropDownTableViewYPos:CGFloat? = nil
    var changeButton:UIButton = UIButton()
    var priceLabel = UILabel()
    var customOptionSelected = Bool()
    var shoppingItem:ShoppingItem? = nil
    var productTitleLabel:UILabel = UILabel()
    var imageParentView: UIView = UIView()
    var horizontalScrollView: UIScrollView = UIScrollView()
    var imagesArray =  [String]()
    var pageViews: [UIImageView?] = []
    var titlesArray = [String]()
    var pageIndex = Int32()
    var righttitlesArray = [String] ()
    var attributeMapList = [AttributeMap]()
    var attributeKeys = [String]()
    var checkQuantityNumber = 0
    var isSizeSelected = Bool()
    var checkType = String()
    var itemImageView = UIImageView ()
    var allData = NSDictionary()
    var productPriceValue = UILabel()
    var addToCartButton = ZFRippleButton()
    var additionalInfoButton = UIButton()
    var shortdes: String? = nil
    var count:Int?
    var arr :NSMutableArray? = []
    var dic :NSMutableDictionary? = [:]
    
    var itemDetailsDemo : DetailsDictionary? = nil
    var arrReviewData : [ProductReviewData] = [ProductReviewData]()
    
    override func loadView() {
        super.loadView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        mainParentScrollView.addSubview(self.mainScrollView)
        self.setUpUI()
        loadImage()

        writeReviewOutlet.layer.masksToBounds = true
        writeReviewOutlet.layer.borderWidth = 2.0
        writeReviewOutlet.layer.cornerRadius = 4.0
        writeReviewOutlet.layer.borderColor = UIColor.black.cgColor
        descriptionText.layoutIfNeeded()
        relatedProductCollectionVIew.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: kCellReuse)
        cellHeight = 186
        relatedProductCollectionVIew.delegate = self
        relatedProductCollectionVIew.dataSource = self
        descriptionText.frame.size.height=60
    }
    
    override func viewWillAppear(_ animated: Bool) {
        debugPrint(Date(), #function,#line)
        super.viewWillAppear(animated)
        backButton.isEnabled = true
        self.view.isUserInteractionEnabled = true
        descriptionText.delegate = self;
        descriptionText.isScrollEnabled = false
        self.tabBarController?.tabBar.isHidden = false
        customdropDownGestureView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        customdropDownGestureView.backgroundColor = UIColor.clear
        customdropDownGestureView.addTarget(self, action: #selector(NewProductDetailePage.dropDownGesturebuttonAction), for: .touchUpInside)
//        if(deviceName == "big"){
//            UILabel.appearance().font = UIFont(name: "Lato", size: 18)
//        }else{
//            UILabel.appearance().font = UIFont(name: "Lato", size: 16)
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        descriptionText.isScrollEnabled = false
        descriptionText.frame.size.height=60
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "OptionViewTap"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "selectOptionViewOption"), object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        descriptionText.setContentOffset(CGPoint.zero, animated: false)
        self.descriptionText.scrollRangeToVisible(NSMakeRange(0, 0))
        descriptionText.scrollRectToVisible(CGRect(origin: CGPoint.zero, size: CGSize(width: 1.0, height: 1.0)), animated: false)
        descriptionText.frame.size.height=60
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpUI()
    {
        buyNowOutlet.setTitle("BUY NOW".localized(), for: UIControl.State())
        rtlBuyNowOutlet.setTitle("BUY NOW".localized(), for: UIControl.State())
        readMore.setTitle("READ MORE".localized(), for: UIControl.State())
        productSpecificationLbl.text = "  DESCRIPTION".localized()
        colourDecriptionLbl.text = "The Color of the product may be vary what is shown in image".localized()
        readAllReviewBtnOutlet.setTitle("Read all reviews >>".localized(), for: UIControl.State())
        productReviewLabel.text = "PRODUCT REVIEWS".localized()
        writeReviewOutlet.setTitle("Write Review".localized(), for: UIControl.State())
        //  colorDescriptionLblHeightConstraint.constant = 0
        colourDecriptionLbl.isHidden = true
        
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        activityIndicator.color = UIColor.black
        activityIndicator.center = CGPoint(x: screenWidth  / 2, y: screenHeight / 2)
        activityIndicator.hidesWhenStopped = true;
        
        if (idForSelectedLangauge == Utils.getArebicLanguageCode()) {
            self.updateUIForRTL()
        }
        else
        {
            arrowBtn.isHidden = false
            rtlback.isHidden = true
            rtlView.isHidden = true
            productSpecificationLbl.textAlignment = .left
            getDiscountPercentLbl.textAlignment = .left
            basePriceLbl.textAlignment = .left
            productNameLbl.textAlignment = .left
            specialPriceLbl.textAlignment = .left
            descriptionText.textAlignment = .left
        }
        
        self.productNameLbl.text = self.shoppingItem?.name
        self.productNameLbl.backgroundColor = UIColor.clear
        self.navigationItem.title = self.shoppingItem?.name.uppercased()
        self.navigationItem.hidesBackButton = true
        reviewTableView.delegate = self
        reviewTableView.dataSource = self
        reviewTableView.estimatedRowHeight = 110
        reviewTableView.rowHeight = UITableView.automaticDimension
        
        if (idForSelectedLangauge == Utils.getArebicLanguageCode()) {
            let tempX = UINib(nibName: "ReviewTableViewCell_RTL" , bundle: nil)
            reviewTableView.register(tempX, forCellReuseIdentifier: "ReviewTableIdentifierCell")
        }else{
            let tempX = UINib(nibName: "ReviewTableViewCell" , bundle: nil) //cellIdentifierTest
            reviewTableView.register(tempX, forCellReuseIdentifier: "ReviewTableIdentifierCell")
        }
        //
        count = 0
        isSizeSelected = false
        customOptionSelected = false
    }
    
    func updateUIForRTL() {
        arrowBtn.isHidden = true
        rtlback.isHidden = false
        rtlView.isHidden = false
        productSpecificationLbl.textAlignment = .right
        getDiscountPercentLbl.textAlignment = .right
        basePriceLbl.textAlignment = .right
        specialPriceLbl.textAlignment = .right
        productNameLbl.textAlignment = .right
        descriptionText.textAlignment = .right
        writeReviewLeadingConstraint.constant = UIScreen.main.bounds.width - writeReviewOutlet.bounds.width - 5
        writeReviewOutlet.updateConstraintsIfNeeded()
        productReviewLabel.textAlignment = .right
        shareBtnOutlet.isHidden = true
        shareBtnRTLOutlet.isHidden = false
        readAllReviewLeadingConstraint.constant = UIScreen.main.bounds.width - readAllReviewBtnOutlet.bounds.width - 5
        readAllReviewBtnOutlet.updateConstraintsIfNeeded()
        readMoreLeadingConstraint.constant = UIScreen.main.bounds.width - readMore.bounds.width - 5
        readMore.updateConstraintsIfNeeded()
        self.beFirstReviewLbl.textAlignment = .right
    }
    
    func loadProduct(){
        
        guard let item = self.shoppingItem else{
            return
        }
        
        if let detailsDict = CacheManager.Instance.getDetails(item.id){
            self.processDetailsData(detailsDict)//ankur
        }else{
            self.addLoader()
            let url = WebApiManager.Instance.getDescUrl(item.id, type: item.type)
            Utils.fillTheData(url, callback : self.processDetails,   errorCallback : self.showError)
        }
        if ShoppingWishlist.Instance.isContainsItem(item){
            wishListBtnOutlet.isSelected = true
        }else{
            wishListBtnOutlet.isSelected = false
        }
        
    }
    func processDetails(_ dataDict : NSDictionary){
        defer{
            self.removeLoader()
        }
        self.shoppingItem?.smallImg = dataDict["img"] as? String
        if self.shoppingItem != nil {
            let id = self.shoppingItem?.id ?? 0
            let type = self.shoppingItem?.type ?? ""
            let imageDataDict :NSDictionary = NSDictionary()
            let item = DetailsDictionary(dataDict: dataDict, imgDict: imageDataDict, type: type)
            
            self.processDetailsData(item);
            if item != nil{
                CacheManager.Instance.addDetails(id, details: item!)
            }
        }
        //  createRelatedProduct()
        
    }
    // MARK:  start for related product
    
    func createRelatedProduct() {
        if let id = self.shoppingItem?.id
        {
            let url = WebApiManager.Instance.getRelatedProductURL(id)
            Utils.fillTheData(url, callback: processData, errorCallback: showError)
        }
    }
    
    
    
    func processData(_ dict : NSDictionary){
        defer{
            self.removeLoader()
        }
        
        relatedProducts.removeAll()
        detailsDict?.getrelatedProducts.removeAll()
        
        if let data = dict["products_list"] as? NSArray{
            relatedProductParenView.isHidden = false
            for item in data{
                
                if let itemDict = item as? NSDictionary{
                    if let shoppingItem = StoreManager.Instance.createShoppingItem(itemDict){
                        relatedProducts.append(shoppingItem)
                        detailsDict?.getrelatedProducts.append(shoppingItem)
                    }
                }
            }
            mainScrollView.contentSize = CGSize(width: UIScreen.main.bounds.width , height: relatedProductParenView.frame.origin.y + relatedProductParenView.frame.height + 70)
            //  dispatch_async(dispatch_get_main_queue(), {
            self.view.layoutIfNeeded()
            // })
            relatedProductCollectionVIew.reloadData()
            
        }else {
            mainScrollView.contentSize = CGSize(width: UIScreen.main.bounds.width , height: reviewView.frame.origin.y + reviewView.frame.height + 70)
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: Collection view delegate methods
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        var size : CGSize
        
        if (UIDevice.current.model.range(of: "iPad") != nil)
        {
            size = CGSize(width: (width/4)   , height: 186)
        }
        else {
            size = CGSize(width: (width/3)  , height: 186)
        }
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return relatedProducts.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellReuse, for: indexPath) as! CustomCollectionViewCell
        var item : ShoppingItem
        item =  relatedProducts[indexPath.row]
        if item.isShowSpecialPrice()
        {
            let attributePrice =  NSMutableAttributedString(string: item.originalPriceStr ?? "")
            attributePrice.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributePrice.length))
            attributePrice.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: NSMakeRange(0, attributePrice.length))
            var priseString = NSMutableAttributedString()
            priseString = NSMutableAttributedString(string: "  \(item.priceStr)")
            attributePrice.append(priseString)
            cell.costTitle.attributedText = attributePrice
        }
        else
        {
            cell.costTitle.text = item.priceStr
        }
        UIImageCache.setImage(cell.new_img_view, image: item.image)
        cell.productTitle.text = item.name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        var item : ShoppingItem
        
        item =  relatedProducts[indexPath.row]
        
        let data = StoreManager.Instance.getShoppingItem(item.id)
        if(data?.type == "grouped"){
            let groupProductObject = self.storyboard?.instantiateViewController(withIdentifier: "groupedViewController") as? groupedViewController
            groupProductObject?.shoppingItem = StoreManager.Instance.getShoppingItem(indexPath.row)
            groupProductObject?.titleString = data?.value(forKey: "name") as? NSString ?? ""
            self.navigationController?.pushViewController(groupProductObject!, animated: true)
        }
            
        else{
            
            DispatchQueue.main.async(execute: {
                let productDtail = NewProductDetailePage(nibName: "NewProductDetailePage", bundle: nil)
                let def = UserDefaults.standard
                let idItem =  def.integer(forKey: "intKey") as Int
                let def1 = UserDefaults.standard
                let idIt = def1.integer(forKey: "intKy") as Int
                
                productDtail.shoppingItem?.id = data?.value(forKey: "id") as? Int ?? 0
                if data?.value(forKey: "id") as? Int == idIt {
                    
                    productDtail.shoppingItem?.id = idItem
                    data?.setValue(idItem, forKey: "id")
                }
                productDtail.shoppingItem = StoreManager.Instance.getShoppingItem(item.id)
                self.navigationController?.pushViewController(productDtail, animated: true)
            })
        }
    }
    
    
    //  end for related product
    
    // MARK: load images
    func loadImage(){
        self.addLoader()
        guard let item = self.shoppingItem else{
            return
        }
        if let imgDict = CacheManager.Instance.getimageDetail(item.id){
            self.processLoadingImage(imgDict)
        }
        else{
            if let id = self.shoppingItem?.id{
                
                if  let imgurl = WebApiManager.Instance.getDescImgsUrl(id){
                    Utils.fillTheData(imgurl, callback : self.processLoadingImage, errorCallback : self.showError)
                }
            }
        }
    }
    
    
    func processLoadingImage(_ imgDataDict : NSDictionary) // ankur image
    {
        self.removeLoader()
        imagesArray.removeAll()
        if let imagesArrayStr = imgDataDict["image"] as? NSArray{
            for i in 0 ..< imagesArrayStr.count{
                imagesArray.append(imagesArrayStr[i] as? String ?? "")
            }
        }
        let id = self.shoppingItem?.id ?? 0
        CacheManager.Instance.addImageDetail(id, details: imgDataDict)
        createImages()
        loadReviewData()
        loadProduct()
    }
    
    func processDetailsData(_ detailsDict : DetailsDictionary?){
        if(self.shoppingItem?.type == "configurable"){
            self.processConfigurableProduct(detailsDict)
        }else{
            self.processSimpleProduct(detailsDict)
        }
    }
    func processSimpleProduct(_ itemDetails: DetailsDictionary?){
        viewForOptionHightConstraint.constant = 0
        let item = self.shoppingItem!
        var custom_attr_len: Int? = nil
        var custom_attr_data = [NSDictionary]()
        shareURl = (itemDetails?.dataDict["url"] as? String) ?? ""
        let img = itemDetails?.dataDict["img"] as? String  //ankur test
        self.shoppingItem?.smallImg = img
        let specialPrice = itemDetails?.dataDict["sprice"] as? String ?? ""
        var price =  itemDetails?.dataDict["price"] as? String ?? ""
        var description = itemDetails?.dataDict["shortdes"] as? String
        shortdes = itemDetails?.dataDict["description"] as? String
        if let sku = itemDetails?.dataDict["sku"] as? String{
            self.shoppingItem?.sku = sku
        }
        
        item.numInStock =  Int(itemDetails?.dataDict["quantity"] as? String ?? "0")!
        
        if(item.numInStock <= 0){
            buyNowOutlet.isEnabled = false
            buyNowOutlet.backgroundColor =  UIColor(red: (223/255.0), green: (114/255.0), blue: (114/255.0), alpha: 1.0)
            cartBtnOutlet.isEnabled = false
            cartBtnOutlet.backgroundColor =  UIColor(red: (144/255.0), green: (144/255.0), blue: (144/255.0), alpha: 0.5)
        }else{
            buyNowOutlet.isEnabled = true
            buyNowOutlet.backgroundColor =  UIColor(red: (223/255.0), green: (114/255.0), blue: (114/255.0), alpha: 1.0)
            cartBtnOutlet.isEnabled = true
            cartBtnOutlet.backgroundColor =  UIColor(red: (144/255.0), green: (144/255.0), blue: (144/255.0), alpha: 1.0)
            wishListBtnOutlet.isEnabled = true
            wishListBtnOutlet.backgroundColor =  UIColor(red: (144/255.0), green: (144/255.0), blue: (144/255.0), alpha: 1.0)
            
        }
        
        if let stockStatus = itemDetails?.dataDict["is_in_stock"] as? Int{
            self.shoppingItem?.inStock = stockStatus == 1
        }
        
        if let custom_attr = itemDetails?.dataDict["custom_attribute"] as? NSDictionary{
            custom_attr_len = custom_attr["total"] as? Int
            if(custom_attr_len > 0){
                custom_attr_data = (custom_attr["data"] as? NSArray ?? []) as! [Any] as! [NSDictionary]
                for i in 0 ..< custom_attr_data.count{
                    if let value = custom_attr_data[i]["attr_value"] as? String{
                        if(value != "No"){
                            if let leftValue = custom_attr_data[i]["attr_label"] as? String{
                                if(leftValue != "featured"){
                                    titlesArray.append(leftValue)
                                    righttitlesArray.append(value)
                                }
                            }
                        }
                    }
                }
                
            }
        }
        productTitleLabel.text = item.name //ankur
        if(description == nil || description == "downloadable"){  //ankur
            if(shortdes != ""){
                description = shortdes
            }
        }
        
        if(Int(Utils.StringToDouble(specialPrice)) > 0 && Int(Utils.StringToDouble(specialPrice)) < Int(Utils.StringToDouble(price))){
            price = specialPrice
        }
        if description != nil{
            description = self.removeHTmltag(description! as NSString)
            productDescription(description!, item : item, stock:self.shoppingItem?.inStock ?? false,type:"Simple")
        }
        if let has_custom_option = itemDetails?.dataDict["has_custom_option"] as? Int{
            
            if(has_custom_option > 0 || shoppingItem?.type == "downloadable"){
                
                hasCustomOption =  true //PC
                itemType = shoppingItem?.type ?? ""
                simpleCustomOptions()
            }else{
                itemType = shoppingItem?.type ?? ""
            }
        }
    }
    
    //MARK: process confuigrable product
    func processConfigurableProduct(_ itemDict : DetailsDictionary?){
        let itemDetails =  itemDict!.dataDict
        let item = self.shoppingItem!
        shareURl = (itemDetails["url"] as? String) ?? ""
        let img = itemDetails["img"] as? String  ?? "" //ankur test
        self.shoppingItem?.smallImg = img
        let specialPrice = itemDetails["sprice"] as? String ?? ""
        var price =  itemDetails["price"] as? String ?? ""
        var description = itemDetails["shortdes"] as? String
        shortdes = itemDetails["description"] as? String
        if let sku = itemDetails["sku"] as? String{
            self.shoppingItem?.sku = sku
        }
        
        item.numInStock = Int(itemDetails["quantity"] as! String)!
        if(item.numInStock <= 0){
            buyNowOutlet.isEnabled = false
            buyNowOutlet.backgroundColor =  UIColor(red: (223/255.0), green: (114/255.0), blue: (114/255.0), alpha: 1.0)
            cartBtnOutlet.isEnabled = false
            cartBtnOutlet.backgroundColor =  UIColor(red: (144/255.0), green: (144/255.0), blue: (144/255.0), alpha: 0.5)
        }
            
        else{
            buyNowOutlet.isEnabled = true
            buyNowOutlet.backgroundColor =  UIColor(red: (223/255.0), green: (114/255.0), blue: (114/255.0), alpha: 1.0)
            cartBtnOutlet.isEnabled = true
            cartBtnOutlet.backgroundColor =  UIColor(red: (144/255.0), green: (144/255.0), blue: (144/255.0), alpha: 1.0)
            wishListBtnOutlet.isEnabled = true
            wishListBtnOutlet.backgroundColor =  UIColor(red: (144/255.0), green: (144/255.0), blue: (144/255.0), alpha: 1.0)
            
        }
        
        if let stockStatus = itemDetails["is_in_stock"] as? Int{
            self.shoppingItem?.inStock = stockStatus == 1
        }
        
        productTitleLabel.text = item.name //ankur
        if(description == nil){  //ankur
            if(shortdes != ""){
                description = shortdes
            }
        }
        if(Int(Utils.StringToDouble(specialPrice)) > 0 && Int(Utils.StringToDouble(specialPrice)) < Int(Utils.StringToDouble(price))){
            price = specialPrice
        }
        
        if description != nil{
            description = self.removeHTmltag(description! as NSString)
            
            productDescription(description!, item : item, stock:self.shoppingItem?.inStock ?? false,type:"Simple")
        }
        getAttributeForItem(itemDetails)
        
    }
    
    func getAttributeForItem(_ itemDict : NSDictionary){
        if let attributes = itemDict["config_attributes"] as?  [NSDictionary]{
            attributes.forEach{item in
                let id = item["prod_id"] as? String
                let name = item["name"] as? String
                let price = item["price"] as? String
                let spclprice = item["spclprice"] as? String
                let inStock = item["is_in_stock"] as? Bool
                let type = item["type"] as? String
                let img = item["img"] as? String
                let sku = item["sku"] as? String
                if let shoppingItem = ShoppingItem(id: Int(id!)!, name: name!, sku: sku!, price: price, specialPrice: spclprice, inStock: inStock!, image: img, type: type!, img1: img){
                    shoppingItem.numInStock = item["stock_quantity"] as! Int
                    var identifierSet = Set<AttributePair>()
                    if let data = item["data"] as? [String: [String : String]]{
                        for(key, value) in data{
                            let label = value["label"]
                            let identifier = AttributePair(name: key, value: label!)
                            identifierSet.insert(identifier)
                        }
                    }
                    
                    if(identifierSet.count > 0){
                        self.childShoppingItems[identifierSet] = shoppingItem
                    }
                }
            }
        }
        
        if let options = itemDict["config_option"] as? [String]{
            self.configOptionName = options
            self.configurableOptions()
        }else{
            viewForOptionHightConstraint.constant = 0
        }
        self.removeLoader()
    }
    
    func configurableOptions(){
        var posParentY:CGFloat = 10
        var posChildY : CGFloat = 50
        for item in self.configOptionName{
            let parentHorizontalView = UIView()
            parentHorizontalView.frame = CGRect(x: 8, y: posParentY , width: 200, height: 40)
            //   self.attributeButtonMap[item] = [UIButton]()
            let attrValueLabel = UIButton()
            attrValueLabel.accessibilityIdentifier = item
            attrValueLabel.frame = CGRect(x: 0, y: 0, width: 170, height: 40)
            attrValueLabel.backgroundColor = UIColor.white
            attrValueLabel.setTitleColor(UIColor.black, for: UIControl.State())
            attrValueLabel.titleLabel?.textAlignment = .left
            attrValueLabel.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
            attrValueLabel.titleLabel?.font = UIFont(name: "Lato", size: 15)
            let sel = "Select ".localized()
            let abc =   sel + "\(item)"
            attrValueLabel.setTitle(abc.localized(), for: UIControl.State())
            // attrValueLabel.titleLabel?.adjustsFontSizeToFitWidth = true
            parentHorizontalView.addSubview(attrValueLabel)
            posParentY = posParentY + 75
            selectActionForBtton(attrValueLabel , posY: posChildY)
            posChildY = posChildY + 75
            self.viewForOption.addSubview(parentHorizontalView)
        }
        // self.viewForOption.addSubview(parentHorizontalScrollView)
        viewForOptionHightConstraint.constant =  CGFloat(configOptionName.count) * 85
    }
    
    func getUniqueAttributes() ->  Set<AttributePair>{
        var attributeSet = Set<AttributePair>()
        self.childShoppingItems.keys.forEach{itemSet in
            itemSet.forEach{item in
                attributeSet.insert(item)
            }
        }
        return attributeSet
    }
    
    func selectActionForBtton(_ button:UIButton , posY : CGFloat){
        var selectedValueSet = Set<String>()
        var horizontalScrollView: UIScrollView = UIScrollView()
        let item = button.accessibilityIdentifier ?? ""
        horizontalScrollView = UIScrollView(frame: CGRect(x: 8, y: posY , width: 414, height: 45))
        if ((SelectedAttributeTextDict[item]) != nil){
            selectedValueSet = SelectedAttributeTextDict[item]!
        }
        
        let allValueSet = getUniqueAttributes().filter({$0.name.lowercased() == item.lowercased()})
        var posX:CGFloat = 0
        horizontalScrollView.tag = item.hashValue
        
        for identifier in allValueSet{
            let buttonView = UIButton()
            
            buttonView.tag = identifier.hashValue
            
            buttonView.frame = CGRect(x: posX, y: 0, width: 40, height: 40)
            buttonView.accessibilityIdentifier = "\(identifier.name),\(identifier.value)"
            if(item.lowercased() == "color"){
                let checkString = UIColor(name: identifier.value)
                buttonView.backgroundColor = checkString
            }else{
                buttonView.backgroundColor = UIColor.white
                let modLabel = " \(identifier.value) "
                let attributeName =  NSMutableAttributedString(string: modLabel)
                if ((SelectedAttributeTextDict[item]) != nil){
                    if !(selectedValueSet.contains(identifier.value)){
                        buttonView.isEnabled = false
                        attributeName.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeName.length))
                    }}
                buttonView.setAttributedTitle(attributeName, for: UIControl.State())
            }
            
            buttonView.setTitleColor(UIColor.black, for: UIControl.State())
            buttonView.titleLabel?.font = UIFont(name: "Lato", size: 15)
            buttonView.layer.borderColor = UIColor.gray.cgColor
            buttonView.layer.borderWidth = 2
            buttonView.sizeToFit()
            buttonView.addTarget(self, action: #selector(NewProductDetailePage.configurableOptionSelection(_:)), for: UIControl.Event.touchUpInside)
            horizontalScrollView.addSubview(buttonView)
            horizontalScrollView.contentSize.width = buttonView.frame.origin.x + buttonView.frame.width + 10
            posX = posX + buttonView.frame.width + 10
        }
        
        self.viewForOption.addSubview(horizontalScrollView)
    }
    
    @objc func configurableOptionSelection(_ button:UIButton){
        if self.shoppingItem?.type == "configurable" {
            let identifier = button.accessibilityIdentifier ?? ""
            let anchor = configOptionName.first
            let comp = (identifier.components(separatedBy: ",")) as NSArray
            let key = comp[0] as? String ?? ""
            if key == anchor {
                selectedAttributes = [:]
                tempSet.removeAll()
            }
            selectedAttributes[key]  = comp[1] as? String
            let foundDict = filteredItems(selectedAttributes, products: configAttributeArr)
            self.reloadAttributes(foundDict)
            for (_ , value) in selectedAttributes{
                tempSet.insert(value)
            }
            updateAttributeUI(key)
        }
    }
    
    func reloadAttributes(_ assoc : [NSDictionary]){
        SelectedAttributeTextDict.removeAll()
        for item in configOptionName{
            SelectedAttributeTextDict[item] = Set<String>()
        }
        
        for num in 0..<assoc.count{
            let dict = assoc[num]
            for(_ , index) in dict{
                if let indexDict = index as? NSDictionary{
                    let data = indexDict["data"] as? NSDictionary ?? [:]
                    for (key , item) in data{
                        let attributeName = key as? String ?? ""
                        if let itemDict = item as? NSDictionary{
                            let attributeVal = itemDict["label"] as? String ?? ""
                            var tempSet = SelectedAttributeTextDict[attributeName]
                            tempSet?.insert(attributeVal)
                            SelectedAttributeTextDict[attributeName] = tempSet
                        }
                    }
                }
            }
        }
    }
    
    func updateAttributeUI(_ key : String){
        let attirbueSet =  getUniqueAttributes().filter({$0.name.lowercased() == key.lowercased()})
        
        for identifier in attirbueSet {
                let buttonView:UIButton = viewForOption.viewWithTag(identifier.hashValue) as! UIButton
                if tempSet.contains(identifier.value){
                    buttonView.isSelected = true
                    buttonView.layer.borderColor = UIColor(red: (223/255.0), green: (114/255.0), blue: (114/255.0), alpha: 1.0).cgColor
                }
                else{
                    buttonView.isSelected = false
                    buttonView.layer.borderColor = UIColor.gray.cgColor
                }
                
                if(identifier.name == configOptionName[0])  || identifier.name == key{
                    continue
                }
                else{
                    let buttonView:UIButton = viewForOption.viewWithTag(identifier.hashValue) as! UIButton
                    buttonView.backgroundColor = UIColor.white
                    let modLabel = " \(identifier.value) "
                    let attributeName =  NSMutableAttributedString(string: modLabel)
                    if ((SelectedAttributeTextDict[identifier.name]) != nil){
                        if !(SelectedAttributeTextDict[identifier.name]!.contains(identifier.value)){
                            buttonView.isEnabled = false
                            attributeName.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeName.length))
                        }else{
                            buttonView.isEnabled = true
                        }
                    }
                    buttonView.setAttributedTitle(attributeName, for: UIControl.State())
                }
            }
        
        tempSet.removeAll()
        
    }
    
    func filteredItems(_ filters:[String:String], products:[NSDictionary]) -> [NSDictionary] {
        let filteredProducts = products.filter { (dict) -> Bool in
            var isContained = true
            for (key, value) in filters {
                let object = dict.allValues.first as? NSDictionary ?? [:]
                let data = object["data"] as? NSDictionary ?? [:]
                let attribute = data[key] as? NSDictionary ?? [:]
                if let keyString = attribute["label"] as? String {
                    if (keyString) != value {
                        isContained = false
                        return isContained
                    }
                }
            }
            return isContained
        }
        return filteredProducts
    }
    func productDescription(_ des: String, item : ShoppingItem, stock:Bool,type:String){
        specialPriceLbl.text = item.priceStr
        if item.isShowSpecialPrice(){
            
            var basePrice = ""
            if item.originalPriceStr != nil {
                basePrice =  "Price  " + item.originalPriceStr!
                
                let linkTextWithColor = "Price  "
                let range1 = (basePrice as NSString).range(of: linkTextWithColor)
                let attributePrice =  NSMutableAttributedString(string: basePrice)
                let range = (basePrice as NSString).range(of: item.originalPriceStr!)
                attributePrice.addAttribute( NSAttributedString.Key.foregroundColor, value:  UIColor(red: 90/255, green: 90/255, blue: 90/255, alpha: 1.0) , range: range1)
                attributePrice.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: range)
                basePriceLbl.attributedText =   attributePrice
            }
        }
        
        if(item.price < item.originalPrice)
        {
            var percent = 0.0
            percent = ((item.originalPrice - item.price ) / item.originalPrice) * 100
            let offvalue:Int = Int(percent)
            let sel = "Selling by price".localized()
            let of = "% off".localized()
            getDiscountPercentLbl.text = sel + " \(offvalue) " + of
        }
            
        else{
            getDiscountHeightConstraint.constant = 0
            getDiscountPercentLbl.isHidden = true
            viewForLabel.constant = viewForLabels.frame.height - (getDiscountPercentLbl.frame.height + basePriceLbl.frame.height)
        }
        let len = des.count
        DispatchQueue.main.async(
            execute: {
                self.descriptionText.text =  des
                self.descriptionText.sizeToFit()
        })
        
        descriptionText.isUserInteractionEnabled = false
        let numLines : Int = Int (descriptionText.contentSize.height / descriptionText.font!.lineHeight );
        if(numLines <= 5){
            textViewHightConstant.constant = descriptionText.contentSize.height-5
            readMoreHeightConstraint.constant = 0
            readMore.isHidden = true
        }
        else{
            readMore.isHidden = true
        }
        if(len == 0){
            descriptionText.text = "No Description Provided".localized()
        }
        if(titlesArray.count <= 0){
            if(shortdes == nil || shortdes == ""){
                additionalInfoButton.isHidden = true
                addToCartButton.frame.origin.y = additionalInfoButton.frame.origin.y
            }
        }
    }
    
    func removeHTmltag(_ descString: NSString) -> String{
        let htmlStringData = descString.data(using: String.Encoding.utf8.rawValue)!
        let attributedHTMLString = try! NSAttributedString(data: htmlStringData, options: [.documentType : NSAttributedString.DocumentType.html,  .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        
        let descriptionAttributedString = attributedHTMLString.string
        
        return descriptionAttributedString
    }
    
    @IBAction func buyNowBtton(_ sender: AnyObject) {
        
        let cart : ShoppingCart = ShoppingCart.Instance
        let TotalCount =  cart.getTotalCount()
        
        if(TotalCount>0){
            for (item, _) in cart {
                
                let inCartItem : ShoppingItem = item
                let item = self.shoppingItem!
                if ((((inCartItem.type == "configurable")||(inCartItem.type == "simple")) && ((item.type == "configurable")||(item.type == "simple")))||((inCartItem.type == "downloadable") && (item.type == "downloadable"))){
                    
                    //***********************PC***************
                    
                    if(hasCustomOption){
                        customOptionPriceButtonAction(sender as! UIButton)
                        let msg = self.getMessage()
                        if msg.isEmpty{
                            AddItemInCart(sender as! UIButton)
                        }
                    }else{
                        AddItemInCart(sender as! UIButton)
                    }
                    
                    //**************************************
                    
                }else{
                    self.alert("Please complete this order before ordering other items".localized())
                }
                break;
            }
        }else{
            //***********************PC***************
            
            if(hasCustomOption){
                customOptionPriceButtonAction(sender as! UIButton)
                let msg = self.getMessage()
                if msg.isEmpty{
                    AddItemInCart(sender as! UIButton)
                }
            }else{
                AddItemInCart(sender as! UIButton)
            }
            
            //***********************PC***************
        }
    }
    
    
    
    func AddItemInCart(_ button : UIButton) {
        
        backButton.isEnabled = false
        if(  shoppingItem?.type == "downloadable")
        {
            if(customOptionSelected == true){
                download_link_list.setObject(UserDefaults.standard.object(forKey: "down_link_options") as! NSArray, forKey: shoppingItem!.name as NSCopying)
                if self.shoppingItem?.numInStock <= 0 {
                    self.alert("Quantity Out of Stock".localized())
                    return
                    
                }
                
                assert(self.shoppingItem != nil)
                let item = self.shoppingItem!
                
                var previousShoppingItem : ShoppingItem? = nil
                previousShoppingItem = ShoppingCart.Instance.findItemByHash(item.hashValue)
                if previousShoppingItem != nil{
                    backButton.isEnabled = true
                    self.alert("Product is already added in cart".localized())
                    
                }else{
                    if button.tag == 10{
                        Utils.addItemInCartWithSync(item, count: 1, isfromByNow: true, controller: self)
                    }else{
                        Utils.addItemInCartWithSync(item, count: 1, isfromByNow: false, controller: self)
                    }
                }
            }else{
                backButton.isEnabled = true
                self.alert("Please Select Options to continue".localized())
                return
            }
        }else{
            if self.shoppingItem?.type == "configurable" {
                backButton.isEnabled = true
                if selectedAttributes.count != configOptionName.count
                {
                    self.alert("Please Select All Options To Add into Cart")
                    return
                }
            }
            
            assert(self.shoppingItem != nil)
            let item = self.shoppingItem!
            let cartItem : ShoppingItem! = ShoppingItem(id: item.id, name: item.name, sku: item.sku, price:String(item.originalPrice), specialPrice:String(item.price) , inStock:item.inStock, image:item.image , type:item.type , img1:item.smallImg)
            cartItem.numInStock = item.numInStock
            if self.shoppingItem?.type == "configurable"{
                var identifierSet = Set<AttributePair>()
                for(key, value) in selectedAttributes{
                    let identifier = AttributePair(name: key, value: value)
                    identifierSet.insert(identifier)
                }
                
                if let selectedItem = self.FindItem(identifier: identifierSet){
                    cartItem.sku = item.sku
                    cartItem.id = selectedItem.id
                    cartItem.numInStock = selectedItem.numInStock
                    cartItem.inStock = selectedItem.inStock
                }
                var name = ""
                let dict = selectedAttributes
                for (_ , value) in dict{
                    let val = value
                    name = name + val + " ,"
                }
                
                let choppedString = String(name.dropLast())
                cartItem.attributeString = choppedString
            }
            
            //*************************PC************************
            
            if (hasCustomOption){
                
                if let customItem = CustomShoppingItem(item: self.shoppingItem!, customOptionsSet: self.optionSet){
                    if let oldItem = ShoppingCart.Instance.findItemByHash(customItem.hashValue){
                        if button.tag == 10{
                            Utils.addItemInCartWithSync(oldItem, count: 1, isfromByNow: true, controller: self)
                        }else{
                            Utils.addItemInCartWithSync(oldItem, count: 1, isfromByNow: false, controller: self)
                        }
                        
                    }else{
                        
                        if button.tag == 10
                        {
                            Utils.addItemInCartWithSync(customItem, count: 1, isfromByNow: true, controller: self)
                        }
                        else
                        {
                            ///self.AddImagetocartWithAnimation(itemImageView)
                            Utils.addItemInCartWithSync(customItem, count: 1, isfromByNow: false, controller: self)
                        }
                    }
                }
            }
                
                //****************************************************
            else{
                backButton.isEnabled = true
                if cartItem != nil{
                    if button.tag == 10
                    {
                        Utils.addItemInCartWithSync(cartItem, count: 1, isfromByNow: true, controller: self)
                    }
                    else
                    {
                        ///self.AddImagetocartWithAnimation(itemImageView)
                        Utils.addItemInCartWithSync(cartItem, count: 1, isfromByNow: false, controller: self)
                    }
                }
                
            }
        }
    }
    func FindItem(identifier : Set<AttributePair>) -> ShoppingItem?{
        return self.childShoppingItems[identifier]
    }
    
    @objc func customOptionPriceButtonAction(_ button: UIButton){
        let msg = self.getMessage()
        if msg.isEmpty{
            var prices = self.shoppingItem?.priceStr ?? ""
            let allSelected = self.getSelectedOptions()
            self.priceLabel.numberOfLines = 3
            for option in allSelected{
                if Utils.StringToDouble(option.price) > 0.0{
                    prices += " + " + Utils.appendWithCurrencySymStr(option.price)
                }
            }
            for item in self.optionSet{
                if let text = item.textBox?.text{
                    if text.count > 0 && item.priceStr != nil{
                        if Utils.StringToDouble(item.priceStr ?? "") > 0.0{
                            prices += " + " + Utils.appendWithCurrencySymStr(item.priceStr ?? "")
                        }
                    }
                }
            }
            
            let customItem = CustomShoppingItem(item: self.shoppingItem!, customOptionsSet: self.optionSet)
            self.priceLabel.text = prices
            if let item = customItem{
                if prices != item.priceStr{
                    self.priceLabel.font = UIFont(name: "HelveticaNeue", size: 12)
                    self.priceLabel.text = prices + " = " + item.priceStr
                    self.priceValue.text = item.priceStr
                }
            }
            customOptionSelected = true
        }else{
            self.alert(msg)
        }
    }
    func getSelectedOptions()->[CustomOption]{
        var allSelected = [CustomOption]()
        
        for item in self.optionSet{
            let selectedOption = item.options.filter({$0.selected == true})
            allSelected += selectedOption
        }
        
        return allSelected
    }
    func populateData(_ dataDict: NSDictionary){
        defer{self.removeLoader()}
        
        if let customOptions = dataDict["custom_option"] as? NSArray{
            if let quantity = dataDict["quantity"] as? String{
                self.shoppingItem?.numInStock = Int(Utils.StringToDouble(quantity))
            }
            for item in customOptions{
                var optionList = [CustomOption]()
                if let itemDict = item as? NSDictionary{
                    let optionId = itemDict["custom_option_id"] as? String
                    let name = itemDict["custom_option_name"] as? String
                    let type = itemDict["custom_option_type"] as? String
                    let isRequired = itemDict["custom_option_is_required"] as? String
                    
                    if let options = itemDict["custom_option_value_array"] as? NSArray{
                        for optionItem in options{
                            if let optionDict = optionItem as? NSDictionary{
                                let id  = optionDict["id"] as? String
                                let price = optionDict["price"] as? String
                                let priceType = optionDict["price_type"] as? String
                                let sku = optionDict["sku"] as? String
                                let sortOrder = optionDict["sort_order"] as? String
                                let title = optionDict["title"] as? String
                                if id != nil && price != nil && title != nil{
                                    let option = CustomOption(id: id!, price: price!, priceType: priceType, sku: sku, sortOrder: sortOrder, title: title!)
                                    optionList.append(option)
                                }
                            }
                        }
                    }
                    if optionId != nil && name != nil && type != nil && isRequired != nil{
                        let bRequired = isRequired! == "1" ? true : false
                        let customSet = CustomOptionSet(id: optionId!, name: name!, type: type!, isRequired: bRequired, options: optionList)
                        
                        if let all = itemDict["all"] as? NSDictionary{
                            if let maxChar = all["max_characters"] as? String{
                                if let maxCharVal = Int(maxChar){
                                    customSet.maxChars = maxCharVal
                                }
                            }
                            if let priceStr = all["price"] as? String{
                                if let priceVal = Int(priceStr){
                                    customSet.priceStr = Utils.DoubleToString(Double(priceVal))
                                }
                            }
                        }
                        
                        self.optionSet.append(customSet)
                    }
                }
            }
        }
        else{
            
            createDownlaodableDataView(dataDict)
            return
        }
        
        
        createCustomOptionsTable()
        
    }
    
    
    func createDownlaodableDataView(_ dataDict: NSDictionary){
        
        if let downloadOptions = dataDict["downloadable_pro_data"] as? NSDictionary{
            if let quantity = dataDict["quantity"] as? String{
                self.shoppingItem?.numInStock = Int(Utils.StringToDouble(quantity))
                
                var optionList = [CustomOption]()
                let title = downloadOptions["links_title"] as? String
                if let linkexist = downloadOptions["links_exist"] as? String{
                    
                    
                    if(linkexist == "1")
                    {
                        
                        if let dataArray  = downloadOptions["links_data"] as? NSArray{
                            
                            for item in dataArray{
                                if let itemDict = item as? NSDictionary{
                                    let link_id = itemDict["link_id"] as? String
                                    var url = itemDict["link_url"] as? String
                                    let link_title = itemDict["title"] as? String ?? ""
                                    if(url == nil){
                                        url = ""
                                    }
                                    
                                    let option = CustomOption(id: link_id!, price: url!, priceType: "", sku: "", sortOrder: nil, title: link_title)
                                    optionList.append(option)
                                }
                                // print(optionList)
                            } // end of for loop item array
                            if(title != nil){
                                let customSet = CustomOptionSet(id: "", name: title!, type: "checkbox", isRequired: true, options : optionList)
                                self.optionSet.append(customSet)
                            }
                            else{
                                let customSet = CustomOptionSet(id: "", name: "", type: "checkbox", isRequired: true, options : optionList)
                                self.optionSet.append(customSet)
                            }
                            
                        } // end of if dataArray
                        
                        
                    } // end of if links exist
                    
                }// ends of if title linkss purchase links exist
                
                
            } // end of inner if
        } // end of the main if
        
        createDownlodableOptionTable()
        
        
    } // end of the funcction
    
    func createDownlodableOptionTable(){
        viewForOptionHightConstraint.constant = 100
        titleParentView.isHidden = true
        
        customTableListParentView.frame = CGRect(x: 15, y: titleParentView.frame.origin.y + 20, width: contentView.frame.width - 30, height: 120)
        
        var posy = 0
        for item in self.optionSet{
            if self.supportedOptions.firstIndex(of: item.type) != nil{
                let singleParentView = UIView()
                singleParentView.frame = CGRect(x: 0, y: CGFloat(posy), width: customTableListParentView.frame.size.width, height: 120)
                // singleParentView.backgroundColor = UIColor.lightGrayColor()
                let label1 = UILabel(frame: CGRect(x: 20, y: 0, width: singleParentView.frame.size.width-40, height: 50))
                label1.text = item.name
                label1.textAlignment = .left
                label1.textColor = UIColor(red: 98/255.0, green: 98/255.0, blue: 98/255.0, alpha: 1.0)
                singleParentView.addSubview(label1)
                
                
                if(item.type == "checkbox" || item.type == "multiple"){
                    var Pos_y_check = 0
                    let customCheckBoxParentScrollView = UIScrollView()
                    customCheckBoxParentScrollView.frame = CGRect(x: 0, y: label1.frame.size.height + label1.frame.origin.y, width: singleParentView.frame.size.width, height: 50)
                    
                    for option in item.options{
                        let customCheckboxbuttonView = CheckBoxButton()
                        customCheckboxbuttonView.tag = option.id.hashValue
                        customCheckboxbuttonView.frame = CGRect(x: 20, y: CGFloat(Pos_y_check), width: customCheckBoxParentScrollView.frame.size.width - 40, height: 25)
                        customCheckboxbuttonView.addTarget(self, action: #selector(NewProductDetailePage.downloadableCheckboxbuttonAction(_:)), for: UIControl.Event.touchUpInside)
                        
                        customCheckboxbuttonView.setTitleColor(UIColor.black, for: UIControl.State())
                        customCheckboxbuttonView.titleLabel?.font = UIFont(name: "Lato", size: 15)
                        customCheckboxbuttonView.setTitle(option.titleWithPrice(), for: UIControl.State())
                        customCheckboxbuttonView.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
                        customCheckboxbuttonView.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
                        
                        customCheckboxbuttonView.backgroundColor = UIColor(red: 236/255.0, green: 236/255.0, blue: 236/255.0, alpha: 1.0)
                        
                        customCheckBoxParentScrollView.addSubview(customCheckboxbuttonView)
                        
                        customCheckBoxParentScrollView.frame.size.height = customCheckboxbuttonView.frame.origin.y + customCheckboxbuttonView.frame.size.height + 10
                        
                        
                        Pos_y_check = Pos_y_check + Int(customCheckboxbuttonView.frame.size.height)
                    }
                    
                    customCheckBoxParentScrollView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
                    //  customCheckBoxParentScrollView.layer.borderWidth = 0.5
                    // singleParentView.frame.size.height = customCheckBoxParentScrollView.frame.size.height
                    singleParentView.addSubview(customCheckBoxParentScrollView)
                    
                    
                }else if(item.type == "radio"){
                    var Pos_y_radio = 5
                    let customRadioParentScrollView = UIScrollView()
                    customRadioParentScrollView.frame = CGRect(x: label1.frame.size.width + label1.frame.origin.x, y: 0, width: singleParentView.frame.size.width, height: singleParentView.frame.size.height)
                    
                    customRadioParentScrollView.tag = item.id.hashValue
                    
                    for option in item.options{
                        let customradiobuttonView = RadioButton()
                        customradiobuttonView.tag = option.id.hashValue
                        customradiobuttonView.frame = CGRect(x: 20, y: CGFloat(Pos_y_radio), width: customRadioParentScrollView.frame.size.width - 40, height: 35)
                        customradiobuttonView.addTarget(self, action: #selector(NewProductDetailePage.customradiobuttonView(_:)), for: UIControl.Event.touchUpInside)
                        
                        customradiobuttonView.setTitleColor(UIColor.white, for: UIControl.State())
                        customradiobuttonView.titleLabel?.font = UIFont(name: "Lato", size: 15)
                        customradiobuttonView.setTitle(option.titleWithPrice(), for: UIControl.State())
                        customradiobuttonView.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
                        customradiobuttonView.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
                        
                        customradiobuttonView.backgroundColor = UIColor(red: 236/255.0, green: 236/255.0, blue: 236/255.0, alpha: 1.0)
                        
                        customRadioParentScrollView.addSubview(customradiobuttonView)
                        
                        customRadioParentScrollView.frame.size.height = customradiobuttonView.frame.origin.y + customradiobuttonView.frame.size.height + 5
                        
                        
                        Pos_y_radio = Pos_y_radio + Int(customradiobuttonView.frame.size.height)+5
                        
                    }
                    
                    customRadioParentScrollView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
                    customRadioParentScrollView.layer.borderWidth = 0.5
                    //singleParentView.frame.size.height = customRadioParentScrollView.frame.size.height
                    singleParentView.addSubview(customRadioParentScrollView)
                    
                }
                    
                else if(item.type == "field" || item.type == "area"){
                    let textfieldParentView = UIView(frame: CGRect(x: label1.frame.size.width + label1.frame.origin.x, y: 0, width: singleParentView.frame.size.width, height: singleParentView.frame.size.height))
                    let textBox1 = UITextField(frame: CGRect(x: 10, y: 5, width: textfieldParentView.frame.size.width - 20, height: textfieldParentView.frame.size.height - 10))
                    textfieldParentView.tag = item.maxChars
                    let spaceLabel1 = UILabel()
                    spaceLabel1.frame = CGRect(x: 10, y: 0, width: 7, height: 26)
                    spaceLabel1.backgroundColor = UIColor.clear
                    textBox1.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
                    textBox1.layer.borderWidth = 2
                    textBox1.font = UIFont(name: "Lato", size: 17)
                    textBox1.textColor = UIColor.black
                    textBox1.backgroundColor = UIColor.white
                    textBox1.layer.cornerRadius = 2
                    textBox1.placeholder = "Enter"
                    textBox1.leftView = spaceLabel1
                    textBox1.leftViewMode = UITextField.ViewMode.always
                    textBox1.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
                    textBox1.delegate = self
                    item.textBox = textBox1
                    
                    textfieldParentView.addSubview(textBox1)
                    textfieldParentView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
                    textfieldParentView.layer.borderWidth = 0.5
                    singleParentView.addSubview(textfieldParentView)
                }
                
                // label1.frame.size.height = singleParentView.frame.size.height
                singleParentView.layer.borderWidth = 2
                singleParentView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
                customTableListParentView.addSubview(singleParentView)
                
                posy = posy + Int(singleParentView.frame.size.height)
            }
        }
        
        let singleParentView = UIView()
        singleParentView.frame = CGRect(x: 0, y: CGFloat(posy), width: 0, height: 50)
        
        self.priceLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.priceLabel.text = self.shoppingItem?.priceStr
        self.priceLabel.textAlignment = .center;
        self.priceLabel.textColor = UIColor.black
        priceLabel.isHidden = true
        let customPriceParentView = UIView(frame: CGRect(x: self.priceLabel.frame.size.width + self.priceLabel.frame.origin.x, y: 0, width: 0, height: singleParentView.frame.size.height))
        
        let customOptionPriceButton = UIButton()
        customOptionPriceButton.frame = CGRect(x: 20, y: 5, width: customPriceParentView.frame.size.width - 40, height: customPriceParentView.frame.size.height - 10)
        customOptionPriceButton.addTarget(self, action: #selector(NewProductDetailePage.customOptionPriceButtonAction(_:)), for: UIControl.Event.touchUpInside)
        
        customOptionPriceButton.backgroundColor = UIColor(red: (223/255.0), green: (114/255.0), blue: (114/255.0), alpha: 1.0)
        customOptionPriceButton.layer.cornerRadius = 3.0
        customOptionPriceButton.setTitle("get_price".localized(), for: UIControl.State())
        customOptionPriceButton.titleLabel?.font = UIFont(name: "Lato", size: 17)
        customOptionPriceButton.titleLabel?.textColor = UIColor.white
        
        customOptionPriceButton.isHidden = true
        
        customPriceParentView.addSubview(customOptionPriceButton)
        customPriceParentView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
        customPriceParentView.layer.borderWidth = 0.5
        
        customPriceParentView.frame.size.height = customOptionPriceButton.frame.origin.y + customOptionPriceButton.frame.size.height + 5
        //  singleParentView.addSubview(customPriceParentView)  //edited by Gauhar
        
        
        singleParentView.frame.size.height = customPriceParentView.frame.size.height
        
        
        self.priceLabel.frame.size.height = singleParentView.frame.size.height
        // singleParentView.layer.borderWidth = 0.5
        singleParentView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
        //customTableListParentView.addSubview(singleParentView) //edited by gauhar
        
        posy = posy + Int(singleParentView.frame.size.height)
        //  customTableListParentView.frame.size.height = CGFloat(posy) + 10
        viewForOption.addSubview(customTableListParentView)
        viewForOptionHightConstraint.constant = customTableListParentView.frame .height + 40
        
    }
    
    
    
    
    func createCustomOptionsTable(){
        
        let detailsTitleLabel = UILabel()
        
        detailsTitleLabel.frame = CGRect(x: 15 ,y: 0 , width: contentView.frame.width - 30 ,height: 24)
        detailsTitleLabel.text = "Product Options".localized()
        detailsTitleLabel.font = UIFont(name: "Lato", size: 18)
        detailsTitleLabel.textColor = UIColor(netHex:0x636363)
        if idForSelectedLangauge == Utils.getArebicLanguageCode() {
            detailsTitleLabel.textAlignment = .right
        }
        self.viewForOption.addSubview(detailsTitleLabel)
        
        customTableListParentView.frame = CGRect(x: 15, y: detailsTitleLabel.frame.origin.y + detailsTitleLabel.frame.height + 20, width: contentView.frame.width - 30, height: 150)
        var posy = 0
        for item in self.optionSet{
            if self.supportedOptions.firstIndex(of: item.type) != nil{
                let singleParentView = UIView()
                singleParentView.layer.borderWidth = 0.5
                singleParentView.layer.borderColor = UIColor(netHex:0xd9d9d9).cgColor
                
                singleParentView.frame = CGRect(x: 0, y: CGFloat(posy), width: customTableListParentView.frame.size.width, height: 37)
                
                
                
                let label1 = UILabel(frame: CGRect(x: 8, y: 0, width: singleParentView.frame.size.width/2 - 20, height: 37))
                
                label1.text = item.name
                
                if item.isRequired{
                    
                    label1.text = item.name + "*"
                    
                }
                
                label1.textAlignment = .left;
                label1.textColor = UIColor(netHex:0x636363)
                
                singleParentView.addSubview(label1)
                
                if(item.type == "drop_down"){
                    
                    
                    
                    //Change x of dropdownParentView
                    
                    let dropdownParentView = UIView(frame: CGRect(x: label1.frame.origin.x, y: label1.frame.origin.y  + label1.frame.size.height + 5, width: singleParentView.frame.size.width - 20, height : singleParentView.frame.size.height))
                    
                    let customOptionDropdownButton = UIButton()
                    customOptionDropdownButton.tag = item.id.hashValue
                    customOptionDropdownButton.frame = CGRect(x: 0, y: 0, width: dropdownParentView.frame.size.width , height: singleParentView.frame.size.height)
                    customOptionDropdownButton.addTarget(self, action: #selector(NewProductDetailePage.simpleProductCustomDropDown(_:)), for: UIControl.Event.touchUpInside)
                    
                    customOptionDropdownButton.setTitle("--Please select--".localized(), for: UIControl.State())
                    customOptionDropdownButton.contentHorizontalAlignment = .center
                    customOptionDropdownButton.contentVerticalAlignment = .center
                    customOptionDropdownButton.titleLabel?.font = UIFont(name: "Lato", size: 14)
                    customOptionDropdownButton.setTitleColor(UIColor(netHex:0x636363), for: UIControl.State())
                    customOptionDropdownButton.layer.cornerRadius = 4
                    dropdownParentView.layer.cornerRadius = 4
                    dropdownParentView.addSubview(customOptionDropdownButton)
                    dropdownParentView.layer.borderColor = UIColor(netHex:0xd9d9d9).cgColor
                    dropdownParentView.layer.borderWidth = 2
                    singleParentView.frame.size.height = dropdownParentView.frame.origin.y + dropdownParentView.frame.size.height + 8
                    singleParentView.addSubview(dropdownParentView)
                    singleParentView.layer.borderWidth = 0.5
                    singleParentView.layer.borderColor = UIColor(netHex:0xd9d9d9).cgColor
                }else if(item.type == "checkbox" || item.type == "multiple"){
                    var Pos_y_check = 5
                    let customCheckBoxParentScrollView = UIScrollView()
                    customCheckBoxParentScrollView.frame = CGRect(x: label1.frame.size.width + label1.frame.origin.x, y: 0, width: singleParentView.frame.size.width/2, height: singleParentView.frame.size.height)
                    
                    for option in item.options{
                        let customCheckboxbuttonView = CheckBoxButton()
                        customCheckboxbuttonView.tag = option.id.hashValue
                        customCheckboxbuttonView.frame = CGRect(x: 20, y: CGFloat(Pos_y_check), width: customCheckBoxParentScrollView.frame.size.width - 20, height: 35)
                        customCheckboxbuttonView.addTarget(self, action: #selector(NewProductDetailePage.customCheckboxbuttonAction(_:)), for: UIControl.Event.touchUpInside)
                        
                        customCheckboxbuttonView.setTitleColor(UIColor(netHex:0x636363), for: UIControl.State())
                        customCheckboxbuttonView.titleLabel?.font = UIFont(name: "Lato", size: 15)
                        customCheckboxbuttonView.setTitle(option.titleWithPrice(), for: UIControl.State())
                        customCheckboxbuttonView.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
                        customCheckboxbuttonView.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
                        
                        customCheckboxbuttonView.backgroundColor = UIColor.white
                        customCheckboxbuttonView.layer.cornerRadius = 3
                        
                        customCheckboxbuttonView.layer.borderColor = UIColor(netHex:0xd9d9d9).cgColor
                        customCheckboxbuttonView.layer.borderWidth = 2
                        
                        customCheckBoxParentScrollView.addSubview(customCheckboxbuttonView)
                        
                        customCheckBoxParentScrollView.frame.size.height = customCheckboxbuttonView.frame.origin.y + customCheckboxbuttonView.frame.size.height + 5
                        
                        
                        Pos_y_check = Pos_y_check + Int(customCheckboxbuttonView.frame.size.height)+5
                    }
                    
                    customCheckBoxParentScrollView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
                    customCheckBoxParentScrollView.layer.borderWidth = 0.5
                    singleParentView.frame.size.height = customCheckBoxParentScrollView.frame.size.height
                    singleParentView.addSubview(customCheckBoxParentScrollView)
                    
                    
                }
                else if(item.type == "radio"){
                    var Pos_y_radio = 5
                    let customRadioParentScrollView = UIScrollView()
                    customRadioParentScrollView.frame = CGRect(x: label1.frame.size.width + label1.frame.origin.x, y: 0, width: singleParentView.frame.size.width/2, height: singleParentView.frame.size.height)
                    
                    customRadioParentScrollView.tag = item.id.hashValue
                    
                    for option in item.options{
                        let customradiobuttonView = RadioButton()
                        customradiobuttonView.tag = option.id.hashValue
                        customradiobuttonView.frame = CGRect(x: 20, y: CGFloat(Pos_y_radio), width: customRadioParentScrollView.frame.size.width - 20, height: 35)
                        customradiobuttonView.addTarget(self, action: #selector(NewProductDetailePage.customradiobuttonView(_:)), for: UIControl.Event.touchUpInside)
                        
                        customradiobuttonView.setTitleColor(UIColor(netHex:0x636363), for: UIControl.State())
                        customradiobuttonView.titleLabel?.font = UIFont(name: "Lato", size: 15)
                        customradiobuttonView.setTitle(option.titleWithPrice(), for: UIControl.State())
                        customradiobuttonView.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
                        customradiobuttonView.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
                        
                        customradiobuttonView.backgroundColor = UIColor.white
                        customradiobuttonView.layer.cornerRadius = 3
                        
                        customradiobuttonView.layer.borderColor = UIColor(netHex:0xd9d9d9).cgColor
                        customradiobuttonView.layer.borderWidth = 2
                        
                        customRadioParentScrollView.addSubview(customradiobuttonView)
                        
                        customRadioParentScrollView.frame.size.height = customradiobuttonView.frame.origin.y + customradiobuttonView.frame.size.height + 5
                        
                        
                        Pos_y_radio = Pos_y_radio + Int(customradiobuttonView.frame.size.height)+5
                        
                    }
                    
                    customRadioParentScrollView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
                    customRadioParentScrollView.layer.borderWidth = 0.5
                    singleParentView.frame.size.height = customRadioParentScrollView.frame.size.height
                    singleParentView.addSubview(customRadioParentScrollView)
                    
                }
                    
                else if(item.type == "field" || item.type == "area"){
                    if let priceStr = item.priceStr{
                        if let text = label1.text{
                            if Utils.StringToDouble(priceStr) > 0.0{
                                label1.text = text + " + " + Utils.appendWithCurrencySymStr(priceStr)
                            }
                        }
                    }
                    
                    let textfieldParentView = UIView(frame: CGRect(x: label1.frame.size.width + label1.frame.origin.x, y: 0, width: singleParentView.frame.size.width/2, height: singleParentView.frame.size.height))
                    let textBox1 = UITextField(frame: CGRect(x: 10, y: 5, width: textfieldParentView.frame.size.width - 10, height: textfieldParentView.frame.size.height - 10))
                    textfieldParentView.tag = item.maxChars
                    let spaceLabel1 = UILabel()
                    spaceLabel1.frame = CGRect(x: 10, y: 0, width: 7, height: 26)
                    spaceLabel1.backgroundColor = UIColor.clear
                    textBox1.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
                    textBox1.layer.borderWidth = 2
                    textBox1.font = UIFont(name: "Lato", size: 17)
                    textBox1.textColor = UIColor.black
                    textBox1.backgroundColor = UIColor.white
                    textBox1.layer.cornerRadius = 2
                    textBox1.placeholder = "Enter"
                    textBox1.leftView = spaceLabel1
                    textBox1.leftViewMode = UITextField.ViewMode.always
                    textBox1.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
                    //     textBox1.delegate = self
                    item.textBox = textBox1
                    
                    textfieldParentView.addSubview(textBox1)
                    textfieldParentView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
                    textfieldParentView.layer.borderWidth = 0.5
                    singleParentView.addSubview(textfieldParentView)
                }
                
                // label1.frame.size.height = singleParentView.frame.size.height
                
                singleParentView.layer.borderWidth = 0.5
                singleParentView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
                customTableListParentView.addSubview(singleParentView)
                
                posy = posy + Int(singleParentView.frame.size.height)
            }
        }
        
        let singleParentView = UIView()
        singleParentView.frame = CGRect(x: 0, y: CGFloat(posy), width: customTableListParentView.frame.size.width, height: 50)
        
        self.priceLabel = UILabel(frame: CGRect(x: 0, y: 0, width: singleParentView.frame.size.width - 20, height: singleParentView.frame.size.height))
        self.priceLabel.text = self.shoppingItem?.priceStr
        self.priceLabel.textAlignment = .center;
        self.priceLabel.textColor = UIColor.black
        singleParentView.addSubview(self.priceLabel)
        
        let customPriceParentView = UIView(frame: CGRect(x: self.priceLabel.frame.size.width + self.priceLabel.frame.origin.x, y: 0, width: 0, height: singleParentView.frame.size.height))
        
        let customOptionPriceButton = UIButton()
        customOptionPriceButton.frame = CGRect(x: 20, y: 5, width: 0, height: customPriceParentView.frame.size.height - 10)
        customOptionPriceButton.addTarget(self, action: #selector(NewProductDetailePage.customOptionPriceButtonAction(_:)), for: UIControl.Event.touchUpInside)
        //        let backgroundImg = UIImage(named: "background")
        //        customOptionPriceButton.setBackgroundImage(backgroundImg, forState: UIControlState.Normal)
        customOptionPriceButton.backgroundColor = UIColor(netHex:0x636363)
        customOptionPriceButton.layer.cornerRadius = 3.0
        customOptionPriceButton.setTitle("get_price".localized(), for: UIControl.State())
        customOptionPriceButton.titleLabel?.font = UIFont(name: "Lato", size: 17)
        customOptionPriceButton.titleLabel?.textColor = UIColor.white
        
        customPriceParentView.addSubview(customOptionPriceButton)
        customPriceParentView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
        customPriceParentView.layer.borderWidth = 0.5
        
        customPriceParentView.frame.size.height = customOptionPriceButton.frame.origin.y + customOptionPriceButton.frame.size.height + 5
        singleParentView.addSubview(customPriceParentView)
        
        
        singleParentView.frame.size.height = customPriceParentView.frame.size.height
        
        
        self.priceLabel.frame.size.height = singleParentView.frame.size.height
        singleParentView.layer.borderWidth = 0.5
        singleParentView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
        customTableListParentView.addSubview(singleParentView)
        
        posy = posy + Int(singleParentView.frame.size.height)
        customTableListParentView.frame.size.height = CGFloat(posy) + 10
        viewForOption.addSubview(customTableListParentView)
        
        
        viewForOptionHightConstraint.constant = customTableListParentView.frame.height + detailsTitleLabel.frame.height + 20
        
        mainScrollView.contentSize.height = contentView.frame.height + viewForOptionHightConstraint.constant
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text{
            if (range.length + range.location > text.count){
                return false;
            }
            
            let newLength = text.count + string.count - range.length
            
            return newLength <= textField.superview?.tag
        }
        
        return false
    }
    
    @objc func simpleProductCustomDropDown(_ button:UIButton){
        changeButton = button
        dropDownTableViewXPos =  customTableListParentView.frame.origin.x + button.superview!.superview!.frame.origin.x + button.superview!.frame.origin.x + button.frame.origin.x
        dropDownTableViewYPos =  customTableListParentView.frame.origin.y + button.superview!.superview!.frame.origin.y + button.superview!.frame.origin.y + button.frame.origin.y + button.frame.height - 3
        
        allDropDownButtonAction(button)
        
    }
    
    
    func findOption(_ idHashValue: Int)->CustomOption?{
        var option : CustomOption? = nil
        
        for item in self.optionSet{
            option = item.options.filter({$0.id.hashValue == idHashValue}).first
            if option != nil{
                break
            }
        }
        
        return option
    }
    @objc func customradiobuttonView(_ button: UIButton){
        //self.addToCartButtoni.enabled = false
        self.FlipButton(button as? FlipFlopButton)
        
        if let parentTag = button.superview?.tag{
            for item in self.optionSet{
                if item.id.hashValue == parentTag{
                    for option in item.options{
                        option.selected = false
                    }
                }
            }
        }
        let option = self.findOption(button.tag)
        option?.selected = button.isSelected
    }
    
    @objc func customCheckboxbuttonAction(_ button: UIButton){
        // self.addToCartButtoni.enabled = false
        button.isSelected = !button.isSelected;
        
        let option = self.findOption(button.tag)
        option?.selected = button.isSelected
    }
    
    @objc func downloadableCheckboxbuttonAction(_ button: UIButton){
        button.isSelected = !button.isSelected;
        let option = self.findOption(button.tag)
        option?.selected = button.isSelected
        
        if(button.isSelected == true){
            dic?.setObject(option?.id ?? "", forKey: "link_id" as NSCopying)
            dic?.setObject("link_name", forKey: "link_name" as NSCopying)
            arr?.add(dic ?? [:])
            dic = [:]
            count = count! + 1
        }else{
            customOptionSelected = false
            for item in arr!{
                let itemDict = item as? NSDictionary
                if(option!.id == itemDict!["link_id"] as? String ){
                    arr?.remove(item)
                }
            }
            count = count! - 1
        }
        
        customOptionSelected = count >= 1
        UserDefaults.standard.set(arr, forKey: "down_link_options")
    }
    
    func allDropDownButtonAction(_ button:UIButton){
        
        dropDownButtonTagValue = button.tag
        
        UIView.animate(withDuration: 0.2, animations: {
            self.changeButton.imageView!.transform = self.changeButton.imageView!.transform.rotated(by: 180 * CGFloat(Double.pi/180))
        }, completion: { _ in
        })
        
        
        if(dropDownBooleanValue == 0){
            customdropDownGestureView.removeFromSuperview()
            
            UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions(), animations: {
                self.dropDownTableView.frame.size.height = 0
            }, completion: { _ in
                self.dropDownTableView.isHidden = true
            })
            
            for allSubViews in self.view.subviews{
                allSubViews.isUserInteractionEnabled = true
            }
            
            navigationItem.titleView?.isUserInteractionEnabled = true
            dropDownBooleanValue = 1
        }else{
            customdropDownGestureView.frame.size.height = contentView.frame.height
            contentView.addSubview(customdropDownGestureView)
            
            var frm = dropDownTableView.frame
            frm.origin.x = dropDownTableViewXPos!
            let f  = contentView.convert((button.superview?.superview!.frame)!, from: viewForOption)
            
            frm.origin.y = f.origin.y + f.size.height
            frm.size.width = button.frame.width
            dropDownTableView.frame = frm
            
            contentView.addSubview(dropDownTableView)
            
            
            self.view.bringSubviewToFront(dropDownTableView)
            dropDownTableView.frame.origin.y = f.origin.y + f.size.height
            UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions(), animations: {
                if let options = self.getTableOptions(){
                    self.dropDownTableView.frame.size.height = CGFloat(options.count) * 40 + 15
                    if self.isTableOptionRequired(){
                        options.first?.selected = true
                        self.dropDownTableView.reloadData()
                    }
                }
                if(self.dropDownTableView.frame.size.height > 150){
                    self.dropDownTableView.frame.size.height = 150
                }
            }, completion: { _ in
                self.dropDownTableView.isHidden = false
            })
            
            dropDownTableView.reloadData()
            navigationItem.titleView?.isUserInteractionEnabled = false
            
            dropDownBooleanValue = 0
        }
    }
    
    func getTableOptions()->[CustomOption]?{
        let options = self.optionSet.filter({$0.id.hashValue == self.dropDownButtonTagValue}).first?.options
        
        return options
    }
    
    func isTableOptionRequired()->Bool{
        return self.optionSet.filter({$0.id.hashValue == self.dropDownButtonTagValue}).first?.isRequired ?? false
    }
    
    // MARK: TableView delegates method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == reviewTableView{
            return min(arrReviewData.count, 2)
        }else{
            if let options = self.getTableOptions(){
                return options.count
            }else{
                return 0
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == reviewTableView{
            let cell = reviewTableView.dequeueReusableCell(withIdentifier: "ReviewTableIdentifierCell", for: indexPath) as! ReviewTableViewCell
            let item = arrReviewData[indexPath.row]
            cell.productNameLbl.text = item.title
            cell.descriptionLbl.text = item.details
            cell.ratingControlView.rating = Int(item.value)!
            cell.nameAndDateLbl.text = "By : \(item.nickName)  |  \(Utils.getDateStringFromStringWithDateFormage(item.createDate as NSString))"
            UITableView_Auto_Height()
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DropDownCell", for: indexPath) as UITableViewCell
            
            let borderLabel = UILabel(frame: CGRect(x: 10, y: cell.frame.size.height - 1, width: cell.frame.size.width - 20, height: 1))
            borderLabel.backgroundColor = UIColor.white.withAlphaComponent(0.3)
            cell.addSubview(borderLabel)
            cell.backgroundColor = UIColor.darkGray
            cell.textLabel?.textColor = UIColor.white
            if let options = self.getTableOptions(){
                
                cell.textLabel?.text = options[indexPath.row].titleWithPrice()
            }
            cell.textLabel?.textAlignment = .center;
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView == reviewTableView ? UITableView.automaticDimension : 40
    }
    
    func UITableView_Auto_Height(){
        DispatchQueue.main.async {
            var frame: CGRect = self.reviewTableView.frame;
            frame.size.height = self.reviewTableView.contentSize.height;
            self.reviewTableView.frame = frame;
            self.reviewTableViewHeightConstraint.constant = self.reviewTableView.contentSize.height
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let options = self.getTableOptions(){
            changeButton.setTitle(options[indexPath.row].titleWithPrice(), for: UIControl.State())
            for option in options{
                option.selected = false
            }
            options[indexPath.row].selected = true
        }
        
        dropDownGesturebuttonAction()
        
    }
    
    @objc func dropDownGesturebuttonAction(){
        dropDownBooleanValue = 0
        let btn = UIButton()
        btn.tag = dropDownButtonTagValue
        allDropDownButtonAction(btn)
    }
    
    func simpleCustomOptions(){
        titleParentView.frame = CGRect(x: additionalInfoButton.frame.origin.x, y: additionalInfoButton.frame.origin.y + additionalInfoButton.frame.height, width: additionalInfoButton.frame.width, height: additionalInfoButton.frame.height)
        
        titileLabel = Utils.createTitleLabel(titleParentView,yposition: 15)
        titileLabel.font = UIFont(name: "Lato", size: 20)
        titileLabel.text = productTitle
        titileLabel.numberOfLines = 2
        titileLabel.sizeToFit()
        titleParentView.addSubview(titileLabel)
        
        contentView.addSubview(titleParentView)
        
        let firstBorder = UILabel(frame: CGRect(x: 0, y: titleParentView.frame.height - 2, width: titleParentView.frame.width, height: 1))
        firstBorder.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
        titleParentView.addSubview(firstBorder)
        
        dropDownTableView.delegate =   self
        dropDownTableView.dataSource =   self
        dropDownTableView.register(UITableViewCell.self, forCellReuseIdentifier: "DropDownCell")
        dropDownTableView.frame = CGRect(x: 20, y: 0, width: 0, height: 0)
        dropDownTableView.scrollsToTop = true
        dropDownTableView.separatorStyle = .none
        dropDownTableView.backgroundColor = UIColor.darkGray
        
        contentView.addSubview(dropDownTableView)
        
        self.loadProducssst()
        
        addToCartButton.isHidden = true
    }
    
    func loadProducssst(){
        if let item = self.shoppingItem{
            self.addLoader()
            
            let url = WebApiManager.Instance.getDescUrl(item.id, type: item.type)
            Utils.fillTheData(url, callback: self.populateData, errorCallback : self.showError)
        }
    }
    
    func getMessage()->String{
        var requiredOptions : [String] = [String]()
        for item in self.optionSet{
            if self.supportedOptions.firstIndex(of: item.type) != nil{
                if item.isRequired{
                    let selectedOption = item.options.filter({$0.selected == true})
                    
                    if item.textBox == nil{
                        if selectedOption.count == 0 {
                            requiredOptions.append(item.name)
                        }
                    }else{
                        if item.textBox?.text?.count == 0{
                            requiredOptions.append(item.name)
                        }
                    }
                }
            }
        }
        
        var msg = ""
        if requiredOptions.count > 0{
            for (index, name) in requiredOptions.enumerated(){
                msg += name
                
                if index < requiredOptions.count - 1  {
                    msg += ", "
                }
            }
            
            if requiredOptions.count == 1{
                msg += " is required option"
            }else{
                msg += " are required options"
            }
        }
        
        return msg
    }
    
    func changeDescruptionTextFram() {
        if( readMoreBttonClicked == false){
            let fixedWidth = descriptionText.frame.size.width
            descriptionText.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
            let newSize = descriptionText.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
            var newFrame = descriptionText.frame
            newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
            let hight = newSize.height
            
            descriptionText.frame = newFrame;
            textViewHightConstant.constant = hight
            descriptionText.isScrollEnabled = true
            readMoreBttonClicked = true
            readMore.setTitle("READ LESS".localized(), for: UIControl.State())
        }
        else{
            readMore.setTitle("READ MORE".localized(), for: UIControl.State())
            readMoreBttonClicked = false
            textViewHightConstant.constant = 70
        }
    }
    
    func createImages(){
        configurePageControl()
        if(imagesArray.count == 0){
            imagesArray.append("product_default_image")
        }
        
        let pageCount = imagesArray.count
        if pageCount > 0{
            for _ in 0..<pageCount {
                pageViews.append(nil)
            }
            let pagesScrollViewSize = UIScreen.main.bounds.size
            imgscrollview.delegate = self
            imgscrollview.contentSize = CGSize(width: (pagesScrollViewSize.width-60) * CGFloat(imagesArray.count),
                                               height: imgscrollview.bounds.size.height)
            loadVisiblePages()
        }
        
    }
    
    func loadVisiblePages() {
        for subview in imgscrollview.subviews{
            subview.removeFromSuperview()
        }
        // First, determine which page is currently visible
        // Load pages in our range
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
            
            var frame = UIScreen.main.bounds
            frame.origin.x = (frame.size.width-60) * CGFloat(page)
            frame.origin.y = 0.0
            frame.size.width = frame.size.width - 60
            frame.size.height = imgscrollview.bounds.size.height
            print(frame.size.height)
            imgscrollview.isPagingEnabled = true
            let newPageView = UIImageView()
            newPageView.frame = frame
            UIImageCache.setImage(newPageView, image: imagesArray[page])
            newPageView.contentMode = .scaleAspectFit
            let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(NewProductDetailePage.imageTapped(_:)))
            newPageView.isUserInteractionEnabled = true
            newPageView.addGestureRecognizer(tapGestureRecognizer)
            
            if page == 0 {
                itemImageView = newPageView
            }
            imgscrollview.addSubview(newPageView)
            
        }
        
        currentPage()
        
    }
    
    func currentPage(){
        let pageWidth = UIScreen.main.bounds.size.width - 60
        let page = Int(floor((imgscrollview.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        
        pageIndex = Int32(page)
        pageControll.currentPage = Int(pageIndex)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        currentPage()
    }
    
    
    func configurePageControl() {
        // Set the total pages to the page control.
        pageControll.numberOfPages = imagesArray.count
        
        // Set the initial page.
        pageControll.currentPage = 0
    }
    
    
    
    @objc func imageTapped(_ img: AnyObject)
    {
        self.view.isUserInteractionEnabled = false
        let fullScreenImageView = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "FullImageViewController1") as! FullImageViewController1
        var array = NSArray()
        array = NSArray(array: imagesArray)
        fullScreenImageView.destinationView = self
        fullScreenImageView.arrayImages = array as? [String] ?? []
        fullScreenImageView.indexOfImage = CGFloat(pageIndex)
        let firstVCView = self.view as UIView?
        let thirdVCView = fullScreenImageView.view as UIView?
        let window = UIApplication.shared.keyWindow
        window?.insertSubview(thirdVCView!, belowSubview: firstVCView!)
        thirdVCView?.transform = (thirdVCView?.transform.scaledBy(x: 0.001, y: 0.001))!
        UIView.animate(withDuration: 0.6, animations: { () -> Void in
        }, completion: { (Finished) -> Void in
            
            UIView.animate(withDuration: 0.6, animations: { () -> Void in
                thirdVCView?.transform = CGAffineTransform.identity
                
            }, completion: { (Finished) -> Void in
                self.present(fullScreenImageView as UIViewController, animated: false, completion: nil)
            })
            
        }) 
        
        
        
    }
    
    override func addLoader(){
        if idForSelectedLangauge == Utils.getArebicLanguageCode() {
            relatedProductParenView.isHidden = true
            descriptionText.isHidden = true
            productSpecificationLbl.isHidden = true
            rtlback.isHidden = true
            rtlView.isHidden = true
            line2Lbl.isHidden = true
            line3View.isHidden = true
            buyNowOutlet.isHidden = true
            cartBtnOutlet.isHidden = true
            wishListBtnOutlet.isHidden = true
            lineLBl.isHidden = true
            readMore.isHidden = true
            pageControll.isHidden = true //ankur
            relatedProductParenView.isHidden = true
            reviewView.isHidden = true
        }else{
            relatedProductParenView.isHidden = true
            descriptionText.isHidden = true
            productSpecificationLbl.isHidden = true
            arrowBtn.isHidden = true
            rtlback.isHidden = true
            rtlView.isHidden = true
            line2Lbl.isHidden = true
            line3View.isHidden = true
            // readMore.hidden = true
            buyNowOutlet.isHidden = true
            cartBtnOutlet.isHidden = true
            wishListBtnOutlet.isHidden = true
            lineLBl.isHidden = true
            readMore.isHidden = true
            pageControll.isHidden = true //ankur
            relatedProductParenView.isHidden = true
            reviewView.isHidden = true
        }
        self.loaderCount += 1
        if self.loaderCount == 1{
            self.view.addSubview(activityIndicator)
            //self.view.userInteractionEnabled=false
            self.mainParentScrollView.isUserInteractionEnabled = false
            activityIndicator.startAnimating()
        }
    }
    
    override func removeLoader(){
        if idForSelectedLangauge == Utils.getArebicLanguageCode() {
            reviewView.isHidden = false
            descriptionText.isHidden = false
            productSpecificationLbl.isHidden = false
            rtlback.isHidden = false
            rtlView.isHidden = false
            line2Lbl.isHidden = false
            line3View.isHidden = false
            buyNowOutlet.isHidden = false
            cartBtnOutlet.isHidden = false
            wishListBtnOutlet.isHidden = false
            lineLBl.isHidden = false
            pageControll.isHidden = false
            
        }else {
            reviewView.isHidden = false
            descriptionText.isHidden = false
            arrowBtn.isHidden = false
            rtlback.isHidden = true
            rtlView.isHidden = true
            productSpecificationLbl.isHidden = false
            line2Lbl.isHidden = false
            line3View.isHidden = false
            buyNowOutlet.isHidden = false
            cartBtnOutlet.isHidden = false
            wishListBtnOutlet.isHidden = false
            lineLBl.isHidden = false
            pageControll.isHidden = false   //ankur
        }
        self.loaderCount -= 1
        if self.loaderCount == 0{
            self.mainParentScrollView.isUserInteractionEnabled = true
            activityIndicator.stopAnimating()
        }
    }
    
    func loadReviewData() {
        addLoader()
        guard let item = self.shoppingItem else{
            return
        }
        let url = WebApiManager.Instance.getProductReviewUrl(item.id)
        Utils.fillTheData(url, callback : self.processReviewData, errorCallback : self.showError)
    }
    
    func processReviewData(_ dataDict : NSDictionary){
        defer{removeLoader()}
        var val = 0
        self.view.isUserInteractionEnabled=true
        let total = dataDict["total"] as? Int
        
        if total>0{
            if  let  all = dataDict["all"] as? NSArray{
                for item in all{
                    
                    let dataItem = item as! NSDictionary
                    if let vote = dataItem["vote"] as? NSArray{
                        for value in vote
                        {
                            let valueItem = value as? NSDictionary ?? [:]
                            let valu = valueItem["value"] as? String ?? ""
                            val = val + Int(valu)!
                        }
                        val = val / 3
                        let reviewData = ProductReviewData(id: dataItem["id"]as? String ?? "", statusId: dataItem["statusid"]as? String ?? "", createDate: dataItem["createdat"]as? String ?? "", details: dataItem["detail"]as? String ?? "", nickName: dataItem["nickname"]as? String ?? "" , value: String(val) , title: dataItem["title"]as? String ?? "")
                        arrReviewData.append(reviewData)
                    }
                }
            }
        }
        if self.arrReviewData.count==0{
            self.reviewTableViewHeightConstraint.constant = 0
            self.beFirstReviewLbl.isHidden = false
            self.readAllReviewBtnOutlet.isHidden = true
            self.readAllReviewHeightConstraint.constant = 0
            self.reviewViewHeightConstraint.constant = self.beFirstReviewLbl.frame.origin.y + self.beFirstReviewLbl.frame.height
            
        }else{
            
            self.beFirstReviewLbl.isHidden = true
            self.beTheFirstReviewHeightConstraint.constant = 0
            if self.arrReviewData.count>2{
                
                self.readAllReviewBtnOutlet.isHidden = false
            }else{
                self.readAllReviewHeightConstraint.constant = 0
                self.readAllReviewBtnOutlet.isHidden = true
            }
            self.reviewTableView.reloadData()
            
        }
        
        createRelatedProduct()
    }
    
    
    
    // MARK: IBAction button
    
    
    @IBAction func addToCart(_ sender: AnyObject) {
        
        let cart : ShoppingCart = ShoppingCart.Instance
        let TotalCount =  cart.getTotalCount()
        
        
        if(TotalCount>0){
            for (item, _) in cart {
                
                let inCartItem : ShoppingItem = item
                let item = self.shoppingItem!
                if ((((inCartItem.type == "configurable")||(inCartItem.type == "simple")) && ((item.type == "configurable")||(item.type == "simple")))||((inCartItem.type == "downloadable") && (item.type == "downloadable"))){
                    
                    if(hasCustomOption){
                        customOptionPriceButtonAction(sender as! UIButton)
                        let msg = self.getMessage()
                        if msg.isEmpty{
                            AddItemInCart(sender as! UIButton)
                        }
                    }else{
                        AddItemInCart(sender as! UIButton)
                    }
                    
                }else{
                    Utils.showAlert("Please complete this order before ordering other items".localized())
                }
                
                break;
            }
        }
            
        else{
            if(hasCustomOption){
                customOptionPriceButtonAction(sender as! UIButton)
                let msg = self.getMessage()
                if msg.isEmpty{
                    AddItemInCart(sender as! UIButton)
                }
            }else{
                AddItemInCart(sender as! UIButton)
            }
        }
        
    }
    
    @IBAction func readAllReviewBtn(_ sender: AnyObject) {
        let allReviewObject = allReviewController(nibName: "allReviewController" , bundle: Bundle.main)
        allReviewObject.arrAllReviewData = arrReviewData
        self.navigationController?.pushViewController(allReviewObject, animated: true)
        
    }
    
    
    @IBAction func shareBttonAction(_ sender: AnyObject) {
        
        let myWebsite = URL(string:shareURl)
        guard let url = myWebsite else {
            print("nothing found")
            return
        }
        
        let shareItems:Array = [url]
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.print, UIActivity.ActivityType.copyToPasteboard, UIActivity.ActivityType.addToReadingList,UIActivity.ActivityType.airDrop]
        
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    func backButtonFunction(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func backBttonAction(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func AdditionalInfoBtton(_ sender: AnyObject) {
        let AddInfoObject = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "detailsAdditionalInfoViewController") as! detailsAdditionalInfoViewController
        AddInfoObject.productTitle = self.shoppingItem?.name
        AddInfoObject.productPrice =  specialPriceLbl.text
        AddInfoObject.stockBool = self.shoppingItem?.inStock ?? false
        AddInfoObject.titlesArray = self.titlesArray
        AddInfoObject.righttitlesArray = self.righttitlesArray
        AddInfoObject.shortDescription = self.shortdes
        
        self.navigationController?.pushViewController(AddInfoObject, animated: true)
        
    }
    
    @IBAction func wishListBtnPressed(_ sender: AnyObject) {
        
        if let button = sender as? UIButton {
            if shoppingItem != nil {
                Utils.addItemToMyWishlist(self.shoppingItem!, btnWish: button,controller: self)
            }
        }
    }
    
    @IBAction func readMoreButton(_ sender: AnyObject) {
        
        changeDescruptionTextFram()
    }
    @IBAction func writeReviewBtn(_ sender: AnyObject) {
        if(UserDefaults.standard.bool(forKey: "isLogin")){
            let myCartObject = WriteReviewViewController(nibName: "WriteReviewViewController" , bundle: Bundle.main)
            myCartObject.shoppingItem = self.shoppingItem
            self.navigationController?.pushViewController(myCartObject, animated: true)
        }else{
            alert("Please Login to write review")
        }
    }
    
    func removeLoaderNew(){
        self.loaderCount -= 1
        
        if self.loaderCount == 0{
            self.view.isUserInteractionEnabled=true
            activityIndicator.stopAnimating()
        }
    }
    
    func addLoaderNew(){
        self.loaderCount += 1
        
        if self.loaderCount == 1{
            self.view.isUserInteractionEnabled=false
            self.view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
        }
    }
}
