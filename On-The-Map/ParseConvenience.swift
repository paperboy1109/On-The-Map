//
//  ParseConvenience.swift
//  On-The-Map
//
//  Created by Daniel J Janiak on 6/26/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import Foundation
import UIKit
import MapKit


extension ParseClient {
    
    
    func getStudentInfo(completionHandlerForStudentInfo: (result: [StudentInformation]?, error: NSError?) -> Void) {
        
    }
    
    
    func postToServer(newStudentCoordinates: CLLocationCoordinate2D, newStudentLocationName: String, completionHandlerForPosting: (result: AnyObject?, error: NSError?) -> Void) {
        
        /* Specify parameters, method, and HTTP body */
        
        let urlParameters = [String: AnyObject]()
        let mutableMethod: String = Methods.Method_STUDENT_LOCATION
        //let jsonBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"Steve\", \"lastName\": \"Gibson\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": \(newStudentCoordinates.latitude), \"longitude\": \(newStudentCoordinates.longitude)}"
        let jsonBody = "{\"uniqueKey\": \"\(DataService.instance.getStudentID())\", \"firstName\": \"\(DataService.instance.getUserFirstName())\", \"lastName\": \"\(DataService.instance.getUserLastName())\",\"mapString\": \"\(newStudentLocationName)\", \"mediaURL\": \"\(DataService.instance.getStudentLink())\",\"latitude\": \(newStudentCoordinates.latitude), \"longitude\": \(newStudentCoordinates.longitude)}"
        
        
        
        print("(postToServer) Here is jsonBody ")
        print(jsonBody)
        
        /* Make the request */
        taskForPOSTMethod(mutableMethod, parameters: urlParameters,jsonBody: jsonBody) { (results, error) in
            
            
            
            /* Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForPosting(result: nil, error: error)
            } else {
                if let postResult = results["objectId"] {
                    
                    
                    // For debugging
                    print("\n(see postToServer func definition) Here is 'results' ")
                    print(results)
                    
                    completionHandlerForPosting(result: postResult, error: nil)

                    
                } else {
                    completionHandlerForPosting(result: nil, error: NSError(domain: "postToServer parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse postToServer"]))
                }
            }
        }
    }
    
    func downloadDataFromParse(completionHandlerForDownloadData: (outcome: Bool) -> Void) {
        
        let mutableMethod: String = ParseClient.Methods.Method_STUDENT_LOCATION
        
        var urlParameters = [String: AnyObject]()
        urlParameters[ParseClient.ParameterKeys.StudentInfoLimit] = ParseClient.ParameterValues.StudentInfoLimit
        urlParameters[ParseClient.ParameterKeys.StudentInfoOrder] = ParseClient.ParameterKeys.StudentInfoOrder
        
        ParseClient.sharedInstance().taskForGETMethod(mutableMethod, parameters: urlParameters) { (results, error) in
            
            if let apiData = results[ParseClient.JSONResponseKeys.APIResults] as? [[String: AnyObject]] {
                
                // (studentInfo will be an array of StudentInformation objects)
                let studentInfo = StudentInformation.studentInfoFromResults(apiData)
                DataService.instance.updateParseData(studentInfo)
                
            } else {
                print("Failed to get data from the parsed result")
            }
            
            DataService.instance.studentInfoUpdated()
            
            completionHandlerForDownloadData(outcome: true)
            
        }
    }
    
    
    
    
    
    
}