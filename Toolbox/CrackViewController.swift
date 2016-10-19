//
//  CrackViewController.swift
//  Toolbox
//
//  Created by Purkylin King on 2016/10/16.
//  Copyright © 2016年 Purkylin King. All rights reserved.
//

import Cocoa
import Security

class CrackViewController: NSViewController {
    @IBOutlet var pathTextField: NSTextField!
    @IBOutlet var drapImageView: DragFilenameImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        self.drapImageView.register { [unowned self] (path) in
            self.pathTextField.stringValue = path
        }
    }
    
    @IBAction func addExecutePermissionAction(_ sender: AnyObject) {
        if pathTextField.stringValue.characters.count == 0 {
            return
        }
        
        let task = Process()
        task.launchPath = "/bin/chmod"
        task.arguments = ["+x", pathTextField.stringValue]
        task.launch()
        if task.terminationReason != Process.TerminationReason.exit {
            print("error")
        }
    }
    
    @IBAction func resignAction(_ sender: AnyObject) {
    }
    

}
