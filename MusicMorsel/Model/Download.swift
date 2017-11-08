//
//  Download.swift
//  MusicMorsel
//
//  Created by Joseph Ugowe on 11/8/17.
//  Copyright © 2017 Joseph Ugowe. All rights reserved.
//

import Foundation

class Download {
    
    var song: Song
    init(song: Song) {
        self.song = song
    }
    
    // Download service sets these values
    var task: URLSessionDownloadTask?
    var isDownloading = false
    var resumeData: Data?
    
    // Download delegate sets this value
    var progress: Float = 0
}
