//
//  AppDelegate.swift
//  Toolbox
//
//  Created by Purkylin King on 2016/9/30.
//  Copyright © 2016年 Purkylin King. All rights reserved.
//

import Cocoa
import PFAboutWindow

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem! //  一定要强引用
    var windowCtrl:NSWindowController!
    var mainController: NSWindowController!
    
    var aboutWindowController = PFAboutWindowController()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        configMenu()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func configMenu() {
        let menu = NSMenu()
//        menu.delegate = self
        menu.addItem(NSMenuItem(title: "打开终端", action: #selector(terminalMenuItemClicked(sender:)), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "生成二维码", action: #selector(qrMenuItemClicked(sender:)), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "识别二维码", action: #selector(detectMenuItemClicked(sender:)), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "编码", action: #selector(encodeMenuItemClicked(sender:)), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "关于", action: #selector(aboutMenuItemClicked(sender:)), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "退出", action: #selector(quitMenuItemClicked(sender:)), keyEquivalent: ""))
        
        let statusItem = NSStatusBar.system().statusItem(withLength: -1)
        statusItem.menu = menu
        statusItem.title = "Toolbox"
        self.statusItem = statusItem
    }
    
    func configAbout() {
        aboutWindowController.appURL = URL(string: "https://purkylin.com")!
        aboutWindowController.appCopyright = NSAttributedString(string: "Purkylin King", attributes: [NSForegroundColorAttributeName : NSColor.tertiaryLabelColor, NSFontAttributeName : NSFont(name: "HelveticaNeue", size: 11)])
        aboutWindowController.appName = "Toolbox"
        aboutWindowController.appCredits = NSAttributedString(string: "Thanks to liuxiaolong, liupeng")
//        aboutWindowController.textShown = NSAttributedString(string: "感谢：liuxiaolong, liupeng")
    }
    
    func showViewController(identifier: String) {
        if self.mainController != nil {
            mainController.window?.orderOut(nil)
        }
        
        let storyboard = NSStoryboard(name: "Main",bundle: nil)
        let windowController = storyboard.instantiateController(withIdentifier: "main") as! NSWindowController
        let viewController = storyboard.instantiateController(withIdentifier: identifier) as! NSViewController
        windowController.contentViewController = viewController
//        windowController.window?.makeKeyAndOrderFront(nil)
        windowController.showWindow(nil)
        windowController.window?.orderFront(nil)
        NSApp.activate(ignoringOtherApps: true) // bring frontmost of any app
        self.mainController = windowController
    }
    
    func encodeMenuItemClicked(sender: AnyObject) {
        showViewController(identifier: "encode")
        mainController.window?.title = "编码"
    }
    
    func qrMenuItemClicked(sender: AnyObject) {
        showViewController(identifier: "generate")
        mainController.window?.title = "生成二维码"
    }
    
    func detectMenuItemClicked(sender: AnyObject) {
        showViewController(identifier: "detect")
        mainController.window?.title = "识别二维码"
    }
    
    func aboutMenuItemClicked(sender: AnyObject) {
        aboutWindowController.showWindow(nil)
    }
    
    func quitMenuItemClicked(sender: AnyObject) {
        NSApp.terminate(nil)
    }
    
    func terminalMenuItemClicked(sender: AnyObject) {
        let cmd = "tell application \"Terminal\"\n    activate\n    tell application \"System Events\" to keystroke \"n\" using {command down}\nend tell\n"
        let script = NSAppleScript(source: cmd)
        script?.executeAndReturnError(nil)
    }
}

extension String {
    func escaped() -> String {
        var arr = [String]()
        for c in self.characters {
            var t = ""
            switch c {
            case "\n":
                t = "\\n"
            case "\t":
                t = "    "
            case "\"":
                t = "\\\""
            case "\\":
                t = "\\\\"
            default:
                t = String(c)
            }
            arr.append(t)
        }
        return arr.joined(separator: "")
    }
}

