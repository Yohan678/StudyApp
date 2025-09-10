//
//  TimerManager.swift
//  StudyApp
//
//  Created by Yohan Yoon on 9/8/25.
//

import Foundation
import SwiftData

@Model
final class TimerManager {
    var startTime: Date?
    var focusTime: Int
    var restTime: Int
    var isFocusing: Bool = true
    
    var elapsedTime: Int = 0
    var remainingTime: Int = 0
    var isRunning: Bool = false
    
    init(startTime: Date? = nil, focusTime: Int, restTime: Int) {
        self.startTime = startTime
        self.focusTime = focusTime
        self.restTime = restTime
    }
    
    //MARK: Turn minutes to seconds
    var totalTimeInSec: Int {
        (isFocusing ? focusTime : restTime ) * 60
    }
    
    //MARK: Remaining Time into 0~1 Double Variable for Progress View
    var timeProgress: Double {
        guard totalTimeInSec > 0 else { return 0 }
        let elapsed = totalTimeInSec - remainingTime
        return Double(elapsed) / Double(totalTimeInSec)
    }
    
    //MARK: Starts Timer
    func start() {
        startTime = Date()
        isRunning = true
        elapsedTime = 0
        remainingTime = totalTimeInSec
    }
    
    //MARK: Pause Timer
    func pause() {
        guard let start = startTime else { return }
        
        let additionalElapsed = Int(Date().timeIntervalSince(start))
        elapsedTime += additionalElapsed
        startTime = nil
        isRunning = false
    }
    
    //MARK: Resume Timer
    func resume() {
        startTime = Date()
        isRunning = true
    }
    
    //MARK: Updates remaining Time
    func updateRemainingTime() {
        guard isRunning, let start = startTime else { return }
        
        let elapsed = elapsedTime + Int(Date().timeIntervalSince(start))
        remainingTime = max(totalTimeInSec - elapsed, 0)
        if remainingTime == 0 {
            stop()
        }
    }
    
    //MARK: Stop and Reset
    func stop() {
        startTime = nil
        elapsedTime = 0
        remainingTime = totalTimeInSec
        isRunning = false
    }
    
    //MARK: Loads data when application is active from inactive / background
    func loadState() {
        if let start = startTime {
            let elapsed = elapsedTime + Int(Date().timeIntervalSince(start))
            remainingTime = max(totalTimeInSec - elapsed, 0)
            isRunning = remainingTime > 0
        } else {
            remainingTime = max(totalTimeInSec - elapsedTime, 0)
        }
    }
    
    
}
