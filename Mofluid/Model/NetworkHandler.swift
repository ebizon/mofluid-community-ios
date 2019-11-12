//
//  NetworkHandler.swift
//  Mofluid
//
//  Created by MANISH on 09/08/16.
//  Copyright © 2016 Mofluid. All rights reserved.
//

import Foundation


class NetworkHandler: NSObject {
    /********************************************************************************/
    static let Instance  = NetworkHandler()
    static let Timeout = 200.0
    weak var delgate : LoaderDelegate?
    /********************************************************************************/
    
    fileprivate override init(){
        super.init()
    }
    
    func getRequestToDictionary(_ url: String?, callback: @escaping (NSDictionary) -> Void, errorCallback: @escaping () -> Void){
        self.doRequest(url, requestType: "GET", body: nil, arraycCallback: nil, dictonaryCallback : callback, errorCallback: errorCallback)
    }
    
    func postRequestToDictionary(_ url: String?, callback: @escaping (NSDictionary) -> Void, errorCallback: @escaping () -> Void){
        self.doRequest(url, requestType: "POST", body: nil, arraycCallback: nil, dictonaryCallback : callback, errorCallback: errorCallback)
    }
    
    func getRequestToArray(_ url: String?, callback: @escaping (NSArray) -> Void, errorCallback: @escaping () -> Void){
        self.doRequest(url, requestType: "GET", body: nil,  arraycCallback: callback, dictonaryCallback : nil, errorCallback: errorCallback)
    }
    
    func postRequestToArray(_ url: String?, callback: @escaping (NSArray) -> Void, errorCallback: @escaping () -> Void){
        self.doRequest(url, requestType: "POST", body: nil, arraycCallback: callback, dictonaryCallback : nil, errorCallback: errorCallback)
    }

    fileprivate func jsonParseCallback(_ object : AnyObject,  arraycCallback: ((NSArray) -> Void)?, dictonaryCallback: ((NSDictionary) -> Void)?){
        if let dataDict = object as? NSDictionary{
            dictonaryCallback?(dataDict)
        }else if let dataArray = object as? NSArray{
            arraycCallback?(dataArray)
        }else{
            assert(false, "Unexpected type of JSON")
        }
    }
    
    fileprivate func doRequest(_ url: String?, requestType : String, body : Data?, arraycCallback: ((NSArray) -> Void)?, dictonaryCallback: ((NSDictionary) -> Void)?, errorCallback: @escaping () -> Void){
        
        assert(requestType == "POST" || requestType == "GET")
        
        if url != nil{
            if let nsurl = URL(string: url!){
                let request = NSMutableURLRequest(url: nsurl)
                request.timeoutInterval = NetworkHandler.Timeout
                request.httpMethod = requestType
                request.httpBody = body
                let appAccessKey = Config.Instance.getAppAccessKey()
                request.addValue(appAccessKey , forHTTPHeaderField: "Authorization")
                
                self.delgate?.addLoader()
                URLSession.shared.dataTask(with: request as URLRequest){(data, response, error) -> Void in
                    self.delgate?.removeLoader()
                    if error == nil{
                        if let dataObject = Utils.parseJSONToAnyObject(data!){
                            self.jsonParseCallback(dataObject, arraycCallback: arraycCallback, dictonaryCallback: dictonaryCallback)
                        }else{
                            errorCallback()
                        }
                    }else{
                        errorCallback()
                    }
                }.resume()
            }else{
                errorCallback()
            }
        }else{
            errorCallback()
        }
    }
}


