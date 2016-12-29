//
//  PreferenceViewController.swift
//  Toolbox
//
//  Created by Purkylin King on 2016/12/25.
//  Copyright © 2016年 Purkylin King. All rights reserved.
//

import Cocoa
import ServiceManagement

class PreferenceViewController: NSViewController {
    @IBOutlet var autoLaunchBtn: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        let state = defaults.integer(forKey: "AutoLaunch")
        autoLaunchBtn.state = state
    }
    
    @IBAction func btnAutoLaunchClicked(_ sender: NSButton) {
        if (SMLoginItemSetEnabled("com.purkylin.LaunchHelper" as CFString, sender.state == NSOnState)) {
            UserDefaults.standard.setValue(sender.state, forKey: "AutoLaunch")
            print("Setting success: \(sender.state)")
        } else {
            print("Setting failed")
        }
        
        UserDefaults.standard.synchronize()
    }
}
