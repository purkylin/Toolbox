//
//  DragFilenameImageView.swift
//  Toolbox
//
//  Created by Purkylin King on 2016/10/16.
//  Copyright © 2016年 Purkylin King. All rights reserved.
//

import Cocoa

/// 拖拽Finder中任意文件
class DragFilenameImageView: NSImageView {
    weak var delegate: AnyObject!
    var dragFinished: ((String) -> Void)?
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        return .link
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        if let properties = sender.draggingPasteboard().propertyList(forType: "NSFilenamesPboardType") as? NSArray,
            let path = properties[0] as? String {
            let dragImage = NSWorkspace.shared().icon(forFile: path)
            self.image = dragImage
            dragFinished?(path)
            return true
            
        }
        return false
    }
    
    func register(dragFinished: @escaping (String) -> Void) {
        self.dragFinished = dragFinished
    }
    
}
