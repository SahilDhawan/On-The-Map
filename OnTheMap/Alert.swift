//
//  Alert.swift
//  OnTheMap
//
//  Created by Sahil Dhawan on 15/04/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import Foundation
import UIKit

class Alert : NSObject
{
    func showAlert(_ msg : String , _ viewController : UIViewController)
    {
        let controller = UIAlertController.init(title: "OnTheMap", message: msg, preferredStyle: .alert)
        let action = UIAlertAction.init(title: "Dismiss", style: .cancel, handler: nil)
        controller.addAction(action)
        viewController.present(controller, animated: true, completion: nil)
    }
}
