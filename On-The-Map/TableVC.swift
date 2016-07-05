//
//  TableViewController.swift
//  On-The-Map
//
//  Created by Daniel J Janiak on 6/24/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import UIKit

class TableVC: UIViewController {
    
    // MARK: - Properties
    var studentInfo: [StudentInformation] = [StudentInformation]()
    
    // MARK: - Outlets
    @IBOutlet var parseDataTableView: UITableView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        parseDataTableView.delegate = self
        
        // studentInfo = DataService.instance.loadedStudentInfo
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBarHidden = false
        
        parseDataTableView.reloadData()
    }
    
    // MARK: - Actions
    
    @IBAction func pinTapped(sender: AnyObject) {
        
        performSegueWithIdentifier("TableToInputSegue", sender: self)
    }
    
    @IBAction func logoutTapped(sender: AnyObject) {
        print("\n\nThe logout button has been tapped")
        
        UdacityClient.sharedInstance().logout() { (data, error) in
            
            if error == nil {
                
                DataService.instance.setUserNameUnknown()
                DataService.instance.resetStudentInfo()
                
                performUIUpdatesOnMain {
                    let loginView = self.storyboard!.instantiateViewControllerWithIdentifier("LoginVC") as! LoginVC
                    self.presentViewController(loginView, animated: true, completion: nil)
                }
            } else {
                let alertView = UIAlertController(title: "Failed to log out", message: "Sorry. Please attempt to log out again", preferredStyle: UIAlertControllerStyle.Alert)
                
                alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) in
                    //self.dismissViewControllerAnimated(true, completion: nil)
                    // The alert view will be dismissed when the user tapps 'OK' so nothing else needs to be done
                }) )
            }
        }
        
    }
    
}

extension TableVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {        
        
        /* Get cell type */
        let cellReuseIdentifier = "ParseDataTableViewCell"
        //let individualInfo = studentInfo[indexPath.row]
        let individualInfo = DataService.instance.loadedStudentInfo[indexPath.row]
        
        if var cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell! {
            
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellReuseIdentifier)
            
            if let studentName = individualInfo.name {
                cell.textLabel!.text = studentName
            } else {
                cell.textLabel!.text = ""
            }
            
            cell.detailTextLabel!.text = individualInfo.link
            
            return cell
        } else {
            // Make updates here when working with a custom cell
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return studentInfo.count
        return DataService.instance.loadedStudentInfo.count
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 68
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let selectedTableCell = tableView.cellForRowAtIndexPath(tableView.indexPathForSelectedRow!)
        
        if let webLink = selectedTableCell?.detailTextLabel!.text {

            if let nsurlLink = NSURL(string: webLink) {
                UIApplication.sharedApplication().openURL(nsurlLink)
            }
        } else {
            print("Unable to access the student's url")
        }
        
        
        
        
    }
}