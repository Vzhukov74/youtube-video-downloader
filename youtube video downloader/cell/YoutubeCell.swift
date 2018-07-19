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
    
    private var video: YoutubeVideoContainer?
    weak var delegate: YoutubeCellDelegate?
    
    func configure(video: YoutubeVideoContainer) {
        self.video = video
        titleLabel.text = video.video.title
        let url = URL(string: video.video.imageUrl ?? "")
        titleImage.sd_setImage(with: url, completed: { [weak self] (_, _, _, _) in
            self?.titleImage.backgroundColor = UIColor.clear
            self?.titleImage.layer.cornerRadius = 4
        })
    }
}

@objc extension YoutubeCell {
    private func downloadAction() {
        guard let _video = video else { return }
        
        switch _video.state {
        case .notDownload:
            guard let str = _video.video.dataUrl else { return }
            
            let video = HCYoutubeParser.h264videos(withYoutubeURL: URL(string: str)!)
            guard let hd = video!["hd720"] else { return }
            let url = hd as! String
            _video.video.url = url
            
            _video.downloadManager?.addDelegate(key: url, delegate: self)
            _video.downloadManager?.startDownloadFileBy(url)
            _video.state = .downloading
            controllButton.setTitle("Pause", for: .normal)
        case .downloading:
            guard let url = _video.video.url else { return }
            _video.downloadManager?.pauseDownloadFileBy(url)
            _video.state = .paused
            controllButton.setTitle("Resume", for: .normal)
        case .paused:
            guard let url = _video.video.url else { return }
            _video.downloadManager?.resumeDownloadFileBy(url)
            _video.state = .downloading
            controllButton.setTitle("Pause", for: .normal)
        case .downloaded:
            guard let url = _video.video.url else { return }
            _video.state = .downloaded
            controllButton.setTitle("Del", for: .normal)
            _video.downloadManager?.removeDelegate(key: url)
        case .saved:
            break
        }
    }
}

extension YoutubeCell: DownloadManagerDelegate {
    func didDownloadFileTo(location: URL) {
        guard let _video = video else { return }
        guard let url = _video.video.url else { return }
        _video.state = .downloaded
        
        if let destinationURL = localFilePathForUrl(url) {

            let fileManager = FileManager.default
            do {
                try fileManager.removeItem(at: destinationURL)
            } catch {
            }
            do {
                try fileManager.copyItem(at: location, to: destinationURL)
            } catch let error as NSError {
                print("Could not copy file to disk: \(error.localizedDescription)")
            }
            _video.video.path = destinationURL.absoluteString
            DatabaseHelper.shared.saveContext()
            DispatchQueue.main.async {
                self.progressLabel.text = "Downloaded"
            }
        }
    }
    
    func didUpdatedProgressForFileBy(url: String, progress: Float) {
        DispatchQueue.main.async {
            let progressStr = String(format: "%.2f", (progress * Float(100)))
            self.progressLabel.text = "Loading: \(progressStr)%"
        }
    }
}

extension YoutubeCell {
    // This method generates a permanent local file path to save a track to by appending
    // the lastPathComponent of the URL (i.e. the file name and extension of the file)
    // to the path of the app’s Documents directory.
    func localFilePathForUrl(_ previewUrl: String) -> URL? {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let name = String(arc4random()) + ".mp4"
        let fullPath = documentsPath.appendingPathComponent(name)
        return URL(fileURLWithPath:fullPath)
    }
}
