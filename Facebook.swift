//
//  FacebookConstants.swift
//  OnTheMap
//
//  Created by Sahil Dhawan on 07/04/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import Foundation
import FBSDKLoginKit


class Facebook : NSObject
{
    struct facebookConstants
    {
        static let facebookApiId : String = "365362206864879"
        static let facebookUrlSchemeSuffix = "onthemap"
        static var accessToken : String = ""
    }
    
    func postSession(completionHandler:@escaping(_ result : Data? ,_ errorString : String?) -> Void)
    {
        let facebookDict = NSMutableDictionary()
        facebookDict.setValue(facebookConstants.accessToken,forKey: "access_token")
        let dataDict = NSMutableDictionary()
        dataDict.setValue(facebookDict, forKey: "facebook_mobile")

        let urlString = ParseStudent.ParseConstants.urlString
        let url = URL(string:urlString)
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        print(dataDict)
        do
        {
            let data = try JSONSerialization.data(withJSONObject: dataDict, options: .prettyPrinted)
            request.httpBody = data
            print(NSString(data: data, encoding: String.Encoding.utf8.rawValue)!)
        }
        catch
        {
            print("cannot serialise facebook data")
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            if error != nil
            {
                completionHandler(nil,error?.localizedDescription)
            }
            else
            {
                let range = Range(uncheckedBounds: (5, data!.count-5))
                let newData = data?.subdata(in: range)
                print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
                completionHandler(newData,nil)
            }
        }
        task.resume()
    }
}
