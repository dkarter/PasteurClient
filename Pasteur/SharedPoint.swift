//
//  SharedPoint.swift
//  Pasteur
//
//  Created by Dorian Karter on 2015-11-06.
//  Copyright © 2015 Great Apes. All rights reserved.
//

import Foundation

class SharedPoint {
  var netService:NSNetService
  var type:String = ""
  var ipAddress:String = ""
  
  init(netService:NSNetService, type:String, ipAddress:String) {
    self.netService = netService
    self.type = type
    self.ipAddress = ipAddress
  }
  
  
}

// MARK: Equatable

extension SharedPoint:Equatable {}

func ==(lhs: SharedPoint, rhs: SharedPoint) -> Bool {
  return (lhs.netService == rhs.netService &&
          lhs.type       == rhs.type &&
          lhs.ipAddress  == rhs.ipAddress)
}