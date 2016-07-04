//
//  StudentInformation.swift
//  On-The-Map
//
//  Created by Daniel J Janiak on 6/24/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import MapKit

struct StudentInformation {
    
    // MARK: Properties
    
    // store individual locations and links downloaded from the service
    let link: String?
    let name: String?
    let latitude: Float?
    let longitude: Float?
    //let location: String?
    var location: CLLocationCoordinate2D? {
        return CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude!), longitude: CLLocationDegrees(longitude!))
    }
    
    // Allow the data to be easily shared
    static var studentDataFromParse = [StudentInformation]()
    
    
    // MARK: Initializers
    // The struct has an init() method that accepts a dictionary as an argument
    // *** It is this method, the init() method that turns response data into a StudentInformation object !
    init(dictionary: [String:AnyObject]) {
        
        if let fName = dictionary[ParseClient.JSONResponseKeys.StudentFirstName], lName = dictionary[ParseClient.JSONResponseKeys.StudentLastName] {
            name = "\(fName) \(lName)"
        } else {
            name = ""
        }
        
        link = dictionary[ParseClient.JSONResponseKeys.StudentLink] as? String
        latitude = dictionary[ParseClient.JSONResponseKeys.StudentLatitude] as? Float
        longitude = dictionary[ParseClient.JSONResponseKeys.StudentLongitude] as? Float
        
        //location = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude!), longitude: CLLocationDegrees(longitude!))
        
    }
    
    
    static func studentInfoFromResults(apiResults: [[String:AnyObject]]) -> [StudentInformation] {
        
        var studentInfoArray = [StudentInformation]()
        
        for item in apiResults {
            studentInfoArray.append(StudentInformation(dictionary: item))
        }
        
        return studentInfoArray
    }
    
    
    
    
    
    
    
    
}
