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
        if (musicPlayer.isPreparedToPlay) {
            if (musicPlayer.playbackState == .playing) {
                musicPlayer.stop()
                sender.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            } else if (musicPlayer.playbackState == .paused) {
                musicPlayer.play()
                sender.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            }
        }
    }
    
    @IBOutlet weak var mediaButtonStatic: UIButton!
    
    @IBOutlet weak var appTabBar: UITabBar!
    
    @IBOutlet weak var albumButton: UITabBarItem!
    
    @IBOutlet weak var songsButton: UITabBarItem!
    
    @IBOutlet weak var artistButton: UITabBarItem!
    
    @IBOutlet weak var navBar: UINavigationBar!
    
    var music : [Music] = []
    var songQuery = MPMediaQuery.songs()
    var songList : [MPMediaItem]!
    var musicPlayer = MPMusicPlayerController.applicationMusicPlayer
    var currentIndex = 0;
    var currentTitle = ""
    var currentId = 0
    var songPredicate = MPMediaPropertyPredicate()
    var artworkSize = CGSize(width: 49, height: 49)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestAccess()
        roundImages(image: currentAlbumImage)
        music = createArray()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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
        for song in songList {
            print(song.title)
        }
    }
    
    func findMusic(id : Int) -> String {
        currentTitle = songList[id].title!
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
        musicPlayer.setQueue(with: MPMediaItemCollection(items: songList))
        
        setupFloatingPlayer(currentTitle: title, currentImage: albumArtwork)
        mediaButtonStatic.setImage(#imageLiteral(resourceName: "pause.png"), for: .normal)
        musicPlayer.play()
    }
    
    func setupFloatingPlayer(currentTitle : String, currentImage : UIImage) {
        currentPlayingTitle.text = currentTitle
        currentAlbumImage.image = currentImage
    }
    
    
    func createArray() -> [Music] {
        var tempMusic : [Music] = []
        for song in songList {
            tempMusic.append(Music(image: (song.artwork?.image(at: artworkSize))!, title: song.title!))
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
        playSong(title: currentTitle, albumArtwork: (songList[indexPath.row].artwork?.image(at: artworkSize))!)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        songQuery.removeFilterPredicate(songPredicate)
        songList = songQuery.items!
    }
    
}



