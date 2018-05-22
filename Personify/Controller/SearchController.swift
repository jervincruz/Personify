//
//  SearchController.swift
//  iOSpotify
//
//  Created by Jervin Cruz on 5/15/18.
//  Copyright © 2018 Jervin Cruz. All rights reserved.
//

import UIKit
import AVFoundation
import Kingfisher

class SearchController : UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, SPTAudioStreamingPlaybackDelegate, SPTAudioStreamingDelegate {

    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var searchTable: UITableView!
    @IBOutlet var songArtistControl: UISegmentedControl!
    
    @IBOutlet var songNameLabel: UILabel!
    @IBOutlet var songArtistLabel: UILabel!
    
    var tracks = [Track]()
    var delegate = UIApplication.shared.delegate as? AppDelegate
    var data = SpotifyData()
    
    let searchQuery = "https://api.spotify.com/v1/search?q="

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate?.searchTriggered = true
        delegate?.playlistTriggered = false
    }
    
    // Handle Action On Return
    @IBAction func textFieldPrimaryActionTriggered(_ sender: Any) {

        // Search TextField
        let userSearch = searchTextField.text!
        let searchSpotify = userSearch.replacingOccurrences(of: " ", with: "%20")
        print("Spotify Search: ", searchSpotify)
        
        // Song / Artist Segmented Control
        var searchType = "&type="
        
        switch(songArtistControl.selectedSegmentIndex){
            case 0:
                searchType += "track"
            case 1:
                searchType += "track"
            default:
                searchType += "song"
        }
        
        let search = searchQuery + searchSpotify + searchType
        print("Search: ", search)
        
        data.callAlamo(url: search)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.tracks = (self.delegate?.searchTracks)!
            print("Search Tracks: ", self.tracks)
            self.searchTable.reloadData()
        }

    }
    
    // Hide Keyboard On Return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell") as! TrackTableViewCell
        let url = URL(string: tracks[indexPath.row].image)
        cell.trackNameLabel.text = tracks[indexPath.row].name
        cell.trackArtistLabel.text = tracks[indexPath.row].artist
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
