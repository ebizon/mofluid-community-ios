//
//  WishListViewController.swift
//  Mofluid
//
//  Created by mac on 10/10/16.
//  Copyright © 2016 Mofluid. All rights reserved.
//

import UIKit

class WishListViewController: PageViewController , UITableViewDelegate ,UITableViewDataSource {
    var arrWishListData = [ShoppingItem]()
    var itemImageView = UIImageView ()
    @IBOutlet var wishListTableView: UITableView!
    @IBOutlet var noProductLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainParentView.isHidden = true
        mainParentScrollView.isHidden = true
        wishListTableView.delegate = self
        wishListTableView.dataSource = self
        
        if idForSelectedLangauge == Utils.getArebicLanguageCode() {
            let nib  = UINib(nibName: "WishListCustomTableViewCell_RTL", bundle: Bundle.main)
            wishListTableView.register(nib, forCellReuseIdentifier: "myWishListIdetifier")
        }else{
            let nib  = UINib(nibName: "WishListCustomTableViewCell", bundle: Bundle.main)
            wishListTableView.register(nib, forCellReuseIdentifier: "myWishListIdetifier")
        }
        
        noProductLbl.isHidden = true
        self.navigationItem.title = "MY WISHLIST"
        loadWishlistItemData()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func loadWishlistItemData(){
        if(UserDefaults.standard.bool(forKey: "isLogin")){
            
            let url = WebApiManager.Instance.getWishlistDataUrl()
            self.addLoader()
            Utils.fillTheDataFromArray(url, callback: self.processWishlistData, errorCallback : self.showError)}
        else
        {
            let refreshAlert = UIAlertController(title: "", message: "Please login to see wishlist", preferredStyle: UIAlertController.Style.alert)
            refreshAlert.addAction(UIAlertAction(title: "OK".localized(), style: .default, handler: { (action: UIAlertAction!) in
                
                UserDefaults.standard.set(true, forKey: "isLoginForWishListPageFromMenu")
                //let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
                let loginObject = LoginVC(nibName:"LoginVC",bundle: nil)//mainStoryboard.instantiateViewController(withIdentifier: "loginViewController") as? loginViewController
                self.navigationController?.pushViewController(loginObject, animated: true)
            }))
            refreshAlert.addAction(UIAlertAction(title: "Not Now".localized(), style: .cancel, handler: { (action: UIAlertAction!) in
                
                self.dismiss(animated: true, completion: nil)
            }))
            
            present(refreshAlert, animated: true, completion: nil)
        }
    }
    
    func backButtonFunction(){
        self.navigationController?.popViewController(animated: true)
    }
    
    fileprivate func processWishlistData(_ dataarray: NSArray){
        defer{self.removeLoader()}
        self.view.isUserInteractionEnabled = true
        
        //if let products_list = dataDict["items"] as? NSArray{
            ShoppingWishlist.Instance.deleteAllItem()
            self.arrWishListData = Utils.getProductFromDataArray(dataarray)
            print(arrWishListData.count)
            ShoppingWishlist.Instance.addItemFromArray(self.arrWishListData)
            wishListTableView.reloadData()
            showLableEmptyMsg()
       // }
    }
    
    fileprivate func showLableEmptyMsg(){
        if arrWishListData.count == 0{
            
            noProductLbl.isHidden = false
            noProductLbl.text = "You have no items in your wishlist."
            
        }else{
            noProductLbl.isHidden = true
        }
    }
    
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrWishListData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 141
    }
    //
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "myWishListIdetifier", for: indexPath) as! WishListCustomTableViewCell
        
        let item :ShoppingItem = self.arrWishListData[indexPath.row]
        
        cell.productTitleLbl.text = item.name
        cell.productPriceLbl.text = item.priceStr
        UIImageCache.setImage(cell.itemIconImageVIew , image: item.image)
        
        cell.addtoCartBtnOutlet.tag = indexPath.row
        cell.deleteBtnOutlet.tag = indexPath.row
        cell.buttonViewOutlet.tag = indexPath.row
        
        
        cell.buttonViewOutlet.addTarget (self, action: #selector(WishListViewController.btnViewPressed(_:)), for: UIControl.Event.touchUpInside)
        cell.addtoCartBtnOutlet.addTarget (self, action: #selector(WishListViewController.btnAddToCartPressed(_:)), for: UIControl.Event.touchUpInside)
        cell.deleteBtnOutlet.addTarget (self, action: #selector(WishListViewController.btnDeletePressed(_:)), for: UIControl.Event.touchUpInside)
        return cell
    }
    
    @IBAction func btnAddToCartPressed(_ sender:UIButton){
            
        backButton.isEnabled = false
        let shoppingItem = self.arrWishListData[sender.tag]
        //create dictionary for add to cart
        let cartDic=NSMutableDictionary()
        cartDic.setValue("", forKey:"quote_id")
        cartDic.setValue(shoppingItem.type, forKey:"product_type")
        cartDic.setValue("1", forKey:"qty")
        cartDic.setValue(shoppingItem.sku, forKey:"sku")
        Utils.addItemInCartWithSync(shoppingItem, count: 1, isfromByNow: true, controller: self)
        //delete wishlist from server
        let item = self.arrWishListData[sender.tag]
        ShoppingWishlist.Instance.deleteItem(item)
        self.arrWishListData.remove(at: sender.tag)
        Utils.deleteWishListOnServer(item, btnWish: sender)
        DispatchQueue.main.async {
            
            self.wishListTableView.reloadData()
            // self.showLableEmptyMsg()
        }
    }
 
    @IBAction func btnDeletePressed(_ sender:UIButton){
        
        let refreshAlert = UIAlertController(title: "", message: Constants.deleteMsgOfWishlist, preferredStyle: UIAlertController.Style.alert)
        refreshAlert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (action: UIAlertAction!) in
        let item = self.arrWishListData[sender.tag]
        ShoppingWishlist.Instance.deleteItem(item)
        self.arrWishListData.remove(at: sender.tag)
            if self.arrWishListData.count == 0{
                
                self.showLableEmptyMsg()
            }
        Utils.deleteWishListOnServer(item, btnWish: sender)
        DispatchQueue.main.async {
                
            self.wishListTableView.reloadData()
            // self.showLableEmptyMsg()
           }
        }))
        refreshAlert.addAction(UIAlertAction(title: "NO", style: .cancel, handler: { (action: UIAlertAction!) in
            
            print("Not Deleted")
        }))
        present(refreshAlert, animated: true, completion: nil)
    }
    
    
    @IBAction func btnViewPressed(_ sender:UIButton){
        let item = self.arrWishListData[sender.tag]
        let productDtail = ProductVC(nibName: "ProductVC", bundle: nil)
        productDtail.shoppingItem = item
        self.navigationController?.pushViewController(productDtail, animated: true)
    }
}
