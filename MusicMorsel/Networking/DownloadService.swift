//
//  DownloadService.swift
//  MusicMorsel
//
//  Created by Joseph Ugowe on 11/5/17.
//  Copyright © 2017 Joseph Ugowe. All rights reserved.
//

import Foundation

class DownloadService {
    
    var activeDownloads: [URL: Download] = [:]
    // SearchViewController creates downloadsSession
    var downloadsSession: URLSession!
    
    // MARK: - Download methods called by TrackCell delegate methods
    
    func startDownload(_ song: Song) {
        
        let download = Download(song: song)
        download.task = downloadsSession.downloadTask(with: song.morselURL)
        download.task!.resume()
        download.isDownloading = true
        activeDownloads[download.song.morselURL] = download
        
    }

    func pauseDownload(_ song: Song) {
        guard let download = activeDownloads[song.morselURL] else { return }
        if download.isDownloading {
            download.task?.cancel(byProducingResumeData: { data in
                download.resumeData = data
            })
            download.isDownloading = false
        }
    }
    
    func cancelDownload(_ song: Song) {
        if let download = activeDownloads[song.morselURL] {
            download.task?.cancel()
            activeDownloads[song.morselURL] = nil
        }
    }
    
    func resumeDownload(_ song: Song) {
        guard let download = activeDownloads[song.morselURL] else { return }
        if let resumeData = download.resumeData {
            download.task = downloadsSession.downloadTask(withResumeData: resumeData)
        } else {
            download.task = downloadsSession.downloadTask(with: download.song.morselURL)
        }
        download.task!.resume()
        download.isDownloading = true
    }
    
}
