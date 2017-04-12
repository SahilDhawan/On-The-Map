//
//  ParseStudent.swift
//  OnTheMap
//
//  Created by Sahil Dhawan on 04/04/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import Foundation
import UIKit

class ParseStudent:NSObject
{
    //MARK: getStudentLocation
    func getStudentLocations(completionHandler:@escaping(_ result:Data?, _ error: String?) -> Void)
    {
        //getting 100 locations only
        var urlString : String = ParseConstants.urlString
        urlString.append("?limit=100")
        
        let request = NSMutableURLRequest.init(url: URL(string:urlString)!)
        request.addValue(ParseConstants.apiKey, forHTTPHeaderField: ParseConstants.apiHeader)
        request.addValue(ParseConstants.applicationId, forHTTPHeaderField: ParseConstants.applicationHeader)
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request as URLRequest) { (data, response, error) in
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
    //MARK: postingStudentDetails
    func postingStudentDetails(completionHandler:@escaping(_ result : Data?, _ errorString : String?)->Void)
    {
        let request = NSMutableURLRequest(url: URL(string:ParseConstants.urlString)!)
        request.httpMethod = "POST"
        request.addValue(ParseConstants.apiKey, forHTTPHeaderField: ParseConstants.apiHeader)
        request.addValue(ParseConstants.applicationId, forHTTPHeaderField: ParseConstants.applicationHeader)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let dict = NSMutableDictionary()
        dict.setValue(StudentDetails.userId, forKey: "uniqueKey")
        dict.setValue(StudentDetails.firstName, forKey: "firstName")
        dict.setValue(StudentDetails.lastName, forKey: "lastName")
        dict.setValue(StudentDetails.webURL, forKey: "mediaURL")
        dict.setValue(StudentDetails.studentLocation.latitude, forKey: "latitude")
        dict.setValue(StudentDetails.studentLocation.longitude, forKey: "longitude")
        do
        {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            request.httpBody = jsonData
        }
        catch{}
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
    //MARK: puttingStudentDetails
    func puttingStudentDetails(completionHandler:@escaping(_ result : Data? , _ errorString: String?) ->Void)
    {
        var urlString : String = ParseConstants.urlString
        urlString.append(StudentDetails.objectId)
        let url = URL(string:urlString)
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "PUT"
        request.addValue(ParseConstants.apiKey, forHTTPHeaderField: ParseConstants.apiHeader)
        request.addValue(ParseConstants.applicationId, forHTTPHeaderField: ParseConstants.applicationHeader)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let dict = NSMutableDictionary()
        dict.setValue(StudentDetails.userId, forKey: "uniqueKey")
        dict.setValue(StudentDetails.firstName, forKey: "firstName")
        dict.setValue(StudentDetails.lastName, forKey: "lastName")
        dict.setValue(StudentDetails.webURL, forKey: "mediaURL")
        dict.setValue(StudentDetails.studentLocation.latitude, forKey: "latitude")
        dict.setValue(StudentDetails.studentLocation.longitude, forKey: "longitude")
        do
        {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            request.httpBody = jsonData
            print(jsonData)
        }
        catch{}
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
