//
//  ProfileVC.swift
//  Mofluid
//
//  Created by Saurabh Mishra on 13/08/18.
//  Copyright © 2018 Mofluid. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {
    
    @IBOutlet weak var lblContact               :           UILabel!
    @IBOutlet weak var lblEmail                 :           UILabel!
    @IBOutlet weak var lblName                  :           UILabel!
    @IBOutlet weak var lblPhPassword            :           UILabel!
    @IBOutlet weak var lblPhEmail               :           UILabel!
    @IBOutlet weak var lblAddress               :           UILabel!
    @IBOutlet weak var lblPhContact             :           UILabel!
    @IBOutlet weak var xMovable                 :           NSLayoutConstraint!
    @IBOutlet weak var viewSegment              :           UIView!
    @IBOutlet weak var viewMovable              :           UIView!
    @IBOutlet weak var btnDownload              :           UIButton!
    @IBOutlet weak var btnOrder                 :           UIButton!
    @IBOutlet weak var viewPassword             :           UIView!
    @IBOutlet weak var btnEditPassword          :           UIButton!
    @IBOutlet weak var btnEdit                  :           UIButton!
    @IBOutlet weak var tvMain                   :           UITableView!
    @IBOutlet weak var ivProfile                :           UIImageView!
    @IBOutlet weak var viewProfile              :           UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        initUi()
        // Do any additional setup after loading the view.
    }
    //MARK:- Init UI
    func initUi(){
        
        self.viewMovable.frame.size.width       =           viewSegment.frame.width/2
    }
    //MARK:- IBACTION
    @IBAction func clickEditPassword(_ sender: Any) {
        
        
    }
    @IBAction func clickEdit(_ sender: Any) {
        
        
    }
    @IBAction func clickDownloads(_ sender: Any) {
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.xMovable.constant   =   0
            self.view.layoutIfNeeded()
            
        }, completion: nil)
    }
    @IBAction func clickOrder(_ sender: Any) {
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.xMovable.constant   =   self.viewMovable.frame.width/2
            self.view.layoutIfNeeded()
            
        }, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
