//
//  GroupedProductDetailCell.swift
//  ForDentist
//
//  Created by Gaurav Rajput on 1/23/17.
//  Copyright © 2017 Mofluid. All rights reserved.
//

protocol GroupedProductDetailCellDelegate {
    func isServiceAvailable(_ pincode:String,completion:(Bool)->Void)
    func pinTextFieldShouldEditing(_ textField:UITextField)-> Void
    
}

class GroupedProductDetailCell: UITableViewCell, UITextFieldDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var productScrollView: UIScrollView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var pageControll: UIPageControl!
    @IBOutlet weak var stockLable: UILabel!
    @IBOutlet weak var descriptionLable: UILabel!
    @IBOutlet weak var itemTypeLabel: UILabel!
    
    var delegate:GroupedProductDetailCellDelegate?
    var myItem : ShoppingItem!
    var controller:UIViewController!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(_ item:ShoppingItem,contlr:UIViewController) {
        self.productName.text = item.name
        myItem = item
        controller = contlr
        // If multiple
        if item.otherImages.count > 0 {
            pageControll.numberOfPages = item.otherImages.count
            pageControll.currentPage = 0
            productScrollView.delegate = self
            productScrollView.contentSize = CGSize(width: productScrollView.bounds.width * CGFloat(item.otherImages.count), height: productScrollView.bounds.height)
            for i in 0...item.otherImages.count - 1{
                loadPage(i,images: item.otherImages)
            }
            productScrollView.bringSubviewToFront(pageControll)
        }
        self.stockLable.text = item.numInStock > 0 || item.inStock ? "In Stock" : "Out of Stock"
        self.descriptionLable.text = item.productDesc
        self.itemTypeLabel.text = item.type.capitalized
    }
    
    func loadPage(_ page: Int,images:[String]) {
        var frame = productScrollView.bounds
        frame.origin.x = frame.size.width * CGFloat(page)
        frame.origin.y = 0.0
        
        let newPageView = UIImageView()
        UIImageCache.setImage(newPageView, image: images[page])
        newPageView.contentMode = .scaleAspectFit
        newPageView.tag = page
        newPageView.frame = frame
        productScrollView.addSubview(newPageView)
    }
    
    func imageTapped(_ gesture: UITapGestureRecognizer)
    {
        //Double tap issue fixed
        let img = gesture.view as! UIImageView
        if gesture.state == .ended {
            let imageView = gesture.view as! UIImageView
            imageView.isUserInteractionEnabled = false
        }
        if gesture.state == .ended {
            let fullScreenImageView = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "FullImageViewController1") as! FullImageViewController1
            let array = NSArray(array: myItem.otherImages)
            
            fullScreenImageView.destinationView = controller
            fullScreenImageView.arrayImages = array as! [String]
            fullScreenImageView.indexOfImage = CGFloat(img.tag)
            
            let firstVCView = controller.view as UIView?
            let thirdVCView = fullScreenImageView.view as UIView?
            
            let window = UIApplication.shared.keyWindow
            window?.insertSubview(thirdVCView!, belowSubview: firstVCView!)
            
            thirdVCView?.transform = (thirdVCView!.transform.scaledBy(x: 0.001, y: 0.001))
            
            UIView.animate(withDuration: 0.6, animations: { () -> Void in
            }, completion: { (Finished) -> Void in
                UIView.animate(withDuration: 0.6, animations: { () -> Void in
                    thirdVCView?.transform = CGAffineTransform.identity
                    }, completion: { (Finished) -> Void in
                        self.controller.present(fullScreenImageView as UIViewController, animated: false, completion: nil)
                        let imageView = gesture.view as! UIImageView
                        imageView.isUserInteractionEnabled = true
                })
            }) 
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = self.productScrollView.frame.size.width
        let contentOffset = self.productScrollView.contentOffset
        let page : Int = Int(floor((contentOffset.x - (pageWidth/2)) / pageWidth) + 1)
        pageControll.currentPage = page
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        if productScrollView != nil{
            for view in productScrollView.subviews{
                view.removeFromSuperview()
            }
        }
    }

}



