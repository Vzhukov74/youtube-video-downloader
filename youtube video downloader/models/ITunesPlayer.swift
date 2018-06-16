//
//  ITunesPlayer.swift
//  youtube video downloader
//
//  Created by Vlad on 15.06.2018.
//  Copyright © 2018 Vlad. All rights reserved.
//

import Foundation
import AVFoundation

protocol ITunesPlayerDelegate: class {
    func startLoad()
    func endLoad()
    func error()
}

class ITunesPlayer {
    private var player = AVAudioPlayer()
    private var dataTask: URLSessionDataTask?
    private var songUrlStr = ""
    private var isPlaying = false
    
    weak var delegate: ITunesPlayerDelegate?
    
    func setSongBy(urlStr: String) {
        self.downloadMp3By(urlStr: urlStr)
    }
    
    func getSongUrlStr() -> String {
        return songUrlStr
    }
    
    func start() {
        isPlaying = true
        player.play()
    }
    
    func stop() {
        if isPlaying == true {
            isPlaying = false
            player.stop()
        }
    }
    
    private func downloadMp3By(urlStr: String) {
        dataTask?.cancel()
        
        guard let url = URL(string: urlStr) else {
            self.delegate?.error()
            return
        }
        
        self.delegate?.startLoad()
        self.setActivityIndicator(isVisible: true)
        
        dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, _, error) in
            defer { self?.dataTask = nil }
            self?.setActivityIndicator(isVisible: false)
            do {
                if let _data = data {
                    self?.player = try AVAudioPlayer(data: _data)
                    DispatchQueue.main.async {
                        self?.start()
                        self?.delegate?.endLoad()
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.delegate?.error()
                    }
                }
            } catch {
                self?.delegate?.error()
            }
        }
        dataTask?.resume()
    }
    
    private func setActivityIndicator(isVisible: Bool) {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = isVisible
        }
    }
    
    deinit {
        setActivityIndicator(isVisible: false)
        print("deinit - GTMPlayer")
    }
}
