//
//  MusicListView.swift
//  Euphoria
//
//  Created by Jalp on 09/10/2018.
//  Copyright © 2018 JDC0rp. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class MusicListView: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.rowHeight = UITableView.automaticDimension
        }
    }
    
    @IBOutlet weak var currentAlbumImage: UIImageView!
    
    @IBOutlet weak var floatingPlayer : UIView!
    
    @IBOutlet weak var currentPlayingTitle: UILabel!
    
    @IBAction func mediaButton(_ sender: UIButton) {
        controlMusic(sender)
    }
    
    
    @IBOutlet weak var mediaButtonStatic: UIButton!
    
    @IBOutlet weak var navBar: UINavigationBar!
    
    var music : [Music] = []
    var songQuery = MPMediaQuery.songs()
    var songList : [MPMediaItem]!
    var audioPlayer : AVAudioPlayer!
    var musicURL : URL!
    var currentIndex = 0;
    var currentTitle = ""
    var currentId = 0
    var songPredicate = MPMediaPropertyPredicate()
    var miniArtworkSize = CGSize(width: 49, height: 49)
    var maxArtworkSize = CGSize(width: 200, height: 200)
    var minAlbumArtwork = UIImage()
    var maxAlbumArtwork = UIImage()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestAccess()
        roundImages(image: currentAlbumImage)
        music = createArray()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.expandPlayer))
        floatingPlayer.addGestureRecognizer(gesture)
    }
    
    @objc func expandPlayer(sender : UITapGestureRecognizer) {
        print("Expanding UI")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "NowPlayingUI") as! NowPlayingViewController
        controller.track = currentTitle
        controller.album = maxAlbumArtwork
        self.present(controller, animated: true, completion: nil)
        print("Success")
        
        controller.musicControl = { sender in
            self.controlMusic(sender)
        }
    }
    
    func controlMusic(_ sender: UIButton) {
        if (audioPlayer.prepareToPlay()) {
            if (audioPlayer.isPlaying) {
                audioPlayer.pause()
                sender.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            } else if !(audioPlayer.isPlaying) {
                audioPlayer.play()
                sender.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            }
        }
    }
    
    func roundImages(image : UIImageView) {
        image.layer.cornerRadius = 6.0
        image.clipsToBounds = true
        image.layer.borderWidth = 2.0
        image.layer.borderColor = UIColor.white.cgColor
    }
    
    func requestAccess(){
        let status = MPMediaLibrary.authorizationStatus()
        
        switch status {
        case .authorized :
            print("Authorised")
        case .notDetermined :
            MPMediaLibrary.requestAuthorization() { status in
                if status == .authorized {
                    DispatchQueue.main.async {
                        // Sync
                    }
                }
            }
        case .denied :
            print("Denied")
        case .restricted :
            print("Restricted")
        }
        accessMusicLibrary()
    }
    
    func accessMusicLibrary(){
        songList = songQuery.items! as [MPMediaItem]
        print("\(songList.count) songs loaded")
    }
    
    func findMusic(id : Int) -> String {
        currentTitle = songList[id].title!
        minAlbumArtwork = (songList[id].artwork?.image(at: miniArtworkSize))!
        maxAlbumArtwork = (songList[id].artwork?.image(at: CGSize(width: 200, height: 200)))!
        return currentTitle
    }
    
    
    func playSong(title : String, albumArtwork : UIImage) {
        songPredicate = MPMediaPropertyPredicate(value: title, forProperty: MPMediaItemPropertyTitle)
        songQuery.addFilterPredicate(songPredicate)
        
        if (songQuery.items?.count)! < 1 {
            print("Song not found")
            return
        } else {
            print("Playing now")
        }
        songList = songQuery.items! as [MPMediaItem]
        let musicURL = songQuery.items?.first?.value(forProperty: MPMediaItemPropertyAssetURL) as? URL
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: musicURL!)
            audioPlayer.prepareToPlay()
        } catch {
            print(error)
        }
        setupFloatingPlayer(currentTitle: title, currentImage: albumArtwork)
        mediaButtonStatic.setImage(#imageLiteral(resourceName: "pause.png"), for: .normal)
        audioPlayer.play()
    }
    
    func setupFloatingPlayer(currentTitle : String, currentImage : UIImage) {
        currentPlayingTitle.text = currentTitle
        currentAlbumImage.image = currentImage
    }
    
    
    func createArray() -> [Music] {
        var tempMusic : [Music] = []
        for song in songList {
            // Add a check for songs with no album artwork
            tempMusic.append(Music(image: (song.artwork?.image(at: miniArtworkSize))!, title: song.title!))
        }
        return tempMusic
    }
}




extension MusicListView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return music.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let musicCell = music[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MusicCell") as! MusicCell
        cell.setMusic(music: musicCell)
        cell.roundImages()
        cell.clipsToBounds = false
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("didSelect  \(indexPath.row)")
        currentTitle = findMusic(id: indexPath.row)
        print(currentTitle)
        playSong(title: currentTitle, albumArtwork: (minAlbumArtwork))
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        songQuery.removeFilterPredicate(songPredicate)
        songList = songQuery.items!
    }
    
}



