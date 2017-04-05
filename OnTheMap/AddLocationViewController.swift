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
    }
    
    func showAlert(_ msg: String)
    {
        let viewController = UIAlertController.init(title: "OnTheMap", message: msg, preferredStyle: .alert)
        let action = UIAlertAction.init(title: "Dismiss", style: .default, handler: nil)
        viewController.addAction(action)
        self.present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func FindLocationPressed(_ sender: Any) {
        guard locationTextField.text == nil, websiteTextField.text == nil else
        {
            let geocoder = CLGeocoder()
            let text = websiteTextField.text!
            if(text.contains("https://www.") || (text.contains("http://www.")))
            {
                StudentDetails.webURL = websiteTextField.text!
                geocoder.geocodeAddressString(locationTextField.text!, completionHandler: { (placemark, error) in
                    if error != nil
                    {
                        self.showAlert("Invalid Location")
                    }
                    else
                    {
                        if let place = placemark, (placemark?.count)! > 0
                        {
                            var location : CLLocation?
                            location = place.first?.location
                            StudentDetails.studentLocation = location!.coordinate
                            self.performSegue(withIdentifier: "UserCoordinate", sender: location)
                        }
                    }
                })
            }
            else
            {
                showAlert("website link is not valid")
                return
            }
            return
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
}

extension AddLocationViewController:UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
