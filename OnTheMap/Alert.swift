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
    
    static let activityView : UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    func showAlert(_ msg : String , _ viewController : UIViewController)
    {
        let controller = UIAlertController.init(title: "OnTheMap", message: msg, preferredStyle: .alert)
        let action = UIAlertAction.init(title: "Dismiss", style: .cancel, handler: nil)
        controller.addAction(action)
        viewController.present(controller, animated: true, completion: nil)
    }

    func activityView(_ state : Bool, _ view : UIView)
    {
        Alert.activityView.alpha = 1
        Alert.activityView.center = CGPoint(x: view.frame.width/2, y: view.frame.height/2)
        if state
        {
            Alert.activityView.startAnimating()
            view.addSubview(Alert.activityView)
        }
        else
        {
            Alert.activityView.stopAnimating()
            view.willRemoveSubview(Alert.activityView)
        }
    }
}
