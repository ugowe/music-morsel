//
//  Song.swift
//  MusicMorsel
//
//  Created by Joseph Ugowe on 11/4/17.
//  Copyright © 2017 Joseph Ugowe. All rights reserved.
//

import UIKit

class Song: NSObject {
    
    let name: String
    let artist: String
    let morselURL: URL
    let index: Int
    var downloaded = false
    
    init(name: String, artist: String, morselURL: URL, index: Int) {
        self.name = name
        self.artist = artist
        self.morselURL = morselURL
        self.index = index
    }
}
