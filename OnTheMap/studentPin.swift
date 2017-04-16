//
//  studentPin.swift
//  OnTheMap
//
//  Created by Sahil Dhawan on 15/04/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//
import MapKit
import Foundation

class studentPin : NSObject,MKAnnotation
{
    var title: String? = ""
    var subtitle: String? = ""
    var coordinate : CLLocationCoordinate2D
    
    init(_ title: String, _ subtitle : String , _ coordinate : CLLocationCoordinate2D)
    {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
    
    func getLink() -> String
    {
        return subtitle!
    }
}
