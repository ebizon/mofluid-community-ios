//
//  CountryVC.swift
//  Mofluid
//
//  Created by Saurabh Mishra on 30/07/18.
//  Copyright © 2018 Mofluid. All rights reserved.
//

import UIKit
protocol CountryDelegate {
    
    func clickedOnItem(title:Country,type:String)
}
class CountryVC: UIViewController {
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tvList: UITableView!
    @IBOutlet weak var viewContent: UIView!
    
    var type                    :       String?
    var delegate                :       CountryDelegate?
    let cellReuseIdentifier     =       "cell"
    var country                 =       [Country]()
    var isSearch                =       false
    var filteredArray           =       [Country]()
    var selectedValue           :       Country?
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialUi()
        // Do any additional setup after loading the view.
    }
    func setInitialUi(){
        
        self.tvList.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tvList.layer.cornerRadius       =   20.0
        viewContent.layer.cornerRadius  =   20.0
        lblTitle.font                   =   Settings().sectionFont
        lblTitle.text                   =   type == "Country" ? "Select Country" : "Select State"
    }
    //MARK: - IBACTIONS
    @IBAction func clickDone(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        selectedValue != nil ? delegate?.clickedOnItem(title: selectedValue!,type: type!) : print("")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension CountryVC:UITableViewDelegate,UITableViewDataSource{
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return isSearch == true ? filteredArray.count : country.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = (self.tvList.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell?)!
        cell.backgroundColor        =   UIColor.clear
        cell.textLabel?.text        =   isSearch == true ? filteredArray[indexPath.row].name : country[indexPath.row].name
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark

        if isSearch == true {
            
            selectedValue = filteredArray[indexPath.row]
        }
        else{
            
            selectedValue = country[indexPath.row]
        }
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return tableView == tableView ? UITableView.automaticDimension : 132
        return 50
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        //tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
}
extension CountryVC:UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        isSearch        =   true
        filteredArray   =   country
        tvList.reloadData()
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
       // isSearch    =   false
       // self.tvList.reloadData()
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        filteredArray.removeAll()
        filteredArray = country.filter { $0.name.lowercased().range(of: textField.text!.lowercased()) != nil}
        self.tvList.reloadData()
        return true
    }
}
