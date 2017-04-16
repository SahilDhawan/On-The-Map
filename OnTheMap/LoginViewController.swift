//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Sahil Dhawan on 03/04/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController {
    
    
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
        navigationController?.navigationBar.isHidden = true
        //Clearing Text Field Data
        self.emailTextField.text = ""
        self.passwordTextField.text = ""
        self.logInButton.isEnabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       navigationController?.navigationBar.isHidden = false
    }
       //MARK: Login and Data Fetch
    @IBAction func loginButtonPressed(_ sender: Any)
    {
        Alert().activityView(true, self.view)
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
                                
                                    let dataDict = try JSONSerialization.jsonObject(with: result!, options: .allowFragments) as! [String : AnyObject]
                                    let userDict = dataDict["user"] as! [String:AnyObject]
                                    
                                    //passing Data to Current User Data
                                    DispatchQueue.main.async {
                                        LoginViewController.lastName = userDict["last_name"] as! String
                                        print(userDict)
                                        print(LoginViewController.lastName)
                                        LoginViewController.userId = userId
                                        LoginViewController.firstName = userDict["first_name"] as! String
                                        //Segue
                                        Alert().activityView(false,self.view)
                                        self.performSegue(withIdentifier: "loginSegue", sender: self)
                                    }
                                }
                                catch{
                                    DispatchQueue.main.async {
                                        Alert().showAlert("cannot serialise getStudentDetails Data",self)
                                        Alert().activityView(false,self.view)
                                        self.logInButton.isEnabled = true
                                    }
                                }
                            }
                            else
                            {
                                //handling data fetch error
                                Alert().showAlert(errorString!,self)
                            }
                        })
                    }
                    catch{
                        Alert().showAlert("cannot serialise udacityLogin Data",self)
                        Alert().activityView(false,self.view)
                        self.logInButton.isEnabled = true
                    }
                }
                else
                {
                    //handling Udacity login error
                    DispatchQueue.main.async {
                        Alert().showAlert(error!,self)
                        Alert().activityView(false,self.view)
                        self.logInButton.isEnabled = true
                        
                    }
                }
            }
            return
        }
        // Alert for email and password
        Alert().showAlert("Email or Password can't be empty",self)
        Alert().activityView(false,self.view)
        self.logInButton.isEnabled = true
    }
    
    //Alert Function
    
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        let url = URL(string:"https://auth.udacity.com/sign-up?next=https%3A%2F%2Fclassroom.udacity.com%2Fauthenticated")
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
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
