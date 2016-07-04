//
//  FacebookLoginButton.swift
//  On-The-Map
//
//  Created by Daniel J Janiak on 6/23/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import UIKit

class FacebookLoginButton: UIButton {
    
    override func awakeFromNib() {
        layer.cornerRadius = 5.0
        backgroundColor = UIColor(colorLiteralRed: 74.0/255.0, green: 99.0/255.0, blue: 183.0/255.0, alpha: 1.0)
        setTitleColor(UIColor.whiteColor(), forState:  .Normal)
    }

}
