//
//  DetectViewController.swift
//  Toolbox
//
//  Created by Purkylin King on 2016/10/9.
//  Copyright © 2016年 Purkylin King. All rights reserved.
//

import Cocoa

class DetectViewController: NSViewController {
//    dynamic var text: String!
    @IBOutlet var textView: NSTextView!
    @IBOutlet weak var imageView: NSImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func btnDetectClicked(_ sender: AnyObject) {
        if let image = imageView.image {
            let resuluts = detectQR(image: image)
            if resuluts.count > 0 {
                textView.string = resuluts.first!
            } else {
                textView.string = ""
            }
        } else {
            textView.string = ""

        }
    
    }
    
    func detectQR(image: NSImage) -> [String] {
        let imageData = image.tiffRepresentation
        let ciImage = CIImage(data: imageData!)
        
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])
        
        var results = [String]()
        let features = detector?.features(in: ciImage!)
        for feature in features as! [CIQRCodeFeature] {
            print(feature.messageString)
            results.append(feature.messageString!)
        }
        return results
    }
}
