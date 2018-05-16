//
//  DiscoverController.swift
//  iOSpotify
//
//  Created by Jervin Cruz on 5/15/18.
//  Copyright © 2018 Jervin Cruz. All rights reserved.
//

import UIKit

class DiscoverController : UIViewController, UITableViewDelegate, UITableViewDataSource {

    let data = SpotifyData()
    let delegate = UIApplication.shared.delegate as? AppDelegate
    var tracks = [Track]()
    
    @IBOutlet var discoverTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.data.callAlamo(url: "https://api.spotify.com/v1/users/spotify/playlists/37i9dQZEVXcI6GCUcgx03q/tracks")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.tracks = (self.delegate?.discoverTracks)!
            print("Discover Tracks: ", self.tracks)
            self.discoverTable.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "discoverCell") as! TrackTableViewCell
        
        cell.trackNameLabel.text = tracks[indexPath.row].name
        cell.trackArtistLabel.text = tracks[indexPath.row].artist
        
        return cell
    }
    
    
    
}
