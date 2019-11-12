//
//  SortView.swift
//  SultanCenter
//
//  Created by mac on 20/07/16.
//  Copyright © 2016 mac. All rights reserved.
//
import UIKit
protocol sortItemDelegate {
    var sortButtonTag : Int { get set }
    func btnSortCatSelect(_ sender: AnyObject)
}

class SortView: UIView {
    
    var controller : UINavigationController?
    var delegate:sortItemDelegate?
    
    @IBOutlet var touchView: UIView!
    
    @IBOutlet var HtoLBtn: UIButton!
    @IBOutlet var LtoHBtn: UIButton!
    @IBOutlet var ZtoABtn: UIButton!
    @IBOutlet var AtoZButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "SortView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let tapGesture = UITapGestureRecognizer(target: self, action:#selector(SortView.tappedImageView(_:)))
        tapGesture.numberOfTapsRequired = 1
        isUserInteractionEnabled = true
        addGestureRecognizer(tapGesture)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        AtoZButton.setTitle("Name (A - Z)".localized(), for: UIControl.State())
        ZtoABtn.setTitle("Name (Z - A)".localized(), for: UIControl.State())
        LtoHBtn.setTitle("Price (Low - High)".localized(), for: UIControl.State())
        HtoLBtn.setTitle("Price (High - Low)".localized(), for: UIControl.State())
        
        if idForSelectedLangauge == Utils.getArebicLanguageCode() {
            AtoZButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0);
            AtoZButton.titleLabel!.transform = CGAffineTransform(scaleX: -1.0, y: 1.0);
            AtoZButton.imageView!.transform = CGAffineTransform(scaleX: -1.0, y: 1.0);
            
            ZtoABtn.transform = CGAffineTransform(scaleX: -1.0, y: 1.0);
            ZtoABtn.titleLabel!.transform = CGAffineTransform(scaleX: -1.0, y: 1.0);
            ZtoABtn.imageView!.transform = CGAffineTransform(scaleX: -1.0, y: 1.0);
            
            LtoHBtn.transform = CGAffineTransform(scaleX: -1.0, y: 1.0);
            LtoHBtn.titleLabel!.transform = CGAffineTransform(scaleX: -1.0, y: 1.0);
            LtoHBtn.imageView!.transform = CGAffineTransform(scaleX: -1.0, y: 1.0);
            
            HtoLBtn.transform = CGAffineTransform(scaleX: -1.0, y: 1.0);
            HtoLBtn.titleLabel!.transform = CGAffineTransform(scaleX: -1.0, y: 1.0);
            HtoLBtn.imageView!.transform = CGAffineTransform(scaleX: -1.0, y: 1.0);
        }else{
            
        }
        
    }
    
    
    func addGesture(_ view : UIView){
    }
    
    @objc func tappedImageView(_ sender: UITapGestureRecognizer) {
        
        self.removeFromSuperview()
        NotificationCenter.default.post(name: Notification.Name(rawValue: "RemoveSortView"), object: nil)
    }
    
    @IBAction func btnSortOptionPressed(_ sender:AnyObject){
        self.delegate?.sortButtonTag = sender.tag
        delegate?.btnSortCatSelect(sender)
        // let object : UIButton =  sender.object as! UIButton
        self.removeFromSuperview()
        NotificationCenter.default.post(name: Notification.Name(rawValue: "RemoveSortView"), object: nil)
    }
    
    
    func setBtnimage(){
        if let tag = self.delegate?.sortButtonTag{
            switch tag {
            case 10:
                AtoZButton.isSelected = true
                break
            case 20:
                ZtoABtn.isSelected = true
                break
            case 30:
                LtoHBtn.isSelected = true
                break
            case 40:
                HtoLBtn.isSelected = true
                break
                
            default:
                break
            }
        }
        
    }
}
