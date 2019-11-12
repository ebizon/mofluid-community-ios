//
//  ConstantPageViewController.swift
//  SultanCenter
//
//  Created by Shitanshu on 16/08/16.
//  Copyright © 2016 mac. All rights reserved.
//

import UIKit

class ConstantPageViewController: PageViewController {
    @IBOutlet weak var txtViewPage: UITextView!
    var pageId :Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        mainParentView.isHidden = true
        self.loadStoreData()
    }
    
    
    fileprivate func processData(_ dataDict: NSDictionary){
        defer{self.removeLoader()}
        self.view.isUserInteractionEnabled = true
        
        if let pageTitle = dataDict["title"] as? String{
            if let pageContent = dataDict["content"] as? String{
                DispatchQueue.main.async(execute: {() in
                    self.navigationItem.title = pageTitle.uppercased()
                    self.txtViewPage.attributedText = pageContent.utf8Data?.attributedString
                })
                
            }
            
        }
        
    }
    
    func loadStoreData() {
        if let pageId = pageId {
            let url =  WebApiManager.Instance.getCMSPageUrl(pageId)
            self.addLoader()
            
            Utils.fillTheData(url, callback: self.processData, errorCallback : self.showError)
        }
    }
    
    func backButtonFunction(){
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension Data {
    var attributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options:[.documentType : NSAttributedString.DocumentType.html,  .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
}
extension String {
    var utf8Data: Data? {
        return data(using: String.Encoding.utf8)
    }
}
