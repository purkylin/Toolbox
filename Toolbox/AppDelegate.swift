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
    
    var windowController: NSWindowController!
    
    var aboutWindowController = PFAboutWindowController()
    
    lazy var generateWindowController: NSWindowController? = {
        return NSStoryboard(name: "Main",bundle: nil).instantiateController(withIdentifier: "generate_qr_window") as? NSWindowController
    }()
    
    lazy var detectWindowController: NSWindowController? = {
        return NSStoryboard(name: "Main",bundle: nil).instantiateController(withIdentifier: "detect_qr_window") as? NSWindowController
    }()
    
    lazy var encodeWindowController: NSWindowController? = {
        return NSStoryboard(name: "Main",bundle: nil).instantiateController(withIdentifier: "encode_window") as? NSWindowController
    }()
    
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
        menu.addItem(NSMenuItem(title: "取色器", action: #selector(colorMenuItemClicked(sender:)), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "偏好设置", action: nil, keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Crack", action: #selector(crackMenuItemClicked(sender:)), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "关于", action: #selector(aboutMenuItemClicked(sender:)), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "退出", action: #selector(quitMenuItemClicked(sender:)), keyEquivalent: ""))
        
        let statusItem = NSStatusBar.system().statusItem(withLength: -1)
        statusItem.menu = menu
        statusItem.image = NSImage(named: "status")
        self.statusItem = statusItem
    }
    
    func configAbout() {
        aboutWindowController.appURL = URL(string: "https://purkylin.com")!
        aboutWindowController.appCopyright = NSAttributedString(string: "Purkylin King", attributes: [NSForegroundColorAttributeName : NSColor.tertiaryLabelColor, NSFontAttributeName : NSFont(name: "HelveticaNeue", size: 11)])
        aboutWindowController.appName = "Toolbox"
        aboutWindowController.appCredits = NSAttributedString(string: "Thanks to liuxiaolong, liupeng")
//        aboutWindowController.textShown = NSAttributedString(string: "感谢：liuxiaolong, liupeng")
    }
    
    func encodeMenuItemClicked(sender: AnyObject) {
        encodeWindowController?.showWindow(nil)
        encodeWindowController?.window?.orderFront(nil)
        NSApp.activate(ignoringOtherApps: true)

        //        NSApp.activate(ignoringOtherApps: true) // bring frontmost of any app
    }
    
    func qrMenuItemClicked(sender: AnyObject) {
        generateWindowController?.showWindow(nil)
        generateWindowController?.window?.orderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    func detectMenuItemClicked(sender: AnyObject) {
        detectWindowController?.showWindow(nil)
        detectWindowController?.window?.orderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    func colorMenuItemClicked(sender: AnyObject) {
        let storyboard = NSStoryboard(name: "Main",bundle: nil)
        let windowController = storyboard.instantiateController(withIdentifier: "color_picker") as! NSWindowController
        windowController.showWindow(nil)
        self.windowController = windowController
        NSApp.activate(ignoringOtherApps: true)
    }
    
    func aboutMenuItemClicked(sender: AnyObject) {
        aboutWindowController.showWindow(nil)
        aboutWindowController.window?.orderFront(nil)
    }
    
    func crackMenuItemClicked(sender: AnyObject) {
        let storyboard = NSStoryboard(name: "Main",bundle: nil)
        let windowController = storyboard.instantiateController(withIdentifier: "crack") as! NSWindowController
        windowController.showWindow(nil)
        windowController.window?.orderFront(nil)
        self.windowController = windowController
        NSApp.activate(ignoringOtherApps: true)
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

