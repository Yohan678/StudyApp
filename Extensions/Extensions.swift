//
//  Extensions.swift
//  StudyApp
//
//  Created by Yohan Yoon on 9/8/25.
//

import Foundation
import SwiftData

extension Int {
    func formatToMMSS() -> String {
        let minutes = self / 60
        let seconds = self % 60
        
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

extension ModelContext {
    @MainActor
    func addStudyTime(seconds: Int) {
        let today = Calendar.current.startOfDay(for: Date())
        
        if let todayLog = try? fetch(FetchDescriptor<CycleCountManager>()).first(where: {
            Calendar.current.isDate($0.date, inSameDayAs: today)
        }) {
            todayLog.items.append(CycleItem(timeStudied: seconds))
        } else {
            let newLog = CycleCountManager(date: today)
            insert(newLog)
            newLog.items.append(CycleItem(timeStudied: seconds))
        }
    }
}
