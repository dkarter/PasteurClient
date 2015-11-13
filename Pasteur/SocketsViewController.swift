//
//  SocketsViewController.swift
//  Pasteur
//
//  Created by Dorian Karter on 2015-11-08.
//  Copyright © 2015 Great Apes. All rights reserved.
//

//import Foundation
import Starscream
import Cocoa

class SocketsViewController: NSViewController {
  let socket:WebSocket = WebSocket(url: NSURL(string: "ws://localhost:8181")!)
  
  @IBOutlet weak var messagesLogTextField: NSTextField!
  @IBOutlet weak var statusLabel: NSTextField!
  @IBOutlet weak var messageTextField: NSTextField!
  @IBAction func connectButtonClicked(sender: NSButton) {
    socket.connect()
    socket.isConnected
  }
  @IBAction func sendButtonClicked(sender: NSButton) {
    socket.writeString(messageTextField.stringValue)
  }
  
  override func viewDidLoad() {
    socket.delegate = self
  }
}

extension SocketsViewController: WebSocketDelegate {
  func websocketDidConnect(socket: WebSocket) {
    if socket.isConnected {
      self.statusLabel.stringValue = "Connected"
    }
  }
  
  func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
    self.statusLabel.stringValue = "Disconnected \(error)"
  }
  
  func websocketDidReceiveData(socket: WebSocket, data: NSData) {
    NSLog("Got some data")
  }
  
  func websocketDidReceiveMessage(socket: WebSocket, text: String) {
    messagesLogTextField.stringValue += "Message: \(text)\n"
  }
}


