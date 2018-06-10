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
    private var timer : Timer?
    private var seconds : Int
    private var minutes : Int
    
    init() {
        timer = Timer()
        seconds = 0
        minutes = 0
    }
    
    func getSeconds() -> Int {
        return seconds
    }
    
    func getMinutes() -> Int {
        return minutes
    }
    
    func startTimer(_ lblTimer : UILabel) {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {[weak self] (_ timer: Timer) -> Void in self?.updateTimer(lblTimer)})
    }
    
    func pauseTimer() {
        timer?.invalidate()
    }
    
    func stopTimer () {
        timer?.invalidate()
        seconds = 0
        minutes = 0
    }
    
    func resumeTimer(_ lblTimer : UILabel) {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {[weak self] (_ timer: Timer) -> Void in self?.updateTimer(lblTimer)})
    }
    
    @objc func updateTimer(_ lblTimer : UILabel) {
        if (seconds < 59) {
            seconds += 1
        } else {
            minutes += 1
            seconds = 0
        }
        
        lblTimer.text = MyTimer.formatTimer(minutes : self.minutes, seconds : self.seconds)
    }
    
    static func formatTimer(minutes : Int, seconds : Int) -> String{
        if (minutes < 10 && seconds < 10) {
         return "0" + String(minutes) + ":" + "0" + String(seconds)
        } else if (minutes < 10 && seconds >= 10) {
            return "0" + String(minutes) + ":" + String(seconds)
        } else if (minutes >= 10 && seconds < 10) {
            return String(minutes) + ":" + "0" + String(seconds)
        } else if (minutes >= 10 && seconds >= 10) {
            return String(minutes) + ":" + String(seconds)
        }
        
        return ""
    }
}
