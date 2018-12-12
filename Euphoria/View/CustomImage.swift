//
//  CustomImage.swift
//  Euphoria
//
//  Created by Jalp on 12/12/2018.
//  Copyright © 2018 JDC0rp. All rights reserved.
//

import UIKit

@IBDesignable
class CustomImage: UIImageView {
    
    override init(image: UIImage?) {
        super.init(image: image)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 9.0
        self.layer.shadowRadius = 0.5
        self.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 9.0).cgPath
        self.layer.shadowColor = UIColor.black.cgColor
        self.clipsToBounds = true
    }

}
