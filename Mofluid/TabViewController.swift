//
//  TabViewController.swift
//  Mofluid
//
//  Created by Sadique_ebizon on 04/12/15.
//  Copyright © 2015 Mofluid. All rights reserved.
//

import UIKit

class TabViewController: UITabBarController,UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
//        int tabitem = tabBarController.selectedIndex;
//        [[tabBarController.viewControllers objectAtIndex:tabitem] popToRootViewControllerAnimated:YES];
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.tabSelectedIndex = self.tabBarController?.selectedIndex
        
        if(item.tag == 100){
            
            delegate.tabSelectedIndex = 0;
            
        }
        
        else if(item.tag == 101){
            
            delegate.tabSelectedIndex = 1;
            
        }
        
        else if(item.tag == 102){
              manageRootVc(2)
            delegate.tabSelectedIndex = 2;
        
        }
            
        else if(item.tag == 103){
            
             delegate.tabSelectedIndex = 3;
            
        }
       
    delegate.previousSelected = delegate.currentSelected
    delegate.currentSelected = delegate.tabSelectedIndex
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let index : Int = (tabBarController.viewControllers?.firstIndex(of: viewController))!
        if index == 0
        {
            let navigationController = viewController as? UINavigationController
            navigationController?.popToRootViewController(animated: true)
        }
        
    }
    
    func manageRootVc(_ index:Int) {
        let navVc = self.viewControllers![index] as! UINavigationController
        if UserDefaults.standard.bool(forKey: "isLogin") == false {
            setRootViewControllorOfWishlistNavigationVc(false,navVc: navVc);
            
        }else {
            setRootViewControllorOfWishlistNavigationVc(true,navVc:navVc);
            
        }
    }
    
    func setRootViewControllorOfWishlistNavigationVc(_ userLogedIn:Bool = false,navVc:UINavigationController) {
        var vcs = navVc.viewControllers
        vcs.removeAll()
        if userLogedIn {
            let profileView = ProfileViewController(nibName: "ProfileViewController", bundle: Bundle.main)
            vcs.insert(profileView, at: 0)
            
        }else {
            
            let loginObject = LoginVC(nibName: "LoginVC", bundle: Bundle.main)
            //let loginObject = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "loginViewController") as? loginViewController
            vcs.insert(loginObject, at: 0)
        }
        navVc.viewControllers = vcs
    }
}
