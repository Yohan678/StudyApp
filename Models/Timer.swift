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
    var startDate: Date?
    var duration: Int
    
    init(startDate: Date? = nil, duration: Int) {
        self.startDate = startDate
        self.duration = duration
    }
}
