//
//  WindowController.swift
//  Toolbox
//
//  Created by Purkylin King on 2016/9/30.
//  Copyright © 2016年 Purkylin King. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController, NSMenuDelegate {
    var statusItem: NSStatusItem! //  一定要强引用

    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
    func configMenu() {
        let menu = NSMenu()
        menu.delegate = self
        
        menu.addItem(NSMenuItem(title: "生成二维码", action: #selector(qrMenuItemClicked(sender:)), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "识别二维码", action: #selector(detectMenuItemClicked(sender:)), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "URL编码", action: #selector(encodeMenuItemClicked(sender:)), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "退出", action: #selector(quitMenuItemClicked(sender:)), keyEquivalent: ""))
        
        for item in menu.items {
            item.target = self
        }
        
        
        let statusItem = NSStatusBar.system().statusItem(withLength: -1)
        statusItem.menu = menu
        statusItem.title = "Toolbox"
        self.statusItem = statusItem
    }
    
    func encodeMenuItemClicked(sender: AnyObject) {
        let vc = self.storyboard!.instantiateController(withIdentifier: "encode")
        self.contentViewController?.presentViewControllerAsModalWindow(vc as! NSViewController)
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
    
    override func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
        return true
    }

}
