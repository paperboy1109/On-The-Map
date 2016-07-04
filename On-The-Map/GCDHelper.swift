//
//  GCDHelper.swift
//  On-The-Map
//
//  Created by Daniel J Janiak on 6/24/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(updates: () -> Void) {
    dispatch_async(dispatch_get_main_queue()) {
        updates()
    }
}