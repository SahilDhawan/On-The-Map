//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Sahil Dhawan on 05/04/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import UIKit
import CoreLocation

class AddLocationViewController: UIViewController {
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    
    //Current User Details
    static var mapString : String = ""
    static var webURL : String = ""
    static var studentLocation : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTextField.delegate = self
        websiteTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        Alert().activityView(false, self.view)
        
    }
    
   
    @IBAction func FindLocationPressed(_ sender: Any) {
        guard locationTextField.text == nil, websiteTextField.text == nil else
        {
            //ActivityIndicatorView
            Alert().activityView(true, self.view)
            let geocoder = CLGeocoder()
            let text = websiteTextField.text!
            if(text.contains("https://www.") || (text.contains("http://www.")) && (text.contains(".com")))
            {
                AddLocationViewController.webURL = websiteTextField.text!
                geocoder.geocodeAddressString(locationTextField.text!, completionHandler: { (placemark, error) in
                    if error != nil
                    {
                        Alert().showAlert("Invalid Location",self)
                        Alert().activityView(false, self.view)
                    }
                    else
                    {
                        if let place = placemark, (placemark?.count)! > 0
                        {
                            var location : CLLocation?
                            location = place.first?.location
                            AddLocationViewController.studentLocation = location!.coordinate
                            AddLocationViewController.mapString = self.locationTextField.text!
                            Alert().activityView(false, self.view)
                            self.performSegue(withIdentifier: "UserCoordinate", sender: location)
                        }
                    }
                })
            }
            else
            {
                Alert().showAlert("website link is not valid",self)
                Alert().activityView(false, self.view)
                return
            }
            return
        }
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "tabController")
        self.present(controller!, animated: true, completion: nil)
    }
    
}


extension AddLocationViewController:UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
