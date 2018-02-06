//
//  DownloadCenter.swift
//  youtube video downloader
//
//  Created by Vlad on 06.02.2018.
//  Copyright © 2018 Vlad. All rights reserved.
//

import Foundation

class DownloadCenter: NSObject {
    
    private var activeDownloads = [String: Download]()
    let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
    
    lazy var downloadsSession: Foundation.URLSession = {
        let configuration = URLSessionConfiguration.background(withIdentifier: "bgSessionConfiguration")
        let session = Foundation.URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        return session
    }()
    
    override init() {
        super.init()
        _ = self.downloadsSession
    }
    
    func startDownload(_ url: String) {
        if activeDownloads[url] != nil {
            resumeDownload(url)
        } else {
            if let downloadUrl =  URL(string: url) {
                let download = Download(url: url)
                let urlRequest = URLRequest(url: downloadUrl)
                download.downloadTask = downloadsSession.downloadTask(with: urlRequest)
                download.downloadTask!.resume()
                download.isDownloading = true
                activeDownloads[download.url] = download
            }
        }
    }
    
    func pauseDownload(_ url: String) {
        if let download = activeDownloads[url] {
            if(download.isDownloading) {
                download.downloadTask?.cancel { data in
                    if data != nil {
                        download.resumeData = data
                    }
                }
                download.isDownloading = false
            }
        }
    }
    
    func cancelDownload(_ url: String) {
        if let download = activeDownloads[url] {
            download.downloadTask?.cancel()
            activeDownloads[url] = nil
        }
    }
    
    func resumeDownload(_ url: String) {
        if let download = activeDownloads[url] {
            if download.isDownloading == false {
                if let resumeData = download.resumeData {
                    download.downloadTask = downloadsSession.downloadTask(withResumeData: resumeData)
                    download.downloadTask!.resume()
                    download.isDownloading = true
                } else if let url = URL(string: download.url) {
                    download.downloadTask = downloadsSession.downloadTask(with: url)
                    download.downloadTask!.resume()
                    download.isDownloading = true
                }
            }
        }
    }
    
    func delete(_ url: String) {
        
    }
    
    func localFilePathForUrl(_ previewUrl: String) -> URL? {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let fullPath = documentsPath.appendingPathComponent((URL(string: previewUrl)?.lastPathComponent)!)
        return URL(fileURLWithPath:fullPath)
    }
}

extension DownloadCenter: URLSessionDelegate, URLSessionDownloadDelegate {
    
    internal func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            if let completionHandler = appDelegate.backgroundSessionCompletionHandler {
                appDelegate.backgroundSessionCompletionHandler = nil
                DispatchQueue.main.async(execute: {
                    completionHandler()
                })
            }
        }
    }
    
    // MARK: - NSURLSessionDownloadDelegate
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        guard let url = downloadTask.originalRequest?.url?.absoluteString else {
            return
        }
        
        guard let code = (downloadTask.response as? HTTPURLResponse)?.statusCode else {
            activeDownloads[url] = nil
            return
        }
        activeDownloads[url] = nil
        
        if code == 200 {
            var destUrlStr = ""
            if let destinationURL = localFilePathForUrl(url) {
                
                destUrlStr = destinationURL.absoluteString
                
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
            }
            
            DispatchQueue(label: "background").sync {
                
                if destUrlStr.count > 0 {
                   print("file was download")
                }
            }
        } else {
            //someError(url: url)
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        if let downloadUrl = downloadTask.originalRequest?.url?.absoluteString,
            let download = activeDownloads[downloadUrl],
            totalBytesExpectedToWrite > 0 {
            
            download.progress = Float(totalBytesWritten)/Float(totalBytesExpectedToWrite)
            
            let totalSize = ByteCountFormatter.string(fromByteCount: totalBytesExpectedToWrite, countStyle: ByteCountFormatter.CountStyle.binary)
            //download.size = totalSize
            download.sizeInByte = totalBytesExpectedToWrite
            
            print(download.progress)
        }
    }
}
