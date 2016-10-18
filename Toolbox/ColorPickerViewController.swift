//
//  ColorPickerViewController.swift
//  Toolbox
//
//  Created by Purkylin King on 2016/10/16.
//  Copyright © 2016年 Purkylin King. All rights reserved.
//

import Cocoa

class ColorPickerViewController: NSViewController {
    @IBOutlet var colorWell: NSColorWell!
    @IBOutlet var colorTextField: NSTextField!
    @IBOutlet var alphaTextField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        colorTextField.isEditable = false
        alphaTextField .isEditable = false
    }
    
    @IBAction func changeColorAction(_ sender: NSColorWell) {
        let r = Int(sender.color.redComponent * 255)
        let g = Int(sender.color.greenComponent * 255)
        let b = Int(sender.color.blueComponent * 255)
        let s = String(format: "#%02X%02X%02X", r, g, b)
        colorTextField.stringValue = s
        
        let alpha = sender.color.alphaComponent
        alphaTextField.stringValue = "\(alpha)"


    }
}
