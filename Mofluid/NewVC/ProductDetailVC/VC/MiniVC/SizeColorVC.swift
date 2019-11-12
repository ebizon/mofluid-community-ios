//
//  SizeColorVC.swift
//  Mofluid
//
//  Created by Saurabh Mishra on 7/9/18.
//  Copyright © 2018 Mofluid. All rights reserved.
//

import UIKit
protocol SizeColorDelegate{
    
    func clickedOnSizeColorDelegate(title:String,value:String)
}
class SizeColorVC: UIViewController,StackContainable {
    @IBOutlet weak var tableView    : UITableView!
    var optionResult    :   (childShoppingItems: [Set<AttributePair>: ShoppingItem],configOptionName:[String])?
    var dataDict        :       NSDictionary!
    var delegate        :   SizeColorDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
        // Do any additional setup after loading the view.
    }
    //MARK:- INIT UI
    func setData(){
        
        tableView.register(UINib(nibName: "AttributeCell", bundle: nil), forCellReuseIdentifier: "AttributeCell")
        tableView.estimatedRowHeight = UITableView.automaticDimension
    }
    //MARK:- StackView Settings
    public func preferredAppearanceInStack() -> ScrollingStackController.ItemAppearance {
        let _ = self.view // force load of the view
        return .scroll(self.tableView!, insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
    public static func create() -> SizeColorVC {
        
        return SizeColorVC(nibName:"SizeColorVC",bundle: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
//MARK:- TABLEVIEW
extension SizeColorVC:UITableViewDataSource,UITableViewDelegate{
    
    //MARK:- TABLEVIEW METHODS
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return 40
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return (optionResult?.configOptionName.count)!
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 20
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "Select" + (self.optionResult?.configOptionName[section])!
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view                    =    UIView(frame: CGRect(x: 0, y: 2, width: tableView.bounds.width, height: 20))
        view.backgroundColor        =    .white
        let label                   =    UILabel(frame: CGRect(x: 5, y: 0, width: tableView.bounds.width - 30, height: 20))
        label.font                  =    UIFont(name:"Lato-Regular",size:15)
        label.textColor             =    UIColor.black
        label.text                  =    "Select" + " " + (self.optionResult?.configOptionName[section])!
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AttributeCell", for:indexPath) as! AttributeCell
        cell.backgroundColor    =   UIColor.clear
        cell.selectionStyle     =   UITableViewCell.SelectionStyle.none
        setDataForCell(cell,indexPath: indexPath)
        return cell
    }
    func setDataForCell(_ cell:AttributeCell, indexPath:IndexPath) {
        
        //set data
        let selectItem      =   self.optionResult?.configOptionName[indexPath.section]
        cell.options        =   ProductDetailVM().getAttributesForValue(value: selectItem!, set:(self.optionResult?.childShoppingItems)!)
        cell.title          =   selectItem
        cell.sectionIndex   =   indexPath.section
        cell.delegate       =   self
        cell.collectionView.reloadData()
    }
    //get options
}

extension SizeColorVC:AttributeDelegate{
    
    func clickedOnAttribute(title: String, option: String) {
        
        delegate?.clickedOnSizeColorDelegate(title: title, value:option)
    }
}
