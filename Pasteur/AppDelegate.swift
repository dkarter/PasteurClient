//
//  AppDelegate.swift
//  Pasteur
//
//  Created by Dorian Karter on 2015-11-06.
//  Copyright © 2015 Great Apes. All rights reserved.
//

import Cocoa


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  private let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-2)
  private let client:PasteurClient = PasteurClient(serverUrl: NSURL(string: "ws://localhost:8181")!)
  private let notificationCenter = NSNotificationCenter.defaultCenter()
  private var disconnectMenuItem:NSMenuItem = NSMenuItem()
  
  func applicationDidFinishLaunching(aNotification: NSNotification) {
    if let button = statusItem.button {
      button.image = buildIcon()
      setMenubarButtonState(button, highlighted: false)
      statusItem.menu = buildMenu()
    }
    
    notificationCenter.addObserver(self, selector: "handleConnectionStateChange", name: "ConnectionStateChanged", object: client)
    
    client.connect()
  }
 
  func handleConnectionStateChange() {
    setMenubarButtonState(statusItem.button!, highlighted: client.isConnected())
    let connectionStateText = client.isConnected() ? "connected to" : "disconnected from"
    showNotification("Pasteur Server Connection", body: "Pasteur is now \(connectionStateText) the server")
  }
  
  private func disconnect(sender: AnyObject) {
    client.disconnect()
  }
  
  private func buildIcon() -> NSImage {
    let icon = NSImage(named: "AppIcon")
    icon!.size = NSSize(width: 22, height: 22)
    return icon!
  }
  
  private func buildMenu() -> NSMenu {
    let menu = NSMenu()
    menu.addItemWithTitle("Publish My Clipboard", action: Selector("publishClipboard:"), keyEquivalent: "P")
    menu.addItem(NSMenuItem.separatorItem())
    disconnectMenuItem = menu.addItemWithTitle("Disconnect", action: Selector("disconnect:"), keyEquivalent: "D")!
    menu.addItemWithTitle("Quit", action: Selector("terminate:"), keyEquivalent: "q")
    return menu
  }
    
  private func publishClipboard(sender: AnyObject) {
    client.publishLocalClipboard()
  }
  
  private func showNotification(title: String, body: String) {
    let notification = NSUserNotification()
    notification.title = title
    notification.informativeText = body
    notification.soundName = NSUserNotificationDefaultSoundName
    NSUserNotificationCenter.defaultUserNotificationCenter().deliverNotification(notification)
  }
  
  private func setMenubarButtonState(button: NSStatusBarButton, highlighted: Bool) {
    if highlighted {
      button.alphaValue = 1
    } else {
      button.alphaValue = 0.3
    }
  }
}

