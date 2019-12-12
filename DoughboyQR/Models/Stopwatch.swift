//
//  Stopwatch.swift
//  DoughboyQR
//
//  Created by Steph Ananth on 12/11/19.
//  Copyright © 2019 AppCoda. All rights reserved.
//

import Foundation

class Stopwatch {
  
  var startTime: NSDate?
  var elapsedTime: Double?
  
  func start() {
    self.startTime = NSDate()
  }
  
  func stop() {
    self.elapsedTime = -startTime!.timeIntervalSinceNow 
    self.startTime = nil
  }
}
