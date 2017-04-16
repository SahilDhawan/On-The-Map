
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
    @IBOutlet weak var plusButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
    }
    func getDataFromParse()
    {
        refreshButton.isEnabled = false
        plusButton.isEnabled = false
        
        Alert().activityView(true, self.view)
        self.mapView.isOpaque = true
        ParseStudent().getStudentLocations(){(result,errorString) in
            
            if errorString == nil
            {
                do{
                    let resultDictionary = try JSONSerialization.jsonObject(with: result!, options: .allowFragments) as! [String:AnyObject]
                    StudentInformation.studentArray = resultDictionary["results"] as! [[String:AnyObject]]
                    DispatchQueue.main.async {
                        self.addingAnnotations()
                        Alert().activityView(false, self.view)
                        self.refreshButton.isEnabled = true
                        self.plusButton.isEnabled = true
                        self.mapView.isOpaque = false
                    }
                }
                catch{}
            }
            else
            {
                Alert().showAlert(errorString!,self)
                self.refreshButton.isEnabled = true
                self.plusButton.isEnabled = true
            }
        }
    }
      //MARK: LogOut
    @IBAction func logOutButtonPressed(_ sender: Any) {
        Alert().activityView(true, self.view)
        UdacityUser().udacityLogOut(){(result,errorString)
            in
            if errorString == nil
            {
                let range = Range(5 ..< result!.count)
                let newData = result?.subdata(in: range)
                print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
            else
            {
                Alert().showAlert(errorString!,self)
                Alert().activityView(false, self.view)
            }
        }
    }
    
    func addingAnnotations()
    {
        for studentData in StudentInformation.studentArray
        {
            //adding StudentData to studentArray
            
            let latitude = studentData["latitude"] as? CLLocationDegrees
            let longitude = studentData["longitude"] as? CLLocationDegrees
            
            let firstName = studentData["firstName"] as? String
            let mediaUrl  = studentData["mediaURL"] as? String
            var coordinate : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)

            //unwrapping optional values
            if let firstName = firstName , let mediaUrl = mediaUrl , let latitude = latitude , let longitude = longitude
            {
                coordinate = CLLocationCoordinate2D.init(latitude: latitude, longitude: longitude)
                let annotation = studentPin(firstName,mediaUrl,coordinate)
                self.mapView.addAnnotation(annotation)
                
            }
        }
    }
    
    @IBAction func refreshButtonPressed(_ sender: Any) {
        getDataFromParse()
    }
    
    @IBAction func addLocation(_ sender: Any) {
        //over write alert
        if !StudentDetails.studentDetail
        {
            let controller = storyboard?.instantiateViewController(withIdentifier: "AddLocation")
            self.present(controller!, animated: true, completion: nil)
        }
        else
        {
            let msgString : String = "Details for student " + LoginViewController.firstName + " " + LoginViewController.lastName + " already exists"
            let controller = UIAlertController.init(title: "OnTheMap", message: msgString, preferredStyle: .alert)
            let dismissAction = UIAlertAction.init(title: "Dismiss", style: .cancel, handler: nil)
            let overwriteActon  = UIAlertAction.init(title: "Overwrite", style: .default, handler: { (action) in
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "AddLocation")
                self.present(controller!, animated: true, completion: nil)
            })
            controller.addAction(overwriteActon)
            controller.addAction(dismissAction)
            self.present(controller, animated: true, completion: nil)
        }
    }
    
}
extension OnTheMapViewController : MKMapViewDelegate
{
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        Alert().activityView(false,self.view)
       
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? studentPin
        {
            let identifier = "studentPin"
            var view : MKPinAnnotationView
            if let dequeueView = self.mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
            {
                dequeueView.annotation = annotation
                view = dequeueView
            }
            else
            {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5 , y:5)
                view.rightCalloutAccessoryView = UIButton.init(type: .detailDisclosure) as UIView
            }
            return view
        }
        return nil
    }
    
    func mapViewWillStartRenderingMap(_ mapView: MKMapView) {
        Alert().activityView(true, self.view)
        getDataFromParse()
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let student = view.annotation as! studentPin
        let url = URL(string:student.getLink())
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
}
