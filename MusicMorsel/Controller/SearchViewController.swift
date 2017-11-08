//
//  SearchViewController.swift
//  MusicMorsel
//
//  Created by Joseph Ugowe on 11/4/17.
//  Copyright © 2017 Joseph Ugowe. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class SearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    lazy var tapRecognizer: UITapGestureRecognizer = {
        var recognizer = UITapGestureRecognizer(target:self, action: #selector(dismissKeyboard))
        return recognizer
    }()
    
    var searchResults: [Song] = []
    let queryService = QueryService()
    let downloadService = DownloadService()
    
    // Get local file path: download task stores tune here; AV player plays it.
    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    func localFilePath(for url: URL) -> URL {
        return documentsPath.appendingPathComponent(url.lastPathComponent)
    }
    
    lazy var downloadSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.tableFooterView = UIView()
        downloadService.downloadsSession = downloadSession 
    }
    
    func playDownload(_ song: Song) {
        let playerViewController = AVPlayerViewController()
        present(playerViewController, animated: true, completion: nil)
        let url = localFilePath(for: song.morselURL)
        let player = AVPlayer(url: url)
        playerViewController.player = player
        player.play()
    }
}

// MARK: - UITableView

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SongCell = tableView.dequeueReusableCell(for: indexPath)
        
        // Delegate cell button tap events to this view controller
        cell.delegate = self
        
        let song = searchResults[indexPath.row]
        cell.configure(song: song, downloaded: song.downloaded, download: downloadService.activeDownloads[song.morselURL])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62.0
    }
    
    // When user taps cell, play the local file, if it's downloaded
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let song = searchResults[indexPath.row]
        if song.downloaded {
            playDownload(song)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - SongCellDelegate

extension SearchViewController: SongCellDelegate {
    
    func downloadTapped(_ cell: SongCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let song = searchResults[indexPath.row]
            downloadService.startDownload(song)
            reload(indexPath.row)
        }
    }
    
    func pauseTapped(_ cell: SongCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let song = searchResults[indexPath.row]
            downloadService.pauseDownload(song)
            reload(indexPath.row)
        }
    }
    
    func resumeTapped(_ cell: SongCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let song = searchResults[indexPath.row]
            downloadService.resumeDownload(song)
            reload(indexPath.row)
        }
    }
    
    func cancelTapped(_ cell: SongCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let song = searchResults[indexPath.row]
            downloadService.cancelDownload(song)
            reload(indexPath.row)
        }
    }
    
    func reload(_ row: Int) {
        tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
    }
}



















