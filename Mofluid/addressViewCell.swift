//
//  addressViewCell.swift
//  Daily Jocks
//
//  Created by rohit on 07/06/16.
//  Copyright © 2016 Mofluid. All rights reserved.
//

import UIKit

protocol addressTableViewCellDelegate : class{
    func openEditPage()
    func removeAddress(id : Int)
}


class addressViewCell: UITableViewCell , UITextFieldDelegate , UITextViewDelegate {
    var addressId : Int?
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var addresLabel: UILabel!
    @IBOutlet weak var mobileLabel: UILabel!
    @IBOutlet weak var selectedAddress: UIImageView!
    
    weak var delegate : addressTableViewCellDelegate?
    
    @IBAction func edit(_ sender: UIButton) {
       self.delegate?.openEditPage()
    }
    @IBAction func remove(_ sender: Any) {
        if let id = self.addressId{
            self.delegate?.removeAddress(id: id)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectedAddress.isHidden = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func doSelect(){
        selectedAddress.isHidden = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func setAddressData(address : Address){
        self.translatesAutoresizingMaskIntoConstraints = true
        self.userName.text = address.getFullName()
        let street = address.getFullStreet().trimmingCharacters(in: CharacterSet.whitespaces)
        let ct = address.city.trimmingCharacters(in: CharacterSet.whitespaces)
        let st = address.region.name.trimmingCharacters(in: CharacterSet.whitespaces)
        let country = address.getCountryName()
        
        self.addresLabel.text = "\(street), \(ct), \(st), \(country), \(address.postCode)"
        //self.mobileLabel.text = address.telePhone
        self.addressId = address.id
        let finalString="\(street), \(ct), \(st), \(country), \(address.postCode)"+"\n"+"Mobile:\(address.telePhone)"
        
        let myAttributes1 = [ NSAttributedString.Key.foregroundColor: UIColor.gray ]
        let mainString = NSAttributedString(string: finalString, attributes: myAttributes1)
        self.addresLabel.attributedText=mainString
    }
    
    @IBAction func viewDetail(_ sender: UIButton) {
    }
}
