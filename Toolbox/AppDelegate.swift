//
//  AppDelegate.swift
//  Toolbox
//
//  Created by Purkylin King on 2016/9/30.
//  Copyright © 2016年 Purkylin King. All rights reserved.
//

import Cocoa
import PFAboutWindow
import ServiceManagement
import Alamofire
import SwiftyJSON

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
        
        if #available(OSX 10.12, *) {
            NSWindow.allowsAutomaticWindowTabbing = true
        } else {
            // Fallback on earlier versions
        }
        
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "records")
        defaults.synchronize()
        
        NSUserNotificationCenter.default.delegate = self
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
        menu.addItem(NSMenuItem(title: "网络设置", action: #selector(networkMenuItemClicked(sender:)), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "还原短链接", action: #selector(recoverUrlMenuItemClicked(sender:)), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        
        let autoLaunchMenuItem = NSMenuItem(title: "开机启动", action: #selector(autoLaunchMenuItemClicked(sender:)), keyEquivalent: "")
        menu.addItem(autoLaunchMenuItem)
        let defaults = UserDefaults.standard
        autoLaunchMenuItem.state = defaults.integer(forKey: "AutoLaunch")
    
//        menu.addItem(NSMenuItem(title: "偏好设置", action: #selector(preferenceMenuItelClicked(sender:)), keyEquivalent: ""))
//        menu.addItem(NSMenuItem(title: "Crack", action: #selector(crackMenuItemClicked(sender:)), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "关于", action: #selector(aboutMenuItemClicked(sender:)), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "退出", action: #selector(quitMenuItemClicked(sender:)), keyEquivalent: ""))
        
        let statusItem = NSStatusBar.system().statusItem(withLength: -1)
        statusItem.menu = menu
        statusItem.image = NSImage(named: "status")
        self.statusItem = statusItem
    }
    
    // MARK - Actions
    func encodeMenuItemClicked(sender: AnyObject) {
        encodeWindowController?.showWindow(nil)
        encodeWindowController?.window?.orderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
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
        NSApp.orderFrontStandardAboutPanel(nil)
    }
    
    func autoLaunchMenuItemClicked(sender: AnyObject) {
        if let item = sender as? NSMenuItem {
            item.state = item.state == NSOnState ? NSOffState : NSOnState
            
            if (SMLoginItemSetEnabled("com.purkylin.LaunchHelper" as CFString, sender.state == NSOnState)) {
                UserDefaults.standard.setValue(item.state, forKey: "AutoLaunch")
                UserDefaults.standard.synchronize()
                print("Setting success \(item.state)")
            } else {
                print("Setting failed")
            }
        }
    }
    
    func crackMenuItemClicked(sender: AnyObject) {
        let storyboard = NSStoryboard(name: "Main",bundle: nil)
        let windowController = storyboard.instantiateController(withIdentifier: "crack") as! NSWindowController
        windowController.showWindow(nil)
        windowController.window?.orderFront(nil)
        self.windowController = windowController
        NSApp.activate(ignoringOtherApps: true)
    }
    
    func networkMenuItemClicked(sender: AnyObject) {
        let storyboard = NSStoryboard(name: "Main",bundle: nil)
        let windowController = storyboard.instantiateController(withIdentifier: "network") as! NSWindowController
        windowController.showWindow(nil)
        windowController.window?.orderFront(nil)
        self.windowController = windowController
        NSApp.activate(ignoringOtherApps: true)
    }
    
    func recoverUrlMenuItemClicked(sender: AnyObject) {
        let pboard = NSPasteboard.general()
        if pboard.canReadItem(withDataConformingToTypes: [NSPasteboardTypeString]) {
            guard let data = pboard.data(forType: NSPasteboardTypeString) else {
                return
            }
            
            guard let raw = String(data: data, encoding: .utf8), raw.characters.count > 0 else {
                return
            }
            
            guard let url = URL(string: raw) else {
                return
            }
            
            Alamofire.request("http://purkylin.com/api/recover_link", method: .post, parameters: ["url" : url]).responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    if json["status"].intValue == 0 {
                        let result = json["url"].stringValue
                        sendRecoverLinkNotification(success: true, url: result, originalUrl: raw)
                    } else {
                        sendRecoverLinkNotification(success: false, url: nil, originalUrl: raw)
                        print(json["message"].stringValue)
                    }
                case .failure(let error):
                    sendRecoverLinkNotification(success: false, url: nil, originalUrl: raw)
                    print(error)
                }
            }
        }
    }
    
    func quitMenuItemClicked(sender: AnyObject) {
        NSApp.terminate(nil)
    }
    
    func terminalMenuItemClicked(sender: AnyObject) {
        let cmd = "tell application \"Terminal\"\n    activate\n    tell application \"System Events\" to keystroke \"n\" using {command down}\nend tell\n"
        let script = NSAppleScript(source: cmd)
        script?.executeAndReturnError(nil)
    }
    
    func preferenceMenuItelClicked(sender: AnyObject) {
        let storyboard = NSStoryboard(name: "Main",bundle: nil)
        let windowController = storyboard.instantiateController(withIdentifier: "preference") as! NSWindowController
        windowController.showWindow(nil)
        windowController.window?.orderFront(nil)
        self.windowController = windowController
        NSApp.activate(ignoringOtherApps: true)
    }
    
    // MARK - Others
    
    func setupLaunchItem() {
        let defaults = UserDefaults.standard
        let enable = defaults.bool(forKey: "AutoLaunch")
        
        if !enable {
            if (SMLoginItemSetEnabled("com.purkylin.LaunchHelper" as CFString, true)) {
                print("Setting auto launch success")
            } else {
                print("Settting auto launch failed")
            }
        }
    }
}

extension AppDelegate: NSUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: NSUserNotificationCenter, didActivate notification: NSUserNotification) {
        if let str = notification.userInfo?["url"] as? String {
            if let url = URL(string: str) {
                NSWorkspace.shared().open(url)
            }
        }
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

