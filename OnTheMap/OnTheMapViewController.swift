
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
    
    let activityView : UIActivityIndicatorView = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
    
    @IBOutlet weak var mapView: MKMapView!
    var resultArray : [[String:AnyObject]] = [[:]]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
        
        getDataFromParse()
    }
    
    
    
    func getDataFromParse()
    {
        activityViewIndicator()
        ParseStudent().getStudentLocations(){(result,errorString) in
            
            if errorString == nil
            {
                do{
                    let resultDictionary = try JSONSerialization.jsonObject(with: result!, options: .allowFragments) as! [String:AnyObject]
                    self.resultArray = resultDictionary["results"] as! [[String:AnyObject]]
                    DispatchQueue.main.async {
                        self.activityView.stopAnimating()
                        self.mapView.isUserInteractionEnabled = true
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
    
    func activityViewIndicator()
    {
        activityView.center = CGPoint.init(x: self.view.frame.width/2, y: self.view.frame.height/2)
        activityView.alpha = 1
        activityView.startAnimating()
        self.view.addSubview(activityView)
        self.mapView.isOpaque = true
    }
    
    @IBAction func logOutButtonPressed(_ sender: Any) {
        activityViewIndicator()
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
            print(studentData)
            let latitude = studentData["latitude"] as? CLLocationDegrees
            
            //Apparently they can't spell longitude
            let longitude1 = studentData["longitude"] as? CLLocationDegrees
            let longitude2 = studentData["longtiude"] as? CLLocationDegrees
            
            let annotation = MKPointAnnotation.init()
            let firstName = studentData["firstName"] as? String
            annotation.title = firstName
            let mediaUrl  = studentData["mediaURL"] as? String
            annotation.subtitle = mediaUrl
            if latitude != nil 
            {
                annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitudeCheck(longitude1, longitude2))
            }
            self.mapView.addAnnotation(annotation)
        }
    }
    
    @IBAction func refreshButtonPressed(_ sender: Any) {
        getDataFromParse()
    }
    
    func longitudeCheck( _ long1 : CLLocationDegrees?, _ long2 : CLLocationDegrees?) -> CLLocationDegrees
    {
        if long1 == nil
        {
            return long2!
        }
        else
        {
            return long1!
        }
    }
    @IBAction func addLocation(_ sender: Any) {
        //over write alert
        if !StudentDetails.studentDetail
        {
            performSegue(withIdentifier: "AddLocation", sender: self)
        }
        else
        {
            let msgString : String = "Details for student " + StudentDetails.firstName + " " + StudentDetails.lastName + " already exists"
            let controller = UIAlertController.init(title: "OnTheMap", message: msgString, preferredStyle: .alert)
            let dismissAction = UIAlertAction.init(title: "Dismiss", style: .cancel, handler: nil)
            let overwriteActon  = UIAlertAction.init(title: "Overwrite", style: .default, handler: { (action) in
                self.performSegue(withIdentifier: "AddLocation", sender: self)
            })
            controller.addAction(overwriteActon)
            controller.addAction(dismissAction)
            self.present(controller, animated: true, completion: nil)
            
        }
    }
}
