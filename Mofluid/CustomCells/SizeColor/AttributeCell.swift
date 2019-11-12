//
//  AttributeCell.swift
//  Mofluid
//
//  Created by Saurabh Mishra on 7/10/18.
//  Copyright © 2018 Mofluid. All rights reserved.
//

import UIKit
protocol AttributeDelegate {
    
    func clickedOnAttribute(title:String,option:String)
}
class AttributeCell: UITableViewCell {

    @IBOutlet var collectionView    :   UICollectionView!
    var delegate                    :   AttributeDelegate?
    //var optionsAvailable            :   Set<AttributePair>?
    var options                     :   [String]?
    var title                       :   String?
    var selectedIndex               :   Int?
    var sectionIndex                :   Int?
    let kSelectedBorderWidth        =   CGFloat(3.0)
    let kUnselectedBorderWidth      =   CGFloat(2.0)
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ColorCell", bundle: nil), forCellWithReuseIdentifier: "ColorCell")
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
        
        return (options?.count)!
    }
    //3
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //set custom cell
        let cell    =   self.collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for:indexPath) as! ColorCell
        if (selectedIndex != nil){
            
            if indexPath.row == selectedIndex{
                
                cell.btnCell.layer.borderColor  =   Settings().getButtonBgColor().cgColor
                cell.btnCell.layer.borderWidth  =   kSelectedBorderWidth
            }
            else{
                
                cell.btnCell.layer.borderColor  =    UIColor.gray.cgColor
                cell.btnCell.layer.borderWidth  =    kUnselectedBorderWidth
            }
        }
        setDataForCell(cell,indexPath: indexPath)
        return cell
    }
    func setDataForCell(_ cell:ColorCell, indexPath:IndexPath) {
        
        //set data
        //check if its color name or not
        if Helper().validateOptionName(options![indexPath.row]).status {
            
            cell.btnCell.backgroundColor    =   Helper().validateOptionName(options![indexPath.row]).color
            
        }
        else{
            
            cell.btnCell.backgroundColor    =   UIColor.clear
            cell.btnCell.setTitle(options?[indexPath.row], for: UIControl.State.normal)
        }
        cell.btnCell.tag    =   indexPath.row
        cell.btnCell.addTarget(self, action: #selector(clickedOnCell), for: .touchUpInside)
    }
    @objc func clickedOnCell(sender: UIButton){
        
        selectedIndex = sender.tag
        delegate?.clickedOnAttribute(title: title!, option: (options?[sender.tag])!)
        let indexPath = NSIndexPath(row: sender.tag, section: 0)
        collectionView.reloadItems(at: [indexPath as IndexPath])
        self.resetOtherCells()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //send delegate call
    }
    func resetOtherCells(){
        
        for i in 0..<options!.count {
            
            let indexPath = NSIndexPath(row: i, section: 0)
            collectionView.reloadItems(at: [indexPath as IndexPath])
        }
    }
}
