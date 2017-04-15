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
    let activityView : UIActivityIndicatorView = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
    
    //Current User Details
    static var objectId : String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        
        //ActivityIndicatorView
        activityView.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2)
        activityView.alpha = 1
        self.view.addSubview(activityView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentAnnotation = MKPointAnnotation.init()
        currentAnnotation.coordinate = AddLocationViewController.studentLocation
        self.mapView.addAnnotation(currentAnnotation)
        let region = MKCoordinateRegionMakeWithDistance(AddLocationViewController.studentLocation, 100, 100)
        let adjustedRegion = self.mapView.regionThatFits(region)
        self.mapView.setRegion(adjustedRegion, animated: true)
        self.mapView.delegate = self
    }
    
    @IBAction func finishButtonPressed(_ sender: Any) {
        
        //Current Student Data
        var currentStudentData = [String:AnyObject]()
        currentStudentData["firstName"] = LoginViewController.firstName as AnyObject?
        currentStudentData["lastName"] = LoginViewController.lastName as AnyObject?
        currentStudentData["userId"] = LoginViewController.userId as AnyObject?
        currentStudentData["webURL"] = AddLocationViewController.webURL as AnyObject?
        currentStudentData["mapString"] = AddLocationViewController.mapString as AnyObject?
        currentStudentData["studentLocation"] = AddLocationViewController.studentLocation as AnyObject?
        currentStudentData["objectId"] = UserCoordinateViewController.objectId as AnyObject?
        
        //Creating StudentDetails Object
        let currentStudent = StudentDetails(currentStudentData)
        
        if !StudentDetails.studentDetail
        {
            //setting flag to true
            StudentDetails.studentDetail = true
            
            ParseStudent().postingStudentDetails(currentStudent) { (result, errorString) in
                if errorString == nil
                {
                    do
                    {
                        let dataDict = try JSONSerialization.jsonObject(with: result!, options: .allowFragments) as! NSDictionary
                        print(dataDict)
                        let objectId = dataDict["objectId"] as! String
                        UserCoordinateViewController.objectId = objectId
                        
                    }
                    catch{}
                }
                else
                {
                    Alert().showAlert(errorString!,self)
                }
            }
        }
        else
        {
            ParseStudent().puttingStudentDetails(currentStudent) { (result, errorString) in
                if errorString == nil
                {
                    do
                    {
                        let dataDict = try JSONSerialization.jsonObject(with: result!, options: .allowFragments) as! NSDictionary
                        print(dataDict)
                    }
                    catch{}
                }
                else
                {
                    Alert().showAlert(errorString!,self)
                }
            }
        }
        //presenting Tab View Controller
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "tabController")
        self.present(controller!, animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
}
//MARK: MKMapViewDelegate
extension UserCoordinateViewController : MKMapViewDelegate
{
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        self.activityView.stopAnimating()
    }
}




