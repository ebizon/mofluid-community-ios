//
//  FiltersViewController.swift
//  Mofluid
//
//  Created by Vivek Shukla on 11/07/16.
//  Copyright © 2016 Mofluid. All rights reserved.
//

import UIKit

class FiltersViewController: UIViewController, UITableViewDelegate ,UITableViewDataSource {
    var arrFilterData = [FiltersAttributeData]()
    var selectedFilterTypeIndex : Int = 0
    @IBOutlet weak var filterTableView: UITableView!
    @IBOutlet weak var SelectProductTableView: UITableView!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var cancelBtnLeading: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tempX = UINib(nibName: "FilterByTableViewCell" , bundle: nil) //cellIdentifierTest
        filterTableView.register(tempX, forCellReuseIdentifier: "filterIdentifierCell")
        
        if idForSelectedLangauge == Utils.getArebicLanguageCode() {
            let tempY = UINib(nibName: "selectFilterTableViewCell_RTL" , bundle: nil) //cellIdentifierTest
            SelectProductTableView.register(tempY, forCellReuseIdentifier: "selectFilterCell")
            cancelBtnLeading.constant = UIScreen.main.bounds.width - cancelButton.bounds.width - 15
        }else{
            let tempY = UINib(nibName: "selectFilterTableViewCell" , bundle: nil) //cellIdentifierTest
            SelectProductTableView.register(tempY, forCellReuseIdentifier: "selectFilterCell")
        }
        
        cancelButton.setTitle("Cancel".localized(), for: UIControl.State())
        filterTableView.estimatedRowHeight = 40
        filterTableView.rowHeight = UITableView.automaticDimension
        SelectProductTableView.estimatedRowHeight = 40
        SelectProductTableView.rowHeight = UITableView.automaticDimension
        
