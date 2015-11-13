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

class ClipboardSyncronizerSpec: QuickSpec {
  override func spec() {
    describe("Connect to server") {
      it("connects to the websocket server") {
        let target = ClipboardSyncronizer.init(serverUrl: NSURL(string: "ws://localhost:8181")!)
        target.connect()
        sleep(1)
        expect(target.isConnected()).to(beTruthy())
      }
    }
    
    describe("Set local clipboard") {
      it("sets the system clipboard to a test string") {
        let target = ClipboardSyncronizer.init(serverUrl: NSURL(string: "")!)
        target.setLocalClipboard("test")
        expect(target.currentClipboardText()).to(equal("test"))
      }
    }
  }
}