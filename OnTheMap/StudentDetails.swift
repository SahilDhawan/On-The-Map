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
    static var firstName : String
    {
        get
        {
            return StudentDetails.firstName
        }
        set
        {
            StudentDetails.firstName = newValue
        }
    }
    static var objectId : String
        {
        get
        {
            return StudentDetails.objectId
        }
        set
        {
            StudentDetails.objectId = newValue
        }
    }
    static var userId : String
        {
        get
        {
            return StudentDetails.userId
        }
        set
        {
            StudentDetails.userId = newValue
        }
    }
    static var lastName : String
        {
        get
        {
            return StudentDetails.lastName
        }
        set
        {
            StudentDetails.lastName = newValue
        }
    }
    static var mapString : String
        {
        get
        {
            return StudentDetails.mapString
        }
        set
        {
            StudentDetails.mapString = newValue
        }
    }
    static var webURL:String
        {
        get
        {
            return StudentDetails.webURL
        }
        set
        {
            StudentDetails.webURL = newValue
        }
    }
    static var studentLocation : CLLocationCoordinate2D
        {
        get
        {
            return StudentDetails.studentLocation
        }
        set
        {
            StudentDetails.studentLocation = newValue
        }
    }
    static var createdAt : Date
        {
        get
        {
            return StudentDetails.createdAt
        }
        set
        {
            StudentDetails.createdAt = newValue
        }
    }
    static var updatedAt : Date
        {
        get
        {
            return StudentDetails.updatedAt
        }
        set
        {
            StudentDetails.updatedAt = newValue
        }
    }
    static var studentDetail : Bool
        {
        get
        {
            return StudentDetails.studentDetail
        }
        set
        {
            StudentDetails.studentDetail = newValue
        }
    }
    
    init(_ StudentData : [String:AnyObject])
    {
        if let firstName = StudentData["firstName"]
        {
            StudentDetails.firstName =  firstName as! String
        }
        if let lastName = StudentData["lastName"]
        {
            StudentDetails.lastName =  lastName as! String
        }
        if let mapString = StudentData["mapString"]
        {
            StudentDetails.mapString = mapString as! String
        }
        if let webURL = StudentData["webURL"]
        {
            StudentDetails.webURL = webURL as! String
        }
        if let studentLocation  = StudentData["studentLocation"]
        {
            StudentDetails.studentLocation = studentLocation as! CLLocationCoordinate2D
        }
        if let createdAt  = StudentData["createdAt"]
        {
            StudentDetails.createdAt = createdAt as! Date
        }
        if let updatedAt  = StudentData["updatedAt"]
        {
            StudentDetails.updatedAt = updatedAt as! Date
        }
        if let objectId  = StudentData["objectId"]
        {
            StudentDetails.objectId = objectId as! String
        }
        if let userId  = StudentData["userId"]
        {
            StudentDetails.userId = userId as! String
        }
    }
    
}
