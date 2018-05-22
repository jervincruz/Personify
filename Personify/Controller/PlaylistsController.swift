//
//  PlaylistsController.swift
//  iOSpotify
//
//  Created by Jervin Cruz on 5/15/18.
//  Copyright © 2018 Jervin Cruz. All rights reserved.
//

import UIKit
import Kingfisher
import NVActivityIndicatorView

class PlaylistsController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var rapCaviar = "https://api.spotify.com/v1/users/spotify/playlists/37i9dQZF1DX0XUsuxWHRQd/tracks"
    var releaseRadar = "https://api.spotify.com/v1/users/spotify/playlists/37i9dQZEVXbkgHHxEDhf26/tracks"
    var todaysTopHits = "https://api.spotify.com/v1/users/spotify/playlists/37i9dQZF1DXcBWIGoYBM5M/tracks"
    var theNewness = "https://api.spotify.com/v1/users/spotify/playlists/37i9dQZF1DWUzFXarNiofw/tracks"
    
    @IBOutlet var rapCaviarImage: UIImageView!
    @IBOutlet var releaseRadarImage: UIImageView!
    @IBOutlet var todaysTopHitsImage: UIImageView!
    @IBOutlet var theNewnessImage: UIImageView!
    
    var rapCaviarUrl : URL?
    var releaseRadarUrl : URL?
    var todaysTopHitsUrl : URL?
    var theNewnessUrl : URL?
    
    var delegate = UIApplication.shared.delegate as? AppDelegate
    let defaults = UserDefaults.standard
    let data = SpotifyData()
    var tracks : [Track]?

    @IBOutlet var playlistTable: UITableView!
    @IBOutlet var activityIndicatorView: NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.playlistTable.reloadData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        delegate?.playlistTriggered = true
        delegate?.searchTriggered = false
        
        activityIndicatorView.type = .lineScale

        if (delegate?.playlistTracks.isEmpty)! {
            activityIndicatorView.startAnimating()
            loadTracks()
            self.playlistTable.reloadData()
        }
        
        self.rapCaviarImage.kf.setImage(with: defaults.url(forKey: "RapCaviar"))
        self.releaseRadarImage.kf.setImage(with: defaults.url(forKey: "ReleaseRadar"))
        self.todaysTopHitsImage.kf.setImage(with: defaults.url(forKey: "TodaysTopHits"))
        self.theNewnessImage.kf.setImage(with: defaults.url(forKey: "TheNewness"))

    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.playlistTable.reloadData()
    }

    func loadTracks() {
        
        delegate?.playlistTriggered = true
        delegate?.searchTriggered = false
        
        DispatchQueue.main.async {
            self.data.callAlamo(url: self.rapCaviar)
            self.data.callAlamo(url: self.releaseRadar)
            self.data.callAlamo(url: self.todaysTopHits)
            self.data.callAlamo(url: self.theNewness)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
                let rapCaviarUrl = URL(string: (self.delegate?.playlistTracks[0].image)!)
                let releaseRadarUrl = URL(string: (self.delegate?.playlistTracks[1].image)!)
                let todaysTopHitsUrl = URL(string: (self.delegate?.playlistTracks[2].image)!)
                let theNewnessUrl = URL(string: (self.delegate?.playlistTracks[3].image)!)
                
                self.defaults.set(rapCaviarUrl, forKey: "RapCaviar")
                self.defaults.set(releaseRadarUrl, forKey: "ReleaseRadar")
                self.defaults.set(todaysTopHitsUrl, forKey: "TodaysTopHits")
                self.defaults.set(theNewnessUrl, forKey: "TheNewness")
                
                self.rapCaviarImage.kf.setImage(with: rapCaviarUrl)
                self.releaseRadarImage.kf.setImage(with: releaseRadarUrl)
                self.todaysTopHitsImage.kf.setImage(with: todaysTopHitsUrl)
                self.theNewnessImage.kf.setImage(with: theNewnessUrl)
            })

        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {
            self.playlistTable.reloadData()
            self.activityIndicatorView.stopAnimating()
            print("COUNT: ", self.delegate?.playlistTracks.count)
        })
    }
    
    /** Playlist Table **/
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (delegate?.playlistTracks.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playlistCell") as! TrackTableViewCell
        
        let url = URL(string: (delegate?.playlistTracks[indexPath.row].image)!)
        cell.trackNameLabel.text = delegate?.playlistTracks[indexPath.row].name
        cell.trackArtistLabel.text = delegate?.playlistTracks[indexPath.row].artist
        cell.trackImage.kf.setImage(with: url)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(tracks![indexPath.row].name)
        playSong(uri: tracks![indexPath.row].uri)
        delegate?.checkHistoryTracks(t: tracks![indexPath.row])
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
