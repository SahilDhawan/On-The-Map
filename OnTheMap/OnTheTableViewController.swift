//
//  OnTheTableViewController.swift
//  OnTheMap
//
//  Created by Sahil Dhawan on 04/04/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import UIKit

var resultArray : [[String:AnyObject]] = [[:]]
let activityView:UIActivityIndicatorView = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)

class OnTheTableViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
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
                    resultArray = dataDict["results"] as! [[String:AnyObject]]
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        activityView.stopAnimating()
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
                print(errorString!)
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
    
    @IBAction func logOutPressed(_ sender: Any) {
        activityViewIndicator()
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
    
    @IBAction func refreshButtonPressed(_ sender: Any) {
        getDataFromParse()
    }
}
extension OnTheTableViewController:UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "OnTheTableCell")
        let studentData = resultArray[indexPath.row]
        print(studentData)
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
