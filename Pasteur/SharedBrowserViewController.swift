//
//  SharedBrowserViewController.swift
//  Pasteur
//
//  Created by Dorian Karter on 2015-11-06.
//  Copyright © 2015 Great Apes. All rights reserved.
//

import Cocoa

class SharedBrowserViewController: NSViewController {
  let sharedBrowser = SharedBrowser()
  
  @IBOutlet weak var smbCheckbox: NSButton!
  @IBOutlet weak var afpCheckbox: NSButton!
  @IBOutlet weak var sharedPointsTable: NSTableView!
  
  @IBAction func searchButton(sender: NSButton) {
    let proto = searchProtocol()
    
    if proto != nil {
      sharedBrowser.reset()
      sharedPointsTable.reloadData()
      sharedBrowser.searchForServicesOfType(proto!)
      sharedPointsTable.reloadData()
    } else {
      showSelectProtocolAlert()
    }
  }
  
  func searchProtocol() -> ServiceType? {
    var searchProtocol:ServiceType?
    if smbCheckbox.state == NSOnState {
      searchProtocol = .Smb
    }
    if afpCheckbox.state == NSOnState {
      searchProtocol = .Afp
    }
    if smbCheckbox.state == NSOnState && afpCheckbox.state == NSOnState {
      searchProtocol = .SmbAndAfp
    }
    return searchProtocol
  }
  
  func showSelectProtocolAlert() {
    let alert = NSAlert()
    alert.messageText = "You must choose a protocol!"
    alert.alertStyle = .WarningAlertStyle
    alert.runModal()
  }
  
  func reloadSharedPointsTable() {
    NSLog("Yeeehhaaa")
    sharedPointsTable.reloadData()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    sharedPointsTable.target = self
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadSharedPointsTable", name: "NewSharedDetected", object: sharedBrowser)
    
  }
  
  override var representedObject: AnyObject? {
    didSet {
      // Update the view, if already loaded.
    }
  }
}

extension SharedBrowserViewController:NSTableViewDataSource {
  func numberOfRowsInTableView(tableView: NSTableView) -> Int {
    return sharedBrowser.sharedPointList.count
  }
  
  func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
    if !rowIsValid(row) {
      return ""
    }
    
    let columnId = tableColumn?.identifier
    let sharedPoint = sharedBrowser.sharedPointList[row]
    switch columnId! {
    case "name":
      return sharedPoint.netService.name
    case "domain":
      return sharedPoint.netService.domain
    case "type":
      return sharedPoint.type
    case "ip":
      return sharedPoint.ipAddress
    default:
      return ""
    }
  }
  
  private func rowIsValid(row: Int) -> Bool {
    return row >= 0 && row < sharedBrowser.sharedPointList.count
  }
}

extension SharedBrowserViewController:NSTableViewDelegate {
  
}

