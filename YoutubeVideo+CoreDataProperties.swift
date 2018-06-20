//
//  YoutubeVideo+CoreDataProperties.swift
//  
//
//  Created by Maximal Mac on 20.06.2018.
//
//

import Foundation
import CoreData


extension YoutubeVideo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<YoutubeVideo> {
        return NSFetchRequest<YoutubeVideo>(entityName: "YoutubeVideo")
    }

    @NSManaged public var imageUrl: String?
    @NSManaged public var path: String?
    @NSManaged public var status: Int64
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var dataUrl: String?

}
