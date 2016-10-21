//
//  DragImageView.swift
//  CocoaDemo
//
//  Created by Purkylin King on 2016/10/16.
//  Copyright © 2016年 Purkylin King. All rights reserved.
//

import Cocoa

/// 保存到Finder
class DragImageView: NSImageView {
    
    override func mouseDown(with event: NSEvent) {
        
        var drapPosition = self.convert(event.locationInWindow, from: nil)
        drapPosition.x -= 16
        drapPosition.y -= 16
        let imageLocation = NSRect(origin: drapPosition, size: NSSize(width: 32, height: 32))
        if self.image != nil {
            self.dragPromisedFiles(ofTypes: ["png"], from: imageLocation, source: self, slideBack: true, event: event)
        }
    }
    
    override func namesOfPromisedFilesDropped(atDestination dropDestination: URL) -> [String]? {
        if let data = self.image?.tiffRepresentation {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyyMMddHHmmss"
            let str = formatter.string(from: Date())
            let fname = str + ".png"
            let dstPath = dropDestination.appendingPathComponent(fname)
            try! data.write(to: dstPath)
        }
        
        return []
        
    }
}
