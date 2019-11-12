//
//  ProductReviewVC.swift
//  Mofluid
//
//  Created by Saurabh Mishra on 7/3/18.
//  Copyright © 2018 Mofluid. All rights reserved.
//

import UIKit
protocol ReviewDelegate {
    
    func clickedOnReadAll(_ arrReviewData:[ProductReviewData])
    func clickedOnAddReview(_ title:String)
}

class ProductReviewVC: UIViewController,StackContainable {
    @IBOutlet weak var tvReview: UITableView!
    @IBOutlet weak var btnAddReview: UIButton!
    @IBOutlet weak var lblFirstReview: UILabel!
    var arrReviewData : [ProductReviewData] =   [ProductReviewData]()
    var shoppingItem  : ShoppingItem?       =   nil
    var delegate      : ReviewDelegate?
    let btnReadAll = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        tvReview.isHidden   =   true
        let tempX           =   UINib(nibName: "ReviewTableViewCell" , bundle: nil) //cellIdentifierTest
        tvReview.register(tempX, forCellReuseIdentifier: "ReviewTableIdentifierCell")
        getProductReview()
        setFooterView()
        // Do any additional setup after loading the view.
    }
    //MARK:- Custom Methods
    func setFooterView(){
        
        btnReadAll.frame.size.width         =       self.tvReview.frame.size.width
        btnReadAll.frame.size.height        =           50
        btnReadAll.backgroundColor          =       UIColor.clear
        btnReadAll.setTitle("Read all reviews >>".localized(), for: .normal)
        btnReadAll.setTitleColor(UIColor.black, for: .normal)
        btnReadAll.addTarget(self, action: #selector(self.readAllReviews), for: UIControl.Event.touchUpInside)
        self.tvReview.tableFooterView       =       btnReadAll
    }
    @objc func readAllReviews(){
        
        delegate?.clickedOnReadAll(arrReviewData)
    }
    //MARK:- IBACTION
    @IBAction func clickOnAddReview(_ sender: Any) {
        
        delegate?.clickedOnAddReview("clicked")
    }
    
    //MARK:- Call Api
    func getProductReview(){
        
        let url = WebApiManager.Instance.getProductReviewUrl((self.shoppingItem?.id)!)
        ApiManager().getApi(url: url!) { (response,status) in
            
            if status{
                
                self.arrReviewData              =       ProductDetailVM().processReviewData((response as? NSDictionary)!)
                self.lblFirstReview.isHidden    =       true
                self.tvReview.isHidden          =       false
                self.tvReview.reloadData()
            }
            else{
                
                self.lblFirstReview.isHidden    =       false
                self.tvReview.frame.size.height =       0
                self.btnReadAll.isHidden        =       true
                self.tvReview.isHidden          =       true
            }
        }
    }
    //MARK:- StackView Settings
    public func preferredAppearanceInStack() -> ScrollingStackController.ItemAppearance {
        let _ = self.view // force load of the view
        return .scroll(self.tvReview!, insets: UIEdgeInsets(top: 70, left: 0, bottom: 0, right: 0))
    }
    public static func create() -> ProductReviewVC {
        
        return ProductReviewVC(nibName:"ProductReviewVC",bundle: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
extension ProductReviewVC:UITableViewDelegate,UITableViewDataSource{
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return min(arrReviewData.count, 2)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tvReview.dequeueReusableCell(withIdentifier: "ReviewTableIdentifierCell", for: indexPath) as! ReviewTableViewCell
        let item                        =  arrReviewData[indexPath.row]
        cell.productNameLbl.text        =  item.title
        cell.descriptionLbl.text        =  item.details
        cell.ratingControlView.rating   =  Int(item.value)!
        cell.nameAndDateLbl.text        =  "By : \(item.nickName)  |  \(Utils.getDateStringFromStringWithDateFormage(item.createDate as NSString))"
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView == tvReview ? UITableView.automaticDimension : 40
    }
}
