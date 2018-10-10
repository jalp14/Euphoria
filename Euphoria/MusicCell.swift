//
//  MusicCell.swift
//  Euphoria
//
//  Created by Jalp on 09/10/2018.
//  Copyright © 2018 JDC0rp. All rights reserved.
//

import UIKit

class MusicCell: UITableViewCell {

    @IBOutlet weak var musicImageView: UIImageView!
    @IBOutlet weak var musicTitleLabel: UILabel!
    
    func setMusic(music : Music){
        musicImageView.image = music.image
        musicTitleLabel.text = music.title
    }
    
    
    
}
