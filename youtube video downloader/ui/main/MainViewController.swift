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

    let downloadCenter = DownloadCenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = Colors.background
        
        let video = HCYoutubeParser.h264videos(withYoutubeURL: URL(string: "https://www.youtube.com/watch?v=teTTOMg_ZsA&list=RDteTTOMg_ZsA")!)
        let hd = video!["hd720"]
        
        let image = (video!["moreInfo"] as! [String: Any])["thumbnail_url"]
        print(image)
        
        let url = hd as! String
        SwiftyBeaver.info(url)
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let fullPath = documentsPath.appendingPathComponent((URL(string: url)?.lastPathComponent)!)
        print(fullPath)
        //downloadCenter.startDownload(url)

    }
    
    private func showDetailVC(with model: Video) {
        
    }
}

extension MainViewController: StoryboardInstanceable {
    static var storyboardName: StoryboardList = .main
}