        if idForSelectedLangauge == Utils.getArebicLanguageCode() {
            resetButton.setTitle("Apply".localized(), for: UIControl.State())
            resetButton.tag = 4
            resetButton.backgroundColor = UIColor(red: 223.0/255.0, green: 114.0/255.0, blue: 114.0/255.0, alpha: 1.0)
            
            applyButton.setTitle("Reset".localized(), for: UIControl.State())
            applyButton.tag = 5
            applyButton.backgroundColor = UIColor(red: 144/255.0, green: 144/255.0, blue: 144/255.0, alpha: 1.0)
        }else{
            resetButton.setTitle("Reset".localized(), for: UIControl.State())
            resetButton.tag = 5
            resetButton.backgroundColor = UIColor(red: 144/255.0, green: 144/255.0, blue: 144/255.0, alpha: 1.0)
            
            applyButton.setTitle("Apply".localized(), for: UIControl.State())
            applyButton.tag = 4
            applyButton.backgroundColor = UIColor(red: 223.0/255.0, green: 114.0/255.0, blue: 114.0/255.0, alpha: 1.0)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == filterTableView {
            if idForSelectedLangauge == Utils.getArebicLanguageCode() {
                return arrFilterData[selectedFilterTypeIndex].attributeValue.count
            }else{
                return arrFilterData.count
            }
        } else {
            if idForSelectedLangauge == Utils.getArebicLanguageCode(){
                return arrFilterData.count
            }else{
                return arrFilterData[selectedFilterTypeIndex].attributeValue.count
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView  == filterTableView{
            if idForSelectedLangauge == Utils.getArebicLanguageCode() {
                let myCell = SelectProductTableView.dequeueReusableCell(withIdentifier: "selectFilterCell", for: indexPath) as! selectFilterTableViewCell
                let attributeVal = arrFilterData[selectedFilterTypeIndex].attributeValue[indexPath.row]
                myCell.btnRadio.isSelected = attributeVal.isSelected
                myCell.selectFilterItemLabel.text  = attributeVal.name
              
                return myCell
            }else{
                let myCell = filterTableView.dequeueReusableCell(withIdentifier: "filterIdentifierCell", for: indexPath) as! FilterByTableViewCell
                if(indexPath.row == selectedFilterTypeIndex){
                    tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
                }

                myCell.lblTitle.text = arrFilterData[indexPath.row].name
                return myCell
            }
        }else{
            if idForSelectedLangauge == Utils.getArebicLanguageCode() {
                let myCell = filterTableView.dequeueReusableCell(withIdentifier: "filterIdentifierCell", for: indexPath) as! FilterByTableViewCell
                if(indexPath.row == selectedFilterTypeIndex){
                    tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
                }
                
                myCell.lblTitle.text = arrFilterData[indexPath.row].name
                return myCell
            }else{
                let myCell = SelectProductTableView.dequeueReusableCell(withIdentifier: "selectFilterCell", for: indexPath) as! selectFilterTableViewCell
                let attributeVal = arrFilterData[selectedFilterTypeIndex].attributeValue[indexPath.row]
                myCell.btnRadio.isSelected = attributeVal.isSelected
                myCell.selectFilterItemLabel.text  = attributeVal.name
            
                return myCell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if idForSelectedLangauge == Utils.getArebicLanguageCode() {
            if tableView == filterTableView {
                let attributeVal = arrFilterData[selectedFilterTypeIndex].attributeValue[indexPath.row]
                let isselected = attributeVal.isSelected
                attributeVal.setValueOfIsselcted(!isselected)
                
                filterTableView.reloadData()
            }else{
                selectedFilterTypeIndex = indexPath.row
                filterTableView.reloadData()
                filterTableView.contentOffset = CGPoint(x: 0, y: 0)
            }
        }else{
            if tableView == filterTableView {
                selectedFilterTypeIndex = indexPath.row
                SelectProductTableView.reloadData()
                SelectProductTableView.contentOffset = CGPoint(x: 0, y: 0)
            }else{
                let attributeVal = arrFilterData[selectedFilterTypeIndex].attributeValue[indexPath.row]
                let isselected = attributeVal.isSelected
                attributeVal.setValueOfIsselcted(!isselected)
                
                SelectProductTableView.reloadData()
            }
        }
    }

    @IBAction func backBtn(_ sender: AnyObject) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func btnResetApplyPressed(_ sender: AnyObject) {
        // In case of RTL : // tag 5 for reset and 4 for apply button
        // tag 4 for reset and 5 for apply button
        //  let dict : FiltersAttributeData = arrFilterData.objectAtIndex(selectedFilterTypeIndex) as! FiltersAttributeData
        
        if(sender.tag == 4){ // apply
            let arrFilterVal = NSMutableArray()
            arrFilterData.forEach{filterAttribute in
                var filterAttributeValString = String()
                filterAttribute.attributeValue.forEach{attributeval in
                    if  attributeval.isSelected {
                        if filterAttributeValString.isEmpty {
                            filterAttributeValString = attributeval.id
                        }else{
                            filterAttributeValString = filterAttributeValString + ",\(attributeval.id)"
                        }
                    }
                }
                if filterAttributeValString.isEmpty == false {
                    let filterDict = ["code": filterAttribute.id,"id": filterAttributeValString]
                    arrFilterVal.add(filterDict)
                }
            }
            
            if(arrFilterVal.count > 0){
                self.dismiss(animated: false, completion: nil)
                let notifDict = ["btnSender": sender,"filterValue": arrFilterVal]
                NotificationCenter.default.post(name: Notification.Name(rawValue: "FilterActionNotification"), object: notifDict)
            }else{
                let alert = UIAlertController(title: "", message: "Please select filter value".localized(), preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "OK".localized(), style: .default, handler: { (action: UIAlertAction!) in
                    //Nothing
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
        else{ // reset
            resetFilters()
            self.dismiss(animated: false, completion: nil)
            let notifDict = ["btnSender": sender,"filterValue": NSArray()]
            NotificationCenter.default.post(name: Notification.Name(rawValue: "FilterActionNotification"), object: notifDict)
        }
    }
    
    fileprivate func resetFilters(){
        arrFilterData.forEach{filterAttribute in filterAttribute.attributeValue.forEach{attribute in attribute.isSelected=false}}
    }
}
