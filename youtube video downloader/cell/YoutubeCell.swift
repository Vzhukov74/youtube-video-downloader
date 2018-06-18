//
//  YoutubeCell.swift
//  youtube video downloader
//
//  Created by Maximal Mac on 18.06.2018.
//  Copyright © 2018 Vlad. All rights reserved.
//

import UIKit
import SDWebImage

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
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var controllButton: UIButton!
    
    func configure(video: YoutubeVideo) {
        titleLabel.text = video.title
        let url = URL(string: video.imageUrl ?? "")
        titleImage.sd_setImage(with: url, completed: nil)
    }
}
