//
//  ClipboardSyncronizerTests.swift
//  Pasteur
//
//  Created by Dorian Karter on 2015-11-08.
//  Copyright © 2015 Great Apes. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import Pasteur

class ClipboardSpec: QuickSpec {
  override func spec() {
    describe("Set local clipboard") {
      it("sets and gets the system clipboard") {
        Clipboard.setClipboardString("test")
        expect(Clipboard.getClipboardString()).to(equal("test"))
      }
    }
  }
}