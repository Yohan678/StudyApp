//
//  MyProgressBar.swift
//  StudyApp
//
//  Created by Yohan Yoon on 9/10/25.
//

import SwiftUI
import SwiftData

struct MyProgressBar: View {
    
    @Query(sort: \TimerManager.startTime, order: .reverse) private var timers: [TimerManager]
    
    var body: some View {
        
        if let timer = timers.first {
            let color = timer.isRunning ? Color.customColor1 : Color.yellow
            ZStack {
                Circle()
                    .stroke(
                        color.opacity(0.4),
                        lineWidth: 30
                    )
                
                Circle()
                    .trim(from: 0, to: timer.timeProgress)
                    .stroke(
                        color,
                        style: StrokeStyle (
                            lineWidth: 30,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.easeOut, value: timer.timeProgress)
            }
        } else {
            Circle()
                .stroke(
                    Color.customColor1,
                    lineWidth: 30
                )
                .rotationEffect(.degrees(-90))
        }
    }
}

#Preview {
    MyProgressBar()
}
