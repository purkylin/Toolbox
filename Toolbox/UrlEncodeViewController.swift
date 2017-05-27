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
    dynamic var reverse = false
    
    var convertType = [String]()
    
    @IBOutlet weak var typePopupButton: NSPopUpButton!
    @IBOutlet var preTextView: NSTextView!
    @IBOutlet var postTextView: NSTextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        typePopupButton.removeAllItems()
        typePopupButton.addItems(withTitles: ["url编码", "md5", "base64", "unicode", "string escape"])
    }
    
    @IBAction func btnConvertAction(_ sender: AnyObject) {
        if let text = preTextView.string, text.characters.count > 0 {
            let selectedIndex = typePopupButton.indexOfSelectedItem
            var postText: String?
            switch selectedIndex {
            case 0:
                if reverse {
                    postText = text.removingPercentEncoding
                } else {
                    if enableComposent {
                        postText = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                    } else {
                        postText = text.addingPercentEncodingForFormData()
                    }
                }
            case 1:
                postText = text.md5
            case 2:
                if reverse {
                    let data = Data(base64Encoded: text)
                    if data != nil {
                        postText = String(data: data!, encoding: .utf8)
                    } else {
                        postText = ""
                    }
                } else {
                    let data = text.data(using: .utf8)
                    postText = data!.base64EncodedString()
                }

            case 3:
                return
            case 4:
                postText = text.escaped()
            default:
                break
            }
//            let postText = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            postTextView.string = postText
        }

    }
    
    @IBAction func btnExchangeAction(_ sender: AnyObject) {
        (preTextView.string, postTextView.string) = (postTextView.string, preTextView.string)
    }
}

extension String {
    var md5 : String{
        let str = self.cString(using: .utf8)
        let strLen = CC_LONG(self.lengthOfBytes(using: .utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen);
        
        CC_MD5(str!, strLen, result);
        
        let hash = NSMutableString();
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i]);
        }
        result.deinitialize();
        
        return String(format: hash as String)
    }
    
    func addingPercentEncodingForRFC3986() -> String? {
        // ALPHA / DIGIT / “-” / “.” / “_” / “~”
        let unreserved = "-._~/?"
        let allowed = NSMutableCharacterSet.alphanumeric()
        allowed.addCharacters(in: unreserved)
        return addingPercentEncoding(withAllowedCharacters: allowed as CharacterSet)
    }
    
    public func addingPercentEncodingForFormData(plusForSpace: Bool=false) -> String? {
        // ALPHA / DIGIT / “*” / “-” / “.” / “_”
        let unreserved = "*-._"
        let allowed = NSMutableCharacterSet.alphanumeric()
        allowed.addCharacters(in: unreserved)
        
        if plusForSpace {
            allowed.addCharacters(in: " ")
        }
        
        var encoded = addingPercentEncoding(withAllowedCharacters: allowed as CharacterSet)
        if plusForSpace {
            encoded = encoded?.replacingOccurrences(of: " ", with: "+")
        }
        return encoded
    }
}
