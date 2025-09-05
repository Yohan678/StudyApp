//
//  Timer.swift
//  StudyApp
//
//  Created by Yohan Yoon on 9/5/25.
//

import Foundation
import SwiftData

@Model
final class Timer {
    var startTime: Date?
    var focusTime: Int
    var restTime: Int
    
    init(startTime: Date? = nil, focusTime: Int, restTime: Int) {
        self.startTime = startTime
        self.focusTime = focusTime
        self.restTime = restTime
    }
}
