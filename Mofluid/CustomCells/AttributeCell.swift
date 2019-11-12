//
//  AttributeCell.swift
//  Mofluid
//
//  Created by Saurabh Mishra on 7/10/18.
//  Copyright © 2018 Mofluid. All rights reserved.
//

import UIKit

class AttributeCell: UITableViewCell {

    @IBOutlet var collectionView: UICollectionView!
    var optionsAvailable : [String]?
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ProductCell", bundle: nil), forCellWithReuseIdentifier: "ProductCell")
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension AttributeCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: Collection View
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    //2
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return (optionsAvailable?.count)!
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
        let item =  productsArray![indexPath.row]
        if item.isShowSpecialPrice(){
            
            let attributePrice =  NSMutableAttributedString(string: item.originalPriceStr!)
            attributePrice.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 1, range: NSMakeRange(0, attributePrice.length))
            attributePrice.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black, range: NSMakeRange(0, attributePrice.length))
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
        delegate?.tappedOnCell!(productsArray![indexPath.row])
    }
}
