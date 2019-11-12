//
//  ChooseAddVC.swift
//  Mofluid
//
//  Created by Saurabh Mishra on 5/29/18.
//  Copyright © 2018 Mofluid. All rights reserved.
//

import UIKit

class ChooseAddVC: PageViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tblvList: UITableView!
    @IBOutlet weak var lblHeader: UILabel!
    var addressList = [Address]()
    var addressTag = 0
    var selectedCell:Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        lblHeader.font=UIFont (name: "Avenir-Book", size: 17)
        self.navigationItem.title = "CHOOSE ADDRESS".localized()
        tblvList.register(UINib(nibName: "AddressCell", bundle: nil), forCellReuseIdentifier: "AddressCell")
        super.createHeader()
        self.mainParentView.removeFromSuperview()
        self.loadAddress()
        // Do any additional setup after loading the view.
    }
    //MARK:- TABLEVIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return addressList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 198
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell", for:indexPath) as! AddressCell
        cell.btnEdit.addTarget(self, action: #selector(ChooseAddVC.editbtn), for: .touchUpInside)
        cell.btnEdit.tag=indexPath.row
        //cell.btnSelect.addTarget(self, action: #selector(ChooseAddVC.selectCell), for: .touchUpInside)
        //cell.btnSelect.tag=indexPath.row
        cell.btnRemove.addTarget(self, action: #selector(ChooseAddVC.deleteCell), for: .touchUpInside)
        cell.btnRemove.tag=indexPath.row
        cell.viewMain.layer.borderColor=UIColor.red.cgColor
        cell.selectionStyle = .none
        self.setDataInCell(cell: cell, indexPath:indexPath)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedCell=indexPath.row
        tblvList.reloadData()
    }
    //MARK:- CUSTOM METHOD
    func setDataInCell(cell:AddressCell,indexPath:IndexPath){
        
        cell.lblName.text=addressList[indexPath.row].getFullName()
        let street = addressList[indexPath.row].getFullStreet().trimmingCharacters(in: CharacterSet.whitespaces)
        let ct = addressList[indexPath.row].city.trimmingCharacters(in: CharacterSet.whitespaces)
        let st = addressList[indexPath.row].region.name.trimmingCharacters(in: CharacterSet.whitespaces)
        let country = addressList[indexPath.row].getCountryName()
        let finalString="\(street), \(ct), \(st), \(country), \(addressList[indexPath.row].postCode)"+"\n"+"Mobile:\(addressList[indexPath.row].telePhone)"
        cell.lblAddress.text=finalString
        cell.btnRemove.tag=addressList[indexPath.row].id
        if (selectedCell != nil){
            
            if indexPath.row==selectedCell{
                
                cell.viewMain.layer.borderWidth=2.0
                cell.viewMain.layer.borderColor=UIColor.red.cgColor
                cell.btnSelect.setImage(UIImage(named:"selcted"), for: UIControl.State.normal)
            }
        }
    }
    @objc func editbtn(_ sender: UIButton){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let buyNowObject = storyboard.instantiateViewController(withIdentifier: "buyNowViewController") as? buyNowViewController
        self.navigationController?.pushViewController(buyNowObject!, animated: true)
        
    }
    @objc func deleteCell(_ sender: UIButton){
        
        let refreshAlert = UIAlertController(title: "", message: "Are you sure want to delete this address?".localized(), preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "YES".localized(), style: .default, handler: { (action: UIAlertAction!) in
            
            self.deleteAddress(sender.tag)
            //add code here
        }))
        refreshAlert.addAction(UIAlertAction(title: "NO".localized(), style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        present(refreshAlert, animated: true, completion: nil)
    }
    func backButtonFunction(){
        self.navigationController?.popViewController(animated: true)
    }
    //MARK:- API
    func loadAddress(){
        
        self.addLoader()
        let url = WebApiManager.Instance.getAddressListURL()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {

            Utils.fillTheDataFromArray(url, callback: self.processAddresses, errorCallback : self.showError)
        }
    }
    func processAddresses(_ dataArray: NSArray){
        self.removeLoader()
        self.addressList.removeAll()
        
        dataArray.forEach { item in
            if let itemDict = item as? NSDictionary{
                if let address = Address.processAddress(dataDict: itemDict){
                    self.addressList.append(address)
                }
            }
        }
        tblvList.reloadData()
    }
    func deleteAddress(_ id:Int){
        
        self.addressList = self.addressList.filter{$0.id != id}
        tblvList.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
