//
//  Encoder.swift
//  Mofluid
//
//  Created by Ebizon-mac-2015 on 06/10/15.
//  Copyright © 2015 Mofluid. All rights reserved.
//

import Foundation

class Encoder{
    
    static func encodeBase64(_ data : Data?)->String?{
        let base64Encoded = data?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        
        return base64Encoded
    }
    
    static func encodeBase64(_ dataDict : NSDictionary)->String?{
        let jsonData = Encoder.createJSON(dataDict)
        let base64Encoded = Encoder.encodeBase64(jsonData)
        
        return base64Encoded
    }
    
    static func encodeBase64(_ str:String)->String{
        
        let data = str.data(using: String.Encoding.utf8)
        
        return data!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
    }
    
    static func encodeBase64(_ data : NSArray)->String?{
        let jsonData = Encoder.createJSON(data)
        let base64Encoded = Encoder.encodeBase64(jsonData)
        
        return base64Encoded
    }

    static func createJSON(_ object: AnyObject)->Data?{
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions(rawValue: 0))
            return jsonData
            
        } catch let error as NSError {
            print("json error: \(error.localizedDescription)")
            return nil
        }
    }
    
    static func encodeUTF8(_ text: String)->Data?{
        let utf8Encoded = text.data(using: String.Encoding.utf8)
        
        return utf8Encoded
    }
    
    static func decodeBase64ToDictionary(_ text:String)->NSDictionary{
        var rtrnDict = NSDictionary()
        let decodedData = Data(base64Encoded: text, options:NSData.Base64DecodingOptions(rawValue: 0))
        do {
            try rtrnDict = JSONSerialization.jsonObject(with: decodedData!, options: []) as! NSDictionary
            
        } catch let error as NSError {
            print(error)
        }
        return rtrnDict
    }
    static func decodeBase64String(_ text:String)->NSString{
        let decodedData = Data(base64Encoded: text, options:NSData.Base64DecodingOptions(rawValue: 0))
        let decodeString = NSString(data: decodedData!, encoding: String.Encoding.utf8.rawValue)
        return decodeString!
    }
}
