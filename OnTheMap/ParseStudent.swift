//
//  ParseStudent.swift
//  OnTheMap
//
//  Created by Sahil Dhawan on 04/04/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import Foundation

class ParseStudent:NSObject
{
    func getStudentLocations(completionHandler:@escaping(_ result:Data?, _ error: String?) -> Void)
    {
        let request = NSMutableURLRequest.init(url: URL(string:"https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.addValue(ParseConstants.apiKey, forHTTPHeaderField: ParseConstants.apiHeader)
        request.addValue(ParseConstants.applicationId, forHTTPHeaderField: ParseConstants.applicationHeader)
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request as URLRequest) { (data, response, error) in
            if error == nil
            {
                completionHandler(data,nil)
            }
            else
            {
                completionHandler(nil,error?.localizedDescription)
            }
        }
        task.resume()
    }
}
