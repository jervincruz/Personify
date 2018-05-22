//
//  QueueController.swift
//  iOSpotify
//
//  Created by Jervin Cruz on 5/15/18.
//  Copyright © 2018 Jervin Cruz. All rights reserved.
//

import UIKit

class HistoryController : UIViewController, UITableViewDelegate, UITableViewDataSource {

    let delegate = UIApplication.shared.delegate as? AppDelegate
    
    @IBOutlet var historyTable: UITableView!
    @IBOutlet var historyCoverImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(delegate?.historyTracks)
        self.historyTable.reloadData()
        
        guard (delegate?.historyTracks.isEmpty)! else {
            let url = URL(string: (delegate?.historyTracks[0].image)!)
            historyCoverImage.kf.setImage(with: url)
            return
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (delegate?.historyTracks.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell") as! TrackTableViewCell
        let url = URL(string: (delegate?.historyTracks[indexPath.row].image)!)
        cell.trackArtistLabel.text = delegate?.historyTracks[indexPath.row].artist
        cell.trackNameLabel.text = delegate?.historyTracks[indexPath.row].name
        cell.trackImage.kf.setImage(with: url)
      
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        playSong(uri: (delegate?.historyTracks[indexPath.row].uri)!)
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

