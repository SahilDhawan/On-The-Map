//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Sahil Dhawan on 03/04/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        guard  emailTextField.text == nil, passwordTextField.text == nil else
        {
                //print("guard check")
            UdacityUser().udacityLogIn(emailTextField.text!,passwordTextField.text!){(result,error) in
                if error == nil
                {
                    let range = Range(5 ..< result!.count)
                    let newData = result?.subdata(in: range)
                    //print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
                    do
                    {
                        let dataDictionary = try JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as! NSDictionary
                        let sessionDictionary = dataDictionary["session"] as! NSDictionary
                        let sessionId = sessionDictionary["id"] as! String
                        print(sessionId)
                        
                    }
                    catch{}
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "loginSegue", sender: self)
                    }
                }
                else
                {
                    print(error!)
                }
            }
            return
        }
        
    }
    
    
}

