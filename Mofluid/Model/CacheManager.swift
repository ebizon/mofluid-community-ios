//
//  CacheManager.swift
//  Mofluid
//
//  Created by MANISH on 21/01/16.
//  Copyright © 2016 Mofluid. All rights reserved.
//

import Foundation


class CacheManager: NSObject {
    static var Instance : CacheManager = CacheManager()
    fileprivate(set) var detailsDictionaryMap = [Int: DetailsDictionary]()
    fileprivate(set) var imageDictMap = [Int: NSDictionary]()
    override init(){
        super.init()
    }
    func addImageDetail(_ id : Int, details : NSDictionary)
    {
      self.imageDictMap[id] = details
    }
    func reset(){
        
        CacheManager.Instance   =   CacheManager()
    }
    func addDetails(_ id : Int, details : DetailsDictionary){
        self.detailsDictionaryMap[id] = details
    }
    
    func getDetails(_ id: Int)->DetailsDictionary?{
        return self.detailsDictionaryMap[id]
    }
    
    func getimageDetail(_ id : Int) -> NSDictionary? {
        return self.imageDictMap[id]
    }
}
