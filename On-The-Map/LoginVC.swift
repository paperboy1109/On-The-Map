//
//  LoginVC.swift
//  On-The-Map
//
//  Created by Daniel J Janiak on 6/20/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    // MARK: - Properties
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    // MARK: - Outlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet var signupButton: UIButton!
    
    @IBOutlet weak var loginWithFBButton: UIButton!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataService.instance.resetStudentInfo()
        DataService.instance.setUserNameUnknown()
        DataService.instance.studentInfoIsOutdated()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        activityIndicator.stopAnimating()
        //enableUI()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        activityIndicator.stopAnimating()
    }
    
    // MARK: - Actions
    
    @IBAction func loginTapped(sender: AnyObject) {
        
        
        // MARK: Validation
        /* Check for incomplete credentials */
        
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            
            showErrorAlert("Login failed", alertDescription: "Please enter your Udacity email and password.")
            
        } else {
            
            disableUI()
            showLoadingIndicator()
            
            UdacityClient.sharedInstance().attemptLogin(emailTextField.text!, password: passwordTextField.text!) { (result, error, errorDesc) in
                
                performUIUpdatesOnMain {
                    self.activityIndicator.stopAnimating()
                    
                    //self.enableUI()
                }
                
                if !error {
                    self.allowLogin()
                } else {
                    performUIUpdatesOnMain {
                        self.showErrorAlert("Login failed", alertDescription: errorDesc)
                    }
                }
                
                
                /*
                 if let validAccount = error as? Bool {
                 if validAccount {
                 self.allowLogin()
                 } else {
                 performUIUpdatesOnMain(){
                 self.enableUI()
                 }
                 self.showErrorAlert("Login failed", alertDescription: "User name or password is incorrect.")
                 }
                 } else {
                 performUIUpdatesOnMain(){
                 self.enableUI()
                 }
                 self.showErrorAlert("Login failed", alertDescription: "There was an error with your request.  Please try again later.")
                 } */
                
                
            }
        }
    }
    
    
    @IBAction func signupTapped(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.udacity.com/account/auth#!/signup")!)
    }
    
    
    @IBAction func loginWithFacebookTapped(sender: AnyObject) {
        showErrorAlert("Not available", alertDescription: "This feature will be implemented soon.  Stay tuned!")
    }
    
    // MARK: - Helpers
    
    private func allowLogin() {
        
        if DataService.instance.dataNeedsUpdate {
            
            ParseClient.sharedInstance().downloadDataFromParse() { (error, errorDesc) in
                
                print("(Closure for downloadDataFromParse) error:")
                print(error)
                
                performUIUpdatesOnMain {
                    self.activityIndicator.stopAnimating()
                }
                
                if !error {
                    // Segue to the next view controller
                    performUIUpdatesOnMain {
                        self.disableUI()
                        let tabView = self.storyboard!.instantiateViewControllerWithIdentifier("MapAndTableTabBarController") as! UITabBarController
                        self.presentViewController(tabView, animated: true, completion: nil)
                        self.activityIndicator.stopAnimating()
                    }
                } else {                    
                    print(errorDesc)
                    performUIUpdatesOnMain() {
                        self.showErrorAlert("Login failed", alertDescription: "There was an error with your request.  Please try again later.")
                    }
                }
                
            }
        }
        
    }
    
    private func showErrorAlert(alertTitle: String, alertDescription: String) {
        
        let alertView = UIAlertController(title: "\(alertTitle)", message: "\(alertDescription)", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) in
            //self.dismissViewControllerAnimated(true, completion: nil)
            // The alert view will be dismissed when the user tapps 'OK' so nothing else needs to be done
        }) )
        
        self.enableUI()
        
        self.presentViewController(alertView, animated: true, completion: nil)
    }
    
    private func disableUI() {
        
        emailTextField.hidden = true
        passwordTextField.hidden = true
        
        loginButton.enabled = false
        loginButton.alpha = 0.5
        loginWithFBButton.enabled = false
        loginWithFBButton.alpha = 0.5
        signupButton.enabled = false
        
    }
    
    private func enableUI() {
        
        activityIndicator.stopAnimating()
        
        emailTextField.hidden = false
        emailTextField.text = nil
        passwordTextField.hidden = false
        passwordTextField.text = nil
        
        loginButton.enabled = true
        loginButton.alpha = 1.0
        loginWithFBButton.enabled = true
        loginWithFBButton.alpha = 1.0
        signupButton.enabled = true
        
    }
    
    private func showLoadingIndicator() {
        
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        
        self.activityIndicator.startAnimating()
        
    }
    
    /* Add code to control the keyboard */
    
    
    // Close keyboard by tapping outside
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Close the keyboard by using the button on the keyboard
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    
    
    
    
    
    
}
