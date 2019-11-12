//
//  OrdersOrTimeLineTableViewCell.swift
//  Daily Jocks
//
//  Created by rohit on 07/06/16.
//  Copyright © 2016 Mofluid. All rights reserved.
//

import UIKit
protocol OrdersOrTimeLineTableViewCellDelegate : class{
    // func openShopTheLook(timeLinePost : TimeLinePost)  // ankur comment
}

class OrdersOrTimeLineTableViewCell: UITableViewCell , UIScrollViewDelegate , UITableViewDelegate , UITableViewDataSource , UICollectionViewDelegate , UICollectionViewDataSource , //OrdersOrTimeLineTableViewCellDelegate ,
    OrderTableViewCellDelegate
{
    
    
    @IBOutlet weak var myOrderButton: UIButton!
    @IBOutlet weak var timeLineButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var timeLineLabel: UILabel!
    @IBOutlet weak var myOrderLabel: UILabel!
    
    @IBOutlet weak var myOrderTableView: UITableView!
    @IBOutlet weak var orderOrTimelineWidthConstraints: NSLayoutConstraint!
    
    @IBOutlet weak var timeLineCollectionView: UICollectionView!
    @IBOutlet weak var timeLineView: UIView!
    @IBOutlet weak var muOrderView: UIView!
    
    var orderList = [OrderData]()
    //   var timeLinePosts = [TimeLinePost]()  ankur comment
    weak var delegate : OrdersOrTimeLineTableViewCellDelegate? = nil
    weak var tableDelegate : OrderTableViewCellDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        timeLineButton.titleLabel?.textColor = UIColor.black
        self.scrollView.delegate = self
        let screenWidth = UIScreen.main.bounds.size.width
        orderOrTimelineWidthConstraints.constant = screenWidth    // ankur comment
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width * 6, height: 0)
        let subMyOrderNib  = UINib(nibName:"OrderTableViewCell", bundle: Bundle.main)
        myOrderTableView.register(subMyOrderNib, forCellReuseIdentifier: "OrderTableViewCell")
        myOrderTableView.delegate = self
        myOrderTableView.dataSource = self
        
        let timeLineCellNib  = UINib(nibName: "TimelineCollectionViewCell", bundle: Bundle.main)
        timeLineCollectionView.register(timeLineCellNib, forCellWithReuseIdentifier: "TIME_LINE_COLLECTION_CELL")
        timeLineCollectionView.delegate = self
        timeLineCollectionView.dataSource = self
        
        myOrderButton.setTitle("MY ORDERS".localized(), for: UIControl.State())
        timeLineButton.setTitle("MY DOWNLOADS".localized(), for: UIControl.State())
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //MARK: Actions
    
    @IBAction func clickedOnMyOrdr(_ sender: UIButton) {
        changTimelineToOrderScroll()
    }
    
    @IBAction func clickedOnTimeLine(_ sender: UIButton) {
        changOrderToTimelineScroll()
    }
    
    fileprivate  func reloadOrderUI()
    {
        myOrderButton.titleLabel?.textColor = UIColor.black
        timeLineButton.titleLabel?.textColor = UIColor.black
        myOrderLabel.isHidden = false
        timeLineLabel.isHidden = true
    }
    fileprivate func reloadTimelineUI()
    {
        myOrderButton.titleLabel?.textColor = UIColor.black
        timeLineButton.titleLabel?.textColor = UIColor.black
        myOrderLabel.isHidden = true
        timeLineLabel.isHidden = false
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
        
    {
        changeScrollOffset()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool){
        if(!decelerate) {
            
            changeScrollOffset()
        }
    }
    
    func changeScrollOffset()
    {
        if scrollView.contentOffset.x >  (UIScreen.main.bounds.size.width)/2 {
            changOrderToTimelineScroll()
            
        }else{
            changTimelineToOrderScroll()
            
        }
    }
    func changOrderToTimelineScroll()
    {
        var point  =  scrollView.contentOffset
        point.x = self.frame.size.width + 5
        reloadTimelineUI()
        scrollView.setContentOffset(point, animated: true)
    }
    
    func changTimelineToOrderScroll()
    {
        var point  =  scrollView.contentOffset
        point.x = 0
        reloadOrderUI()
        scrollView.setContentOffset(point, animated: true)
    }
    
    //MARK: Table view protocols
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orderList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell", for: indexPath) as! OrderTableViewCell
        
        cell.setOrder(self.orderList[indexPath.row])
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    //MARK:- Collection
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //  return timeLinePosts.count
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TIME_LINE_COLLECTION_CELL", for: indexPath) as! TimelineCollectionViewCell
        //let post = self.timeLinePosts[indexPath.row]
        //  UIImageCache.setImage(cell.productImageView, image: post.image)
        //cell.timeLinePost = post
        //  cell.delegate = self
        cell.layoutIfNeeded()
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let cellWidth: CGFloat = (UIScreen.main.bounds.size.width/3) - 10
        return CGSize(width: cellWidth, height: 110)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func setOrderList(_ orders : [OrderData]){
        self.orderList = orders
        self.myOrderTableView.reloadData()
        
    }
    //    
    //    func setTimeLines(timeLinePosts : [TimeLinePost]){
    //        
    //        self.timeLinePosts = timeLinePosts
    //        self.timeLineCollectionView.reloadData()
    //    }
    //    
    func createViewForNoProductsForTableCell(_ tempString : String , cell : OrderTableViewCell )
    {
        let viewOnCell = UIView()
        viewOnCell.frame = self.frame
        viewOnCell.backgroundColor = UIColor.white
        cell.addSubview(viewOnCell)
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.text =  tempString
        textLabel.font = UIFont(name:"Lato-Bold" , size: 10)
        textLabel.textColor =  UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 0.65)
        textLabel.backgroundColor = UIColor.clear
        viewOnCell.addSubview(textLabel)
        let horizontalCons = NSLayoutConstraint(item: textLabel   , attribute : NSLayoutConstraint.Attribute.centerY, relatedBy : NSLayoutConstraint.Relation.equal, toItem: viewOnCell, attribute : NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant : 0)
        let verticalyCentreCons = NSLayoutConstraint(item: textLabel   , attribute : NSLayoutConstraint.Attribute.centerX, relatedBy : NSLayoutConstraint.Relation.equal, toItem: viewOnCell, attribute : NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant : 0)
        
        
        cell.addConstraints([horizontalCons , verticalyCentreCons])
        
        //
        
    }
    
    func createViewForNoProductsForCollectionCell(_ tempString : String , timelineCollectionViewCell : TimelineCollectionViewCell)
    {
        let viewOnCell = UIView()
        viewOnCell.frame = self.frame
        viewOnCell.backgroundColor = UIColor.white
        timelineCollectionViewCell.addSubview(viewOnCell)
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.text =  tempString
        textLabel.font = UIFont(name:"Lato-Bold" , size: 10)
        textLabel.textColor =  UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 0.65)
        textLabel.backgroundColor = UIColor.clear
        viewOnCell.addSubview(textLabel)
        let horizontalCons = NSLayoutConstraint(item: textLabel   , attribute : NSLayoutConstraint.Attribute.centerY, relatedBy : NSLayoutConstraint.Relation.equal, toItem: viewOnCell, attribute : NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant : 0)
        let verticalyCentreCons = NSLayoutConstraint(item: textLabel   , attribute : NSLayoutConstraint.Attribute.centerX, relatedBy : NSLayoutConstraint.Relation.equal, toItem: viewOnCell, attribute : NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant : 0)
        
        timelineCollectionViewCell.addConstraints([horizontalCons , verticalyCentreCons])
        
        
    }
    
    func Reorder(_ order : OrderData){
        self.tableDelegate?.Reorder(order)
    }
    
    func viewDetailsOrder(_ order : OrderData){
        // ankur comment
        self.tableDelegate?.viewDetailsOrder(order)
    }
    
    
    
}
