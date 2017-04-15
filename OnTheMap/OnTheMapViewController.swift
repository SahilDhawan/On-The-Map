
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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
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
                        self.mapView.isUserInteractionEnabled = true
                        self.addingAnnotations()
                    }
                }
                catch{}
            }
            else
            {
                Alert().showAlert(errorString!,self)
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
    //MARK: LogOut
    @IBAction func logOutButtonPressed(_ sender: Any) {
        activityViewIndicator()
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
            }
        }
    }
    
    func addingAnnotations()
    {
        for studentData in resultArray
        {
            //adding StudentData to studentArray
            StudentInformation.studentArray.append(StudentDetails(studentData))
            let latitude = studentData["latitude"] as? CLLocationDegrees
            
            //Apparently they can't spell longitude
            let longitude1 = studentData["longitude"] as? CLLocationDegrees
            let longitude2 = studentData["longtiude"] as? CLLocationDegrees
            
            let firstName = studentData["firstName"] as? String
            let mediaUrl  = studentData["mediaURL"] as? String
            var coordinate : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
            if latitude != nil
            {
                coordinate = CLLocationCoordinate2DMake(latitude!, longitudeCheck(longitude1, longitude2))
            }
            //created studentPin Object
            let annotation = studentPin(firstName!,mediaUrl!,coordinate)
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
        self.activityView.stopAnimating()
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
    
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let student = view.annotation as! studentPin
        let url = URL(string:student.getLink())
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
}
