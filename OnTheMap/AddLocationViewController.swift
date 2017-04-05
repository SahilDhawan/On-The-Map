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
    func showAlert(_ msg: String)
    {
        let viewController = UIAlertController.init(title: "OnTheMap", message: msg, preferredStyle: .alert)
        let action = UIAlertAction.init(title: "Dismiss", style: .default, handler: nil)
        viewController.addAction(action)
        self.present(viewController, animated: true, completion: nil)
    }
    @IBAction func FindLocationPressed(_ sender: Any) {
        guard locationTextField.text == nil else
        {
            let geocoder = CLGeocoder()
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
                        self.performSegue(withIdentifier: "UserCoordinate", sender: location)
                    }
                }
            })
            return
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserCoordinate"
        {
        let location = sender as! CLLocation
        let viewController = segue.destination as! UserCoordinateViewController
            viewController.location = location
        }
    }
}
extension AddLocationViewController:UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
