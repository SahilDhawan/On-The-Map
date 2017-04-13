//
//  StudentDetails.swift
//  OnTheMap
//
//  Created by Sahil Dhawan on 05/04/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import Foundation
import MapKit

struct StudentDetails
{
    var firstName : String = ""
    var objectId : String = ""
    var userId : String = ""
    var lastName : String = ""
    var mapString : String = ""
    var webURL : String = ""
    var studentLocation : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var createdAt : String = ""
    var updatedAt : String = ""
    static var studentDetail : Bool = false
    
    
    init(_ StudentData : [String:AnyObject])
    {
        if let firstName = StudentData["firstName"]
        {
            self.firstName =  firstName as! String
        }
        if let lastName = StudentData["lastName"]
        {
            self.lastName =  lastName as! String
        }
        if let mapString = StudentData["mapString"]
        {
            self.mapString = mapString as! String
        }
        if let webURL = StudentData["webURL"]
        {
            self.webURL = webURL as! String
        }
        if let studentLocation  = StudentData["studentLocation"]
        {
            self.studentLocation = studentLocation as! CLLocationCoordinate2D
        }
        if let createdAt  = StudentData["createdAt"]
        {
            self.createdAt = createdAt as! String
        }
        if let updatedAt  = StudentData["updatedAt"]
        {
            self.updatedAt = updatedAt as! String
        }
        if let objectId  = StudentData["objectId"]
        {
            self.objectId = objectId as! String
        }
        if let userId  = StudentData["userId"]
        {
            self.userId = userId as! String
        }
        if let studentDetail = StudentData["studentDetail"]
        {
            StudentDetails.studentDetail = studentDetail as! Bool
        }
        
    }
    
}

