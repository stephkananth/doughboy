//
//  ViewModel.swift
//  DoughboyQR
//
//  Created by Steph Ananth on 12/11/19.
//  Copyright © 2019 AppCoda. All rights reserved.
//

import Foundation

class ViewModel {
  
  // MARK: Round Logic
  let numRounds: Int = 10
  var rounds: [[Int]] = []
  var currentRound: Int = 0
  var isUserDone: Bool = false
  
  func setupRounds() {
    for _ in 0..<self.numRounds {
      let target = Int.random(in: 0..<1000) % 4
      let action = Int.random(in: 0..<1000) % 2
      self.rounds.append([target, action])
    }
    self.rounds.shuffle()
  }
  
  func incrementRound() {
    self.currentRound += 1
  }
  
  func decrementRound() {
    if self.currentRound > 0 {
      self.currentRound -= 1
    }
  }
  
  // MARK: Time Logic
  let stopwatch = Stopwatch()
  
  // MARK: Start Game Logic
  func setupGame() {
    self.setupRounds()
    self.currentRound = 0
    self.isUserDone = false
  }
}
