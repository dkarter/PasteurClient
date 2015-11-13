//
//  ClipboardSyncronizer.swift
//  Pasteur
//
//  Created by Dorian Karter on 2015-11-08.
//  Copyright © 2015 Great Apes. All rights reserved.
//

import Foundation
import Starscream

class PasteurClient {
  var serverUrl:NSURL
  var ws:WebSocket
  let pasteboard = NSPasteboard.generalPasteboard()
  
  init(serverUrl: NSURL) {
    self.serverUrl = serverUrl
    ws = WebSocket(url: serverUrl)
    ws.delegate = self
  }
  
  func connect() {
    ws.connect()
  }
  
  func disconnect() {
    ws.disconnect()
  }
  
  func isConnected() -> Bool {
    return ws.isConnected
  }
  
  
  func publishLocalClipboard() {
    if isConnected() {
      ws.writeString(Clipboard.getClipboardString()!)
    }
  }
}

extension PasteurClient: WebSocketDelegate {
  func websocketDidConnect(socket: WebSocket) {
    NSNotificationCenter.defaultCenter().postNotificationName("ConnectionStateChanged", object: self)
  }
  
  func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
    NSNotificationCenter.defaultCenter().postNotificationName("ConnectionStateChanged", object: self)
  }
  
  // message handling
  func websocketDidReceiveMessage(socket: WebSocket, text: String) {
    NSLog("Received message \(text)")
    // parse message json and use inner data to direct next actions
    Clipboard.setClipboardString(text)
  }
  
  func websocketDidReceiveData(socket: WebSocket, data: NSData) {
    NSLog("Received message \(data)")
  }
}

