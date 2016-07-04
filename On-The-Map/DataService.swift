//
//  DataService.swift
//  On-The-Map
//
//  Created by Daniel J Janiak on 6/28/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import Foundation

class DataService {
    
    // MARK: - Properties
    static let instance = DataService()
    
    private var _loadedStudentInfo = [StudentInformation]()
    private var _dataNeedsUpdate = Bool()
    private var _currentUserID = String()
    private var _userFirstName = String()
    private var _userLastName = String()
    private var _userNameKnown = Bool()
    private var _studentLink = String()
    
    
    var loadedStudentInfo: [StudentInformation] {
        return _loadedStudentInfo
    }
    
    var dataNeedsUpdate: Bool {
        return _dataNeedsUpdate
    }
    
    func addIndividualStudentInfo(individualInfo: StudentInformation) {
        _loadedStudentInfo.append(individualInfo)
    }
    
    func updateParseData(parseDataArray: [StudentInformation]) {
        _loadedStudentInfo = parseDataArray
    }
    
    func studentInfoIsOutdated() {
        _dataNeedsUpdate = true
    }
    
    func studentInfoUpdated() {
        _dataNeedsUpdate = false
    }
    
    func resetStudentInfo() {
        _loadedStudentInfo = [StudentInformation]()
    }
    
    func setStudentID(currentID: String) {
        _currentUserID = currentID
    }
    
    func getStudentID() -> String {
        return _currentUserID
    }
    
    func setUserFirstName(firstName: String) {
        _userFirstName = firstName
    }
    
    func getUserFirstName() -> String {
        return _userFirstName
    }
    
    func setUserLastName(lastName: String) {
        _userLastName = lastName
    }
    
    func getUserLastName() -> String {
        return _userLastName
    }
    
    func setUserNameUnknown() {
        _userNameKnown = false
    }
    
    func setUserNameKnown() {
        _userNameKnown = true
    }
    
    func userNameKnown() -> Bool {
        return _userNameKnown
    }
    
    func setStudentLink(newLink: String) {
        _studentLink = newLink
    }
    
    func getStudentLink() -> String {
        return _studentLink
    }
    
    
}