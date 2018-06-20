//
//  InitDataHelper.swift
//  youtube video downloader
//
//  Created by Maximal Mac on 18.06.2018.
//  Copyright © 2018 Vlad. All rights reserved.
//

import Foundation

class InitDataHelper {
    private static let isFirstStartKey = "isFirstStartKey"
    
    static let videos = [("Japan Weekend 2018 COSPLAY VIDEO", "https://i.ytimg.com/vi/8wh2YpFKB1g/default.jpg", "https://www.youtube.com/watch?v=8wh2YpFKB1g"), ("WonderCon 2018 Cosplay Music Video", "https://i.ytimg.com/vi/0dwvL5wo3uI/default.jpg", "https://www.youtube.com/watch?v=0dwvL5wo3uI"), ("BEST DANCE OF YOUTUBE", "https://i.ytimg.com/vi/R-3GFhihEYc/default.jpg", "https://www.youtube.com/watch?v=R-3GFhihEYc"), ("BEST DANCE #7", "https://i.ytimg.com/vi/teTTOMg_ZsA/default.jpg", "https://www.youtube.com/watch?v=teTTOMg_ZsA&list=RDteTTOMg_ZsA")]
    
    //"https://www.youtube.com/watch?v=8wh2YpFKB1g", "https://www.youtube.com/watch?v=0dwvL5wo3uI", "https://www.youtube.com/watch?v=R-3GFhihEYc", "https://www.youtube.com/watch?v=teTTOMg_ZsA&list=RDteTTOMg_ZsA"
    
    static func initDatastoreIfNeeded() {
        if UserDefaults.standard.value(forKey: InitDataHelper.isFirstStartKey) == nil {
            print("it is first start")
            
            for video in InitDataHelper.videos {
                let title = video.0
                let imageUrl = video.1
                let url = video.2
                
                let data = YoutubeVideo(context: DatabaseHelper.shared.managedObjectContext)
                data.title = title
                data.imageUrl = imageUrl
                data.url = ""
                data.path = ""
                data.status = 0
                data.dataUrl = url
            }
            DatabaseHelper.shared.saveContext()
            
            UserDefaults.standard.set(true, forKey: InitDataHelper.isFirstStartKey)
        }
    }
}
