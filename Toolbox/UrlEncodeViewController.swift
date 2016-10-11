//
//  UrlEncodeViewController.swift
//  Toolbox
//
//  Created by Purkylin King on 2016/10/1.
//  Copyright © 2016年 Purkylin King. All rights reserved.
//

import Cocoa

class UrlEncodeViewController: NSViewController {
    dynamic var enableComposent = false
    @IBOutlet var preTextView: NSTextView!
    @IBOutlet var postTextView: NSTextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func btnConvertAction(_ sender: AnyObject) {
//        let preUrl = NSURL(string: preTextView.string)
//        let postUrl = NSURL(string: postTextView.string)
        if let text = preTextView.string, text.characters.count > 0 {
            let postText = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            postTextView.string = postText
        }

    }
    
    @IBAction func btnExchangeAction(_ sender: AnyObject) {
        (preTextView.string, postTextView.string) = (postTextView.string, preTextView.string)
    }
}
