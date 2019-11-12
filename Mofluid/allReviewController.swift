//
//  allReviewController.swift
//  SultanCenter
//
//  Created by Vivek Shukla on 29/08/16.
//  Copyright © 2016 mac. All rights reserved.
//

import UIKit

class allReviewController: PageViewController, UITableViewDelegate,  UITableViewDataSource {
      var arrAllReviewData : [ProductReviewData] = [ProductReviewData]()    
    @IBOutlet var topView: UIView!
    @IBOutlet var writeReviewoutlet: UIButton!
    @IBOutlet weak var reviewTableView: UITableView!
    @IBOutlet weak var reviewTitleLabel: UILabel!
    
    @IBOutlet var writeReviewLeadingConstraint:NSLayoutConstraint!
    
    
    @IBAction func writeReviewBtn(_ sender: AnyObject) {
        
        if(UserManager.Instance.getUserInfo() != nil)
        {
            let myCartObject = WriteReviewViewController(nibName: "WriteReviewViewController" , bundle: Bundle.main)
            self.navigationController?.pushViewController(myCartObject, animated: true)
        }
        else
        {
            alert("Please Login to write review")
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        writeReviewoutlet.layer.masksToBounds = true
        writeReviewoutlet.layer.borderWidth = 2.0
        writeReviewoutlet.layer.cornerRadius = 4.0
        writeReviewoutlet.layer.borderColor = UIColor.black.cgColor
        
        
        
        mainParentView.isHidden = true
        mainParentScrollView.isHidden = true
        reviewTableView.estimatedRowHeight = 60
        reviewTableView.rowHeight = UITableView.automaticDimension
        self.navigationItem.title = "PRODUCT REVIEWS"
        
        if idForSelectedLangauge == Utils.getArebicLanguageCode(){
            let tempX = UINib(nibName: "ReviewTableViewCell_RTL" , bundle: nil) //cellIdentifierTest
            reviewTableView.register(tempX, forCellReuseIdentifier: "ReviewTableIdentifierCell")
            
            writeReviewLeadingConstraint.constant = UIScreen.main.bounds.width - writeReviewoutlet.bounds.width - 5
            writeReviewoutlet.updateConstraintsIfNeeded()
            reviewTitleLabel.textAlignment = .right
        }else{
            let tempX = UINib(nibName: "ReviewTableViewCell" , bundle: nil) //cellIdentifierTest
            reviewTableView.register(tempX, forCellReuseIdentifier: "ReviewTableIdentifierCell")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrAllReviewData.count
    }
    
    
    //
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let myCell2 = reviewTableView.dequeueReusableCell(withIdentifier: "ReviewTableIdentifierCell", for: indexPath) as! ReviewTableViewCell
        
        let data : ProductReviewData =  arrAllReviewData[indexPath.row]
        myCell2.ratingControlView.rating = Int(data.value)!
        myCell2.descriptionLbl.text = data.details
        myCell2.productNameLbl.text = data.title
        // myCell2.lb.text = data.value
        myCell2.nameAndDateLbl.text = "By : \(data.nickName)  |  \(Utils.getDateStringFromStringWithDateFormage(data.createDate as NSString))"
        
        
        
        return myCell2
        
    }
    func backButtonFunction()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
}
