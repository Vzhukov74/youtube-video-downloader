//
//  ITunesPlayerCell.swift
//  youtube video downloader
//
//  Created by Maximal Mac on 15.06.2018.
//  Copyright © 2018 Vlad. All rights reserved.
//

import UIKit

class ITunesPlayerCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView! {
        didSet {
            mainView.layer.cornerRadius = 4
        }
    }
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton! {
        didSet {
            playPauseButton.addTarget(self, action: #selector(self.playPauseButtonAction), for: .touchUpInside)
        }
    }
    
    func configure(song: ITunesSong) {
        
    }
}

@objc extension ITunesPlayerCell {
    private func playPauseButtonAction() {
        print("play")
    }
}
