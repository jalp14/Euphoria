//
//  NowPlayingView.swift
//  Euphoria
//
//  Created by Jalp on 28/10/2018.
//  Copyright © 2018 JDC0rp. All rights reserved.
//

import Foundation
import UIKit

class NowPlayingView : UIViewController {
    
    @IBOutlet weak var albumArtIage: UIImageView!
    
    @IBOutlet var musicProgressBar: UIView!
    
    @IBOutlet weak var mediaControlBtn: UIButton!
    
    @IBOutlet weak var volumeSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
