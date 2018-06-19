//
//  YoutubeViewController.swift
//  youtube video downloader
//
//  Created by Maximal Mac on 18.06.2018.
//  Copyright © 2018 Vlad. All rights reserved.
//

import UIKit
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
            cell.delegate = self
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let path = model.videos[indexPath.row].path, !path.isEmpty {
            
        }
    }
}

extension YoutubeViewController: YoutubeCellDelegate {
    func startDownloadFor(video: YoutubeVideo) {
        model.startDownloadFor(video: video)
    }
}



