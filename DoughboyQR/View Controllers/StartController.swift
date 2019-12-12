//
//  StartController.swift
//  DoughboyQR
//
//  Created by Steph Ananth on 12/11/19.
//  Copyright © 2019 AppCoda. All rights reserved.
//

import Foundation
import UIKit

class StartController: UIViewController {
  
  var viewModel = ViewModel()
  
  @IBAction func startButtonPressed(_ sender: UIButton) {
    self.viewModel.setupGame()
    self.viewModel.stopwatch.start()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let qrVC: QRScannerController = segue.destination as? QRScannerController {
      qrVC.viewModel = self.viewModel
    }
  }
}
