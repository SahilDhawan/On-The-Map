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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentAnnotation = MKPointAnnotation.init()
        currentAnnotation.coordinate = StudentDetails.studentLocation
        self.mapView.addAnnotation(currentAnnotation)
        let region = MKCoordinateRegionMakeWithDistance(StudentDetails.studentLocation, 100, 100)
        let adjustedRegion = self.mapView.regionThatFits(region)
        self.mapView.setRegion(adjustedRegion, animated: true)
    }
    
    @IBAction func finishButtonPressed(_ sender: Any) {
        _ = self.navigationController?.popToRootViewController(animated: true)
       ParseStudent().postingStudentDetails()
    }
}
