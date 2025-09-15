//
//  CycleCountManager.swift
//  StudyApp
//
//  Created by Yohan Yoon on 9/15/25.
//

import Foundation
import SwiftData

@Model
final class CycleCountManager {
    @Attribute(.unique) var date: Date
    
    @Relationship(deleteRule: .cascade) var items: [CycleItem] = [ ]
    
    var totalStudyTime: Int {
        items.reduce(0) { $0 + $1.timeStudied }
    }
    
    init(date: Date) {
        self.date = date
    }
}

@Model
final class CycleItem {
    var timeStudied: Int
    var creationDate: Date
    
    init(timeStudied: Int) {
        self.timeStudied = timeStudied
        self.creationDate = Date()
    }
}
