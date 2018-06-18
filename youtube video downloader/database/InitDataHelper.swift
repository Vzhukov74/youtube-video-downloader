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
    
    static let videos = [("Japan Weekend 2018 COSPLAY VIDEO", "https://i.ytimg.com/vi/8wh2YpFKB1g/default.jpg", "https://r4---sn-4pvgq-n8vs.googlevideo.com/videoplayback?source=youtube&ip=80.77.168.133&signature=3F4EA97DE178EFEC190F198A7748C42986E7D560.C76A804CBDB6A3633937A178401C86A5BE9E9DA7&mt=1529312513&mv=m&ms=au,rdu&mm=31,29&mn=sn-4pvgq-n8vs,sn-n8v7kn7d&id=o-AAq62iWjI6onG8rT1KOCN5gnlZrgdLOju9BbaRlSjLvg&initcwndbps=586250&c=WEB&ipbits=0&pl=24&ei=q3UnW_LCJ6fe7gSMjJHIBA&itag=22&ratebypass=yes&requiressl=yes&mime=video/mp4&key=yt6&fvip=14&sparams=dur,ei,id,initcwndbps,ip,ipbits,itag,lmt,mime,mm,mn,ms,mv,nh,pl,ratebypass,requiressl,source,expire&expire=1529334283&nh=,IgpwcjA0LnN2bzA2KgkxMjcuMC4wLjE&lmt=1526878007751914&dur=212.741&signature=22"), ("WonderCon 2018 Cosplay Music Video", "https://i.ytimg.com/vi/0dwvL5wo3uI/default.jpg", "https://r3---sn-4pvgq-n8vs.googlevideo.com/videoplayback?c=WEB&key=yt6&mime=video/mp4&fvip=8&nh=,IgpwcjA0LnN2bzA2KgkxMjcuMC4wLjE&dur=230.295&expire=1529334284&ratebypass=yes&requiressl=yes&initcwndbps=586250&source=youtube&ei=rHUnW_WyC9Ht7QTwobq4Dg&lmt=1526402399082883&sparams=dur,ei,id,initcwndbps,ip,ipbits,itag,lmt,mime,mm,mn,ms,mv,nh,pl,ratebypass,requiressl,source,expire&ipbits=0&signature=341FB693F3659D24F0CAAB6609D4416B81B69715.3891EA604C1E3DC41F7C7E5B670931B7F1473DAF&id=o-AAZA0YO-m9kf5ZoAMNiV_O1lIoaXucMuPJHzkYq7-VMo&mv=m&mt=1529312513&ms=au,rdu&mn=sn-4pvgq-n8vs,sn-n8v7knee&ip=80.77.168.133&mm=31,29&itag=22&pl=24&signature=22"), ("BEST DANCE OF YOUTUBE", "https://i.ytimg.com/vi/R-3GFhihEYc/default.jpg", "https://r8---sn-4pvgq-n8ve.googlevideo.com/videoplayback?ms=au,rdu&mt=1529312513&mv=m&ip=80.77.168.133&id=o-AA_sQEfEgPupdk3oR2QbOvh25eOJ44YPEtPQmVuHOBlT&requiressl=yes&dur=677.000&mm=31,29&mn=sn-4pvgq-n8ve,sn-n8v7znly&pl=24&ipbits=0&expire=1529334284&sparams=dur,ei,id,initcwndbps,ip,ipbits,itag,lmt,mime,mm,mn,ms,mv,nh,pl,ratebypass,requiressl,source,expire&initcwndbps=636250&lmt=1507292465472453&nh=,IgpwcjA0LnN2bzA2KgkxMjcuMC4wLjE&source=youtube&mime=video/mp4&itag=22&key=yt6&signature=58683E0E8E9D841642A0AEF111FB93DE1DA8F685.69132D2EBA19CB587986B5C8F1624E459E1A4099&ratebypass=yes&fvip=4&ei=rHUnW9S_G-Ht7AT95LTICQ&c=WEB&signature=22"), ("BEST DANCE #7", "https://i.ytimg.com/vi/teTTOMg_ZsA/default.jpg", "https://r6---sn-4pvgq-n8ve.googlevideo.com/videoplayback?ms=au,rdu&itag=22&initcwndbps=636250&mv=m&mt=1529312513&sparams=dur,ei,id,initcwndbps,ip,ipbits,itag,lmt,mime,mm,mn,ms,mv,nh,pl,ratebypass,requiressl,source,expire&ei=rHUnW8WaLcKK7AS-87P4Cg&mn=sn-4pvgq-n8ve,sn-n8v7snek&mm=31,29&expire=1529334284&pl=24&mime=video/mp4&lmt=1511344423583394&dur=609.175&ratebypass=yes&source=youtube&key=yt6&nh=,IgpwcjA0LnN2bzA2KgkxMjcuMC4wLjE&id=o-ADryPS7HL1ldpbPEvfmk7K_gwTy2-_qwl9uX8S4pdZ_2&c=WEB&fvip=10&signature=7A42538128AD782ED8D7C7314606C5958EF0E750.52785CBB71CFC715B582E11CFB03B01F4D2F8615&ipbits=0&requiressl=yes&ip=80.77.168.133&signature=22")]
    
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
                data.url = url
                data.path = ""
                data.status = 0
            }
            DatabaseHelper.shared.saveContext()
            
            UserDefaults.standard.set(true, forKey: InitDataHelper.isFirstStartKey)
        }
    }
}
