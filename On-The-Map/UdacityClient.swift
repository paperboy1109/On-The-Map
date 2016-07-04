//
//  UdacityClient.swift
//  On-The-Map
//
//  Created by Daniel J Janiak on 6/30/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import Foundation
import UIKit

class UdacityClient: NSObject {
    
    // MARK: - Properties
    
    let session = NSURLSession.sharedSession()
    
    // authentication state
    var accountKey: Int? = nil
    
    
    // MARK: - Initializers
    
    override init() {
        super.init()
    }
    
    // MARK: - Helpers
    // create a URL from parameters
    func udacityAPIURLFromParameters(method: String, userID: String?) -> NSURL {
        let components = NSURLComponents()
        components.scheme = UdacityClient.Constants.ApiScheme
        components.host = UdacityClient.Constants.ApiHost
        
        var methodID = userID
        if methodID != nil {
            methodID = "/" + methodID!
        }
        components.path = UdacityClient.Constants.ApiPath + (method) + (methodID ?? "")//UdacityClient.Methods.Method_STUDENT_LOCATION
        
        return components.URL!
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
    
}
