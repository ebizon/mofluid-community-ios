//
//  WriteReviewViewController.swift
//  SultanCenter
//
//  Created by Shitanshu on 19/08/16.
//  Copyright © 2016 mac. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding

class WriteReviewViewController: UIViewController {
    
    
    @IBOutlet weak var ratingQTitleLabel: UILabel!
    
    @IBOutlet weak var qualityLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var reviewSummeryLabel: UILabel!
    @IBOutlet weak var thoughtsLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var PriceRatingContral: RatingControl!
    @IBOutlet weak var valueRatingContral: RatingControl!
    @IBOutlet weak var RatingContralQuailty: RatingControl!
    @IBOutlet weak var scrollView: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var yourThoughtTextView: UITextView!
    @IBOutlet weak var reviewSummaryTextField: UITextField!
    @IBOutlet weak var lblProductName: UILabel!
    
    
    
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var ratingViewRTL: UIView!
    
    var shoppingItem :ShoppingItem? = nil
    var activeField: UIView!
    var txtTemp : UITextField!
    var animationDuration :TimeInterval!
    var isViewAnimated :Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblProductName.text = shoppingItem?.name
        RatingContralQuailty.rating = 1
        valueRatingContral.rating = 1
        PriceRatingContral.rating = 1
        self.navigationItem.title = "WRITE REVIEW".localized()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ratingViewRTL.isHidden = true
        ratingView.isHidden = false
        
        ratingQTitleLabel.text = "how do you rate ths product ?".localized()
        qualityLabel.text = "Quality".localized()
        valueLabel.text = "Value".localized()
        priceLabel.text = "Price".localized()
        reviewSummeryLabel.text = "Review summary :".localized()
        thoughtsLabel.text = "Let us know your thought:".localized()
        nicknameLabel.text = "Your nickname :".localized()
        submitButton.setTitle("Submit".localized(), for: UIControl.State())
        if idForSelectedLangauge == Utils.getArebicLanguageCode() {
            self.updateUIForRTL()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if txtTemp != nil{
            txtTemp.resignFirstResponder()
        }
        super.viewDidDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func updateUIForRTL() {
        ratingQTitleLabel.textAlignment = .right
        qualityLabel.textAlignment = .right
        valueLabel.textAlignment = .right
        priceLabel.textAlignment = .right
        reviewSummeryLabel.textAlignment = .right
        thoughtsLabel.textAlignment = .right
        nicknameLabel.textAlignment = .right
        nickNameTextField.textAlignment = .right
        yourThoughtTextView.textAlignment = .right
        reviewSummaryTextField.textAlignment = .right
        lblProductName.textAlignment = .right
        ratingViewRTL.isHidden = false
        ratingView.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeField = textField
        txtTemp = textField
        return true
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        activeField = textView
        
        let keyboardDoneButtonShow = UIToolbar(frame: CGRect(x: 200,y: 200, width: self.view.frame.size.width,height: 30))
        
        // self.view.frame.size.height/17
        keyboardDoneButtonShow.barStyle = UIBarStyle .blackTranslucent
        let button: UIButton = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 65, height: 20)
        button.setTitle("Done", for: UIControl.State())
        button.addTarget(self, action: #selector(WriteReviewViewController.doneAction(_:)), for: UIControl.Event .touchUpInside)
        button.backgroundColor = UIColor.clear
        let doneButton: UIBarButtonItem = UIBarButtonItem()
        doneButton.customView = button
        let negativeSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: nil, action: nil)
        negativeSpace.width = -10.0
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let toolbarButton = [flexSpace,doneButton,negativeSpace]
        keyboardDoneButtonShow.setItems(toolbarButton, animated: false)
        textView.inputAccessoryView = keyboardDoneButtonShow
        
        return true
    }
    
    
    @IBAction func doneAction(_ sender:UIButton){
        yourThoughtTextView.resignFirstResponder()
    }
    
    
    @IBAction func btnSubmitReviewPressed(_ sender:UIButton){
        
        guard let textReview = reviewSummaryTextField.text, !textReview.isEmpty else {
            
            Helper().showAlert(self, message: "Please fill review summary".localized())
            return
        }
        
        guard let textThought = yourThoughtTextView.text, !textThought.isEmpty else {
            
            Helper().showAlert(self, message: "Please fill your thought".localized())
            return
        }
        
        guard let textNickName = nickNameTextField.text, !textNickName.isEmpty else {
            
            Helper().showAlert(self, message: "Please fill nickname".localized())
            return
        }
        
        assert(self.shoppingItem != nil)
        
        let url = WebApiManager.Instance.getSubmitReviewUrl(String(self.shoppingItem!.id), QualityRate: String(RatingContralQuailty.rating), valueRate: String(valueRatingContral.rating), priceRate: String(PriceRatingContral.rating), reviewSummary: Encoder.encodeBase64(textReview), thoughts: Encoder.encodeBase64(textThought), nickName: (textNickName))
        callPostReviewApi(url!)
    }
    func callPostReviewApi(_ url:String){
        
        Helper().addLoader(self)

        ApiManager().getApi(url: url) { (response,status) in
            
            if status{
                
                self.getResponceReviewSubmit((response as? NSDictionary)!)
            }
            else{
                
                Helper().showAlert(self, message:Settings().errorMessage)
            }
            Helper().removeLoader()
        }
    }
    fileprivate func getResponceReviewSubmit(_ dataDict: NSDictionary){
        defer{Helper().removeLoader()}
        print(dataDict)
        let status = dataDict["status"]as! String
        if status == "success" {
            let refreshAlert = UIAlertController(title: "", message: dataDict["review"] as? String, preferredStyle: UIAlertController.Style.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                self.navigationController?.popViewController(animated: true)
            }))
            present(refreshAlert, animated: true, completion: nil)
        }
    }
    
    
    func backButtonFunction()
    {
        self.navigationController?.popViewController(animated: true)
    }
}
