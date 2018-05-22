//
//  DiscoverController.swift
//  iOSpotify
//
//  Created by Jervin Cruz on 5/15/18.
//  Copyright © 2018 Jervin Cruz. All rights reserved.
//

import UIKit
import Kingfisher
import NVActivityIndicatorView


class DiscoverController : UIViewController, UITableViewDelegate, UITableViewDataSource {

    let data = SpotifyData()
    let delegate = UIApplication.shared.delegate as? AppDelegate
    var tracks = [Track]()
    let activityData = ActivityData()
    
    @IBOutlet var discoverCoverImage: UIImageView!
    @IBOutlet var discoverTable: UITableView!
    @IBOutlet var activityIndicatorView: NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate?.playlistTriggered = true
        delegate?.searchTriggered = false
        
        // Animate and Load Tracks
        activityIndicatorView.type = .lineScale
        activityIndicatorView.startAnimating()
        loadTracks()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        delegate?.playlistTriggered = true
        delegate?.searchTriggered = false
        
        loadTracks()
        DispatchQueue.main.async {
            self.activityIndicatorView.stopAnimating()
        }
    }
    
    func loadTracks(){
        DispatchQueue.main.async {
            self.data.callAlamo(url: "https://api.spotify.com/v1/users/spotify/playlists/37i9dQZEVXcI6GCUcgx03q/tracks")
            self.discoverTable.reloadData()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.tracks = (self.delegate?.discoverTracks)!
            print("Discover Tracks: ", self.delegate?.discoverTracks)
            self.discoverTable.reloadData()
            
            //Set Cover Art
            guard (self.delegate?.discoverTracks.isEmpty)! else {
                let coverURL = URL(string: (self.delegate?.discoverTracks[0].image)!)
                self.discoverCoverImage.kf.setImage(with: coverURL)
                return
            }
        }
    }
    
    // Discover Table
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "discoverCell") as! TrackTableViewCell
        let url = URL(string: (delegate?.discoverTracks[indexPath.row].image)!)
        cell.trackNameLabel.text = delegate?.discoverTracks[indexPath.row].name
        cell.trackArtistLabel.text = delegate?.discoverTracks[indexPath.row].artist
        cell.trackImage.kf.setImage(with: url)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(tracks[indexPath.row].name)
        playSong(uri: tracks[indexPath.row].uri)
        delegate?.checkHistoryTracks(t: tracks[indexPath.row])
    }
    
    func playSong(uri : String) {
        delegate?.activateAudioSession()
        self.delegate?.player?.playSpotifyURI(uri, startingWith: 0, startingWithPosition: 0, callback: { (error) in
            if (error != nil) {
                print("playing!")
            }
        })
    }
    
}
