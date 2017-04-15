//
//  OnTheTableViewController.swift
//  OnTheMap
//
//  Created by Sahil Dhawan on 04/04/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import UIKit


class OnTheTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let activityView:UIActivityIndicatorView = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
    var resultArray : [[String:AnyObject]] = [[:]]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
        getDataFromParse()
    }
    
    func getDataFromParse()
    {
        activityViewIndicator()
        ParseStudent().getStudentLocations(completionHandler: {(data,errorString) in
            if errorString == nil
            {
                do
                {
                    let dataDict = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
                    self.resultArray = dataDict["results"] as! [[String:AnyObject]]
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.activityView.stopAnimating()
                        self.tableView.isOpaque = false
                    }
                }
                catch
                {
                    print("Could not serialise the data ")
                    return
                }
            }
            else
            {
                Alert().showAlert(errorString!,self)
                self.activityView.stopAnimating()
                return
            }
        })
    }
    func activityViewIndicator()
    {
        activityView.center = CGPoint.init(x: self.view.frame.width/2, y: self.view.frame.height/2)
        activityView.alpha = 1
        activityView.startAnimating()
        self.view.addSubview(activityView)
        self.tableView.isOpaque = true
    }
    //MARK: LogOut
    @IBAction func logOutPressed(_ sender: Any) {
        activityViewIndicator()
        UdacityUser().udacityLogOut(){(result,errorString)
            in
            if errorString == nil
            {
                let range = Range(5 ..< result!.count)
                let newData = result?.subdata(in: range)
                print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
            else
            {
                Alert().showAlert(errorString!,self)
                self.activityView.stopAnimating()
            }
        }
    }
    
    @IBAction func addLocation(_ sender: Any) {
        if !StudentDetails.studentDetail
        {
            let controller = storyboard?.instantiateViewController(withIdentifier: "AddLocation")
            self.present(controller!, animated: true, completion: nil)
            StudentDetails.studentDetail = true
        }
        else
        {
            let msgString : String = "Details for student " + LoginViewController.firstName + " " + LoginViewController.lastName + " already exists"
            let controller = UIAlertController.init(title: "OnTheMap", message: msgString, preferredStyle: .alert)
            let dismissAction = UIAlertAction.init(title: "Dismiss", style: .cancel, handler: nil)
            let overwriteActon  = UIAlertAction.init(title: "Overwrite", style: .default, handler: { (action) in
                
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "AddLocation")
                self.present(controller!, animated: true, completion: nil)            })
            controller.addAction(overwriteActon)
            controller.addAction(dismissAction)
            self.present(controller, animated: true, completion: nil)
        }
    }
    //refresh
    @IBAction func refreshButtonPressed(_ sender: Any) {
        getDataFromParse()
    }
}
//MARK : UITableViewDataSource
extension OnTheTableViewController:UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "OnTheTableCell")
        let studentData = resultArray[indexPath.row]
        let firstName : String? = (studentData["firstName"] as? String)
        let mediaURL : String? = (studentData["mediaURL"] as? String)
        
        tableCell?.textLabel?.text = firstName
        tableCell?.detailTextLabel?.text = mediaURL
        if firstName != nil
        {
            tableCell?.imageView?.image = UIImage(named:"icon_pin")
        }
        return tableCell!
    }
}
//MARK : UITableViewDelegate
extension OnTheTableViewController:UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let studentData = resultArray[indexPath.row]
        let mediaUrl :String? = studentData["mediaURL"] as? String
        let url : URL = URL(string: mediaUrl!)!
        UIApplication.shared.open(url, options:[:] , completionHandler: nil)
    }
}
