//
//  YoutubeModel.swift
//  youtube video downloader
//
//  Created by Maximal Mac on 18.06.2018.
//  Copyright © 2018 Vlad. All rights reserved.
//

import Foundation
import CoreData

class YoutubeVideoContainer {
    let video: YoutubeVideo
    weak var downloadManager: DownloadManager?
    var state: YoutubeVideoStatus = .notDownload
    
    init(video: YoutubeVideo) {
        self.video = video
    }
}

enum YoutubeVideoStatus: Int {
    case notDownload
    case downloading
    case paused
    case downloaded
    case saved
}

class YoutubeModel {
    
    lazy private var downloadManager = { () -> DownloadManager in
        let downloadManager = DownloadManager()
        return downloadManager
    }()
    
    var videos = [YoutubeVideoContainer]() {
        didSet {
            self.needUpdateUI?()
        }
    }
    
    var needUpdateUI: (() -> Void)?
    
    func fetchVideos() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "YoutubeVideo")
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: DatabaseHelper.shared.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try fetchedResultsController.performFetch()
            let elements = fetchedResultsController.fetchedObjects as? [YoutubeVideo] ?? []
            var _videos = [YoutubeVideoContainer]()
            elements.forEach { (element) in
                let _video = YoutubeVideoContainer(video: element)
                _video.downloadManager = self.downloadManager
                _videos.append(_video)
            }
            videos = _videos
        } catch {
            print(error.localizedDescription)
        }
    }
}
