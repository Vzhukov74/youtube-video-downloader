//
//  Download.swift
//  youtube video downloader
//
//  Created by Vlad on 06.02.2018.
//  Copyright © 2018 Vlad. All rights reserved.
//

import Foundation

class Download: NSObject {
    var url:String
    var isDownloading = false
    var progress:Float = 0.0
    
    var downloadTask:URLSessionDownloadTask?
    var resumeData:Data?
    
    var sizeInByte: Int64 = 0
    
    init(url:String) {
        self.url = url
    }
}
