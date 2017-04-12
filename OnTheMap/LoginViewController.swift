//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Sahil Dhawan on 03/04/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController {
    
    let activityView : UIActivityIndicatorView = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var debugLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    func activityViewIndicator()
    {
        activityView.center = CGPoint.init(x: self.view.frame.width/2, y: self.view.frame.height/2)
        activityView.alpha = 1
        activityView.startAnimating()
        self.view.addSubview(activityView)
    }
    @IBAction func loginButtonPressed(_ sender: Any) {
        activityViewIndicator()
        self.logInButton.isEnabled = false
        guard  emailTextField.text == nil, passwordTextField.text == nil else
        {
            UdacityUser().udacityLogIn(emailTextField.text!,passwordTextField.text!){(result,error) in
                if error == nil
                {
                    let range = Range(5 ..< result!.count)
                    let newData = result?.subdata(in: range)
                    do
                    {
                        let dataDictionary = try JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as! NSDictionary
                        print(dataDictionary)
                        let sessionDictionary = dataDictionary["session"] as? NSDictionary
                        
                        if let session = sessionDictionary
                        {
                            let sessionId = session["id"] as! String
                            UdacityUser.sessionId = sessionId
                            let resultDict = dataDictionary["account"] as! [String:AnyObject?]
                            let userId = resultDict["key"] as! String
                            UdacityUser().gettingStudentDetails(userId, { (result, errorString) in
                                if errorString == nil
                                {
                                    do
                                    {
                                        let dataDict = try JSONSerialization.jsonObject(with: result!, options: .allowFragments) as! NSDictionary
                                        let userDict = dataDict["user"] as! [String:AnyObject]
                                        StudentDetails.lastName = userDict["last_name"] as! String
                                        StudentDetails.userId = userId
                                        StudentDetails.firstName = userDict["first_name"] as! String
                                        print(StudentDetails.firstName + " " + StudentDetails.lastName)
                                    }
                                    catch{}
                                }
                                else
                                {
                                    print(errorString!)
                                }
                            })
                        }
                        else
                        {
                            DispatchQueue.main.async {
                                self.showAlert("Invalid Login !")
                                self.activityView.stopAnimating()
                                self.logInButton.isEnabled = true
                            }
                            return
                        }
                    }
                    catch{}
                    DispatchQueue.main.async {
                        self.activityView.stopAnimating()
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
    func showAlert(_ msg : String)
    {
        let controller = UIAlertController.init(title: "OnTheMap", message: msg, preferredStyle: .alert)
        let action = UIAlertAction.init(title: "Dismiss", style: .cancel, handler: nil)
        controller.addAction(action)
        self.present(controller, animated: true, completion: nil)
    }
}
extension LoginViewController : UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
