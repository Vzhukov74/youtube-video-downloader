//
//  YoutubeModel.swift
//  youtube video downloader
//
//  Created by Maximal Mac on 18.06.2018.
//  Copyright © 2018 Vlad. All rights reserved.
//

import Foundation
import CoreData

class YoutubeModel {
    
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
}
