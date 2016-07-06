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
    
    func postToServer(newStudentCoordinates: CLLocationCoordinate2D, newStudentLocationName: String, completionHandlerForPosting: (result: AnyObject?, error: NSError?) -> Void) {
        
        /* Specify parameters, method, and HTTP body */
        
        let urlParameters = [String: AnyObject]()
        let mutableMethod: String = Methods.Method_STUDENT_LOCATION
        let jsonBody = "{\"uniqueKey\": \"\(DataService.instance.getStudentID())\", \"firstName\": \"\(DataService.instance.getUserFirstName())\", \"lastName\": \"\(DataService.instance.getUserLastName())\",\"mapString\": \"\(newStudentLocationName)\", \"mediaURL\": \"\(DataService.instance.getStudentLink())\",\"latitude\": \(newStudentCoordinates.latitude), \"longitude\": \(newStudentCoordinates.longitude)}"
        
        /* Make the request */
        taskForPOSTMethod(mutableMethod, parameters: urlParameters,jsonBody: jsonBody) { (results, error) in
            
            
            /* Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForPosting(result: nil, error: error)
            } else {
                if let postResult = results["objectId"] {
                    
                    
                    // For debugging
                    /*
                     print("\n(see postToServer func definition) Here is 'results' ")
                     print(results)
                     */
                    
                    completionHandlerForPosting(result: postResult, error: nil)
                    
                    
                } else {
                    completionHandlerForPosting(result: nil, error: NSError(domain: "postToServer parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse postToServer"]))
                }
            }
        }
    }
    
    func downloadDataFromParse(completionHandlerForDownloadData: (error: Bool, errorDesc: NSError?) -> Void) {
        
        let mutableMethod: String = ParseClient.Methods.Method_STUDENT_LOCATION
        
        var urlParameters = [String: AnyObject]()
        urlParameters[ParseClient.ParameterKeys.StudentInfoLimit] = ParseClient.ParameterValues.StudentInfoLimit
        urlParameters[ParseClient.ParameterKeys.StudentInfoOrder] = ParseClient.ParameterValues.StudentInfoOrder
        
        /* Make the request */
        taskForGETMethod(mutableMethod, parameters: urlParameters) { (results, error) in
            
            print("(Closure, taskForGETMethod) error:")
            print(error)
            print(results)
            print(results.count)
            print(results.dynamicType)
            
            /* Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForDownloadData(error: true, errorDesc: error)
            } else {
                
                if let apiData = results[ParseClient.JSONResponseKeys.APIResults] as? [[String: AnyObject]] {
                    
                    print("Here is apiData.count")
                    print(apiData.count)
                    
                    if apiData.count > 0 {
                        let studentInfo = StudentInformation.studentInfoFromResults(apiData)
                        DataService.instance.updateParseData(studentInfo)
                        DataService.instance.studentInfoUpdated()
                        completionHandlerForDownloadData(error: false, errorDesc: nil)
                    } else {
                        // (login will fail)
                        let studentInfo = StudentInformation.studentInfoFromResults(apiData)
                        DataService.instance.updateParseData(studentInfo)
                        DataService.instance.studentInfoUpdated()
                        completionHandlerForDownloadData(error: true, errorDesc: nil)
                    }
                    
                    // Reverse the order of the data (if needed)
                    //DataService.instance.reverseDataOrder()
                    
                } else {
                    print("Failed to get data from the parsed result")
                    DataService.instance.studentInfoIsOutdated()
                    completionHandlerForDownloadData(error: true, errorDesc: nil)
                }                
            }
            
            
            
        }
    }
    
    
    
    
    
    
}