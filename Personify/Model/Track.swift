//
//  Track.swift
//  iOSpotify
//
//  Created by Jervin Cruz on 5/15/18.
//  Copyright © 2018 Jervin Cruz. All rights reserved.
//

import UIKit

struct Track {
    
    let name : String
    let artist : String
    let uri : String
    let popularity : Int
    let image : String
    
    init(name : String, artist : String, uri : String, popularity : Int, image : String) {
        self.name = name
        self.artist = artist
        self.uri = uri
        self.popularity = popularity
        self.image = image
    }
}
