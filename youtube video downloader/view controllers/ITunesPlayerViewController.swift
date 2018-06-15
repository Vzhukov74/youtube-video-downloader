//
//  ITunesPlayerViewController.swift
//  youtube video downloader
//
//  Created by Maximal Mac on 15.06.2018.
//  Copyright © 2018 Vlad. All rights reserved.
//

import UIKit

class ITunesSong {
    let songName: String
    let authorName: String
    let url: String
    
    init(songName: String, authorName: String, url: String) {
        self.songName = songName
        self.authorName = authorName
        self.url = url
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
    
    private var songs = [ITunesSong]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        songs = [ITunesSong(songName: "shake it off", authorName: "Taylor Swift", url: "")]
        
        tableView.reloadData()
    }
}

extension ITunesPlayerViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ITunesPlayerCell", for: indexPath) as? ITunesPlayerCell {
            cell.configure(song: songs[indexPath.row])
            
            return cell
        }
        return UITableViewCell()
    }
}
