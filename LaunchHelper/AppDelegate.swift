//
//  AppDelegate.swift
//  LaunchHelper
//
//  Created by Purkylin King on 2016/12/23.
//  Copyright © 2016年 Purkylin King. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        let mainIdentifier = "com.purkylin.LaunchHelper"
        let running = NSWorkspace.shared().runningApplications.filter { (app) -> Bool in
            return app.bundleIdentifier == mainIdentifier
        }
        
        let alreadyRunning = running.count > 0
        
        if alreadyRunning {
            let path = Bundle.main.bundlePath as NSString
            var components = path.pathComponents
            components.removeLast()
            components.removeLast()
            components.removeLast()
            components.removeLast()
            
            let appPath = NSString.path(withComponents: components)
            print("a--------b")
            print(appPath)
            NSWorkspace.shared().launchApplication(appPath)
            NSApp.terminate(nil)
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

