//
//  GroupedProductDetailViewController.swift
//  ForDentist
//
//  Created by Shitanshu on 28/12/16.
//  Copyright © 2016 Mofluid. All rights reserved.
//

import UIKit

class GroupedProductDetailViewController: PageViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var groupProductTableView: UITableView!
    @IBOutlet weak var addToCartButton:UIButton!
    
    var shoppingItem:ShoppingItem?
    var groupedItems = [ShoppingItem]()
    var imagesArray = [String]()
    
    var tempCart = ShoppingCart.Instance.getTempCart()
    var isServiceAvailable = false
    var txtTemp : UITextField?
    
    //MARK: View Lifecycle methods
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        super.createHeader()
        groupProductTableView.delegate =   self
        groupProductTableView.dataSource   =   self
        
        //**************PC*******RTL
        
        if idForSelectedLangauge == Utils.getArebicLanguageCode()
        {
            groupProductTableView.register(UINib(nibName: "GroupProductCellRTL", bundle: Bundle.main), forCellReuseIdentifier: "GroupProductCellRTL")
        }
        else{
            groupProductTableView.register(UINib(nibName: "GroupProductCell", bundle: Bundle.main), forCellReuseIdentifier: "GroupProductCell")
        }
        
        //**********************
        
        // GroupedProductDetailCell
        groupProductTableView.register(UINib(nibName: "GroupedProductDetailCell", bundle: Bundle.main), forCellReuseIdentifier: "GroupedProductDetailCell")
        groupProductTableView.rowHeight = UITableView.automaticDimension
        groupProductTableView.estimatedRowHeight = 120
        self.title = shoppingItem?.name
        loadProduct()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //???: It is a delibarated call to ignore the base method call.
    override func createMainView() {
    }
    
    //MARK: TableView methods
    //MARK:-
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return groupedItems.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = groupProductTableView.dequeueReusableCell(withIdentifier: "GroupedProductDetailCell") as! GroupedProductDetailCell
            cell.configureCell(self.shoppingItem!, contlr: self)
            cell.delegate = self
            cell.selectionStyle = .none
            print("grouped items",self.groupedItems)
            return cell
        }
        
        if idForSelectedLangauge == Utils.getArebicLanguageCode(){
            
            let cell = groupProductTableView.dequeueReusableCell(withIdentifier: "GroupProductCellRTL") as! GroupProductCellRTL
            let item = self.groupedItems[indexPath.row]
            cell.configureCell(item, selectedQuantity: item.selectedItemCount)
            cell.selectionStyle = .none
            cell.delegate = self
            return cell
        }else{
            
            let cell = groupProductTableView.dequeueReusableCell(withIdentifier: "GroupProductCell") as! GroupProductCell
            let item = self.groupedItems[indexPath.row]
            cell.configureCell(item, selectedQuantity: item.selectedItemCount)
            cell.selectionStyle = .none
            cell.delegate = self
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableView.automaticDimension
        }
        return 120
    }
    
    //MARK: Other methods
    func loadProduct(){
        guard let item = self.shoppingItem else{
            return
        }
        self.addLoader()
        let url = WebApiManager.Instance.getDescUrl(item.id, type: item.type)
        debugPrint("grouped product url = \(String(describing: url))")
        Utils.fillTheData(url, callback : self.processDetails, errorCallback : self.showError)
    }
    
    func processDetails(_ dataDict : NSDictionary){
        defer{self.removeLoader()}
        
        let id = self.shoppingItem!.id
        let type = self.shoppingItem!.type
        if let imgurl = WebApiManager.Instance.getDescImgsUrl(id){
            self.addLoader()
            Utils.fillTheData(imgurl, callback: { (data) in
                let item = DetailsDictionary(dataDict: dataDict, imgDict: data, type: type)
                defer{self.removeLoader()}
                self.processGroupedProduct(item)
                }, errorCallback: self.showError)
        }
    }
    
    override func showError() {
         ErrorHandler.Instance.showError()
         self.navigationController?.popViewController(animated: true)
    }
    
    func processGroupedProduct(_ itemDetails: DetailsDictionary?){
        if self.shoppingItem != nil{
            guard let _ = self.shoppingItem else{
                return
            }
            
            if let imagesArrayStr = itemDetails?.dataDict["image"] as? NSArray{
                self.shoppingItem?.otherImages = [String]()
                for i in 0 ..< imagesArrayStr.count{
                    self.shoppingItem?.otherImages.append(imagesArrayStr[i] as! String)
                }
            }
            
            if let sku = itemDetails?.dataDict["sku"] as? String{
                shoppingItem?.sku = sku
            }
            
            shoppingItem?.numInStock = Utils.stringToInt(itemDetails?.dataDict["quantity"] as? String ?? "0")
            
            if let description = itemDetails?.dataDict["description"] as? String{
                self.shoppingItem?.productDesc = description.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            }
            
            if let shortdesc = itemDetails?.dataDict["shortdes"] as? String {
                self.shoppingItem?.productShortDesc = shortdesc.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                
            }
            
            if let products = itemDetails?.dataDict["groupdata"] as? NSArray{
                for item in products{
                    if let itemDict = item as? NSDictionary{
                    let status = itemDict["status"] as? String
                    if(status == "1"){
                        if let groupedItem = StoreManager.Instance.createGroupedShoppingItem(item as! NSDictionary){
                            self.groupedItems.append(groupedItem)
                            if groupedItem.numInStock > 0 {
                                self.shoppingItem?.inStock = true
                            }
                        }
                    }
                }
                }
            }
        }
        self.groupProductTableView.reloadData()
    }
}


