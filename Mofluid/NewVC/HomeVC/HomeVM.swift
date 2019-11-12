//
//  HomeVM.swift
//  Mofluid
//
//  Created by Saurabh Mishra on 26/06/18.
//  Copyright © 2018 Mofluid. All rights reserved.
//

import Foundation
import FSPagerView
import Kingfisher
class HomeVM{
    
    //load login information
    //MARK:- Api Methods
    func callForStoreDetails(_ url:String,_ completion:@escaping (_ isSuccess:Bool,_ data:AnyObject)->Void){
        
        ApiManager().getApi(url: url) { (response,status) in
            
            if status{
                
                completion(true,response)
            }
            else{
                
                completion(false,NSNull())
            }
        }
    }
    func callForProducts(_ completion:@escaping (_ isSuccess:Bool,_ data:AnyObject)->Void){
        
        var finalProducts       =   [FinalProduct]()
        let newProductUrl       =   WebApiManager.Instance.getNewProductsURL()
        let featureProductUrl   =   WebApiManager.Instance.getFeatureProductsURL()
        let bestProductUrl      =   WebApiManager.Instance.getBestsellerProductsURL()
        let dispatchGroup       =   DispatchGroup()
        dispatchGroup.enter()
        ApiManager().getApi(url: newProductUrl!) { (response,status) in
            
            if status{
                
                let products    =   self.parserForProducts(response as! NSDictionary)
                let homeModel   =   HomeModel(products:products,sectionName:"newProducts")
                finalProducts.append(FinalProduct(home:homeModel,name:FinalProduct.names.NewProducts))
            }
            
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        ApiManager().getApi(url: featureProductUrl!) { (response,status) in
            
            if status{
                
                let products    =   self.parserForProducts(response as! NSDictionary)
                let homeModel   =   HomeModel(products:products,sectionName:"featuredProducts")
                finalProducts.append(FinalProduct(home:homeModel,name:FinalProduct.names.FeaturedProducts))
            }
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        ApiManager().getApi(url: bestProductUrl!) { (response,status) in
            
            if status{
                
                let products    =   self.parserForProducts(response as! NSDictionary)
                let homeModel   =   HomeModel(products:products,sectionName:"bestProducts")
                finalProducts.append(FinalProduct(home:homeModel,name:FinalProduct.names.BestProducts))
            }
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: DispatchQueue.main) { // 2
            
            completion(true,finalProducts as AnyObject)
        }
    }
   
    //MARK:- Api Parser
    func parserForProducts(_ dataDict:NSDictionary)->[ShoppingItem]{
        
        var products = [ShoppingItem]()
        if let status = dataDict["status"] as? NSArray{
            if let statusDict = status as? [NSDictionary]{
                if let showStatus = statusDict[0]["Show_Status"] as? NSString{
                    if(showStatus == "1"){
                        if let products_list = dataDict["products_list"] as? NSArray{
                            products_list.forEach{item in
                                if let shoppingItem = StoreManager.Instance.createShoppingItem(item as! NSDictionary){
                                    products.append(shoppingItem)
                                }
                            }
                        }
                    }
                }
            }
        }
        return products
    }
    func populateStoreDetails(_ dataDict: NSDictionary){
        let storeDetail = StoreManager.Instance.storeDetail
        
        storeDetail.banners.removeAll(keepingCapacity: true)
        
        let storeID     =   (dataDict["store"] as? NSDictionary)?.value(forKey:"store_id") as? String
        let currency    =   ((dataDict["currency"] as? NSDictionary)?.value(forKey:"current") as? NSDictionary)?.value(forKey:"code") as? String
        Config.Instance.setCurrencyCode(currency ?? "")
        Config.Instance.setStoreId(storeID ?? "")
        WebApiManager.Instance.refreshURL()
        
        if let store = dataDict["store"] as? NSDictionary{
            let aboutUs = store["about_us"] as! String
            let privacyPolicy = store["privacy_policy"] as? String ?? ""
            storeDetail.privacyPloicy = privacyPolicy
            storeDetail.aboutUsId = aboutUs
        }
        
        if let theme = dataDict["theme"] as? NSDictionary{
            if let logo = theme["logo"] as? NSDictionary{
                if let image = logo["image"] as? NSArray{
                    if let imageDict = image as? [NSDictionary]{
                        if let logoImage = imageDict[0]["mofluid_image_value"] as? String{
                            storeDetail.logo = logoImage
                        }
                    }
                }
            }
            
            if let banner = theme["banner"] as? NSDictionary{
                if let images = banner["image"] as? NSArray{
                    images.forEach{image in
                        if let imageDict = image as? NSDictionary{
                            storeDetail.bannersDict.append(imageDict)
                            if let mofluid_image_value = imageDict["mofluid_image_value"] as? String{
                                storeDetail.banners.append(mofluid_image_value)
                            }
                        }
                    }
                }
            }
        }
    }
    
}

//MARK:- TABLEVIEW
extension HomeVC:UITableViewDataSource,UITableViewDelegate{
    
    //MARK:- TABLEVIEW METHODS    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return 156
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return productList.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 30
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var title = ""
        if let tableSection = self.productList[section].name {
            switch tableSection {
            case .FeaturedProducts:
                title = "Featured Products".localized()
                break
            case .NewProducts:
                title = "New Products".localized()
                break
            case .BestProducts:
                title = "Best Products".localized()
                break
            }
        }
        return title
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view                    =    UIView(frame: CGRect(x: 0, y: 2, width: tableView.bounds.width, height: SectionHeaderHeight))
        let lineView                =    UIView(frame: CGRect(x: 5, y: 25, width: tableView.bounds.width-10, height: 0.8))
        lineView.backgroundColor    =    .black
        view.backgroundColor        =    .white
        let label                   =    UILabel(frame: CGRect(x: 5, y: 0, width: tableView.bounds.width - 30, height: SectionHeaderHeight))
        label.font                  =    UIFont(name:"Lato-Regular",size:18)
        label.textColor             =    UIColor.black
        
        if let tableSection = self.productList[section].name {
            switch tableSection {
                
                case .FeaturedProducts:
                    label.text = "Featured Products".uppercased()
                    break
                case .NewProducts:
                    label.text = "New Products".uppercased()
                    break
                case .BestProducts:
                    label.text = "Best Products".uppercased()
                    break
            }
        }
        view.addSubview(lineView)
        view.addSubview(label)
        return view
    }
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell", for:indexPath) as! ProductTableViewCell
        cell.backgroundColor    =   UIColor.clear
        cell.selectionStyle     =   UITableViewCell.SelectionStyle.none
        setDataForCell(cell,indexPath: indexPath)
        return cell
    }
    func setDataForCell(_ cell:ProductTableViewCell, indexPath:IndexPath) {
        
        //set data
        cell.productsArray  =   self.productList[indexPath.section].homeModel.products
        cell.delegate       =   self
        cell.collectionView.reloadData()
    }
}

