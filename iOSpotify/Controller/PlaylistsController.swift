//
//  PlaylistsController.swift
//  iOSpotify
//
//  Created by Jervin Cruz on 5/15/18.
//  Copyright © 2018 Jervin Cruz. All rights reserved.
//

import UIKit

class PlaylistsController : UIViewController, UITableViewDelegate, UITableViewDataSource {

    var rapCaviar = "https://api.spotify.com/v1/users/spotify/playlists/37i9dQZF1DX0XUsuxWHRQd/tracks"
    var releaseRadar = "https://api.spotify.com/v1/users/spotify/playlists/37i9dQZEVXbkgHHxEDhf26/tracks"
    var todaysPopHits = "https://api.spotify.com/v1/users/spotify/playlists/37i9dQZF1DXcBWIGoYBM5M/tracks"
    var theNewness = "https://api.spotify.com/v1/users/spotify/playlists/37i9dQZF1DWUzFXarNiofw/tracks"
    
    
    var tracks = [Track]()
    var delegate = UIApplication.shared.delegate as? AppDelegate
    let data = SpotifyData()
    
    @IBOutlet var playlistTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate?.playlistTriggered = true
        delegate?.searchTriggered = false
        
        data.callAlamo(url: rapCaviar)
        data.callAlamo(url: releaseRadar)
        data.callAlamo(url: todaysPopHits)
        data.callAlamo(url: theNewness)

        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.tracks = (self.delegate?.playlistTracks)!
            print("Playlist Tracks: ", self.tracks)
            self.playlistTable.reloadData()
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playlistCell") as! TrackTableViewCell
        
        cell.trackNameLabel.text = tracks[indexPath.row].name
        cell.trackArtistLabel.text = tracks[indexPath.row].artist
        
        return cell
    }
    
    
}
