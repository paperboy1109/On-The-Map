//
//  ParseConstants.swift
//  On-The-Map
//
//  Created by Daniel J Janiak on 6/23/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import UIKit

extension ParseClient {
    
    // MARK: - Constants
    struct Constants {
        
        // MARK: - API Key
        static let ApiKey: String = ""
        
        // MARK: - URLs
        static let ApiScheme = "https"
        static let ApiHost = "api.parse.com"
        static let ApiPath = "/1"
        
    }
    
    // MARK: - Methods
    struct Methods {
        
        // MARK: - Both GET and POST
        static let Method_STUDENT_LOCATION = "/classes/StudentLocation"
        
    }
    
    // MARK: - Parameter Keys
    struct ParameterKeys {
        static let ApiKey = "api_key"
        static let StudentInfoLimit = "limit"
        static let StudentInfoOrder = "order"
    }
    
    // MARK: - Parameter Values
    struct ParameterValues {
        static let StudentInfoLimit = "100"
        static let StudentInfoOrder = "-updatedAt"
    }
    
    // MARK: - JSON Response Keys
    struct JSONResponseKeys {
        
        static let APIResults = "results"
        static let StudentFirstName = "firstName"
        static let StudentLastName = "lastName"
        static let StudentLocationName = "mapString"
        static let StudentLatitude = "latitude"
        static let StudentLongitude = "longitude"
        static let StudentLink = "mediaURL"
    }
    
}