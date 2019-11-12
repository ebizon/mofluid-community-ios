//
//  productListViewController.swift
//  Mofluid
//
//  Created by sudeep goyal on 10/09/15.
//  Copyright © 2015 Mofluid. All rights reserved.
//

import UIKit
import Foundation

class productListViewController: PageViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource ,sortItemDelegate{
    @IBOutlet var buttonView: UIView!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet var lineView: UIView!
    @IBOutlet var sortBtnOutlet: UIButton!
    @IBOutlet var filterBtnOutlet: UIButton!
    
    let emptyLabel = UILabel()
    var type = ""
    var order = ""
    var sortButtonTag: Int = 10
    
    @IBAction func filterBtn(_ sender: AnyObject) {
        if(filterAttributeList.count>0){
            let newViewController = FiltersViewController(nibName: "FiltersViewController", bundle: nil)
            newViewController.arrFilterData = filterAttributeList as [FiltersAttributeData]
            self.present(newViewController, animated: true, completion: nil)
        }else{
            self.alert("Please wait for products to load")
        }
    }
    
    @IBAction func sortBtn(_ sender: AnyObject) {
        let sort : SortView = SortView.instanceFromNib() as! SortView
        sort.frame = UIScreen.main.bounds
        sort.delegate = self
        sort.setBtnimage()
        self.view.addSubview(sort)
        
        self.navigationController?.navigationBar.isUserInteractionEnabled = false
    }
    
    var categoryId : Int = -1
    var filterData = ""
    var filterAttributeList = [FiltersAttributeData]()
    var isInitialLoad  = Bool()
    var isFilterApply = Bool()
    var pagesize : Int = 12
    var currentpage : Int = 1
    var totalCountofProducts = Int()
    var categoryName  = "".localized()
    var pageTitle = "".localized()
    var allShoppingItems = [ShoppingItem]()
    var collectionView: UICollectionView!
    var titleString = "Search Result"
    var refreshControl = UIRefreshControl()
    var needLoading = true
    var myActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myActivityIndicator.color = UIColor.black
        myActivityIndicator.center = CGPoint(x: view.frame.size.width  / 2, y: view.frame.size.height - 60 )
        myActivityIndicator.hidesWhenStopped = true;
        self.view.addSubview(myActivityIndicator)
        self.navigationItem.title = titleString.uppercased() as String
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        filterBtnOutlet.isHidden = false
        lineView.isHidden = false
        sortBtnOutlet.isHidden = false
        
        isInitialLoad = true
        self.loadProducts(true , type: type , order: order)
        
        self.createProductListView()
        UserDefaults.standard.set(false, forKey: "isTapped")
        self.collectionView.alwaysBounceVertical = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(productListViewController.ApplyFilterAction(_:)), name: NSNotification.Name(rawValue: "FilterActionNotification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(productListViewController.removeSortViewAction(_:)), name: NSNotification.Name(rawValue: "RemoveSortView"), object: nil)
        
        emptyLabel.frame = CGRect(x: 20, y: (UIScreen.main.bounds.height-30)/2, width: UIScreen.main.bounds.width - 40, height: 30)
        emptyLabel.text = "No Products Available!".localized()
        emptyLabel.textAlignment = .center;
        emptyLabel.font = UIFont(name: "Lato", size: 20)
        emptyLabel.textColor = UIColor.darkGray
        self.view.addSubview(emptyLabel)
        emptyLabel.isHidden = true
        
        filterButton.setTitle("Filter".localized(), for: UIControl.State())
        sortButton.setTitle("Sort".localized(), for: UIControl.State())
    }
    
    @objc func removeSortViewAction(_ notification: Notification){
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
    }
    
    func refresh(_ sender:AnyObject){
        refreshTheLoadData()
    }
    
