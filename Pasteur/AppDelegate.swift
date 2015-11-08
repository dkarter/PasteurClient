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
  let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-2)

  
  func applicationDidFinishLaunching(aNotification: NSNotification) {
    statusItem.highlightMode = true
    if let button = statusItem.button {
      button.image = buildIcon()
      statusItem.menu = buildMenu()
    }
  }
  
  func buildIcon() -> NSImage {
    let icon = NSImage(named: "AppIcon")
    icon!.size = NSSize(width: 22, height: 22)
    return icon!
  }
  
  func buildMenu() -> NSMenu {
    let menu = NSMenu()
    menu.addItemWithTitle("Neptune.chi Clipboard", action: Selector("showNotification:"), keyEquivalent: "")
    menu.addItemWithTitle("Chris Erin's Clipboard", action: Selector("logMessage:"), keyEquivalent: "")
    menu.addItem(NSMenuItem.separatorItem())
    menu.addItemWithTitle("Publish My Clipboard", action: Selector("logMessage:"), keyEquivalent: "P")
    menu.addItem(NSMenuItem.separatorItem())
    menu.addItemWithTitle("Quit", action: Selector("terminate:"), keyEquivalent: "q")
    return menu
  }
    
  func logMessage(sender: AnyObject) {
    print(NSPasteboard.generalPasteboard().pasteboardItems![0].stringForType("public.utf8-plain-text"))
  }
  
  func showNotification(sender: AnyObject) {
    let notification = NSUserNotification()
    notification.title = "Test from Swift"
    notification.informativeText = "The body of this Swift notification"
    notification.actionButtonTitle = "Copy"
    notification.otherButtonTitle = "Paste"
    notification.setValue(true, forKey: "_showsButtons")
    notification.soundName = NSUserNotificationDefaultSoundName
    NSUserNotificationCenter.defaultUserNotificationCenter().deliverNotification(notification)
  }
}

