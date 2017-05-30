//
//  Util.swift
//  Toolbox
//
//  Created by Purkylin King on 2017/5/30.
//  Copyright © 2017年 Purkylin King. All rights reserved.
//

import Foundation

func sendRecoverLinkNotification(success: Bool, url: String?, originalUrl: String) {
    let userCenter = NSUserNotificationCenter.default
    let notif = NSUserNotification()
    if success {
        notif.title = "Recover link success"
        notif.userInfo = ["url" : url!]
        notif.informativeText = "Click here to open"
    } else {
        notif.title = "Recover follow link failed"
        notif.informativeText = originalUrl
    }
    
//    notif.actionButtonTitle = "Open"

//    notif.additionalActions = [
//        NSUserNotificationAction(identifier: "Copy", title: "Copy")
//    ]
    
    userCenter.deliver(notif)
}
