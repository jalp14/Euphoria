//
//  CustomImage.swift
//  Euphoria
//
//  Created by Jalp on 12/12/2018.
//  Copyright © 2018 JDC0rp. All rights reserved.
//

import UIKit

class CustomImage: UIImageView {
    
    override init(image: UIImage?) {
        super.init(image: image)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Shady stuff
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 4.0, height: 4.0)
        self.layer.shadowOpacity = 0.9
        self.layer.shadowRadius = 4.0
        
        // Radii stuff
        self.layer.cornerRadius = 9.0
        self.layer.masksToBounds = true
    }

}
