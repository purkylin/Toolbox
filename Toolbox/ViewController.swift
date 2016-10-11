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
//        test()
        
//        let storyboard = NSStoryboard(name: "Main", bundle: nil);
//        let storyboard = self.storyboard
//        let vc = storyboard?.instantiateController(withIdentifier: "encode")
//        
    
    }
    
    func test() {
        service = NetService(domain: "local.", type: "_spider._tcp", name: "", port: 2333)
        service.delegate = self
        service.publish()
        browser = NetServiceBrowser()
        browser.delegate = self
        browser.searchForServices(ofType: "_spider._tcp", inDomain: "local.")
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
        if moreComing {
            print("more")
        } else {
            print(service.name)
            service.delegate = self
            service.resolve(withTimeout: 2)
            clients.append(service)
        }
    }
    
    func netServiceDidPublish(_ sender: NetService) {
        print("publish ok")
    }
    
    func netService(_ sender: NetService, didNotPublish errorDict: [String : NSNumber]) {
        print("publish error")
    }
    
    func netServiceDidResolveAddress(_ sender: NetService) {
        let address = sender.addresses?.first
        let strAddr = GCDAsyncSocket.host(fromAddress: address)
        print(strAddr)
    }
    
    func netService(_ sender: NetService, didNotResolve errorDict: [String : NSNumber]) {
        print("error resolve")
    }

}

