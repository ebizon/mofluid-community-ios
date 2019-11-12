//
//  MofluidMainApp.swift
//  Mofluid
//
//  Created by Ebizon-mac-2015 on 24/09/15.
//  Copyright (c) 2015 Ebizon Net. All rights reserved.
//

import Foundation
import UIKit

@objc(MofluidMainApp) class MofluidMainApp: UIApplication {
    var time : Date = Date()
    
    override func sendEvent(_ event: UIEvent) {
        if event.type != .touches {
            super.sendEvent(event)
            return
        }
        
        super.sendEvent(event)
    }
}
