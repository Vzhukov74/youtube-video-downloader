//
//  StoryboardList.swift
//  youtube video downloader
//
//  Created by Vlad on 20.01.2018.
//  Copyright © 2018 Vlad. All rights reserved.
//

import UIKit

enum StoryboardList: String {
    case navigation = "MainNavigationController"
    case main = "MainViewController"
    case detail = "DetailViewController"
}

protocol StoryboardInstanceable {
    static var storyboardName: StoryboardList {get set}
}

extension StoryboardInstanceable {
    static var storyboardInstance: Self? {
        let storyboard = UIStoryboard(name: storyboardName.rawValue, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier:String(describing: self)) as? Self
        return vc
    }
}

