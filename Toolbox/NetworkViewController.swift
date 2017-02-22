//
//  NetworkViewController.swift
//  Toolbox
//
//  Created by Purkylin King on 2016/12/26.
//  Copyright © 2016年 Purkylin King. All rights reserved.
//

import Cocoa

class NetworkViewController: NSViewController {

    @IBOutlet weak var dnsComboBox: NSComboBox!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        let defaults = UserDefaults.standard
        if let records = defaults.value(forKeyPath: "records") as? [String] {
            dnsComboBox.removeAllItems()
            dnsComboBox.addItems(withObjectValues: records)
            
            if let record = defaults.string(forKey: "currentDNS") {
                if let index = records.index(of: record) {
                    dnsComboBox.selectItem(at: index)
                }
            }
        } else {
            dnsComboBox.removeAllItems()
            dnsComboBox.addItems(withObjectValues: ["默认", "8.8.8.8", "114.114.114.114"])
            dnsComboBox.selectItem(at: 0)
        }
    }
    
    @IBAction func btnApplyClicked(_ sender: Any) {
        let title = dnsComboBox.stringValue
        if title.characters.count > 0 {
            if title == "默认" {
                SudoHelper.sharedInstance().runCommand("networksetup -setdnsservers Wi-Fi empty", completion: { (output, success) in
                    if !success {
                        DispatchQueue.main.async {
                            let alert = NSAlert()
                            alert.informativeText = output!
                            alert.beginSheetModal(for: self.view.window!, completionHandler: nil)
                        }
                    } else {
                        let defaults = UserDefaults.standard
                        defaults.set(self.dnsComboBox.objectValues, forKey: "records")
                        defaults.setValue(self.dnsComboBox.stringValue, forKey: "currentDNS")
                        defaults.synchronize()
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
                    } else {
                        if self.dnsComboBox.indexOfItem(withObjectValue: self.dnsComboBox.stringValue) == NSNotFound {
                            self.dnsComboBox.addItem(withObjectValue: self.dnsComboBox.stringValue)
                            
                            let defaults = UserDefaults.standard
                            defaults.set(self.dnsComboBox.objectValues, forKey: "records")
                            defaults.setValue(self.dnsComboBox.stringValue, forKey: "currentDNS")
                            defaults.synchronize()
                        }
                    }
                })
            }
        }
        
    }
}
