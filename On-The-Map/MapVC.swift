//
//  MapVC.swift
//  On-The-Map
//
//  Created by Daniel J Janiak on 6/24/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController {
    
    // MARK: - Properties
    
    let mapSpan:MKCoordinateSpan = MKCoordinateSpanMake(10 , 10)
    
    // var studentInfo: [StudentInformation] = [StudentInformation]()
    
    var mapAnnotations = [MKPointAnnotation]()
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    // MARK: - Outlets
    @IBOutlet var map: MKMapView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.delegate = self
        
        // studentInfo = DataService.instance.loadedStudentInfo
        
        //for item in self.studentInfo {
        for item in DataService.instance.loadedStudentInfo {
            let newAnnotation:MKPointAnnotation = MKPointAnnotation()
            newAnnotation.coordinate = item.location!
            newAnnotation.title = item.name!
            newAnnotation.subtitle = item.link!
            // self.map.addAnnotation(newAnnotation)
            mapAnnotations.append(newAnnotation)
        }
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        showLoadingIndicator()
        
        if DataService.instance.dataNeedsUpdate {
            
            ParseClient.sharedInstance().downloadDataFromParse() { (error, errorDesc) in
                
                performUIUpdatesOnMain {
                    self.activityIndicator.stopAnimating()
                }
                
                if !error {                    
                    performUIUpdatesOnMain() {
                        self.map.addAnnotations(self.mapAnnotations)
                        self.showErrorAlert("Data updated!", alertDescription: "Sorry for the wait, but you now have the most recent data.")
                    }
                } else {
                    print(errorDesc)
                    performUIUpdatesOnMain() {
                        self.map.addAnnotations(self.mapAnnotations)
                        self.showErrorAlert("Data update failed", alertDescription: "Data shown on the map may not be completely up-to-date. Try logging in later.")
                    }
                }
                
            }
        } else {
            self.activityIndicator.stopAnimating()
            map.addAnnotations(mapAnnotations)
        }
        
    }
    
    // MARK: - Actions
    
    @IBAction func pinTapped(sender: AnyObject) {
        
        performSegueWithIdentifier("MapToInputSegue", sender: self)
    }
    
    
    @IBAction func logoutTapped(sender: AnyObject) {
        
        print("\n\nThe logout button has been tapped")
        
        UdacityClient.sharedInstance().logout() { (data, error) in
            
            //
            print("Here is data and error")
            print(data)
            print(error)
            
            if error == nil {
                
                DataService.instance.setUserNameUnknown()
                DataService.instance.resetStudentInfo()
                DataService.instance.studentInfoIsOutdated()
                
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
    
    // MARK: - Helpers
    
    private func showLoadingIndicator() {
        
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        
        self.activityIndicator.startAnimating()
        
    }
    
    private func showErrorAlert(alertTitle: String, alertDescription: String) {
        
        let alertView = UIAlertController(title: "\(alertTitle)", message: "\(alertDescription)", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        
        self.presentViewController(alertView, animated: true, completion: nil)
    }
    
    
    
    
}

extension MapVC: MKMapViewDelegate {
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "Student"
        
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
        
        if annotationView == nil {
            
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
            
            let btn = UIButton(type: .DetailDisclosure)
            annotationView!.rightCalloutAccessoryView = btn
            
        } else {
            
            annotationView!.annotation = annotation
        }
        
        return annotationView
        
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        /* For debugging only
        // What came with the annotationView?
        print("\n *** calloutAccessoryControlTapped has been called *** ")
        //print(self.studentInfo.first)
        
        // Found it!
        print(view.annotation?.subtitle)
         */
        
        
        if let webLink = view.annotation?.subtitle {
            print("Here is the web link: ")
            print(webLink)
            if let nsurlLink = NSURL(string: webLink!) {
                UIApplication.sharedApplication().openURL(nsurlLink)
            }
        } else {
            print("Unable to access the student's url")
        }
    }
    
    
}


