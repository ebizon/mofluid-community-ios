//
//  SetBannerAnimation.swift
//  Mofluid
//
//  Created by Saurabh Mishra on 26/06/18.
//  Copyright © 2018 Mofluid. All rights reserved.
//

import Foundation
import FSPagerView
class SetBannerAnimation{
    
    fileprivate let transformerNames = ["cross fading", "zoom out", "depth", "linear", "overlap", "ferris wheel", "inverted ferris wheel", "coverflow", "cubic"]
    fileprivate let transformerTypes: [FSPagerViewTransformerType] = [.crossFading,
                                                                      .zoomOut,
                                                                      .depth,
                                                                      .linear,
                                                                      .overlap,
                                                                      .ferrisWheel,
                                                                      .invertedFerrisWheel,
                                                                      .coverFlow,
                                                                      .cubic]
    func setAnimation(_ value:Int)->(view:FSPagerView,transform:CGAffineTransform){
        
        let pagerView = FSPagerView()
        let type = self.transformerTypes[value]
        var transform = CGAffineTransform()
        pagerView.transformer = FSPagerViewTransformer(type:type)
        switch type {
        case .crossFading, .zoomOut, .depth:
            pagerView.itemSize = .zero // 'Zero' means fill the size of parent
        case .linear, .overlap:
            transform = CGAffineTransform(scaleX: 0.6, y: 0.75)
            pagerView.itemSize = pagerView.frame.size.applying(transform)
        case .ferrisWheel, .invertedFerrisWheel:
            pagerView.itemSize = CGSize(width: 180, height: 140)
        case .coverFlow:
            pagerView.itemSize = CGSize(width: 220, height: 170)
        case .cubic:
            transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            pagerView.itemSize = pagerView.frame.size.applying(transform)
        }
        return (pagerView,transform)
    }
}
