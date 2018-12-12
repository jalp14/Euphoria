//
//  NowPlayingViewController.swift
//  Euphoria
//
//  Created by Jalp on 11/12/2018.
//  Copyright © 2018 JDC0rp. All rights reserved.
//

import Foundation
import UIKit

class NowPlayingViewController : UIViewController {
    

    @IBOutlet weak var albumArtwork: UIImageView!
    @IBOutlet weak var currentTrack: UILabel!
    
    var track : String = "Not Playing"
    var album : UIImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentTrack.text = track
        albumArtwork.image = album
    }

     required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
}
