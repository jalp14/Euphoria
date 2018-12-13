//
//  RoundedPlayer.swift
//  Euphoria
//
//  Created by Jalp on 16/11/2018.
//  Copyright © 2018 JDC0rp. All rights reserved.
//

import Foundation
import UIKit

class RoundedPlayer : UIView {
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        }
    }
