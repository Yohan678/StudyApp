//
//  TimerManager.swift
//  StudyApp
//
//  Created by Yohan Yoon on 9/8/25.
//

import Foundation
import SwiftData
import UserNotifications

@Model
final class TimerManager {
    var startTime: Date?
    var focusTime: Int
    var restTime: Int
    var isFocusing: Bool = true
    
    var elapsedTime: Int = 0
    var remainingTime: Int = 0
    var isRunning: Bool = false
    
    //targetDate for notification scheduling
    var targetDate: Date? = nil
    
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
        
        let title = isFocusing ? "Time to take a break" : "Time to focus"
        let body = isFocusing ? "Good Job 👍" : "Let's go 💪"
        targetDate = Date().addingTimeInterval(TimeInterval(remainingTime))
        
        scheduleNotification(title: title, body: body, for: targetDate!)
    }
    
    //MARK: Pause Timer
    func pause() {
        guard let start = startTime else { return }
        
        cancelNotification()
        
        let additionalElapsed = Int(Date().timeIntervalSince(start))
        elapsedTime += additionalElapsed
        
        startTime = nil
        isRunning = false
    }
    
    //MARK: Resume Timer
    func resume() {
        startTime = Date()
        
        let title = isFocusing ? "Time to take a break" : "Time to focus"
        let body = isFocusing ? "Good Job 👍" : "Let's go 💪"
        targetDate = Date().addingTimeInterval(TimeInterval(remainingTime))
        
        scheduleNotification(title: title, body: body, for: targetDate!)
        
        isRunning = true
    }
    
    //MARK: Updates remaining Time
    @MainActor
    func updateRemainingTime(context: ModelContext) {
        guard isRunning, let start = startTime else { return }
        
        let elapsed = elapsedTime + Int(Date().timeIntervalSince(start))
        remainingTime = max(totalTimeInSec - elapsed, 0)
        if remainingTime == 0 {
            if isFocusing {
                context.addStudyTime(seconds: focusTime)
            }
            stop()
        }
    }
    
    //MARK: Stop, Reset, Change Boolean isFocusing
    func stop() {
        isFocusing.toggle()
        startTime = nil
        elapsedTime = 0
        remainingTime = totalTimeInSec
        isRunning = false
        
        cancelNotification()
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
    
    private var notificationIdentifier = "pausable_timer_notification"
    
    //MARK: Schedule Notification
    func scheduleNotification(title: String, body: String, for date: Date) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(identifier: notificationIdentifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to request notification: \(error.localizedDescription)")
            } else {
                print("Notification requested succesfully.")
            }
        }
    }
    
    private func cancelNotification() {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationIdentifier])
            print("Scheduled notification is cancelled.")
        }
    
    
}
