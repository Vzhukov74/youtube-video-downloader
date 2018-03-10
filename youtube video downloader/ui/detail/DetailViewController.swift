//
//  DetailViewController.swift
//  youtube video downloader
//
//  Created by Vlad on 06.02.2018.
//  Copyright © 2018 Vlad. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var model: Video!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

extension DetailViewController: StoryboardInstanceable {
    static var storyboardName: StoryboardList = .detail
}