//MARK:- PagerView
extension HomeVC:FSPagerViewDataSource,FSPagerViewDelegate{
    
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        
        return bannerUrls.count
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.kf.setImage(with:URL(string: bannerUrls[index]))
        cell.imageView?.contentMode     =   .scaleAspectFill
        cell.imageView?.center          =   (cell.imageView?.superview?.center)!
        cell.imageView?.clipsToBounds   =   true
        return cell
    }
    
    // MARK:- FSPagerView Delegate
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
        let response                            =   getBannerData(index)
        if response.id != 0 {
            
            let mainStoryboard                  =   UIStoryboard(name: "Main",bundle: nil)
            let destViewController              =   mainStoryboard.instantiateViewController(withIdentifier: "productListViewController") as!                               productListViewController
            destViewController.categoryId       =   Int(response.id)
            destViewController.titleString      =   response.productname
            self.navigationController?.pushViewController(destViewController, animated:true)
        }
    }
    
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        guard self.pageControl.currentPage != pagerView.currentIndex else {
            return
        }
        self.pageControl.currentPage = pagerView.currentIndex // Or Use KVO with property "currentIndex"
    }
    
    func getBannerData(_ value:Int)->(productname:String,id:Int,base:String){
        
        var base                   =    ""
        var id                     =    0
        var productname            =    ""
        let bannerData             =    StoreManager.Instance.storeDetail.bannersDict[value]
        if  let mofluidImageAction =    bannerData["mofluid_image_action"] as? String{
            let dict               =    Encoder.decodeBase64ToDictionary(mofluidImageAction)
            
            if let baseValue = dict["base"] as? String{
                
                base = baseValue
            }
            if let idValue = dict["id"] as? String{
                
                id  =  Int(idValue)!
            }
            if let productValue = dict["name"] as? String{
                
                productname =   productValue
            }
        }
        return (productname:productname,id:id,base:base)
    }
}


//MARK:- Cell Delegate
extension HomeVC:ProductCellDelegate{
    
    func tappedOnCell(_ shopeItem:ShoppingItem){
        
//        if(shopeItem.type == "grouped"){
//            let groupProductObject          =       GroupedProductDetailViewController(nibName: "GroupedProductDetailViewController", bundle: nil)
//            groupProductObject.shoppingItem = shopeItem
//            self.navigationController?.pushViewController(groupProductObject, animated: true)
//        }else{
            //DispatchQueue.main.async(execute: {
                
                let productDtail = ProductVC(nibName: "ProductVC", bundle: nil)
                //let productDtail = NewProductDetailePage(nibName: "NewProductDetailePage", bundle: nil)
                
//                let def     =   UserDefaults.standard
//                let idItem  =   def.integer(forKey: "intKey") as Int
//                let def1    =   UserDefaults.standard
//                let idIt    =   def1.integer(forKey: "intKy") as Int
//
//                productDtail.shoppingItem?.id = shopeItem.value(forKey: "id") as! Int
//
//                if shopeItem.id == idIt {
//
//                    productDtail.shoppingItem?.id = idItem
//                    shopeItem.setValue(idItem, forKey: "id")
//                }
                productDtail.shoppingItem = shopeItem//StoreManager.Instance.getShoppingItem(shopeItem.id)
                self.navigationController?.pushViewController(productDtail, animated: true)
            //})
        //}
    }
}


//MARK:- RightMenu Delegate
extension HomeVC:RightSideMenuDelegate{
    
    func tappedOnButton(_ vc:UIViewController,message:String){
        
        print("test")
    }
}
