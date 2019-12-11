//
//  CoreMotionController.swift
//  QRCodeReader
//
//  Created by Steph Ananth on 12/10/19.
//  Copyright © 2019 AppCoda. All rights reserved.
//

import Foundation
import UIKit
import CoreMotion

class CoreMotionController: UIViewController {
  
  let motionManager = CMMotionManager()
  var timer: Timer!
  
  let threshold: Double = 0.5
  let target = Int.random(in: 1..<3)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationItem.hidesBackButton = true
    
    switch self.target {
    case 1:
      self.title = "<-- Left"
    case 2:
      self.title = "Right -->"
    default:
      self.title = "ERROR"
    }
    
    motionManager.startAccelerometerUpdates()
    timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(CoreMotionController.update), userInfo: nil, repeats: true)
  }
  
  @objc func update() {
    if let accelerometerData = motionManager.accelerometerData {
      switch self.target {
      case 1:
        if accelerometerData.acceleration.x <= -self.threshold, let _: CoreMotionController = self.navigationController?.viewControllers.last as? CoreMotionController {
          performSegue(withIdentifier: "tiltConfirmed", sender: self)
        }
      case 2:
        if accelerometerData.acceleration.x >= self.threshold, let _: CoreMotionController = self.navigationController?.viewControllers.last as? CoreMotionController{
          performSegue(withIdentifier: "tiltConfirmed", sender: self)
        }
      default:
        print("ERROR")
      }
    }
  }
  
}
