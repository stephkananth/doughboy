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
import AudioToolbox

class CoreMotionController: UIViewController {
  
  var viewModel: ViewModel? = nil
  var previousStepCorrect: Bool = true
  var target: Int = 0
  let threshold: Double = 0.5
  
  override var prefersStatusBarHidden: Bool {
      return true
  }
  
  func updateTarget() {
    if !self.viewModel!.isUserDone {
      self.target = self.viewModel!.rounds[self.viewModel!.currentRound][1]
      switch self.target {
      case 0:
        self.title = "<-- Left"
      case 1:
        self.title = "Right -->"
      default:
        self.title = "ERROR"
      }
      let attributes = [NSAttributedString.Key.font: UIFont(name: "Avenir-Black", size: 48)!]
      self.navigationController?.navigationBar.titleTextAttributes = attributes
    }
  }
  
  // MARK: Core Motion
  let motionManager = CMMotionManager()
  var timer: Timer!
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let doneVC: DoneViewController = segue.destination as? DoneViewController {
      doneVC.viewModel = self.viewModel
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationItem.hidesBackButton = true
    self.updateTarget()
    motionManager.startAccelerometerUpdates()
    timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(CoreMotionController.update), userInfo: nil, repeats: true)
  }
  
  @objc func update() {
    if !self.viewModel!.isUserDone {
      if let accelerometerData = motionManager.accelerometerData {
        if let _: CoreMotionController = self.navigationController?.viewControllers.last as? CoreMotionController {
          switch self.previousStepCorrect {
          case true:
            switch self.viewModel?.rounds[self.viewModel!.currentRound][1] {
            case 0:
              if accelerometerData.acceleration.x <= -self.threshold {
                // Vibration
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                self.viewModel?.incrementRound()
                if self.viewModel?.currentRound == self.viewModel!.numRounds {
                  self.viewModel?.stopwatch.stop()
                  self.viewModel?.isUserDone = true
                  performSegue(withIdentifier: "doneSegue", sender: self)
                  return
                } else {
                  self.navigationController?.popViewController(animated: false)
                }
              } else if accelerometerData.acceleration.x >= self.threshold * 1.5 {
                // Vibration
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                self.viewModel!.decrementRound()
                self.navigationController?.popViewController(animated: false)
              }
            case 1:
              if accelerometerData.acceleration.x >= self.threshold {
                // Vibration
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                self.viewModel!.incrementRound()
                if self.viewModel?.currentRound == self.viewModel!.numRounds {
                  self.viewModel?.stopwatch.stop()
                  self.viewModel?.isUserDone = true
                  performSegue(withIdentifier: "doneSegue", sender: self)
                  return
                } else {
                  self.navigationController?.popViewController(animated: false)
                }
              } else if accelerometerData.acceleration.x <= -self.threshold * 1.5 {
                // Vibration
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                self.viewModel!.decrementRound()
                self.navigationController?.popViewController(animated: false)
              }
            default:
              print("ERROR")
            }
          case false:
            if  accelerometerData.acceleration.x >= self.threshold || accelerometerData.acceleration.x <= -self.threshold {
              AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
              self.viewModel!.decrementRound()
              self.navigationController?.popViewController(animated: false)
            }
          }
        }
      }
    }
  }
}
