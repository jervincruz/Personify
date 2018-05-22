//
//  AppDelegate.swift
//  iOSpotify
//
//  Created by Jervin Cruz on 5/3/18.
//  Copyright © 2018 Jervin Cruz. All rights reserved.
//

import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, SPTAudioStreamingPlaybackDelegate {

    var window: UIWindow?
    
    var auth = SPTAuth()
    var player : SPTAudioStreamingController?
    var accessToken = ""
    
    var discoverTracks = [Track]()
    var playlistTracks = [Track]()
    var searchTracks = [Track]()
    var historyTracks = [Track]()
    
    var playlistTriggered = false
    var searchTriggered = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        auth.redirectURL = URL(string: Constants.redirectURI)
        auth.sessionUserDefaultsKey = Constants.sessionKey
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        // Check if App can handle redirect URL
        
        if auth.canHandle(auth.redirectURL) {
            auth.handleAuthCallback(withTriggeredAuthURL: url) { (error, session) in
                // Handle error
                
                if error != nil {
                    print("Error")
                }
            
                // Add Session to User Defaults
                let userDefaults = UserDefaults.standard
                let sessionData = NSKeyedArchiver.archivedData(withRootObject: session)
                userDefaults.set(sessionData, forKey: Constants.sessionKey)
                userDefaults.synchronize()
                
                // Tell notification center login is successful
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.sessionKey), object: nil)
            }
            return true
        }
        return false
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didChangePlaybackStatus isPlaying: Bool) {
        if isPlaying {
            self.activateAudioSession()
        } else {
            self.deactivateAudioSession()
        }
    }
    
    func activateAudioSession() {
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: .mixWithOthers)
        try? AVAudioSession.sharedInstance().setActive(true)
    }
    
    func deactivateAudioSession() {
        try? AVAudioSession.sharedInstance().setActive(false)
    }
    
    func checkHistoryTracks(t : Track){
        if historyTracks.contains(where: {$0.uri == t.uri}) {
            historyTracks = historyTracks.filter() {$0.uri != t.uri }
            historyTracks.insert(t, at: 0)
        }
        else if historyTracks.count == 30 {
            historyTracks.removeLast()
            historyTracks.insert(t, at: 0)
        } else {
            historyTracks.insert(t, at: 0)
        }
    }

}

