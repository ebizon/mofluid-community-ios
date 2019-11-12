
import UIKit
import Foundation
import SloppySwiper

class searchViewController: UIViewController, UISearchBarDelegate{
    lazy var searchBar = UISearchBar(frame: CGRect(x: 30, y: 0, width: 200, height: 50))
    let swiper = SloppySwiper()
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        
        if navigationItem.leftBarButtonItems == nil {
            navigationItem.leftBarButtonItems = []
        }
        
        let _ = Utils.createSpacer()
        
        let leftNavBarButton = UIBarButtonItem(customView: searchBar)
        self.navigationItem.rightBarButtonItem = leftNavBarButton
        searchBar.delegate = self
        
        searchBar.becomeFirstResponder()
        searchBar.frame.size.width = self.view.frame.width - 60
        searchBar.showsCancelButton = false
        
        searchBar.tintColor = UIColor.orange
        
        self.view.backgroundColor = UIColor.lightGray
        navigationController?.navigationBar.barTintColor = UIColor.white
        
        self.navigationController?.delegate = swiper
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.resignFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool){
        self.searchBar.becomeFirstResponder()
        let spacer = Utils.createSpacer()
        let searchBarItem = UIBarButtonItem(customView: self.searchBar)
        if idForSelectedLangauge == Utils.getArebicLanguageCode() {
            navigationItem.leftBarButtonItem = searchBarItem
        }else{
            navigationItem.leftBarButtonItems?.insert(spacer, at: 0)
            self.navigationItem.rightBarButtonItem = searchBarItem
        }
        
        for subView in self.searchBar.subviews  {
            for subsubView in subView.subviews  {
                if let textField = subsubView as? UITextField {
                    var bounds = textField.frame
                    bounds.size.height = 40
                    textField.bounds = bounds
                    textField.borderStyle = UITextField.BorderStyle.roundedRect
                    textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
                    textField.font = UIFont(name: "Lato", size: 18)
                    
                    if idForSelectedLangauge == Utils.getArebicLanguageCode() {
                        textField.textAlignment = .right
                    }else{
                        textField.textAlignment = .left
                    }
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func addHeaderItem(_ spacer: UIBarButtonItem, callback: ()->UIBarButtonItem){
        assert(navigationItem.leftBarButtonItems != nil)
        
        navigationItem.leftBarButtonItems?.insert(callback(), at: 0)
        navigationItem.leftBarButtonItems?.insert(spacer, at: 0)
    }
    
    func createBackButton()->UIBarButtonItem{
        let backButtonButtonItem = UIBarButtonItem()
        let backButton = Utils.createBackButton()
        
        backButton.addTarget(self, action: #selector(searchViewController.backButtonAction(_:)), for: .touchUpInside)
        backButtonButtonItem.customView = backButton
        
        return backButtonButtonItem
    }
    
    func keyboardWillDisappear(_ notification: Notification){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func backButtonAction(_ button:UIButton) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        self.tabBarController?.selectedIndex = delegate.previousSelected!
        
        delegate.previousSelected = delegate.currentSelected
        delegate.currentSelected = self.tabBarController?.selectedIndex
        delegate.tabSelectedIndex =  delegate.currentSelected
        
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = self.searchBar.text{
            Utils.actOnSearch(text, viewCtrl:self)
        }
    }
}
