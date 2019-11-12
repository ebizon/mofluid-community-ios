//
//  MyNavigationController.swift
//  SwiftSideMenu
//
//  Created by Evgeny Nazarov on 30.09.14.
//  Copyright (c) 2014 Evgeny Nazarov. All rights reserved.
//

import UIKit

class MyNavigationController: ENSideMenuNavigationController, ENSideMenuDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.alignMenu()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func alignMenu() {
        if (idForSelectedLangauge == Utils.getArebicLanguageCode()){
            sideMenu = ENSideMenu(sourceView: self.view, menuViewController: NewMyMenuTableViewController(), menuPosition:.right)
        }else{
            sideMenu = ENSideMenu(sourceView: self.view, menuViewController: NewMyMenuTableViewController(), menuPosition:.left)
        }
        
        sideMenu?.menuWidth = self.view.frame.width - 100
        
        view.bringSubviewToFront(navigationBar)
    }
}
