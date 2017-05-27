//
//  ViewController.swift
//  Toolbox
//
//  Created by Purkylin King on 2016/9/30.
//  Copyright © 2016年 Purkylin King. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NetServiceDelegate, NetServiceBrowserDelegate {
    var service: NetService!
    var browser: NetServiceBrowser!
    var clients = [NetService]()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

}

