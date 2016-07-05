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
        
        map.addAnnotations(mapAnnotations)
        
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

extension MapVC: MKMapViewDelegate {
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "Student"
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
        
        if annotationView == nil {
            //4
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
            
            // 5
            let btn = UIButton(type: .DetailDisclosure)
            annotationView!.rightCalloutAccessoryView = btn
        } else {
            // 6
            annotationView!.annotation = annotation
        }
        
        return annotationView
        
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        // What came with the annotationView?
        print("\n *** calloutAccessoryControlTapped has been called *** ")
        //print(self.studentInfo.first)
        
        // Found it!
        print(view.annotation?.subtitle)
        
        // TODO: use the subtitle to link to the right web address
        
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


