//
//  UdacityUser.swift
//  OnTheMap
//
//  Created by Sahil Dhawan on 04/04/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import Foundation

class UdacityUser:NSObject
{
    
    override init()
    {
        super.init()
    }
    
    func udacityLogIn(_ email : String, _ password : String , completionHandler : @escaping (_ result:Data?, _ error : String?) ->Void)
    {
        
        let request = NSMutableURLRequest.init(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let httpBodyString = "{\"udacity\": {\"username\": \"" + email +  "\", \"password\": \"" + password + "\"}}"
//        print("\n" + httpBodyString + "\n")
        request.httpBody = httpBodyString.data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error…
                completionHandler(nil,error?.localizedDescription)
            }
            else
            {
                completionHandler(data,nil)
            }
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
            if error == nil {
                completionHandler(data,nil)
                return
            }
            else
            {
                completionHandler(nil,error?.localizedDescription)
            }
        }
        task.resume()
    }
}

