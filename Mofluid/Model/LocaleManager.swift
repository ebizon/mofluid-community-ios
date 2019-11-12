//
//  LocaleManager.swift
//  Mobilestic
//
//  Created by Ebizon-mac-2015 on 24/09/15.
//  Copyright (c) 2015 Ebizon Net. All rights reserved.
//

import Foundation

class Region{
    let id: String
    let name: String
    
    init(id: String, name: String){
        self.id = id
        self.name = name
    }
}

typealias Country = Region
typealias State = Region

class LocaleManager: NSObject {
    static var Instance : LocaleManager = LocaleManager()
    fileprivate(set) var _countryList = [Country]()
    fileprivate(set) var stateListMap = [String:[State]]()
    
    override init(){
        super.init()
        populateCountryList()
    }
    func reset(){
        
        LocaleManager.Instance  =   LocaleManager()
    }
    func getCountryList()->[Country]{
        return self._countryList
    }
    
    func getCountryNameByCode(_ code: String)->String?{
        let name = self._countryList.filter{$0.id == code}.first?.name
        
        return name
    }
    
    func getCountryCodeByName(_ name: String)->String?{
        let code =  self._countryList.filter{$0.name == name}.first?.id
        
        return code
    }
    
    func getStateNameByCode(_ countryCode : String, code: String)->String?{
        var name : String? = code
        
        let stateList = self.getStateList(countryCode)
        if !stateList.isEmpty{
            name = stateList.filter{$0.id == code}.first?.name
        }
        
        return name
    }
    
    func getStateCodeByName(_ countryCode : String, name: String)->String?{
        let stateList = self.getStateList(countryCode)
        let code =  stateList.filter{$0.name == name}.first?.id
        
        return code
    }
    
    func getStateList(_ countryCode: String)->[State]{
        
        if self.stateListMap[countryCode] == nil{
            self.stateListMap[countryCode] = [State]()
            if self.stateListMap[countryCode]!.isEmpty{
                if let url = WebApiManager.Instance.getStateListURL(countryCode){
                    self.fetchStateList(url, countryCode: countryCode)
                }
            }
        }
        
        return self.stateListMap[countryCode]!
    }
    
    fileprivate func fetchStateList(_ url: String, countryCode: String){
        if let data = WebApiManager.Instance.getJSON(url){
            if let dataDict = Utils.parseJSON(data){
                if let items = dataDict["mofluid_regions"] as? NSArray{
                    for item in items{
                        if let itemDict = item as? NSDictionary{
                            let id = itemDict["region_id"] as? String
                            let name = itemDict["region_name"] as? String
                            
                            if id != nil && name != nil{
                                self.stateListMap[countryCode]!.append(State(id: id!, name: name!))
                            }
                        }
                    }
                }
            }
        }
    }

    fileprivate func populateCountryList(){
        if let url = WebApiManager.Instance.getCountryListURL(){
            Utils.fillTheData(url, callback: parseCountryList, errorCallback: {
                //Empty
            })
        }
    }
    
    fileprivate func parseCountryList(_ dataDict: NSDictionary){
        self._countryList.removeAll(keepingCapacity: true)
        if let items = dataDict["mofluid_countries"] as? NSArray{
            for item in items{
                if let itemDict = item as? NSDictionary{
                    let id = itemDict["country_id"] as? String
                    let name = itemDict["country_name"] as? String
                    
                    if id != nil && name != nil{
                        self._countryList.append(Country(id: id!, name: name!))
                    }
                }
            }
        }
    }
}
