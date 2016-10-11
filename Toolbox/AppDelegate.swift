//
//  AppDelegate.swift
//  Toolbox
//
//  Created by Purkylin King on 2016/9/30.
//  Copyright © 2016年 Purkylin King. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem! //  一定要强引用
    var windowCtrl:NSWindowController!
    var mainController: NSWindowController!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application

        configMenu()
        NSApplication.shared().mainWindow?.orderOut(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func configMenu() {
        let menu = NSMenu()
//        menu.delegate = self
        menu.addItem(NSMenuItem(title: "生成二维码", action: #selector(qrMenuItemClicked(sender:)), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "识别二维码", action: #selector(detectMenuItemClicked(sender:)), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "URL编码", action: #selector(encodeMenuItemClicked(sender:)), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "退出", action: #selector(quitMenuItemClicked(sender:)), keyEquivalent: ""))
        
        let statusItem = NSStatusBar.system().statusItem(withLength: -1)
        statusItem.menu = menu
        statusItem.title = "Toolbox"
        self.statusItem = statusItem
    }
    
    func encodeMenuItemClicked(sender: AnyObject) {
//        let windowController = NSWindowController()
//        let storyboard = NSStoryboard(name: "Main",bundle: nil)
//        let controller: NSViewController = storyboard.instantiateController(withIdentifier: "encode") as! NSViewController
//        windowController.contentViewController = controller
//        windowController.showWindow(nil)
//        self.mainController = windowController
//        NSApplication.shared().mainWindow = windowController.window
//        myWindow?.makeKeyAndOrderFront(self)
    }
    
    func qrMenuItemClicked(sender: AnyObject) {
        
    }
    
    func detectMenuItemClicked(sender: AnyObject) {
        
    }
    
    func quitMenuItemClicked(sender: AnyObject) {
        NSApp.terminate(nil)
    }
    
    func test() {
        
    }
    

    

}