//MARK: Group product delegate
extension GroupedProductDetailViewController:GroupProductCellDelegate{
    
//    func didItemQuantityIncrease(itemId: Int) -> (Int) {
//        var count = 1
//        if let item = StoreManager.Instance.getShoppingItem(itemId){
//            count = item.selectedItemCount
//            if count != item.numInStock{
//                count += 1
//            }
//            item.setSelectedItemCountValue(count)
//        }
//        return count
//        
//    }
//    
//    func didItemQuantityDecreased(itemId: Int) -> (Int) {
//        var count = 1
//        if let item = StoreManager.Instance.getShoppingItem(itemId){
//            count = item.selectedItemCount
//            if count > 1{
//                count -= 1
//            }
//            item.setSelectedItemCountValue(count)
//        }
//        
//        return count
//    }
//    self.view.makeToast("Successfully Added")
//self.alert("Product already added to cart".localized())
    
    func shouldItemAddToCartd(_ itemId: Int) {
    
        if let item = StoreManager.Instance.getShoppingItem(itemId){
            let count = item.selectedItemCount
            if item.numInStock >= count {
                 Utils.addItemInCartWithSync(item, count: count, isfromByNow: false, controller: self)
                
             }else{
                self.alert("you have requested to add more than final quantity of this product.")
            }
        }
    }
    
    func shouldShowAlertMessage(_ msg: String) {
        self.view.makeToast(msg)
    }
}


//MARK: Group product delegate
extension GroupedProductDetailViewController:GroupProductCellDelegateRTL{
    
    //    func didItemQuantityIncrease(itemId: Int) -> (Int) {
    //        var count = 1
    //        if let item = StoreManager.Instance.getShoppingItem(itemId){
    //            count = item.selectedItemCount
    //            if count != item.numInStock{
    //                count += 1
    //            }
    //            item.setSelectedItemCountValue(count)
    //        }
    //        return count
    //
    //    }
    //
    //    func didItemQuantityDecreased(itemId: Int) -> (Int) {
    //        var count = 1
    //        if let item = StoreManager.Instance.getShoppingItem(itemId){
    //            count = item.selectedItemCount
    //            if count > 1{
    //                count -= 1
    //            }
    //            item.setSelectedItemCountValue(count)
    //        }
    //
    //        return count
    //    }
    //    self.view.makeToast("Successfully Added")
    //self.alert("Product already added to cart".localized())
    
    func shouldItemAddToCartdRTL(_ itemId: Int) {
        
        if let item = StoreManager.Instance.getShoppingItem(itemId){
            let count = item.selectedItemCount
            if item.numInStock >= count {
                Utils.addItemInCartWithSync(item, count: count, isfromByNow: false, controller: self)
                
            }else{
                self.alert("you have requested to add more than final quantity of this product.")
            }
        }
    }
    
    func shouldShowAlertMessageRTL(_ msg: String) {
        self.view.makeToast(msg)
    }
}


//MARK:-RTL
extension GroupedProductDetailViewController: GroupedProductDetailCellDelegate{
    func isServiceAvailable(_ pincode: String, completion: (Bool) -> Void) {
//        self.addLoader()
//        RESTClient.checkServiceAvailability(pincode) { (response, error) in
//            dispatch_async(dispatch_get_main_queue(), { 
//                self.removeLoader()    
//            })
//            var status = false
//            if error != nil{
//                completion(status)
//                return
//            }
//            
//            if let res = response as? NSArray {
//                status = res.firstObject as! Bool
//            }else{
//                status = response!["status"] as! Bool
//            }
//            if status {
//                dispatch_async(dispatch_get_main_queue(), { 
//                    self.isServiceAvailable = true
//                    self.groupProductTableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: .Automatic)
//                })
//            }
//            completion(status)
//        }
    }
    
    func pinTextFieldShouldEditing(_ textField: UITextField) {
        txtTemp = textField
        let keyboardDoneButtonShow = UIToolbar(frame: CGRect(x: 200,y: 200, width: self.view.frame.size.width,height: 30))
        keyboardDoneButtonShow.barStyle = UIBarStyle .blackTranslucent
        let button: UIButton = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 65, height: 20)
        button.setTitle("Done", for: UIControl.State())
        button.addTarget(self, action: #selector(GroupedProductDetailViewController.doneAction(_:)), for: UIControl.Event .touchUpInside)
        button.backgroundColor = UIColor.clear
        let doneButton: UIBarButtonItem = UIBarButtonItem()
        doneButton.customView = button
        let negativeSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: nil, action: nil)
        negativeSpace.width = -10.0
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let toolbarButton = [flexSpace,doneButton,negativeSpace]
        keyboardDoneButtonShow.setItems(toolbarButton, animated: false)
        textField.inputAccessoryView = keyboardDoneButtonShow
    }
    
    @IBAction func doneAction(_ sender:UIButton){
        if txtTemp != nil{
            txtTemp!.resignFirstResponder()
        }
        
    }
}

//MARK:
//MARK:-
extension GroupedProductDetailViewController {
    
    
    
}
