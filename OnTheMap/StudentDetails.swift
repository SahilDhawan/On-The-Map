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
    static var objectId : String = ""
    static var userId : String = ""
    static var firstName : String = ""
    static var lastName : String = ""
    static var mapString : String = ""
    static var webURL:String = ""
    static var studentLocation : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude:0,longitude:0)
    static var createdAt : NSDate = NSDate()
    static var updatedAt : NSDate = NSDate()
}
