//
//  SpotifyData.swift
//  iOSpotify
//
//  Created by Jervin Cruz on 5/15/18.
//  Copyright © 2018 Jervin Cruz. All rights reserved.
//

import Alamofire
import SwiftyJSON

class SpotifyData {
    
    let delegate = UIApplication.shared.delegate as? AppDelegate
    var tracks = [Track]()
    
    func callAlamo(url: String) {
        Alamofire
            .request(url, method: .get, headers: ["Authorization":"Bearer " + (delegate?.accessToken)!])
            .responseJSON { response in
                if response.result.isSuccess {
                    print("Response: ", response)
                    let spotifyJSON : JSON = JSON(response.result.value!)
                    self.updateSpotifyData(json : spotifyJSON)
                  //  self.tableView.reloadData()
                }
        }
    }
    
    func updateSpotifyData(json : JSON) {
        do {
            delegate?.discoverTracks = []
            delegate?.playlistTracks = []
            delegate?.searchTracks = []
            
            var x : Int = 0

            // Search
            if (delegate?.searchTriggered)! {
                while json["tracks"]["items"][x] != JSON.null {
                    // Add Track
                    let name = json["tracks"]["items"][x]["name"].stringValue
                    let artist = json["tracks"]["items"][x]["artists"][0]["name"].stringValue
                    let uri = json["tracks"]["items"][x]["uri"].stringValue
                    let popularity = json["tracks"]["items"][x]["popularity"].intValue

                    let track = Track(name: name, artist: artist, uri: uri, popularity: popularity)
                    
                    if tracks.contains(where: { $0.name == track.name &&
                        $0.artist == track.artist &&
                        $0.popularity == track.popularity &&
                        $0.uri == track.uri }) {
                        x = x + 1
                    } else {
                        self.tracks.append(track)
                        x = x + 1
                    }
                }
            } else {
                // Discover Weekly / Playlists
                    while json["items"][x] != JSON.null {
                        let name = json["items"][x]["track"]["name"].stringValue
                        let artist = json["items"][x]["track"]["artists"][0]["name"].stringValue
                        let uri = json["items"][x]["track"]["uri"].stringValue
                        let popularity = json["items"][x]["track"]["popularity"].intValue
        
                        let track = Track(name: name, artist: artist, uri: uri, popularity: popularity)
                
                        if tracks.contains(where: { $0.name == track.name &&
                            $0.artist == track.artist &&
                            $0.popularity == track.popularity &&
                            $0.uri == track.uri }) {
                            x = x + 1
                        } else {
                            self.tracks.append(track)
                            x = x + 1
                        }
                    }
            }
        
            for i in 0..<tracks.count {
                print("Name: ", tracks[i].name)
                print("Artist: ", tracks[i].artist)

            }
            tracks.sort{ $0.popularity > $1.popularity }
            
            delegate?.discoverTracks = tracks
            delegate?.playlistTracks = tracks
            delegate?.searchTracks = tracks
            
            //print(tracks)
        }
        catch {
            print(error)
        }
    }
    
}
