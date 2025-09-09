//
//  MainView.swift
//  StudyApp
//
//  Created by Yohan Yoon on 8/29/25.
//

import SwiftUI
import SwiftData
import Combine

struct MainView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \TimerManager.startTime, order: .reverse) private var timers: [TimerManager]
    @State private var isShowingSheet: Bool = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State var remainingTime: Int = 0
    @State private var isRunning: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                if let _ = timers.first {
                    Text(remainingTime.formatToMMSS())
                        .font(Font.custom("digital-7", size: 120))
                        .shadow(radius: 10)
                } else {
                    Text("12:00")
                        .font(Font.custom("digital-7", size: 120))
                        .shadow(radius: 10)
                }
                
                Spacer()
                
                HStack {
                    //MARK: Set Timer View
                    Button {
                        isShowingSheet.toggle()
                    } label: {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.blue)
                            .frame(width: 150, height: 80)
                            .shadow(radius: 8)
                            .overlay {
                                Image(systemName: "timer")
                                    .foregroundColor(.white)
                                    .bold()
                                    .font(.title)
                            }
                        
                    }
                    .padding()
                    .sheet(isPresented: $isShowingSheet) {
                        SetTimerView()
                    }
                    
                    //MARK: Start or Stop Timer
                    Button {
                        if isRunning {
                                // Stop
                                isRunning = false
                                if let entity = timers.first {
                                    entity.startTime = nil
                                    try? context.save()
                                }
                            } else {
                                // Start
                                isRunning = true
                                if let entity = timers.first {
                                    entity.startTime = Date()
                                    try? context.save()
                                }
                            }
                    } label: {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.blue)
                            .frame(width: 150, height: 80)
                            .shadow(radius: 8)
                            .overlay {
                                Image(systemName: isRunning ? "stop.fill" : "play.fill")
                                    .foregroundColor(.white)
                                    .bold()
                                    .font(.title)
                            }
                    }
                    .padding()
                }
                
                Spacer()
            }
            .navigationTitle("POMODORO")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            loadTimer()
        }
        .onReceive(timer) { _ in
            updateRemainingTime()
        }
    }
    
    //updates remaining time by subtracting 1 by every second
    func updateRemainingTime() {
        guard isRunning, let entity = timers.first, let startTime = entity.startTime else { return }
        
        let elapsed = Int(Date().timeIntervalSince(startTime))
        
        let totalRemainingTime = entity.isFocusing ? entity.focusTime : entity.restTime
        
        let totalRemainingTimeInSec = totalRemainingTime * 60
        
        remainingTime = max(totalRemainingTimeInSec - elapsed, 0)
        
        if remainingTime == 0 {
            isRunning = false
            entity.startTime = nil
            try? context.save()
        }
    }
    
    //loads timer when active from background or inactive
    func loadTimer() {
        guard let entity = timers.first else { return }
        
        if let startTime = entity.startTime {
            let elapsed = Int(Date().timeIntervalSince(startTime))
            
            let totalRemainingTime = entity.isFocusing ? entity.focusTime : entity.restTime
            
            let totalRemainingTimeInSec = totalRemainingTime * 60
            
            remainingTime = max(totalRemainingTimeInSec - elapsed, 0)
            
            isRunning = remainingTime > 0
        }
    }
}

#Preview {
    MainView()
        .modelContainer(for: TimerManager.self, inMemory: true)
}
