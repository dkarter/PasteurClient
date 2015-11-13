//
//  Clipboard.swift
//  Pasteur
//
//  Created by Dorian Karter on 2015-11-08.
//  Copyright © 2015 Great Apes. All rights reserved.
//

import Foundation
import AppKit

class Clipboard {
  class func getClipboardString() -> String? {
    let clipboard = NSPasteboard.generalPasteboard()
    return clipboard.stringForType(NSPasteboardTypeString)
  }
  
  class func setClipboardString(text: String) {
    let clipboard = NSPasteboard.generalPasteboard()
    clipboard.clearContents()
    clipboard.setString(text, forType: NSPasteboardTypeString)
  }
}
