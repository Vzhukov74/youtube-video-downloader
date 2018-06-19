//
//  YoutubeModel.swift
//  youtube video downloader
//
//  Created by Maximal Mac on 18.06.2018.
//  Copyright © 2018 Vlad. All rights reserved.
//

import Foundation
import CoreData

enum YoutubeVideoStatus: Int {
    case notDownload
    case downloading
    case downloaded
}

class YoutubeModel {
    
    lazy private var downloadManager = { () -> DownloadManager in
        let downloadManager = DownloadManager()
        downloadManager.delegate = self
        return downloadManager
    }()
    
    var videos = [YoutubeVideo]() {
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
            self.videos = fetchedResultsController.fetchedObjects as? [YoutubeVideo] ?? []
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func startDownloadFor(video: YoutubeVideo) {
        guard let url = video.url, !url.isEmpty else { return }
        downloadManager.startDownloadFileBy(url)
    }
    
    func pauseDownloadFor(video: YoutubeVideo) {
        guard let url = video.url, !url.isEmpty else { return }
        downloadManager.pauseDownloadFileBy(url)
    }
    
    func cancelDownloadFor(video: YoutubeVideo) {
        guard let url = video.url, !url.isEmpty else { return }
        downloadManager.cancelDownloadFileBy(url)
    }
    
    func resumeDownloadFor(video: YoutubeVideo) {
        guard let url = video.url, !url.isEmpty else { return }
        downloadManager.resumeDownloadFileBy(url)
    }
}

extension YoutubeModel: DownloadManagerDelegate {
    func didDownloadFileTo(location: URL) {
        
    }
    
    func dudUpdatedProgressForFileBy(url: String, progress: Float) {
        
    }
}
