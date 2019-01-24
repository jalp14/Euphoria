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
    
    var musicControl : ((_ sender : UIButton) -> ())?
    
    var initialTouchPoint : CGPoint = CGPoint(x: 0, y: 0)
    
    @IBAction func dismissNowPlayingUI(_ sender: UIPanGestureRecognizer) {
     let touchPoint = sender.location(in: self.view.window)
        
        // Check if the state of the gesture changes
        if sender.state == UIGestureRecognizer.State.began {
            initialTouchPoint = touchPoint
        } else if sender.state == UIGestureRecognizer.State.changed {
            if touchPoint.y - initialTouchPoint.y > 100 {
            self.view.frame = CGRect(x: 0, y: touchPoint.y - initialTouchPoint.y, width: self.view.frame.width, height: self.view.frame.height)
            }
        } else if sender.state == UIGestureRecognizer.State.ended || sender.state == UIGestureRecognizer.State.cancelled {
            if touchPoint.y - initialTouchPoint.y > 100 {
                self.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                    })
            }
        }
    }
    
    
    @IBOutlet weak var trackDuration: UIProgressView!
    @IBOutlet weak var albumName: UILabel!
    
    @IBAction func playButton(_ sender: UIButton) {
        musicControl?(sender)
    }
    
    
    @IBAction func prevButton(_ sender: Any) {
    }
    
    @IBAction func nextButton(_ sender: Any) {
    }
    
    @IBAction func volumeSlider(_ sender: Any) {
    }
    
    
    var track : String = "Not Playing"
    var album : UIImage = UIImage()
    var albumTitle : String = "Album"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentTrack.text = track
        albumArtwork.image = album
        albumName.text = albumTitle
    }

     required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}
