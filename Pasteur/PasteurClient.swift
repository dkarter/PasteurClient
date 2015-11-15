//
//  ClipboardSyncronizer.swift
//  Pasteur
//
//  Created by Dorian Karter on 2015-11-08.
//  Copyright © 2015 Great Apes. All rights reserved.
//

import Foundation
import Socket_IO_Client_Swift

class PasteurClient {
  var serverUrl:NSURL
  let pasteboard = NSPasteboard.generalPasteboard()
  var socket:SocketIOClient
  var isConnected:Bool = false
  
  init(serverUrl: NSURL) {
    self.serverUrl = serverUrl
    socket = SocketIOClient(socketURL: serverUrl.absoluteString, options: [SocketIOClientOption.ForceWebsockets(true)])
    addEventHandlers()
  }
  
  func addEventHandlers() {
    let connected: NormalCallback = { data, ack in
      self.isConnected = true
      NSNotificationCenter.defaultCenter().postNotificationName("ConnectionStateChanged", object: self)
    }
    
    let disconnected: NormalCallback = { data, ack in
      self.isConnected = false
      NSNotificationCenter.defaultCenter().postNotificationName("ConnectionStateChanged", object: self)
    }
    
    let clipboardReceived: NormalCallback = { data, ack in
      if let text = data[0] as? String {
        Clipboard.setClipboardString(text)
      }
    }
    
    socket.on("connect", callback: connected)
    socket.on("disconnect", callback: disconnected)
    socket.on("clipboardPublished", callback: clipboardReceived)
    self.socket.onAny {print("Got event: \($0.event), with items: \($0.items)")}
  }
  
  func connect() {
    socket.connect()
  }
  
  func disconnect() {
    socket.disconnect()
  }
  
  func setConnectedStatus(status: Bool) {
    self.isConnected = status
  }
  
  func publishLocalClipboard() {
    socket.emit("clipboardPublished", Clipboard.getClipboardString()!)
  }
}
