//
//  ITunesPlayerModel.swift
//  youtube video downloader
//
//  Created by Vlad on 15.06.2018.
//  Copyright © 2018 Vlad. All rights reserved.
//

import UIKit

struct ITunesSearchResponse: Codable {
    var resultCount: Int
    var results: [ITunesSong]
}

struct ITunesSong: Codable {
    let songName: String
    let authorName: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case songName = "trackName"
        case authorName = "artistName"
        case url = "previewUrl"
    }
}

class ITunesPlayerModel {
    var songs = [ITunesSong]() {
        didSet {
            currenSongIndex = 0
        }
    }
    
    private let session = URLSession(configuration: .default)
    private var task: URLSessionTask?
    
    private var currenSongIndex = 0
    
    func searchSongFor(text: String, completion: @escaping () -> Void) {
        task?.cancel()
        
        guard var urlComponents = URLComponents(string: "https://itunes.apple.com/search") else { return }
        urlComponents.query = "media=music&entity=song&term=\(text)"
        guard let url = urlComponents.url else { return }
        
        task = session.dataTask(with: url, completionHandler: { (data, response, error) in
            defer { self.task = nil }
            
            if let data = data {
                guard let response = response as? HTTPURLResponse else { return }
                if response.statusCode == 200 {
                    let decoder = JSONDecoder()
                    do {
                        let responseData = try decoder.decode(ITunesSearchResponse.self, from: data)
                        self.songs = responseData.results
                        DispatchQueue.main.async {
                            completion()
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
        })
        task?.resume()
    }
    
    func nextSong() -> ITunesSong? {
        let nextIndex = currenSongIndex + 1
        
        if nextIndex < 0 || nextIndex >= songs.count {
            return nil
        }
        currenSongIndex = nextIndex
        return songs[currenSongIndex]
    }
    
    func previous() -> ITunesSong? {
        if currenSongIndex == 0 {
            return nil
        }
        currenSongIndex -= 1
        return songs[currenSongIndex]
    }
    
    func playSongAt(index: Int) -> ITunesSong? {
        assert(index >= 0 && index < songs.count)
        currenSongIndex = index
        return songs[currenSongIndex]
    }
}
