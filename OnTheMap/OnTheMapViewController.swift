//
//  OnTheMapViewController.swift
//  OnTheMap
//
//  Created by Sahil Dhawan on 04/04/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import UIKit

class OnTheMapViewController: UIViewController {
    

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
}
