//
//  TrackTableViewCell.swift
//  iOSpotify
//
//  Created by Jervin Cruz on 5/16/18.
//  Copyright © 2018 Jervin Cruz. All rights reserved.
//

import UIKit

class TrackTableViewCell: UITableViewCell {

    @IBOutlet var trackNameLabel: UILabel!
    @IBOutlet var trackArtistLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
