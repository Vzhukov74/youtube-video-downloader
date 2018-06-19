//
//  DownloadManager.swift
//  youtube video downloader
//
//  Created by Maximal Mac on 18.06.2018.
//  Copyright © 2018 Vlad. All rights reserved.
//

import Foundation

protocol DownloadManagerDelegate: class {
    func didDownloadFileTo(location: URL)
    func dudUpdatedProgressForFileBy(url: String, progress: Float)
}

class DownloadManager: NSObject {
    private var downloads: [String: Download] = [:]
    
    lazy private var session: URLSession = {
        let config = URLSessionConfiguration.background(withIdentifier: "bgSessionConfiguration")
        let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
        return session
    }()
    
    weak var delegate: DownloadManagerDelegate?
    
    func startDownloadFileBy(_ url: String) {
        let task = Download(url: url)
        let urlRequest = URLRequest(url: URL(string: url)!)
        task.downloadTask = session.downloadTask(with: urlRequest)
        task.downloadTask!.resume()
        task.isDownloading = true
        downloads[url] = task
    }
    
    func cancelDownloadFileBy(_ url: String) {
        guard let download = downloads[url] else { return }
        download.downloadTask?.cancel()
        downloads[url] = nil
    }
    
    func pauseDownloadFileBy(_ url: String) {
        guard let download = downloads[url] else { return }
        if download.isDownloading {
            download.downloadTask?.cancel(byProducingResumeData: { (data) in
                download.resumeData = data
            })
            download.isDownloading = false
        }
    }
    
    func resumeDownloadFileBy(_ url: String) {
        guard let download = downloads[url] else { return }
        if let resumeData = download.resumeData {
            download.downloadTask = session.downloadTask(withResumeData: resumeData)
        } else {
            let urlRequest = URLRequest(url: URL(string: url)!)
            download.downloadTask = session.downloadTask(with: urlRequest)
        }
        download.downloadTask?.resume()
        download.isDownloading = true
    }
}

extension DownloadManager: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        self.delegate?.didDownloadFileTo(location: location)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        guard let url = downloadTask.originalRequest?.url?.absoluteString,
            let download = downloads[url]  else { return }

        download.progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        //let totalSize = ByteCountFormatter.string(fromByteCount: totalBytesExpectedToWrite, countStyle: .file)
        
        self.delegate?.dudUpdatedProgressForFileBy(url: url, progress: download.progress)
        
//        DispatchQueue.main.async {
//            if let trackCell = self.tableView.cellForRow(at: IndexPath(row: download.track.index,
//                                                                       section: 0)) as? TrackCell {
//                trackCell.updateDisplay(progress: download.progress, totalSize: totalSize)
//            }
//        }
    }
}
