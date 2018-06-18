//
//  ITunesPlayerViewController.swift
//  youtube video downloader
//
//  Created by Maximal Mac on 15.06.2018.
//  Copyright © 2018 Vlad. All rights reserved.
//

import UIKit

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
    @IBOutlet weak var tableViewBottomConstrain: NSLayoutConstraint!
    
    private var searchText = "" {
        didSet {
            model.searchSongFor(text: searchText) { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    var model = ITunesPlayerModel()
    
    private var playerControlView = PlayerControlView()
    private var playerControlViewBottomConstrain = NSLayoutConstraint()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapAction)))
        configurePlayerControlView()
    }
    
    private func configurePlayerControlView() {
        playerControlView = PlayerControlView.loadFromXib()
        playerControlView.layer.cornerRadius = 4
        playerControlView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(playerControlView)
        
        let heigh = -48
        playerControlViewBottomConstrain = playerControlView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: CGFloat(heigh))
        
        let playerControlViewConstrains = [playerControlView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8), playerControlView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8), playerControlViewBottomConstrain]
        
        NSLayoutConstraint.activate(playerControlViewConstrains)
        hidePlayerController()
        playerControlView.delegate = self
    }
    
    private func hidePlayerController() {
        UIView.animate(withDuration: 0.3) {
            self.playerControlViewBottomConstrain.constant = 100
            self.tableViewBottomConstrain.constant = 0
            self.loadViewIfNeeded()
        }
    }
    
    private func unhidePlayerController() {
        UIView.animate(withDuration: 0.3) {
            self.tableViewBottomConstrain.constant = 102
            self.playerControlViewBottomConstrain.constant = -92
            self.loadViewIfNeeded()
        }
    }
}

extension ITunesPlayerViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ITunesPlayerCell", for: indexPath) as? ITunesPlayerCell {
            let index = indexPath.row
            cell.configure(song: model.songs[index], index: index)
            cell.delegate = self
            
            return cell
        }
        return UITableViewCell()
    }
}

extension ITunesPlayerViewController: ITunesPlayerCellDelegate {
    func playSongAt(index: Int) {
        if let song = model.playSongAt(index: index) {
            unhidePlayerController()
            playerControlView.configureFor(song: song)
        }
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

extension ITunesPlayerViewController: PlayerControlViewDelegate {
    func nextSong() -> ITunesSong? {
        return model.nextSong()
    }
    
    func previousSong() -> ITunesSong? {
        return model.previous()
    }
}
