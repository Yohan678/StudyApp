//
//  PomodoroSetting.swift
//  StudyApp
//
//  Created by Yohan Yoon on 9/5/25.
//

import Foundation

struct PomodoroSetting: Identifiable {
    let id = UUID()
    let title: String
    let focusTime: Int
    let restTime: Int
}
