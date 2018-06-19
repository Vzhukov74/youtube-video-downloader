//
//  YoutubeCell.swift
//  youtube video downloader
//
//  Created by Maximal Mac on 18.06.2018.
//  Copyright © 2018 Vlad. All rights reserved.
//

import UIKit
import SDWebImage

protocol YoutubeCellDelegate: class {
    func startDownloadFor(video: YoutubeVideo)
}

class YoutubeCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView! {
        didSet {
            mainView.layer.cornerRadius = 4
        }
    }
    @IBOutlet weak var titleImage: UIImageView! {
        didSet {
            titleImage.layer.cornerRadius = 4
        }
    }
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = ""
        }
    }
    @IBOutlet weak var progressLabel: UILabel! {
        didSet {
            progressLabel.text = ""
        }
    }
    @IBOutlet weak var controllButton: UIButton! {
        didSet {
            controllButton.addTarget(self, action: #selector(self.downloadAction), for: .touchUpInside)
        }
    }
    
    private var video: YoutubeVideo?
    
    weak var delegate: YoutubeCellDelegate?
    
    func configure(video: YoutubeVideo) {
        self.video = video
        titleLabel.text = video.title
        let url = URL(string: video.imageUrl ?? "")
        titleImage.sd_setImage(with: url, completed: { [weak self] (_, _, _, _) in
            self?.titleImage.backgroundColor = UIColor.clear
            self?.titleImage.layer.cornerRadius = 4
        })
    }
    
    func setProgress() {
        
    }
}

@objc extension YoutubeCell {
    private func downloadAction() {
        delegate?.startDownloadFor(video: video!)
    }
}
