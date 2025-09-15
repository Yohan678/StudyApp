//
//  HistoryGridView.swift
//  StudyApp
//
//  Created by Yohan Yoon on 9/13/25.
//

import SwiftUI
import SwiftData

struct HistoryGridView: View {
    @Environment(\.modelContext) private var context
    
    @Query(sort: \CycleCountManager.date, order: .reverse) private var cycleLogs: [CycleCountManager]
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    static let colors: [Color] = [.red, .blue, .green, .orange, .purple]
    @State private var selectedColor = colors.randomElement() ?? .gray
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.customColor4.ignoresSafeArea()
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(cycleLogs) { log in
                            HistoryBoxView(completionDate: log.date, totalStudiedTimes: log.totalStudyTime, randomColor: selectedColor)
                                .padding()
                        }
                    }
                }
                .navigationTitle("Study Log")
                .toolbar {
                    Button("Add 1 min Cycle") {
                        context.addStudyTime(seconds: 1)
                    }
 
                }
            }
        }
    }
    
    //MARK: Testing Only
//    private func deleteTodayLog() {
//        let today = Calendar.current.startOfDay(for: Date())
//        
//        if let todayLog = cycleLogs.first(where: {
//            Calendar.current.isDate($0.date, inSameDayAs: today)
//        }) {
//            context.delete(todayLog)
//        }
//    }
}

#Preview {
    HistoryGridView()
}