    fileprivate func refreshTheLoadData(){
        self.currentpage = 1
        self.isInitialLoad = true
        self.isFilterApply = false
        self.removeLoader()
        self.allShoppingItems.removeAll()
        self.view.isUserInteractionEnabled = false
        self.loadProducts(true , type: type , order: order)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(deviceName == "big"){
            UILabel.appearance().font = UIFont(name: "Lato", size: 18)
        }else{
            UILabel.appearance().font = UIFont(name: "Lato", size: 15)
        }
        
        self.tabBarController?.tabBar.isHidden = false
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "OptionViewTap"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "selectOptionViewOption"), object: nil)
        
    }
    
    
    func backButtonFunction(){
        if UserDefaults.standard.bool(forKey: "isOpen") {
            return
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func createProductListView(){
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        if(deviceWidth >= 1025){
            layout.itemSize = CGSize(width: 178, height: 220)
        }
        else if(deviceWidth >= 768 && deviceWidth < 1025){
            layout.itemSize = CGSize(width: 178, height: 220)
        }
        else if(deviceWidth >= 569 && deviceWidth < 768){
            layout.itemSize = CGSize(width: 178, height: 220)
        }
        else if(deviceWidth >= 481 && deviceWidth < 569){
            layout.itemSize = CGSize(width: 178, height: 220)
        }
        else if(deviceWidth > 320 && deviceWidth < 481){
            layout.itemSize = CGSize(width: mainParentScrollView.frame.size.width/2.19, height: 230)
        }
        else if(deviceWidth <= 320){
            layout.itemSize = CGSize(width: mainParentScrollView.frame.size.width/2.209, height: 180)
        }
        
        mainParentScrollView.addSubview(buttonView)
        collectionView = UICollectionView(frame: CGRect(x: 0,y: 47, width: mainParentScrollView.frame.size.width, height: mainParentScrollView.frame.size.height - 100), collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = UIColor.white
        
        mainParentScrollView.backgroundColor = UIColor.clear
        
        mainParentScrollView.addSubview(collectionView)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.allShoppingItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        for view in cell.contentView.subviews{
            view.removeFromSuperview()
        }
        
        cell.backgroundColor = UIColor.white
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor.white.cgColor
        if allShoppingItems.count>0{
            
            
        
        let item = self.allShoppingItems[indexPath.row]
        let productTitle = UILabel()
        productTitle.font = UIFont(name: "Lato", size: 14)
        productTitle.text = item.name
        
        productTitle.textColor = UIColor.black
        productTitle.textAlignment = .center;
        productTitle.frame = CGRect(x: 7, y: 170, width:cell.frame.size.width-14, height: 23)
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 960:
                productTitle.frame = CGRect(x: 7, y: 125, width:cell.frame.size.width-14, height: 23)
            case 1136:
                productTitle.frame = CGRect(x: 7, y: 125, width:cell.frame.size.width-14, height: 23)
            default:
                productTitle.frame = CGRect(x: 7, y: 178, width:cell.frame.size.width-14, height: 23)
            }
        }
        
        var oldLabel = UILabel()
        if item.isShowSpecialPrice(){
            oldLabel = UILabel(frame: CGRect(x: 1, y: productTitle.frame.origin.y + productTitle.frame.size.height + 1, width:cell.frame.size.width/2, height: 23))
            oldLabel.textColor = UIColor.gray
            oldLabel.font = UIFont(name: "Lato", size: 14)
            oldLabel.textAlignment = .left;
            oldLabel.backgroundColor = UIColor.white
            
            let attributePrice =  NSMutableAttributedString(string: item.originalPriceStr!)
            attributePrice.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributePrice.length))
            
            oldLabel.attributedText = attributePrice
            cell.addSubview(oldLabel)
            
            let newLabel = UILabel(frame: CGRect(x: 1+cell.frame.size.width/2, y: oldLabel.frame.origin.y, width:cell.frame.size.width/2, height: 23))
            newLabel.textColor = UIColor.red
            newLabel.font = UIFont(name: "Lato", size: 14)
            newLabel.textAlignment = .center;
            newLabel.text = item.priceStr
            newLabel.backgroundColor = UIColor.white
            cell.addSubview(newLabel)
            
        }else{
            oldLabel = UILabel(frame: CGRect(x: 1, y: productTitle.frame.origin.y + productTitle.frame.size.height + 1, width:cell.frame.size.width - 2, height: 23))
            oldLabel.textColor = UIColor.red
            oldLabel.font = UIFont(name: "Lato", size: 14)
            oldLabel.textAlignment = .center;
            oldLabel.text = item.priceStr
            oldLabel.backgroundColor = UIColor.white
            cell.addSubview(oldLabel)
        }
        
        let new_img_view = UIImageView()
        new_img_view.frame = CGRect(x: 0, y: 0, width: cell.frame.size.width, height: 180)
        if UIDevice().userInterfaceIdiom == .pad {
            new_img_view.frame = CGRect(x: 0, y: 0, width: cell.frame.size.width, height: 170)
            
        }
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 960:
                new_img_view.frame = CGRect(x: 0, y: 0, width: cell.frame.size.width, height: 110)
            case 1136:
                new_img_view.frame = CGRect(x: 0,y: 0,width: cell.frame.size.width, height: 115)
                
            default:
                print("default")
            }
        }
        
        new_img_view.contentMode = .scaleAspectFit
        
        UIImageCache.setImage(new_img_view, image: item.image)
        
        cell.tag = item.id
        
        cell.contentView.addSubview(productTitle)
        cell.contentView.addSubview(new_img_view)
        
        var shouldLoadMore =  (indexPath.row == (self.allShoppingItems.count - 1) / 2 )      // && !isFilterApply
        let maxPageCount = self.maxPageCount(self.totalCountofProducts, pagesize: self.pagesize)
        if currentpage >= maxPageCount {
            shouldLoadMore = false
        }
        
        if shouldLoadMore {
            currentpage = currentpage + 1
            self.loadProductsNewFunc(false ,type: type , order: order)
        }
        
        shouldLoadMore =  ( indexPath.row == (self.allShoppingItems.count - 1))     //&& !isFilterApply
        if shouldLoadMore{
            currentpage = currentpage + 1
            self.loadProductsNewFunc1()
        }
        }
        return cell
    }
    
    fileprivate func loadProductsNewFunc(_ isIndicatorShow : Bool , type : String ,order : String ){
        var url = ""
        if isFilterApply
        {
            url = WebApiManager.Instance.getProductFilterList(String(self.categoryId), filterData: filterData , pagesize: self.pagesize, currentPage: self.currentpage) ?? ""
        }
        else
        {
            url = WebApiManager.Instance.getAccessurl(self.categoryId, pagesize: self.pagesize, currentPage: self.currentpage) ?? ""
        }
        url = url + "&sortorder=" + order + "&sorttype=" + type
        if isIndicatorShow {
            self.loaderCount = 0
            self.addLoader()
        }
        if self.categoryId == -1 {
            
            url = WebApiManager.Instance.getSearchURL(self.categoryName , pagesize: self.pagesize, currentPage: self.currentpage) ?? ""
            url = url + "&sortorder=" + order + "&sorttype=" + type
            self.pageTitle = "Showing search result for  " + "'" + self.categoryName.uppercased() + "'"
        }
        ApiManager().getApi(url: url) { (response, status) in
            
            if status{
                self.processData(response as! NSDictionary)
            }
            else{
                self.showError()
            }
        }
    }
    
    
    fileprivate func loadProductsNewFunc1(){
        if self.needLoading{
            var url = ""
            if isFilterApply
            {
                url = WebApiManager.Instance.getProductFilterList(String(self.categoryId), filterData: filterData , pagesize: self.pagesize, currentPage: self.currentpage) ?? ""
            }
            else{
                url = WebApiManager.Instance.getAccessurl(self.categoryId, pagesize: self.pagesize, currentPage: self.currentpage) ?? ""
            }
            self.removeLoader()
            myActivityIndicator.startAnimating()
            
            if self.categoryId == -1{
                
                url = WebApiManager.Instance.getSearchURL(self.categoryName , pagesize: self.pagesize, currentPage: self.currentpage) ?? ""
                url = url + "&sortorder=" + order + "&sorttype=" + type
                self.pageTitle = "Showing search result for  " + "'" + self.categoryName.uppercased() + "'"
            }
            
            ApiManager().getApi(url: url) { (response, status) in
                
                if status{
                    self.processData(response as! NSDictionary)
                }
                else{
                    self.showError()
                }
            }
        }
    }
    func maxPageCount(_ totalItems: Int,pagesize:Int) -> Int {
        var number = totalItems/pagesize
        number = number > 0 ? number + 1 : number
        
        return number
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let item = self.allShoppingItems[indexPath.row]
        let productDtail = ProductVC(nibName: "ProductVC", bundle: nil)
        productDtail.shoppingItem = item
        self.navigationController?.pushViewController(productDtail, animated: true)
    }
    
    fileprivate func loadProducts(_ isIndicatorShow : Bool , type : String ,order : String ){
        var url = ""
        if isFilterApply{
            if self.categoryId == -1{
                url = WebApiManager.Instance.getSearchProductFilterList(self.categoryName, filterData: filterData , pagesize: self.pagesize, currentPage: self.currentpage) ?? ""
            }else{
                url = WebApiManager.Instance.getProductFilterList(String(self.categoryId), filterData: filterData , pagesize: self.pagesize, currentPage: self.currentpage) ?? ""
            }
        }else{
            if self.categoryId == -1{
                url = WebApiManager.Instance.getSearchURL(self.categoryName , pagesize: self.pagesize, currentPage: self.currentpage) ?? ""
            }else{
                url = WebApiManager.Instance.getAccessurl(self.categoryId, pagesize: self.pagesize, currentPage: self.currentpage) ?? ""
            }
        }
        url = url + "&sortorder=" + order + "&sorttype=" + type
        if isIndicatorShow {
            self.loaderCount = 0
            self.addLoader()
        }
        
        if self.categoryId == -1{
            self.pageTitle = "Showing search result for  " + "'" + self.categoryName.uppercased() + "'"
        }
        Utils.fillTheData(url, callback: self.processData, errorCallback : self.showError)
    }
    
    fileprivate func loadProductsWithLoading(){
        if self.needLoading{
            self.loadProducts(true, type: self.type, order: self.order)
        }
    }
    
    fileprivate func processData(_ dataDict: NSDictionary){
        defer{self.removeLoader()
            myActivityIndicator.stopAnimating()
        }
        
        let oldCount = self.allShoppingItems.count
        
        self.view.isUserInteractionEnabled = true
        self.collectionView.reloadData()
        self.refreshControl.endRefreshing()
        if(isInitialLoad){
            self.isInitialLoad = false
            self.allShoppingItems.removeAll()
            self.getProductFilterValue()
        }
        if let totalCount = dataDict["total_count"] as? Int{
            self.totalCountofProducts = totalCount
            if(totalCount > 0){
                if let products_list = dataDict["items"] as? NSArray{
                    
                    for item in products_list{
                        
                        if let shoppingItem = StoreManager.Instance.createShoppingAccessory(item as! NSDictionary){
                            if !self.allShoppingItems.contains(where: {$0.id == shoppingItem.id}){ //Small array not costly ops, if get replace with ordered set
                                self.allShoppingItems.append(shoppingItem)
                            }
                        }
                    }
                    //                    products_list.forEach{item in
                    //                        if let shoppingItem = StoreManager.Instance.createShoppingAccessory(item as! NSDictionary){
                    //                            if !self.allShoppingItems.contains(where: {$0.id == shoppingItem.id}){ //Small array not costly ops, if get replace with ordered set
                    //                                self.allShoppingItems.append(shoppingItem)
                    //                            }
                    //                        }
                    //                    }
                    
                    emptyLabel.isHidden = true
                    self.collectionView.isHidden = false
                }else{
                    emptyLabel.isHidden = false
                    self.collectionView.isHidden = true
                }
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }else{
                emptyLabel.isHidden = false
            }
            
            self.needLoading = self.allShoppingItems.count > oldCount
        }
    }
    
    func getProductFilterValue(){
        var url : String? = nil
        if(self.categoryId != -1){
            url = WebApiManager.Instance.getProductFilterAttribute(String(self.categoryId))
        }else{
            url = WebApiManager.Instance.getProductSearchFilterAttribute(self.categoryName)
        }
        
        self.addLoader()
        
        Utils.fillTheDataFromArray(url, callback: self.processFilterAttributeData, errorCallback: self.showError)
    }
    
    func processFilterAttributeData(_ dataArray : NSArray){
        defer{self.removeLoader()}
        filterAttributeList.removeAll()
        dataArray.forEach{data in
            let dictData = data as! NSDictionary
            if let childData = dictData["values"] as? NSArray{
                var arrAttrVal = [FilterAttributeValue]()
                childData.forEach{chaildValue in
                    let attributeVal = chaildValue as! NSDictionary
                    if let childid = attributeVal["id"] as? String, let childvalue = attributeVal["label"] as? String, let count = attributeVal["count"] as? String{
                        let fltrAttrVal = FilterAttributeValue(id: childid, name: childvalue, count: count)
                        arrAttrVal.append(fltrAttrVal)
                    }
                }
                if(arrAttrVal.count > 0){
                    let filterData = FiltersAttributeData(id: dictData["code"] as! String, name: dictData["label"] as! String,  attributeValue: arrAttrVal)
                    filterAttributeList.append(filterData)
                }
            }
        }
    }
    
    @objc func ApplyFilterAction(_ notification: Notification){
        self.allShoppingItems.removeAll()
        let objet = notification.object as! NSDictionary?
        isFilterApply = true
        self.currentpage = 1
        let filterValue = objet!.value(forKey: "filterValue") as! NSArray
        filterData = Encoder.encodeBase64(filterValue)!
        self.loadProducts(true, type: self.type, order: self.order)
    }
    
    func btnSortCatSelect(_ sender: AnyObject){
        sortButtonTag = sender.tag
        self.allShoppingItems.removeAll()
        currentpage = 1
        switch sortButtonTag{
        case 10:
            type = "name"
            order = "asc"
            self.loadProductsNewFunc(true, type:type , order: order)
            break
        case 20:
            type = "name"
            order = "desc"
            self.loadProductsNewFunc(true, type:type , order: order)
            break
        case 30:
            type = "price"
            order = "asc"
            self.loadProductsNewFunc(true, type:type , order: order)
            break
        case 40:
            type = "price"
            order = "desc"
            self.loadProductsNewFunc(true, type:type , order: order)
            break
        default:
            break
        }
        
        self.collectionView.reloadData()
    }
}


