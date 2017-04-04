
//
//  OnTheMapViewController.swift
//  OnTheMap
//
//  Created by Sahil Dhawan on 04/04/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import UIKit
import MapKit

class OnTheMapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    var resultArray : [[String:AnyObject]] = [[:]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ParseStudent().getStudentLocations(){(result,errorString) in
            
            if errorString == nil
            {
                do{
                    let resultDictionary = try JSONSerialization.jsonObject(with: result!, options: .allowFragments) as! [String:AnyObject]
                    self.resultArray = resultDictionary["results"] as! [[String:AnyObject]]
                    DispatchQueue.main.async {
                        self.addingAnnotations()
                    }
                }
                catch{}
            }
            else
            {
                print(errorString!)
            }
        }
    }
    
    @IBAction func logOutButtonPressed(_ sender: Any) {
        UdacityUser().udacityLogOut(){(result,errorString)
            in
            if errorString == nil
            {
                let range = Range(5 ..< result!.count)
                let newData = result?.subdata(in: range)
                print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "Login") as! LoginViewController
                self.present(viewController, animated: true, completion: nil)
            }
            else
            {
                print(errorString!)
            }
        }
    }
    func addingAnnotations()
    {
        for studentData in resultArray
        {
            let latitude = studentData["latitude"] as! CLLocationDegrees
            let longitude = studentData["longitude"] as! CLLocationDegrees
            let annotation = MKPointAnnotation.init()
            annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
            self.mapView.addAnnotation(annotation)
        }
    }
}
