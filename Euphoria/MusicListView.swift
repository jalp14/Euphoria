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
    
    @IBOutlet weak var tableView: UITableView!
     
    var music : [Music] = []
    var songQuery = MPMediaQuery.songs()
    var songList : [MPMediaItem]!
    var musicPlayer = MPMusicPlayerController.applicationMusicPlayer
    var currentIndex = 0;
    var currentTitle = ""
    var currentId = 0
    var songPredicate = MPMediaPropertyPredicate()

    

    override func viewDidLoad() {
        super.viewDidLoad()
        requestAccess()
        music = createArray()
        tableView.delegate = self
        tableView.dataSource = self
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
    
    func playSong(title : String) {
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
        musicPlayer.play()
    }
    
    
    func createArray() -> [Music] {
        
        var tempMusic : [Music] = []
       
        let artworkSize = CGSize(width: 49, height: 49)
       
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
        
         return cell
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelect  \(indexPath.row)")
        currentTitle = findMusic(id: indexPath.row)
        print(currentTitle)
        playSong(title: currentTitle)
     }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        songQuery.removeFilterPredicate(songPredicate)
        songList = songQuery.items!
    }
        
    }


