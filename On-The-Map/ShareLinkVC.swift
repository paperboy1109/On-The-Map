//
//  ShareLinkVC.swift
//  On-The-Map
//
//  Created by Daniel J Janiak on 7/1/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import UIKit
import MapKit

class ShareLinkVC: UIViewController {
    
    // MARK: - Properties
    
    var studentStudyLocation = CLLocationCoordinate2D()
    var studentStudyLocationName = String()
    
    var linkTextDelegate = UserInfoTextDelegate()
    
    let mapSpan:MKCoordinateSpan = MKCoordinateSpanMake(10 , 10)
    
    let linkTextAttributes = [
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 17)!,
        ]
    
    // MARK: - Outlets
    @IBOutlet var newLocationMap: MKMapView!
    @IBOutlet var linkTextField: UITextField!
    @IBOutlet var postDataBtn: UIButton!
    @IBOutlet var cancelBtn: UIButton!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        linkTextField.delegate = linkTextDelegate
        setPlaceholderText(linkTextField, initialText: "Enter a Link to Share Here")
        
        postDataBtn.layer.cornerRadius = 5.0
        
        let mapRegion:MKCoordinateRegion = MKCoordinateRegionMake(studentStudyLocation, mapSpan)
        
        // Display the region of interest
        newLocationMap.setRegion(mapRegion, animated: true)
        
        // Add an annotation
        let firstAnotation = MKPointAnnotation()
        firstAnotation.coordinate = studentStudyLocation
        newLocationMap.addAnnotation(firstAnotation)
    }
    
    override func viewWillAppear(animated: Bool) {
        print("(ShareLinkVC) Here is 'studentStudyLocation': \(studentStudyLocation)")
    }
    
    
    // MARK: - Actions
    
    @IBAction func cancelTapped(sender: AnyObject) {
        
        let tabView = self.storyboard!.instantiateViewControllerWithIdentifier("MapAndTableTabBarController") as! UITabBarController
        self.presentViewController(tabView, animated: true, completion: nil)
        linkTextField.text = nil
    }
    
    @IBAction func postDataTapped(sender: AnyObject) {
        
        if let newLink = linkTextField.text {
            DataService.instance.setStudentLink(newLink)
        } else {
            DataService.instance.setStudentLink("")
        }
        
        ParseClient.sharedInstance().postToServer(studentStudyLocation, newStudentLocationName: studentStudyLocationName) { (result, error) in
            
            guard (error == nil) else {
                print("There was an error with your POST request: \(error)")
                self.showErrorAlert("Data failed to upload", alertDescription: "Please try again later.")
                return
            }
            
            // View the result for debugging purposes
            print("(Closure of postToServer) Here is 'result' :")
            print(result)
            
            // Indicate that the singleton needs updating
            DataService.instance.studentInfoIsOutdated()
            
            performUIUpdatesOnMain {
                let tabView = self.storyboard!.instantiateViewControllerWithIdentifier("MapAndTableTabBarController") as! UITabBarController
                self.presentViewController(tabView, animated: true, completion: nil)
            }
        }
    }
    
    
    // MARK: - Helpers
    func setPlaceholderText(textField: UITextField, initialText: String) {
        
        textField.text = ""
        
        textField.attributedPlaceholder = NSAttributedString(string: initialText, attributes: linkTextAttributes)
        
        
    }
    
    private func showErrorAlert(alertTitle: String, alertDescription: String) {
        
        let alertView = UIAlertController(title: "\(alertTitle)", message: "\(alertDescription)", preferredStyle: UIAlertControllerStyle.Alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) in
            // Remain at the present view so that the user can try again, or tap 'cancel'
        }) )
        
        self.presentViewController(alertView, animated: true, completion: nil)
    }
    
    
    
    
}
