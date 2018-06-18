//
//  YoutubeVideo+CoreDataProperties.swift
//  
//
//  Created by Maximal Mac on 18.06.2018.
//
//

import Foundation
import CoreData


extension YoutubeVideo: EntityCreating {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<YoutubeVideo> {
        return NSFetchRequest<YoutubeVideo>(entityName: "YoutubeVideo")
    }

    @NSManaged public var title: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var url: String?
    @NSManaged public var status: Int64
    @NSManaged public var path: String?

}
