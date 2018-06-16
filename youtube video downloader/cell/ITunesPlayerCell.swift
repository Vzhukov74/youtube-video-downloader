//
//  ITunesPlayerCell.swift
//  youtube video downloader
//
//  Created by Maximal Mac on 15.06.2018.
//  Copyright © 2018 Vlad. All rights reserved.
//

import UIKit

protocol ITunesPlayerCellDelegate: class {
    func playSongAt(index: Int)
}

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
    
    var song: ITunesSong?
    var index = 0
    weak var delegate: ITunesPlayerCellDelegate?
    
    func configure(song: ITunesSong, index: Int) {
        self.song = song
        self.index = index
        songNameLabel.text = song.songName
        authorNameLabel.text = song.authorName
    }
}

@objc extension ITunesPlayerCell {
    private func playPauseButtonAction() {
        delegate?.playSongAt(index: index)
    }
}
