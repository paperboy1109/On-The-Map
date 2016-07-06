//
//  InputVC.swift
//  On-The-Map
//
//  Created by Daniel J Janiak on 7/1/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import UIKit
import MapKit

class InputVC: UIViewController {
    
    // MARK: - Properties
    
    var userLocation: CLLocationCoordinate2D?
    
    var userLocationName: String?
    
    var locationTextDelegate = UserInfoTextDelegate()
    
    let locationTextAttributes = [
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 17)!
    ]
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    // MARK: - Outlets
    
    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var colorStripe: UIView!
    @IBOutlet var findLocationTappedBtn: GrayButton!
    @IBOutlet var cancelBtn: UIButton!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationTextField.delegate = locationTextDelegate
        
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        
        disableUI()
        showLoadingIndicator()
        
        if DataService.instance.userNameKnown() {
            self.activityIndicator.stopAnimating()
            self.enableUI()
        } else {
            
            UdacityClient.sharedInstance().getUserName() { (error, errorDesc) in
                
                performUIUpdatesOnMain() {
                    self.activityIndicator.stopAnimating()
                    self.enableUI()
                }
                
                if !error {
                    DataService.instance.setUserNameKnown()
                }
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        performUIUpdatesOnMain() {
            self.activityIndicator.stopAnimating()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ShareLinkVC" {
            
            if let sharelinkVC = segue.destinationViewController as? ShareLinkVC {
                
                guard userLocation != nil && userLocationName != nil else {
                    return
                }
                
                sharelinkVC.studentStudyLocation = userLocation!
                sharelinkVC.studentStudyLocationName = userLocationName!
            }
        }
    }
    
    
    
    
    // MARK: - Actions
    
    @IBAction func cancelTapped(sender: AnyObject) {
        
        activityIndicator.stopAnimating()
        
        locationTextField.text = nil
        
        let tabView = self.storyboard!.instantiateViewControllerWithIdentifier("MapAndTableTabBarController") as! UITabBarController
        self.presentViewController(tabView, animated: true, completion: nil)
    }
    
    
    @IBAction func findOnMapTapped(sender: AnyObject) {
        
        showLoadingIndicator()
        //Example of successful geolocation
        //CLGeocoder().geocodeAddressString("San Francisco, USA") { (placemarks, error) in
        
        //Example of failed geolocation
        //CLGeocoder().geocodeAddressString("kdksladkfsakdfjksadf;jasd") { (placemarks, error) in
        
        if (locationTextField.text == "" || locationTextField.text == nil) {
            self.showErrorAlert("No location entered", alertDescription: "Please enter your location.  Example: San Francisco, USA")
        } else {
            CLGeocoder().geocodeAddressString(locationTextField.text!) { (placemarks, error) in
                
                func sendError(error: String) {
                    print(error)
                    self.showErrorAlert("Location not found", alertDescription: "Please try entering your location again.  Example: San Francisco, USA")
                }
                
                /* GUARD: Was there an error? */
                guard (error == nil) else {
                    sendError("There was an error with your request: \(error)")
                    return
                }
                
                /* "Drill down to get the data of interest (coordinates) */
                
                /* GUARD: Was there any data returned? */
                guard let data = placemarks else {
                    sendError("No data was returned by the request!")
                    return
                }
                
                guard let locationData = data[0].location?.coordinate else {
                    sendError("The data retunred did not include coordinates!")
                    return
                }
                
                guard let locationName = data[0].name else {
                    sendError("The data retunred did not include a name!")
                    return
                }
                
                self.userLocation = locationData
                self.userLocationName = locationName
                
                self.performSegueWithIdentifier("ShareLinkVC", sender: sender)
                
                
            }
        }
    }
    
    // MARK: - Helpers
    
    func setPlaceholderText(textField: UITextField, initialText: String) {
        
        textField.text = ""
        
        textField.attributedPlaceholder = NSAttributedString(string: initialText, attributes: locationTextAttributes)
        
    }
    
    private func showLoadingIndicator() {
        
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
    }
    
    private func showErrorAlert(alertTitle: String, alertDescription: String) {
        
        let alertView = UIAlertController(title: "\(alertTitle)", message: "\(alertDescription)", preferredStyle: UIAlertControllerStyle.Alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) in
            self.activityIndicator.stopAnimating()
        }) )
        
        self.presentViewController(alertView, animated: true, completion: nil)
    }
    
    func disableUI() {
        locationTextField.enabled = false
        colorStripe.alpha = 0.4
        findLocationTappedBtn.hidden = true
        findLocationTappedBtn.enabled = false
        cancelBtn.hidden = true
        cancelBtn.enabled = false
    }
    
    func enableUI() {
        locationTextField.enabled = true
        colorStripe.alpha = 1.0
        findLocationTappedBtn.hidden = false
        findLocationTappedBtn.enabled = true
        cancelBtn.hidden = false
        cancelBtn.enabled = true
        
        setPlaceholderText(locationTextField, initialText: "Enter Your Location Here")
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
