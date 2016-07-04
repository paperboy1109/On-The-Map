//
//  OrangeButton.swift
//  On-The-Map
//
//  Created by Daniel J Janiak on 6/23/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import UIKit

class OrangeButton: UIButton {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        layer.cornerRadius = 5.0
        backgroundColor = UIColor(colorLiteralRed: 255.0/255.0, green: 59.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        setTitleColor(UIColor.whiteColor(), forState:  .Normal)
    }

}
