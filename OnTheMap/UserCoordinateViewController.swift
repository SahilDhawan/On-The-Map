//
//  UserCoordinateViewController.swift
//  OnTheMap
//
//  Created by Sahil Dhawan on 05/04/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import UIKit
import MapKit

class UserCoordinateViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!

    var location = CLLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentAnnotation = MKPointAnnotation.init()
        currentAnnotation.coordinate = location.coordinate
        self.mapView.addAnnotation(currentAnnotation)
    }
}
