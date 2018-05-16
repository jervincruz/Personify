//
//  ViewController.swift
//  iOSpotify
//
//  Created by Jervin Cruz on 5/3/18.
//  Copyright © 2018 Jervin Cruz. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MainViewController: UIViewController, SPTAudioStreamingPlaybackDelegate, SPTAudioStreamingDelegate {
    // Authorization Properties
    var auth = SPTAuth.defaultInstance()!
    var session : SPTSession!
    //var player : SPTAudioStreamingController?
    var loginURL : URL?
    let delegate = UIApplication.shared.delegate as? AppDelegate
    

    // Data Properties
    var searchURL = "https://api.spotify.com/v1/search?q=Shawn%20Mendes&type=track"
    var playlistURL = "https://api.spotify.com/v1/users/jervincruz/playlists"
    var discoverWeekly = "https://api.spotify.com/v1/users/spotify/playlists/37i9dQZEVXcI6GCUcgx03q/tracks"
    var releaseRadar = "https://api.spotify.com/v1/users/spotify/playlists/37i9dQZEVXbkgHHxEDhf26/tracks"
    var trackNames : [String] = []
    var trackURIs : [String] = []
    
    var tracks = [Track]()
    
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.updateAfterFirstLogin), name: NSNotification.Name(Constants.sessionKey), object: nil)
        
    }
    
    // Once Logged In
    @objc func updateAfterFirstLogin() {
        
        loginButton.isHidden = true
        
        let userDefaults = UserDefaults.standard
        if let sessionObj : AnyObject = userDefaults.object(forKey: Constants.sessionKey) as AnyObject? {
            
            let sessionDataObj = sessionObj as! Data
            
            let firstTimeSession = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as! SPTSession
            self.session = firstTimeSession
            
            initializePlayer(authSession : session)
        }
        
        performSegue(withIdentifier: "mainToSelection", sender: self)
    }
    
    func initializePlayer(authSession : SPTSession) {
        if delegate?.player == nil {
            delegate?.player = SPTAudioStreamingController.sharedInstance()
            delegate?.player?.playbackDelegate = self
            delegate?.player?.delegate = self
            try! delegate?.player!.start(withClientId: auth.clientID)
            delegate?.player!.login(withAccessToken: authSession.accessToken)
            delegate?.accessToken = authSession.accessToken
            print("Access Token: ", delegate?.accessToken)
        }
    }

    // Initial Setup
    func setup() {
        SPTAuth.defaultInstance().clientID = Constants.clientID
        SPTAuth.defaultInstance().redirectURL = URL(string: Constants.redirectURI)
        SPTAuth.defaultInstance().requestedScopes = [SPTAuthStreamingScope, SPTAuthPlaylistReadPrivateScope, SPTAuthPlaylistModifyPublicScope, SPTAuthPlaylistModifyPrivateScope]
        loginURL = SPTAuth.defaultInstance().spotifyWebAuthenticationURL()
    }
    
    // Login
    @IBAction func loginBtnPressed(_ sender: Any) {
        if UIApplication.shared.openURL(loginURL!) {
            if auth.canHandle(auth.redirectURL) {
                // To - do build in error handling
            }
        }
    }
    
    // Music Playing After Authorization
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
        // after a user authenticates a session, the SPTAudioStreamingController is then initialized and this method called
        print("logged in")
//        self.player?.playSpotifyURI("spotify:track:7JJmb5XwzOO8jgpou264Ml", startingWith: 0, startingWithPosition: 0, callback: { (error) in
//            if (error != nil) {
//                print("playing!")
//            }
//        })
        
       // callAlamo(url: searchURL)
       // callAlamo(url: "https://api.spotify.com/v1/browse/featured-playlists")
    

    }
    
    @IBAction func playSong(_ sender: Any) {
        self.delegate?.player?.playSpotifyURI("spotify:track:5jsw9uXEGuKyJzs0boZ1bT", startingWith: 0, startingWithPosition: 0, callback: { (error) in
            if (error != nil) {
                print("playing!")
            }
        })
    }
    


}

// Data Parsing
extension MainViewController {
    
    func callAlamo(url: String) {
        Alamofire
            .request(url, method: .get, headers: ["Authorization":"Bearer " + (delegate?.accessToken)!])
            .responseJSON { response in
            if response.result.isSuccess {
                print("Response: ", response)
                let spotifyJSON : JSON = JSON(response.result.value!)
                self.updateSpotifyData(json : spotifyJSON)
            }
        }
    }
    
    func updateSpotifyData(json : JSON) {
        do {
//            var spotifyJSON = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as? [String : AnyObject]
//            print(spotifyJSON)
            
            var x : Int = 0
            print("Track Count", json["tracks"]["items"].count )
            while json["tracks"]["items"][x] != JSON.null {
                // Add Track
                var name = json["tracks"]["items"][x]["name"].stringValue
                var artist = json["tracks"]["items"][x]["album"]["artists"]["name"].stringValue
                var uri = json["tracks"]["items"][x]["uri"].stringValue
                var popularity = json["tracks"]["items"][x]["popularity"].intValue

                let track = Track(name: name, artist: artist, uri: uri, popularity: popularity)
                tracks.append(track)
                x = x + 1
            }
            
            for i in 0..<tracks.count {
                print("Track Names: ", tracks[i].name)
            }
            tracks.sort{ $0.popularity > $1.popularity }
        }
        catch {
            print(error)
        }
    }
}

extension MainViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath)
        cell.textLabel?.text = tracks[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        playSong(uri: tracks[indexPath.row].uri)
    }
    
    func playSong(uri : String) {
        delegate?.player?.playSpotifyURI(uri, startingWith: 0, startingWithPosition: 0, callback: { (error) in
            if (error != nil) {
                print("playing!")
            }
        })
    }
    
}

