//
//  Timer.swift
//  MemoryGame
//
//  Created by Zohar Bergman on 07/04/2018.
//  Copyright © 2018 Zohar Bergman. All rights reserved.
//

import Foundation
import UIKit

class MyTimer {
    private var timer : Timer
    private var seconds : Int
    private var minutes : Int
    
    init() {
        timer = Timer()
        seconds = 0
        minutes = 0
    }
    
    func StartTimer(_ lblTimer : UILabel) {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {[weak self] (_ timer: Timer) -> Void in self?.UpdateTimer(lblTimer)})
    }
    
    func PauseTimer() {
        timer.invalidate()
    }
    
    func StopTimer () {
        timer.invalidate()
        seconds = 0
        minutes = 0
    }
    
    func ResumeTimer(_ lblTimer : UILabel) {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {[weak self] (_ timer: Timer) -> Void in self?.UpdateTimer(lblTimer)})
    }
    
    @objc func UpdateTimer(_ lblTimer : UILabel) {
        if (seconds < 59) {
            seconds += 1
        } else {
            minutes += 1
            seconds = 0
        }
        
        if (minutes < 10 && seconds < 10) {
            lblTimer.text = "0" + String(minutes) + ":" + "0" + String(seconds)
        } else if (minutes < 10 && seconds >= 10) {
            lblTimer.text = "0" + String(minutes) + ":" + String(seconds)
        } else if (minutes >= 10 && seconds < 10) {
            lblTimer.text = String(minutes) + ":" + "0" + String(seconds)
        } else if (minutes >= 10 && seconds >= 10) {
            lblTimer.text = String(minutes) + ":" + String(seconds)
        }
    }
}
