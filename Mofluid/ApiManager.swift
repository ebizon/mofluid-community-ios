//
//  ApiManager.swift
//  MyRentBooking
//
//  Created by Saurabh  on 1/11/18.
//  Copyright © 2018 dogma. All rights reserved.
//

import UIKit

class ApiManager: NSObject {

    //get api
    func getApi(url:String,completion:@escaping(_ response:AnyObject,_ isSuccess:Bool)->Void){
        
        var request = URLRequest(url: URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)
        request.httpMethod = "GET"
        let appAccessKey = Config.Instance.getAppAccessKey()
        request.addValue(appAccessKey , forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            DispatchQueue.main.async() {
                if !(data==nil){
                    
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!) as AnyObject
                        completion(json,true)
                    } catch {
                        
                        completion(NSNull(),false)
                        print("error")
                    }
                }
                else{
                    completion(NSNull(),false)
                    print("error")
                }
           }
        })
        task.resume()
    }
    
    //post api
    func postApi(url:String,params:AnyObject,completion:@escaping(_ response:AnyObject,_ isSuccess:Bool)->Void){
        
        var request = URLRequest(url: URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)
        print(params)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let appAccessKey = Config.Instance.getAppAccessKey()
        request.addValue(appAccessKey , forHTTPHeaderField: "Authorization")
        
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            //print(response)
            DispatchQueue.main.async() {
            if((response) != nil){
                
                do {
                    
                    let json = try JSONSerialization.jsonObject(with: data!) as AnyObject
                    completion(json,true)
                
                } catch {
                    
                    completion(NSNull(),false)
                    print("error")
                }
            }
            }
        })
        task.resume()
    }
}
