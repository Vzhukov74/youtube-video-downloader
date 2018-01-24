//
//  MainViewController.swift
//  youtube video downloader
//
//  Created by Vlad on 20.01.2018.
//  Copyright © 2018 Vlad. All rights reserved.
//

import UIKit
import SwiftyBeaver

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let video = HCYoutubeParser.h264videos(withYoutubeURL: URL(string: "https://www.youtube.com/watch?v=teTTOMg_ZsA&list=RDteTTOMg_ZsA")!)
        let hd = video!["hd720"]
        let url = hd as! String
        SwiftyBeaver.info(url)
    }
}

extension MainViewController: StoryboardInstanceable {
    static var storyboardName: StoryboardList = .main
}
