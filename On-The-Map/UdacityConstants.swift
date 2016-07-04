//
//  UdacityConstants.swift
//  On-The-Map
//
//  Created by Daniel J Janiak on 6/30/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import UIKit

extension UdacityClient {
    
    // MARK: - Constants
    struct Constants {
        
        // MARK: - API Key
        static let ApiKey: String = ""
        
        // MARK: - URLs
        static let ApiScheme = "https"
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "/api"
    }
    
    // MARK: - Methods
    struct Methods {
        
        // Log in
        static let Method_AUTHENTICATION = "/session"
        static let Method_STUDENT_INFO = "/users"
    }
    
    // MARK: - JSON Response Keys
    struct JSONResponseKeys {
        
        static let AccountInfo = "account"
        static let IsValidAccount = "registered"
        static let UserID = "key"
        
    }
    
}
