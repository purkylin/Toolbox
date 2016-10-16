//
//  BarcodeViewController.swift
//  Toolbox
//
//  Created by Purkylin King on 2016/9/30.
//  Copyright © 2016年 Purkylin King. All rights reserved.
//

import Cocoa

enum QRCorrectLevel: String {
    case L = "L"
    case M = "M"
    case Q = "Q"
    case H = "H"
}

let maxHistoryCount = 10
let maxHistoryItemCharsCount = 10

class BarcodeViewController: NSViewController, NSMenuDelegate {
    var correctLevel: QRCorrectLevel = .L
    dynamic var rawString: String!

    @IBOutlet weak var imageView: NSImageView!
    
    @IBOutlet weak var historyPopUpButton: NSPopUpButton!

    dynamic var extendViewHidden = true
    
    var history = [String]()
    
//    @IBOutlet var textView: NSTextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        historyPopUpButton.removeAllItems()
//        historyPopUpButton.addItem(withTitle: "清空历史")
        
        let menu = NSMenu()
        menu.delegate = self
        let copyItem = NSMenuItem(title: "Copy", action: #selector(menuItemCopyAction(sender:)), keyEquivalent: "")
        menu.addItem(copyItem)
        imageView.menu = menu
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        if historyPopUpButton.itemTitles.count != 0 {
            return
        }
        
        let defaults = UserDefaults.standard
        if let items = defaults.value(forKey: "History") as? [String] {
            historyPopUpButton.removeAllItems()
            historyPopUpButton.addItems(withTitles: items)
        }
    }
    
    @IBAction func btnCollapaseClicked(_ sender: AnyObject) {
        self.extendViewHidden = !self.extendViewHidden
    }
    
    @IBAction func levelChangeAction(_ sender: AnyObject) {
        let segmented = sender as! NSSegmentedControl
        let index = segmented.selectedSegment
        switch index {
        case 0:
            correctLevel = .L
        case 1:
            correctLevel = .M
        case 2:
            correctLevel = .Q
        case 3:
            correctLevel = .H
        default:
            correctLevel = .L
        }
    }
    
    func generatorQRCode(_ content: String, level: QRCorrectLevel,centerImage: NSImage?) -> NSImage? {
        if content.isEmpty {
            return nil
        }
        
        let filter = CIFilter(name: "CIQRCodeGenerator")
        let data = content.data(using: String.Encoding.utf8)
        filter?.setValue(data, forKey: "inputMessage")
        filter?.setValue(level.rawValue, forKey: "inputCorrectionLevel") // 设置滤镜的纠错率
        
        var output = filter?.outputImage
        let transform = CGAffineTransform(scaleX: 20, y: 20)
        output = output?.applying(transform)
        
        let rep = NSCIImageRep(ciImage: output!)
        let result = NSImage(size: rep.size)
        result.addRepresentation(rep)
        return result
    }
    
    @IBAction func btnGenerateClicked(_ sender: AnyObject) {
        if rawString == nil {
            return
        }
        let image = generatorQRCode(rawString, level: correctLevel, centerImage: nil)
        imageView.image = image
        
        addHistoryItem(item: rawString)
        historyPopUpButton.removeAllItems()
        historyPopUpButton.addItems(withTitles: history)
        
        let defaults = UserDefaults.standard
        defaults.set(history, forKey: "History")
    }
    
    func addHistoryItem(item: String) {
        if history.count == maxHistoryCount {
            for i in (1..<maxHistoryCount).reversed() {
                history[i] = history[i-1]
            }
            history[0] = item
        } else {
            history.insert(item, at: 0)
        }
    
        historyPopUpButton.insertItem(withTitle: item, at: 0)
    }
    
    @IBAction func historyItemClicked(_ sender: AnyObject) {
        let popup = sender as! NSPopUpButton
        rawString = popup.selectedItem?.title
    }
    
    func menuItemCopyAction(sender: AnyObject) {
        let pb = NSPasteboard.general()
        pb.clearContents()
        if let image = imageView.image {
            pb.writeObjects([image])
        }
    }
    
    override func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
        if menuItem.title == "Copy" {
            if imageView.image == nil {
                return false
            }
        }
        
        return true
    }
}
