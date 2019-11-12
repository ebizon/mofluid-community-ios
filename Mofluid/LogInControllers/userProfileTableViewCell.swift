//
//  userProfileTableViewCell.swift
//  Daily Jocks
//
//  Created by rohit on 07/06/16.
//  Copyright © 2016 Mofluid. All rights reserved.
//

import UIKit

protocol UserProfileTableViewCellDelegate : class{
    func openEditPage(_ image : UIImage?)
}


class userProfileTableViewCell: UITableViewCell , UITextFieldDelegate , UITextViewDelegate {
    @IBOutlet weak var userProfilePic: UIImageView!
    
    @IBOutlet var editImage: UIImageView!
    @IBOutlet var currentPasswordLbl: UILabel!
    @IBOutlet weak var contactInfoTopConstraints: NSLayoutConstraint!
    
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet var changePasswordBtn: UIButton!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var contactNoTf: UITextField!
    @IBOutlet weak var addresstextView: UITextView!
    
    @IBOutlet weak var viewDetailButton: UIButton!
    @IBOutlet weak var addresLabel: UILabel!
    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet weak var emailIdTf: UITextField!
    let storyboard =  UIStoryboard()
    weak var delegate : UserProfileTableViewCellDelegate?
    
    @IBOutlet weak var logOutButton: UIButton!
    @IBAction func edit(_ sender: UIButton) {
        
        //        contactNoTf.userInteractionEnabled = !contactNoTf.userInteractionEnabled
        //        addresstextView.userInteractionEnabled = !addresstextView.userInteractionEnabled
        //        addresstextView.editable = !addresstextView.editable
    }
    
    
    @IBAction func toggleNotification(_ sender: UISwitch) {
        if sender.isOn{
            //            PushNotificationManager.pushManager().registerForPushNotifications()
            //            ViewUtils.alert("Push notifications turned on successfully")
        }else{
            //            PushNotificationManager.pushManager().unregisterForPushNotifications()
            //            ViewUtils.alert("Push notifications turned off successfully")
        }
        
        // UserInfo.savePushNotif(sender.on)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        uiSetUp()
        
        setUserData()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setUserData()
    }
    
    
    fileprivate func uiSetUp(){
        
        userProfilePic.layer.cornerRadius = userProfilePic.frame.size.width/2
        userProfilePic.contentMode = .scaleAspectFit
        contactNoTf.delegate = self
        addresstextView.delegate = self
        editButton.layer.cornerRadius = 3.0
        editButton.layer.masksToBounds = true
        
        if let user = UserManager.Instance.getUserInfo(){
            let logInType = String(describing: user.loginType)
            if logInType == "FacebookLogin" {
                currentPasswordLbl.text = "".localized() //PC
                currentPasswordLbl.text = ""
                changePasswordBtn.setTitle("", for: UIControl.State())
                changePasswordBtn.isEnabled  = false      //PC
                editImage.image = UIImage(named: "")
            }
            else if logInType == "GooglePlus"{
                currentPasswordLbl.text = "".localized() //PC
                currentPasswordLbl.text = ""
                changePasswordBtn.setTitle("", for: UIControl.State())
                changePasswordBtn.isEnabled  = false     //PC
                editImage.image = UIImage(named: "")
            }else{
                currentPasswordLbl.text = "Current Password".localized() //PC
            }
        }
        addGesture(userProfilePic)
   
        contactLabel.text =  "Contact Info".localized()
        emailLabel.text = "Email id".localized()
        logOutButton.setTitle("LOGOUT".localized(), for: UIControl.State())
        editButton.setTitle("Edit".localized(), for: UIControl.State())
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setImage(){
        
        
        // ankur comment
        //       let url = UserInfo.ProfileImageURL
        // let fileManager = NSFileManager.defaultManager()
        // if let path = url.path{
        //  if fileManager.fileExistsAtPath(path) {
        //    if let data = NSData(contentsOfURL: url){
        //      self.userProfilePic.image = UIImage(data: data)
        //}
        // }
        // }
    }
    func addGesture(_ itemView : UIView){
        let tapGesture = UITapGestureRecognizer(target: self, action:#selector(userProfileTableViewCell.tappedItemiew(_:)))
        tapGesture.numberOfTapsRequired = 1
        itemView.isUserInteractionEnabled = true
        itemView.addGestureRecognizer(tapGesture)
    }
    
    @objc func tappedItemiew(_ sender: UITapGestureRecognizer) {
        self.delegate?.openEditPage(self.userProfilePic.image)
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
    
    func setUserData(){
        
        
        self.translatesAutoresizingMaskIntoConstraints = true
        if let user = UserManager.Instance.getUserInfo(){
            if let address = user.billAddress{
                self.userName.text = "\(address.firstName) \(address.lastName)"
                let st = address.getFullStreet().trimmingCharacters(in: CharacterSet.whitespaces)
                let ct = address.city.trimmingCharacters(in: CharacterSet.whitespaces)
                let region = address.region.name.trimmingCharacters(in: CharacterSet.whitespaces)
                let country = address.getCountryName()
        
                self.addresLabel.text = "\(st), \(ct), \(region), \(country), \(address.postCode)"
                self.emailIdTf.text = user.userName
                self.contactNoTf.text = address.telePhone
            }else{
                
                contactInfoTopConstraints.constant = 40
                self.userName.text = user.firstName + " " + user.lastName
                if user.userName != ""
                {
                    self.emailIdTf.text = user.userName
                }
                self.contactNoTf.text = "NA"
                self.addresLabel.text = "NA"
            }
        }
    }
    
    @IBAction func viewDetail(_ sender: UIButton) {
    }
}
