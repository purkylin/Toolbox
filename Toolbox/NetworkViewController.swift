//
//  NetworkViewController.swift
//  Toolbox
//
//  Created by Purkylin King on 2016/12/26.
//  Copyright © 2016年 Purkylin King. All rights reserved.
//

import Cocoa

class NetworkViewController: NSViewController {

    @IBOutlet weak var dnsPopupButton: NSPopUpButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        let defaults = UserDefaults.standard
        if let records = defaults.value(forKeyPath: "records") as? [String] {
            dnsPopupButton.removeAllItems()
            dnsPopupButton.addItems(withTitles: records)
            
            if let record = defaults.string(forKey: "currentDNS") {
                if let index = records.index(of: record) {
                    dnsPopupButton.selectItem(at: index)
                }
            }
        } else {
            dnsPopupButton.removeAllItems()
            dnsPopupButton.addItems(withTitles: ["默认", "8.8.8.8", "114.114.114.114"])
            dnsPopupButton.selectItem(at: 0)
        }
    }
    
    @IBAction func btnApplyClicked(_ sender: Any) {
        if let title = dnsPopupButton.titleOfSelectedItem {
            if title == "默认" {
                SudoHelper.sharedInstance().runCommand("networksetup -setdnsservers Wi-Fi empty", completion: { (output, success) in
                    if !success {
                        DispatchQueue.main.async {
                            let alert = NSAlert()
                            alert.informativeText = output!
                            alert.beginSheetModal(for: self.view.window!, completionHandler: nil)
                        }
                    }
                })
            } else {
                SudoHelper.sharedInstance().runCommand("networksetup -setdnsservers Wi-Fi \(title)", completion: { (output, success) in
                    if !success {
                        DispatchQueue.main.async {
                            let alert = NSAlert()
                            alert.informativeText = output!
                            alert.beginSheetModal(for: self.view.window!, completionHandler: nil)
                        }

                    }
                })
            }
            
            let defaults = UserDefaults.standard
            defaults.set(dnsPopupButton.itemTitles, forKey: "records")
            defaults.setValue(dnsPopupButton.stringValue, forKey: "currentDNS")
            defaults.synchronize()
        }
        
    }
}
