//
//  OrderTableViewCell.swift
//  Daily Jocks
//
//  Created by rohit on 08/06/16.
//  Copyright © 2016 Mofluid. All rights reserved.
//

import UIKit

protocol OrderTableViewCellDelegate : class{
    func Reorder(_ order : OrderData)
    func viewDetailsOrder(_ order : OrderData)
}

class OrderTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource , SubOrderTableViewCellDelegate{
    
    @IBOutlet weak var orderLabel: UILabel!
    
    @IBOutlet weak var orderTableView: UITableView!
    var orderData : OrderData? = nil
    
    weak var delegate : OrderTableViewCellDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if idForSelectedLangauge == Utils.getArebicLanguageCode() {
            let subMyOrderNib  = UINib(nibName:"subMyOrderTableViewCell_RTL", bundle: Bundle.main)
            orderTableView.register(subMyOrderNib, forCellReuseIdentifier: "SUB_MY_ORDER_CELL")
        }else{
            let subMyOrderNib  = UINib(nibName:"subMyOrderTableViewCell", bundle: Bundle.main)
            orderTableView.register(subMyOrderNib, forCellReuseIdentifier: "SUB_MY_ORDER_CELL")
        }
        orderTableView.delegate = self
        orderTableView.dataSource = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setOrder(_ order : OrderData){
        
        self.orderData = order
        //        self.orderLabel.text = "   \(order.date)(\(order.id))" // Three extra space to align label text
        self.orderTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let order = self.orderData{
            return order.items.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SUB_MY_ORDER_CELL", for: indexPath) as! subMyOrderTableViewCell
        cell.delegate = self
        if let order = self.orderData{
            cell.timeANdDateLBl.text = "   \(order.date)(\(order.id))"
            cell.setOrder(order.items[indexPath.row], status: order.getStatus())
        }
        cell.orderData = self.orderData
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 140
    }
    
    func Reorder(_ order : OrderData){
        self.delegate?.Reorder(order)
    }
    func viewDetailsOrder(_ order : OrderData){
        self.delegate?.viewDetailsOrder(order)
    }
    
    @IBAction func viewDetailsAction(_ sender: AnyObject) {
        //        if let order = self.orderData{
        //            self.delegate?.viewDetailsOrder(order)
        //        }
    }
    
    
    @IBAction func canceOrderAction(_ sender: AnyObject) {
        //        if let order = self.orderData{
        //            self.delegate?.cancelOrder(order)
        //        }
    }
    
}
