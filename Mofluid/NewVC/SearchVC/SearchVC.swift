//
//  SearchVC.swift
//  Mofluid
//
//  Created by Saurabh Mishra on 20/08/18.
//  Copyright © 2018 Mofluid. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {
    
    @IBOutlet weak var tvList       :   UITableView!
    @IBOutlet weak var searchBar    :   UISearchBar!
    @IBOutlet weak var ivLoader     :   UIActivityIndicatorView!
    var item                        =   [ShoppingItem]()
    override func viewDidLoad() {
        super.viewDidLoad()
        ivLoader.isHidden           =   true
        self.navigationItem.title   =   Settings().search
        self.navigationController?.navigationBar.tintColor = .black
        let tempX           =   UINib(nibName: "SearchCell" , bundle: nil) //cellIdentifierTest
        tvList.register(tempX, forCellReuseIdentifier: "SearchCell")
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
       // searchBar.text=""
       // item.removeAll()
       // tvList.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension SearchVC:UITableViewDelegate,UITableViewDataSource{
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return item.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tvList.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchCell
        cell.ivProduct?.kf.setImage(with:URL(string: item[indexPath.row].image!))
        cell.lblName.text   =   item[indexPath.row].name
        cell.selectionStyle =   .none
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let productDtail            =   ProductVC(nibName: "ProductVC", bundle: nil)
        productDtail.shoppingItem   =   item[indexPath.row]
        self.navigationController?.pushViewController(productDtail, animated: true)
    }
}
