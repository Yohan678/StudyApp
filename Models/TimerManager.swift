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
    
    init(startTime: Date? = nil, focusTime: Int, restTime: Int) {
        self.startTime = startTime
        self.focusTime = focusTime
        self.restTime = restTime
    }
}
