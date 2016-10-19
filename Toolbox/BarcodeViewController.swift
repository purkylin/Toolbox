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
    
    func maxDataLength(level: QRCorrectLevel) -> Int {
        switch level {
        case .L:
            return 2953
        case .M:
            return 2331
        case .Q:
            return 1663
        case .H:
            return 1273
        }
    }
    
    func generatorQRCode(_ content: String, level: QRCorrectLevel,centerImage: NSImage?) -> NSImage? {
        if content.isEmpty {
            return nil
        }
        
//        * http://en.wikipedia.org/wiki/QR_code
//        
//        Numeric only    Max. 7,089 characters (0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
//        Alphanumeric    Max. 4,296 characters (0–9, A–Z [upper-case only], space, $, %, *, +, -, ., /, :)
//        Binary/byte     Max. 2,953 characters (8-bit bytes) (23624 bits)
//        Kanji/Kana  Max. 1,817 characters
        
        let filter = CIFilter(name: "CIQRCodeGenerator")
        let data = content.data(using: String.Encoding.utf8)
        if data!.count > maxDataLength(level: correctLevel) {
            let alert = NSAlert()
            alert.messageText = "数据太长,请截断,当前数据长度\(data!.count), 最大长度\(maxDataLength(level: correctLevel)), 一个汉字占3字节, 一个字符占1字节"
            alert.beginSheetModal(for: self.view.window!, completionHandler: nil)
            return nil
        }
        
        filter?.setValue(data, forKey: "inputMessage")
        filter?.setValue(level.rawValue, forKey: "inputCorrectionLevel") // 设置滤镜的纠错率
        
        var output = filter?.outputImage
        if output == nil {
            print("Generate qr failed")
            return nil
        }
        
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
