//
//  UdacityConvenience.swift
//  On-The-Map
//
//  Created by Daniel J Janiak on 6/30/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import UIKit

extension UdacityClient {
    
    
    func attemptLogin(loginName: String, password: String, completionHandlerForLogin: (result: AnyObject!, error: NSError?) -> Void) {
        
        let loginURL = udacityAPIURLFromParameters(Methods.Method_AUTHENTICATION, userID: nil)
        
        let request = NSMutableURLRequest(URL: loginURL)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(loginName)\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            func sendError(error: String) {
                print(error)
                // TODO: Uncomment the two lines below in the final version of the function
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForLogin(result: nil, error: NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            self.parseLoginData(data, completionHandlerForParseLoginData: completionHandlerForLogin)
            
        }
        
        task.resume()
        
    }
    
    func getUserName(completionHandlerForGetName: (error: NSError?) -> Void) {
        
        let userInfoURL = udacityAPIURLFromParameters(Methods.Method_STUDENT_INFO, userID: DataService.instance.getStudentID())
        
        let request = NSMutableURLRequest(URL: userInfoURL)
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            func sendError(error: String) {
                print(error)
                // TODO: Uncomment the two lines below in the final version of the function
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGetName(error: NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            self.parseAccountData(data, completionHandlerForParseAccountData: completionHandlerForGetName)
            
        }
        
        task.resume()
        
        
    }
    
    func parseLoginData(loginData: NSData, completionHandlerForParseLoginData: (result: AnyObject!, error: NSError?) -> Void) {
        
        // FOR ALL RESPONSES FROM THE UDACITY API, YOU WILL NEED TO SKIP THE FIRST 5 CHARACTERS OF THE RESPONSE.
        let newData = loginData.subdataWithRange(NSMakeRange(5, loginData.length - 5))
        
        var parsedResult: AnyObject!
        
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(newData)'"]
            completionHandlerForParseLoginData(result: nil, error: NSError(domain: "convertLoginData", code: 1, userInfo: userInfo))
        }
        
        
        //From the parsed result, extract the value for the key 'registered'
        
        guard let loginInfo = parsedResult as? [String: AnyObject] else {
            print("Failed to get login information")
            return
        }
        
        /* Check whether the account is valid */
        guard let accountInfo = loginInfo[JSONResponseKeys.AccountInfo] as? [String: AnyObject] else {
            print("Failed to get account information")
            return
        }
        
        guard let validAccount = accountInfo[JSONResponseKeys.IsValidAccount] as? Bool else {
            print("Failed to get account status")
            return
        }
        
        /* Get the user ID */
        
        guard let userID = accountInfo[JSONResponseKeys.UserID] as? String else {
            print("Failed to get userID")
            return
        }
        
        DataService.instance.setStudentID(userID)
        
        completionHandlerForParseLoginData(result: validAccount, error: nil)
        
    }
    
    func parseAccountData(accountData: NSData, completionHandlerForParseAccountData: (error: NSError?) -> Void) {
        
        let newData = accountData.subdataWithRange(NSMakeRange(5, accountData.length - 5))
        
        var parsedResult: AnyObject!
        
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(newData)'"]
            completionHandlerForParseAccountData(error: NSError(domain: "convertLoginData", code: 1, userInfo: userInfo))
        }
        
        
        guard let userInfoParsed = parsedResult["user"] as? [String: AnyObject] else {
            print("Failed to get userInfoParsed")
            return
        }
        
        guard let userLastName = userInfoParsed["last_name"] as? String else {
            print("Failed to get userInfoParsed")
            return
        }
        
        guard let userFirstName = userInfoParsed["first_name"] as? String else {
            print("Failed to get userInfoParsed")
            return
        }
        
        if userFirstName != "nil" {
            DataService.instance.setUserFirstName(userFirstName)
        } else {
            DataService.instance.setUserFirstName("")
        }
        
        if userLastName != "nil" {
            DataService.instance.setUserLastName(userLastName)
        } else {
            DataService.instance.setUserLastName("")
        }
        
        completionHandlerForParseAccountData(error: nil)
        
        
    }
    
    func logout(completionHandlerForLogout: (data: AnyObject?, error: String?) -> Void) {
        
        let logoutURL = udacityAPIURLFromParameters(Methods.Method_AUTHENTICATION, userID: nil)
        
        let request = NSMutableURLRequest(URL: logoutURL)
        request.HTTPMethod = "DELETE"
        
        var xsrfCookie: NSHTTPCookie? = nil
        
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            func sendError(error: String) {
                print(error)
                completionHandlerForLogout(data: nil, error: error)
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* subset response data! */
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            
            DataService.instance.resetStudentInfo()
            DataService.instance.dataNeedsUpdate
            
            completionHandlerForLogout(data: newData, error: nil)
        }
        task.resume()
    }

    
}

