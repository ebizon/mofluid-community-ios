//
//  CustomOptionsVC.swift
//  Mofluid
//
//  Created by Saurabh Mishra on 17/08/18.
//  Copyright © 2018 Mofluid. All rights reserved.
//

import UIKit
protocol CustomOptionDelegate {
    
    func selectedValue(_ title:CustomOptionSet,_ selectedOption:CustomOption)
}
class CustomOptionsVC: UIViewController, StackContainable {

    @IBOutlet weak var tableView    :   UITableView!
    @IBOutlet weak var lblTitle     :   UILabel!
    var optionsValue                :   [CustomOptionSet]?
    var kHeight                     =   45
    var selectedRow                 =   1001
    var delegate                    :   CustomOptionDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        let tempX                   =   UINib(nibName: "OptionCell" , bundle: nil)
        tableView.register(tempX, forCellReuseIdentifier: "OptionCell")
        setInitData()
        // Do any additional setup after loading the view.
    }
    //MARK:- Set Data
    func setInitData(){
        
        if let _ = optionsValue{
            
            optionsValue![0].isRequired ? (lblTitle.text   =   optionsValue![0].name + ("*")) : (lblTitle.text   =   optionsValue![0].name)
        }
    }
    //MARK:- StackView Settings
    public static func create() -> CustomOptionsVC {
        
        return CustomOptionsVC(nibName:"CustomOptionsVC",bundle: nil)
    }
    public func preferredAppearanceInStack() -> ScrollingStackController.ItemAppearance {
        let _ = self.view // force load of the view
        return .view(height: CGFloat(kHeight*(optionsValue![0].options.count)))
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension CustomOptionsVC:UITableViewDelegate,UITableViewDataSource{
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return optionsValue![0].options.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell", for: indexPath) as! OptionCell
        cell.btnSelect.setTitle(optionsValue![0].options[indexPath.row].title.uppercased(), for: .normal)
        cell.delegate   =   self
        cell.tag        =   indexPath.row
        indexPath.row  == selectedRow ? (cell.ivCircle.image =   #imageLiteral(resourceName: "Radio-active"))   :   (cell.ivCircle.image =   #imageLiteral(resourceName: "unselect"))
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView == self.tableView ? UITableView.automaticDimension : CGFloat(kHeight)
    }
}
extension CustomOptionsVC:OptionDelegate{
    
    func clickedOnItem(_ tag: Int) {
        
        selectedRow =   tag
        delegate?.selectedValue(optionsValue![0],optionsValue![0].options[tag])
        self.tableView.reloadData()
    }
}
