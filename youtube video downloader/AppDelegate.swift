//
//  AppDelegate.swift
//  youtube video downloader
//
//  Created by Vlad on 20.01.2018.
//  Copyright © 2018 Vlad. All rights reserved.
//

import UIKit
import SwiftyBeaver

let log = SwiftyBeaver.self

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var backgroundSessionCompletionHandler: (() -> Void)?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let console = ConsoleDestination()
        log.addDestination(console)
        
        InitDataHelper.initDatastoreIfNeeded()
        
//        let strs = ["https://www.youtube.com/watch?v=8wh2YpFKB1g", "https://www.youtube.com/watch?v=0dwvL5wo3uI", "https://www.youtube.com/watch?v=R-3GFhihEYc", "https://www.youtube.com/watch?v=teTTOMg_ZsA&list=RDteTTOMg_ZsA"]
//        
//        for str in strs {
//            let video = HCYoutubeParser.h264videos(withYoutubeURL: URL(string: str)!)
//            let hd = video!["hd720"]
//            
//            let image = (video!["moreInfo"] as! [String: Any])["thumbnail_url"] as! String
//            let title = (video!["moreInfo"] as! [String: Any])["title"] as! String
//            
//            let url = hd as! String
//            
//            print(title)
//            print(image)
//            print(url)
//            
//            SwiftyBeaver.info(url)
//        }

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        backgroundSessionCompletionHandler = completionHandler
    }
}

