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
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.updateAfterFirstLogin), name: NSNotification.Name(Constants.sessionKey), object: nil)
        
    }
    
    // Once Logged In
    @objc func updateAfterFirstLogin() {
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
    // Sign Up
    @IBAction func signUpBtnPressed(_ sender: Any) {
        UIApplication.shared.open(URL(string : "https://www.spotify.com/us/signup/")!, options: [:], completionHandler: { (status) in
        })
        
    }
    
    
    // Music Playing After Authorization
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
        // after a user authenticates a session, the SPTAudioStreamingController is then initialized and this method called
        print("logged in")
    }
}
