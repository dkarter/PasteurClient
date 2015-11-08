//
//  SharedBrowser.swift
//  Pasteur
//
//  Created by Dorian Karter on 2015-11-06.
//  Copyright © 2015 Great Apes. All rights reserved.
//

import Foundation

public enum ServiceType {
  case Smb
  case Afp
  case SmbAndAfp
}

class SharedBrowser:NSObject, NSNetServiceBrowserDelegate, NSNetServiceDelegate {
  let afpType:String
  let smbType:String
  var afpBrowser:NSNetServiceBrowser
  var smbBrowser:NSNetServiceBrowser
  var serviceList:[NSNetService]
  var sharedPointList:[SharedPoint]
  
  override init () {
    self.afpType         = "_afpovertcp._tcp."
    self.smbType         = "_smb._tcp."
    self.smbBrowser      = NSNetServiceBrowser()
    self.afpBrowser      = NSNetServiceBrowser()
    self.serviceList     = [NSNetService]()
    self.sharedPointList = [SharedPoint]()
    
    super.init()
    self.afpBrowser.delegate = self
    self.smbBrowser.delegate = self
  }
  
  func update() {
    for service in serviceList {
      service.delegate = self
      service.resolveWithTimeout(5)
    }
  }
  
  func reset() {
    smbBrowser.stop()
    afpBrowser.stop()
    for service in serviceList {
      service.stop()
    }
    serviceList = [NSNetService]()
    sharedPointList = [SharedPoint]()
  }
  
  func searchForServicesOfType(type:ServiceType) {
    switch type {
    case .Afp:
      afpBrowser.searchForServicesOfType(afpType, inDomain: "")
    case .Smb:
      smbBrowser.searchForServicesOfType(smbType, inDomain: "")
    case .SmbAndAfp:
      smbBrowser.searchForServicesOfType(smbType, inDomain: "")
      afpBrowser.searchForServicesOfType(afpType, inDomain: "")
    }
  }
  
  // MARK NSNetServiceBrowserDelegate methods
  
  func netServiceBrowser(browser: NSNetServiceBrowser, didFindService service: NSNetService, moreComing: Bool) {
    serviceList.append(service)
    NSLog("Found: \(service)")
    if !moreComing {
      update()
    }
  }
  
  func netServiceBrowser(browser: NSNetServiceBrowser, didRemoveService service: NSNetService, moreComing: Bool) {
    // remove from service list
    serviceList = serviceList.filter({$0 != service})
    
    // remove from shared point list
    sharedPointList = sharedPointList.filter({$0.netService != service})

    NSLog("Became unavailable: \(service)")
    if !moreComing {
      update()
    }
  }
  
  
  func netServiceBrowser(browser: NSNetServiceBrowser, didNotSearch errorDict: [String : NSNumber]) {
    NSLog("Search was not successful. Error code: \(errorDict[NSNetServicesErrorCode])")
  }
  
  
  // MARK NSNetServiceDelegate methods
  
  func netServiceDidResolveAddress(sender: NSNetService) {
    //service.addresses - array containing NSData objects, each of which contains an appropriate
    //sockaddr structure that you can use to connect to the socket
    for addressBytes in sender.addresses!
    {
      var inetAddress : sockaddr_in!
      var inetAddress6 : sockaddr_in6?
      //NSData’s bytes returns a read-only pointer (const void *) to the receiver’s contents.
      //var bytes: UnsafePointer<()> { get }
      let inetAddressPointer = UnsafePointer<sockaddr_in>(addressBytes.bytes)
      //Access the underlying raw memory
      inetAddress = inetAddressPointer.memory
      
      if inetAddress.sin_family == __uint8_t(AF_INET) //Note: explicit convertion (var AF_INET: Int32 { get } /* internetwork: UDP, TCP, etc. */)
      {
      }
      else
      {
        if inetAddress.sin_family == __uint8_t(AF_INET6) //var AF_INET6: Int32 { get } /* IPv6 */
        {
          let inetAddressPointer6 = UnsafePointer<sockaddr_in6>(addressBytes.bytes)
          inetAddress6 = inetAddressPointer6.memory
          inetAddress = nil
        }
        else
        {
          inetAddress = nil
        }
      }
      var ipString : UnsafePointer<Int8>?
      //static func alloc(num: Int) -> UnsafeMutablePointer<T>
      let ipStringBuffer = UnsafeMutablePointer<Int8>.alloc(Int(INET6_ADDRSTRLEN))
      if (inetAddress != nil)
      {
        var addr = inetAddress.sin_addr
        ///func inet_ntop(_: Int32, _: UnsafePointer<()>, _: UnsafeMutablePointer<Int8>, _: socklen_t) -> UnsafePointer<Int8>
        ipString = inet_ntop(Int32(inetAddress.sin_family),
          &addr,
          ipStringBuffer,
          __uint32_t(INET6_ADDRSTRLEN))
      }
      else
      {
        if (inetAddress6 != nil)
        {
          var addr  = inetAddress6!.sin6_addr
          
          ipString = inet_ntop(Int32(inetAddress6!.sin6_family),
            &addr,
            ipStringBuffer,
            __uint32_t(INET6_ADDRSTRLEN))
        }
      }
      if (ipString != nil)
      {
        // Returns `nil` if the `CString` is `NULL` or if it contains ill-formed
        // UTF-8 code unit sequences.
        //static func fromCString(cs: UnsafePointer<CChar>) -> String?
        let ip = String.fromCString(ipString!)
        if ip != nil {
          NSLog("\(sender.name)(\(sender.type)) - \(ip!)")
          var ext : String
          switch sender.type {
          case afpType :
            ext = "afp"
          case smbType :
            ext = "smb"
          default:
            ext = sender.type
          }
          sharedPointList.append(SharedPoint(netService: sender, type: ext, ipAddress: ip!))
          NSNotificationCenter.defaultCenter().postNotificationName("NewSharedDetected", object: self)
        }
      }
      /// This type stores a pointer to an object of type T. It provides no
      /// automated memory management, and therefore the user must take care
      /// to allocate and free memory appropriately.
      ipStringBuffer.dealloc(Int(INET6_ADDRSTRLEN))
    }
  }
  
  
  
}