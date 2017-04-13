//
//  UdacityUser.swift
//  OnTheMap
//
//  Created by Sahil Dhawan on 04/04/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import Foundation
import MapKit
import UIKit


class UdacityUser:NSObject
{
    
    static var sessionId : String =  ""
    static var userId : String = ""
    
    
    func udacityLogIn(_ email : String, _ password : String , completionHandler : @escaping (_ result:Data?, _ error : String?) ->Void)
    {
        let request = NSMutableURLRequest.init(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let userDict = NSMutableDictionary()
        userDict.setValue(email, forKey: "username")
        userDict.setValue(password, forKey: "password")
        let udacityDict = NSMutableDictionary()
        udacityDict.setValue(userDict, forKey: "udacity")
        do
        {
            //creating data for httpBody
            let userData = try JSONSerialization.data(withJSONObject: udacityDict, options: .prettyPrinted)
            request.httpBody = userData
        }
        catch
        {
            print("cannot serialise udacity login data")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            guard (error == nil)
                else
            {
                completionHandler(nil,"There was an error with your request")
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                completionHandler(nil,"Your request returned a status code other than 2xx!")
                return
            }
            
            guard let data = data else
            {
                completionHandler(nil,"Could not fetch data")
                return
            }
            
            completionHandler(data,nil)
        }
        task.resume()
    }
    
    func gettingStudentDetails(_ userId : String, _ completionHandler:@escaping (_ result : Data?,_ errorString: String?)->Void)
    {
        var requestUrl = "https://www.udacity.com/api/users/"
        requestUrl.append(userId)
        print(requestUrl)
        let request = NSMutableURLRequest(url: URL(string:requestUrl)!)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            guard (error == nil)
                else
            {
                completionHandler(nil,"There was an error with your request")
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                completionHandler(nil,"Your request returned a status code other than 2xx!")
                return
            }
            
            guard let data = data else
            {
                completionHandler(nil,"Could not fetch data")
                return
            }
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range)
            completionHandler(newData,nil)
        }
        task.resume()
    }
    
    func udacityLogOut(completionHandler : @escaping (_ result : Data?, _ error : String?) -> Void)
    {
        
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            guard (error == nil)
                else
            {
                completionHandler(nil,"There was an error with your request")
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                completionHandler(nil,"Your request returned a status code other than 2xx!")
                return
            }
            
            guard let data = data else
            {
                completionHandler(nil,"Could not fetch data")
                return
            }
            
            completionHandler(data,nil)
        }
        task.resume()
    }
}

