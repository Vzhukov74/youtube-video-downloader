//
//  MainNavigationController.swift
//  youtube video downloader
//
//  Created by Vlad on 20.01.2018.
//  Copyright © 2018 Vlad. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let vc = MainViewController.storyboardInstance {
            self.viewControllers = [vc]
        }
    }
}

extension MainNavigationController: StoryboardInstanceable {
    static var storyboardName: StoryboardList = .navigation
}
