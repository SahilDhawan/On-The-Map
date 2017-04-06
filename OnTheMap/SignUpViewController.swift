//
//  SignUpViewController.swift
//  OnTheMap
//
//  Created by Sahil Dhawan on 05/04/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    let activityView : UIActivityIndicatorView = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://auth.udacity.com/sign-up?next=https%3A%2F%2Fclassroom.udacity.com%2Fme")
        
        DispatchQueue.global().async {
            let urlRequest = URLRequest.init(url: url!)
            self.webView.loadRequest(urlRequest)
            self.activityView.stopAnimating()
        }
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url!){ (data, response, error) in
            if error == nil
            {
                do
                {
                    let dataDict = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
                    print(dataDict)
                }
                catch
                {
                    
                }
            }
        }
        dataTask.resume()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activityViewIndicator()
    }
    
    func activityViewIndicator()
    {
        activityView.alpha = 1
        activityView.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2)
        activityView.startAnimating()
        self.view.addSubview(activityView)
    }
}
