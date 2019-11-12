//
//  RelatedProductsListVC.swift
//  Mofluid
//
//  Created by Saurabh Mishra on 7/3/18.
//  Copyright © 2018 Mofluid. All rights reserved.
//

import UIKit

class RelatedProductsListVC: UIViewController,StackContainable {

    var delegate:ProductCellDelegate?
    @IBOutlet weak var collectionView: UICollectionView!
    var productsArray = [ShoppingItem]()
    var shoppingItem  : ShoppingItem?       =   nil
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ProductCell", bundle: nil), forCellWithReuseIdentifier: "ProductCell")
        getRelatedProducts()
        // Do any additional setup after loading the view.
    }
    //MARK:- Call Api
    func getRelatedProducts(){
        
        let url = WebApiManager.Instance.getRelatedProductURL((self.shoppingItem?.id)!)
        ApiManager().getApi(url: url!) { (response, status) in
            
            if status{
                
                self.productsArray   =   ProductDetailVM().processRelatedProductData((response as? NSDictionary)!)
                self.collectionView.reloadData()
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    public static func create() -> RelatedProductsListVC {
        
        return RelatedProductsListVC(nibName:"RelatedProductsListVC",bundle: nil)
    }
}

//MARK:- Collection View Methods

extension RelatedProductsListVC:UICollectionViewDelegate,UICollectionViewDataSource{
    
    // MARK: Collection View
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    //2
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return (productsArray.count)
    }
    //3
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //set custom cell
        let cell=self.collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for:indexPath) as! ProductCell
        setDataForCell(cell,indexPath: indexPath)
        return cell
    }
    func setDataForCell(_ cell:ProductCell, indexPath:IndexPath) {
        
        //set data
        cell.lblPrice.text = ""
        cell.ivProduct.image = #imageLiteral(resourceName: "product_default_image")
        cell.lblName.text = ""
        let item =  productsArray[indexPath.row]
        if item.isShowSpecialPrice(){
            
            let attributePrice =  NSMutableAttributedString(string: item.originalPriceStr!)
            attributePrice.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributePrice.length))
            attributePrice.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: NSMakeRange(0, attributePrice.length))
            var priseString = NSMutableAttributedString()
            priseString = NSMutableAttributedString(string: "  \(item.priceStr)")
            attributePrice.append(priseString)
            cell.lblPrice.attributedText = attributePrice
            
        }else{
            cell.lblPrice.text = item.priceStr
        }
        cell.ivProduct?.kf.setImage(with:URL(string: item.image!))
        cell.lblName.text = item.name
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //send delegate call
        delegate?.tappedOnCell!(productsArray[indexPath.row])
    }
}
