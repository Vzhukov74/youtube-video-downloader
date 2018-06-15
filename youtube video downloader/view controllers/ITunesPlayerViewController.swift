//
//  ITunesPlayerViewController.swift
//  youtube video downloader
//
//  Created by Maximal Mac on 15.06.2018.
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
    var songs = [ITunesSong]()
    
    private let session = URLSession(configuration: .default)
    private var task: URLSessionTask?
    
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
}

class ITunesPlayerViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            let nib = UINib(nibName: "ITunesPlayerCell", bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: "ITunesPlayerCell")
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
            searchBar.placeholder = "song name or artist"
            searchBar.keyboardType = .asciiCapable
            searchBar.returnKeyType = .done
        }
    }
    
    private var searchText = "" {
        didSet {
            model.searchSongFor(text: searchText) { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    var model = ITunesPlayerModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapAction)))
    }
}

extension ITunesPlayerViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ITunesPlayerCell", for: indexPath) as? ITunesPlayerCell {
            cell.configure(song: model.songs[indexPath.row])
            
            return cell
        }
        return UITableViewCell()
    }
}

extension ITunesPlayerViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchText = searchBar.text!
        self.view.endEditing(true)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchText = ""
        self.view.endEditing(true)
    }
}

@objc extension ITunesPlayerViewController {
    private func tapAction() {
        self.view.endEditing(true)
    }
}
