//
//  DoneViewController.swift
//  DoughboyQR
//
//  Created by Steph Ananth on 12/11/19.
//  Copyright © 2019 AppCoda. All rights reserved.
//

import Foundation
import UIKit

class DoneViewController: UIViewController {
  
  var viewModel: ViewModel? = nil
  
  @IBOutlet weak var trialsLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationItem.hidesBackButton = true
    self.updateLabels()
  }
  
  func updateLabels() {
    self.trialsLabel.text = "User completed \(self.viewModel!.numRounds) trials"
    self.timeLabel.text = "User took \(self.viewModel!.stopwatch.elapsedTime! / Double(self.viewModel!.numRounds))"
  }
}
