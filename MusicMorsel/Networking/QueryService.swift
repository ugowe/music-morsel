//
//  QueryService.swift
//  MusicMorsel
//
//  Created by Joseph Ugowe on 11/5/17.
//  Copyright © 2017 Joseph Ugowe. All rights reserved.
//

import Foundation

// Runs query data task, and stores results in array of Tracks
class QueryService {
    
    typealias JSONDictionary = [String: Any]
    typealias QueryResult = ([Song]?, String) -> ()
    
    var songs: [Song] = []
    var errorMessage = ""
    
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    func getSearchResults(searchTerm: String, completion: @escaping QueryResult) {
        
        dataTask?.cancel()
        
        if var urlComponents = URLComponents(string: "https://itunes.apple.com/search") {
            urlComponents.query = "media=music&entity=song&term=\(searchTerm)"
            
            guard let url = urlComponents.url else { return }
            
            dataTask = defaultSession.dataTask(with: url) { data, response, error in
                defer { self.dataTask = nil }
                
                if let error = error {
                    self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
                } else if let data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    self.updateSearchResults(data)
                    
                    DispatchQueue.main.async {
                        completion(self.songs, self.errorMessage)
                    }
                }
            }
            
            dataTask?.resume()
        }
    }
    
    fileprivate func updateSearchResults(_ data: Data) {
        var response: JSONDictionary?
        songs.removeAll()
        
        do {
            response = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
        } catch let parseError as NSError {
            errorMessage += "JSONSerialization error: \(parseError.localizedDescription)\n"
            return
        }
        
        guard let array = response!["results"] as? [Any] else {
            errorMessage += "Dictionary does not contain results key\n"
            return
        }
        var index = 0
        for songDictionary in array {
            if let songDictionary = songDictionary as? JSONDictionary,
                let morselURLString = songDictionary["previewUrl"] as? String,
                let morselURL = URL(string: morselURLString),
                let name = songDictionary["trackName"] as? String,
                let artist = songDictionary["artistName"] as? String {
                songs.append(Song(name: name, artist: artist, morselURL: morselURL, index: index))
                index += 1
            } else {
                errorMessage += "Problem parsing trackDictionary\n"
            }
        }
    }
    
}
