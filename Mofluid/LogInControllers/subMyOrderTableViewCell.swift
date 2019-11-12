//
//  subMyOrderTableViewCell.swift
//  Daily Jocks
//
//  Created by rohit on 08/06/16.
//  Copyright © 2016 Mofluid. All rights reserved.
//

import UIKit
protocol SubOrderTableViewCellDelegate : class{
    func Reorder(_ order : OrderData)
    func viewDetailsOrder(_ order : OrderData)
}
class subMyOrderTableViewCell: UITableViewCell {
    var orderData : OrderData? = nil
    weak var delegate : SubOrderTableViewCellDelegate? = nil
    
    @IBOutlet var viewOrderBtnOutlet: UIButton!
    @IBOutlet var reorderBtnOutlet: UIButton!
    @IBOutlet var timeANdDateLBl: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var orderStatusImageView: UIImageView!
    @IBOutlet weak var orderStatusLabel: UILabel!
    @IBOutlet weak var orderId: UILabel!
    @IBOutlet weak var purchasedOn: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewOrderBtnOutlet.setTitle("View Order".localized(), for: UIControl.State())
        reorderBtnOutlet.setTitle("Reorder".localized(), for: UIControl.State())
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setOrder(_ order : OrderItem, status : String){
        UIImageCache.setImage(self.productImageView, image: order.image)
        self.productName.text = order.name
        self.priceLabel.text = "MVR" + order.price
        self.orderStatusLabel.text = status
        self.orderStatusImageView.image = UIImage(named: status)
    }
    
    @IBAction func cancelOrderAction(_ sender: AnyObject) {
        if let order = self.orderData{
            self.delegate?.Reorder(order)
        }
    }
    
    @IBAction func viewDetailsAction(_ sender: AnyObject) {
        if let order = self.orderData{
            self.delegate?.viewDetailsOrder(order)
        }
    }
}
