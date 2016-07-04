//
//  GrayButton.swift
//  On-The-Map
//
//  Created by Daniel J Janiak on 7/2/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import UIKit

class GrayButton: UIButton {
    
    override func awakeFromNib() {
        layer.cornerRadius = 5.0
        backgroundColor = UIColor(colorLiteralRed: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0)
        setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
    }
    
}
