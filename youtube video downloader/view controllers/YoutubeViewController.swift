//
//  YoutubeViewController.swift
//  youtube video downloader
//
//  Created by Maximal Mac on 18.06.2018.
//  Copyright © 2018 Vlad. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import SwiftyBeaver

class YoutubeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            let nib = UINib(nibName: "YoutubeCell", bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: "YoutubeCell")
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    private let model = YoutubeModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model.needUpdateUI = { [weak self] in
            self?.tableView.reloadData()
        }
        model.fetchVideos()
    }
    
}

extension YoutubeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "YoutubeCell", for: indexPath) as? YoutubeCell {
            let index = indexPath.row
            cell.configure(video: model.videos[index])
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let path = model.videos[indexPath.row].video.path, !path.isEmpty {
            print(path)
            let videoURL = URL(string: path)
            let player = AVPlayer(url: videoURL!)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            self.present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
        }
    }
}
