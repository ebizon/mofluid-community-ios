//
//  GroupListVC.swift
//  Mofluid
//
//  Created by Saurabh Mishra on 7/13/18.
//  Copyright © 2018 Mofluid. All rights reserved.
//

import UIKit

class GroupListVC: UIViewController {
    @IBOutlet weak var lblPlaceholder: UILabel!
    
    var shoppingItem                :       ShoppingItem?
    var groupedItems                =       [ShoppingItem]()
    @IBOutlet var tableView         :       UITableView!
    @IBOutlet var viewContainer     :       UIView!
    var myTabBarController          :       UITabBarController?
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialUi()
        self.tabBarItem =   myTabBarController?.tabBarItem
        // Do any additional setup after loading the view.
    }
    
    //MARK:- INIT UI
    func setInitialUi(){
        
        tableView.register(UINib(nibName: "GroupedProductCell", bundle: nil), forCellReuseIdentifier: "GroupedProductCell")
        tableView.estimatedRowHeight = UITableView.automaticDimension
        let tapGesture: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(GroupListVC.tapGestureRecognized(_:)))
        self.viewContainer.addGestureRecognizer(tapGesture)
        self.loadData()
    }
    //MARK:- Custom Methods
    func loadData(){
        
        Helper().addLoader(self)
        GroupProductVM().getProducts(shoppingItem!) { (status,response) in
            
            Helper().removeLoader()
            if status{
                
                self.groupedItems    =   GroupProductVM().parseGroupedData(self.shoppingItem!,(response as? NSDictionary)!)
                self.groupedItems.count > 0 ? (self.lblPlaceholder.isHidden=true) : (self.lblPlaceholder.isHidden=false)
                self.tableView.reloadData()
            }
            else{
                AJAlertController.initialization().showAlertWithOkButton(aStrMessage:Settings().errorMessage,vc:self)
                { (index, title) in
                    print(index,title)
                    self.presentingViewController?.dismiss(animated: true, completion:nil)
                }
            }
        }
    }
    //Tap gesture
    @objc func tapGestureRecognized(_ sender:UIPanGestureRecognizer) {
        self.dismiss(animated: true) {
        }
    }
    //add2cart
    func addToCart(_ item:ShoppingItem,_ qty:String){
        
        Helper().addLoader(self)
        CartRequestHandler().addToCart(item,Int(qty)!,vc:self,tabBar:myTabBarController!) { (response, status,message) in
            
            Helper().removeLoader()
            if status{
                
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
