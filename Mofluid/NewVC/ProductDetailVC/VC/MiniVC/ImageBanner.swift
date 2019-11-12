//
//  ImageBanner.swift
//  Mofluid
//
//  Created by Saurabh Mishra on 7/3/18.
//  Copyright © 2018 Mofluid. All rights reserved.
//

import UIKit
protocol ImageBannerDelegate{
    
    func clickedOnShare(_ image:String)
}
class ImageBanner: UIViewController,StackContainable,UIScrollViewDelegate {
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var pageControl      :   UIPageControl!
    @IBOutlet weak var svScrollView     :   UIScrollView!
    var delegate                        :   ImageBannerDelegate?
    var shoppingItem                    :   ShoppingItem?              =   nil
    var imagesArray                                                    =  [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        loader.isHidden       = false
        svScrollView.delegate = self
        self.loadImages()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.view.isUserInteractionEnabled  =   true
    }
    //MARK:- INIT UI
    func renderImageOnScroll(){
        
        configurePageControl()
        loader.isHidden    =   true
        for i in 0..<imagesArray.count {
            
            let imageView               = UIImageView()
            let x = self.view.frame.size.width * CGFloat(i)
            imageView.frame             = CGRect(x: x, y: 0, width: self.view.frame.width, height: svScrollView.frame.size.width)
            imageView.contentMode       = .scaleAspectFit
            imageView.kf.setImage(with: URL(string: imagesArray[i]), placeholder: #imageLiteral(resourceName: "product_default_image"))
            let tapGestureRecognizer    = UITapGestureRecognizer(target:self, action:#selector(ImageBanner.imageTapped(_:)))
            imageView.isUserInteractionEnabled      =       true
            imageView.addGestureRecognizer(tapGestureRecognizer)
            svScrollView.contentSize.width          =       svScrollView.frame.size.width * CGFloat(i + 1)
            svScrollView.addSubview(imageView)
        }
        pageControl.currentPage = 0
    }
    func loadImages(){
        
        guard let item = self.shoppingItem else{
            return
        }
        if let imgDict = CacheManager.Instance.getimageDetail(item.id){
            self.processLoadingImage(imgDict)
        }
        else{
            if let id = self.shoppingItem?.id{
                
                if  let imgurl = WebApiManager.Instance.getDescImgsUrl(id){
                    
                    self.callImageApi(imgurl)
                }
            }
        }
    }
    
    @IBAction func clickOnShare(_ sender: Any) {
        
        delegate?.clickedOnShare(imagesArray[pageControl.currentPage])
    }
    //MARK:- ScrollView Methods
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let pageWidth   =   UIScreen.main.bounds.size.width - 60
        let page        =   Int(floor((svScrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        pageControl.currentPage     =      page
    }
    //MARK:- Custom Methods
    func processLoadingImage(_ imgDataDict : NSDictionary){
        
        imagesArray.removeAll()
        if let imagesArrayStr   =   imgDataDict["image"] as? NSArray{
            
            _ = imagesArrayStr.map{imagesArray.append($0 as? String ?? "")}
            self.renderImageOnScroll()
        }
        let id = self.shoppingItem?.id ?? 0
        CacheManager.Instance.addImageDetail(id, details: imgDataDict)
    }
    func configurePageControl() {
        // Set the total pages to the page control.
        pageControl.isHidden        =   false
        pageControl.numberOfPages   =   imagesArray.count
        // Set the initial page.
        pageControl.currentPage     =   0
    }
    @objc func imageTapped(_ img: AnyObject)
    {
        self.view.isUserInteractionEnabled  =   false
        let fullScreenImageView = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "FullImageViewController1") as! FullImageViewController1
        var array = NSArray()
        array = NSArray(array: imagesArray)
        fullScreenImageView.destinationView     =   self
        fullScreenImageView.arrayImages         =   array as? [String] ?? []
        fullScreenImageView.indexOfImage        =   CGFloat(pageControl.currentPage)
        let firstVCView                         =   self.view as UIView?
        let thirdVCView                         =   fullScreenImageView.view as UIView?
        let window                              =   UIApplication.shared.keyWindow
        window?.insertSubview(thirdVCView!, belowSubview: firstVCView!)
        thirdVCView?.transform                  =   (thirdVCView?.transform.scaledBy(x: 0.001, y: 0.001))!
        UIView.animate(withDuration: 0.6, animations: { () -> Void in
        }, completion: { (Finished) -> Void in
            
            UIView.animate(withDuration: 0.6, animations: { () -> Void in
                thirdVCView?.transform          =   CGAffineTransform.identity
                
            }, completion: { (Finished) -> Void in
                self.present(fullScreenImageView as UIViewController, animated: false, completion: nil)
            })
        })
    }
    //MARK:- Api Call
    func callImageApi(_ url:String){
        
        ApiManager().getApi(url: url) { (response, status) in
            
            if status{
                
                self.processLoadingImage((response as? NSDictionary)!)
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    public static func create() -> ImageBanner {
        
        return ImageBanner(nibName:"ImageBanner",bundle: nil)
    }
}
