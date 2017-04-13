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
        self.view.addSubview(activityView)    }
    
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
        _ = self.navigationController?.popToRootViewController(animated: true)
        if !StudentDetails.studentDetail
        {
            //setting flag to true
            StudentDetails.studentDetail = true
            
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
                    self.showAlert(errorString!)
                }
            }
        }
        else
        {
            
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
                    self.showAlert(errorString!)
                }
            }
        }
    }
    @IBAction func cancelButtonPressed(_ sender: Any) {
        let  _ =
        self.navigationController?.popViewController(animated: true)
    }
    
    func showAlert(_ msg: String)
    {
        let viewController = UIAlertController.init(title: "OnTheMap", message: msg, preferredStyle: .alert)
        let action = UIAlertAction.init(title: "Dismiss", style: .default, handler: nil)
        viewController.addAction(action)
        self.present(viewController, animated: true, completion: nil)
    }
}
//MARK: MKMapViewDelegate
extension UserCoordinateViewController : MKMapViewDelegate
{
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        self.activityView.stopAnimating()
    }
}




