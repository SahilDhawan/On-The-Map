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
    
    //MARK: Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var debugLabel: UILabel!
    
    //Current User Details
    static var firstName : String = ""
    static var lastName : String = ""
    static var userId : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        //Clearing Text Field Data
        self.emailTextField.text = ""
        self.passwordTextField.text = ""
        self.logInButton.isEnabled = true
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
    
    //MARK: Login and Data Fetch
    @IBAction func loginButtonPressed(_ sender: Any)
    {
        activityViewIndicator()
        self.logInButton.isEnabled = false
        guard  (emailTextField.text == "" || passwordTextField.text == "") else
        {
            
            //Udacity Login
            
            UdacityUser().udacityLogIn(emailTextField.text!,passwordTextField.text!){(result,error) in
                if error == nil
                {
                    let range = Range(5 ..< result!.count)
                    let newData = result?.subdata(in: range)
                    do
                    {
                        let dataDictionary = try JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as! NSDictionary
                        let resultDict = dataDictionary["account"] as! [String:AnyObject?]
                        let userId = resultDict["key"] as! String
                        
                        UdacityUser().gettingStudentDetails(userId, { (result, errorString) in
                            if errorString == nil
                            {
                                do
                                {
                                    print(NSString(data: result!, encoding: String.Encoding.utf8.rawValue)!)
                                    
                                    let dataDict = try JSONSerialization.jsonObject(with: result!, options: .allowFragments) as! NSDictionary
                                    let userDict = dataDict["user"] as! [String:AnyObject]
                                    
                                    //passing Data to Current User Data
                                    DispatchQueue.main.async {
                                        LoginViewController.lastName = userDict["last_name"] as! String
                                        print(userDict)
                                        print(LoginViewController.lastName)
                                        LoginViewController.userId = userId
                                        LoginViewController.firstName = userDict["first_name"] as! String
                                        //Segue
                                        self.activityView.stopAnimating()
                                        self.performSegue(withIdentifier: "loginSegue", sender: self)
                                    }
                                }
                                catch{
                                    DispatchQueue.main.async {
                                        self.showAlert("cannot serialise getStudentDetails Data")
                                        self.activityView.stopAnimating()
                                        self.logInButton.isEnabled = true
                                    }
                                }
                            }
                            else
                            {
                                //handling data fetch error
                                self.showAlert(errorString!)
                            }
                        })
                    }
                    catch{
                        self.showAlert("cannot serialise udacityLogin Data")
                        self.activityView.stopAnimating()
                        self.logInButton.isEnabled = true
                    }
                }
                else
                {
                    //handling Udacity login error
                    DispatchQueue.main.async {
                        self.showAlert(error!)
                        self.activityView.stopAnimating()
                        self.logInButton.isEnabled = true
                        
                    }
                }
            }
            return
        }
        // Alert for email and password
        showAlert("Email or Password can't be empty")
        self.activityView.stopAnimating()
        self.logInButton.isEnabled = true
    }
    
    //Alert Function
    func showAlert(_ msg : String)
    {
        let controller = UIAlertController.init(title: "OnTheMap", message: msg, preferredStyle: .alert)
        let action = UIAlertAction.init(title: "Dismiss", style: .cancel, handler: nil)
        controller.addAction(action)
        self.present(controller, animated: true, completion: nil)
    }
    
    
}
//MARK: TextFieldDelegate
extension LoginViewController : UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
