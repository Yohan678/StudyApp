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
                
                ZStack {
                    MyProgressBar()
                        .frame(width: 300, height: 300)
                    
                    if let entity = timers.first {
                        Text(entity.remainingTime > 0
                             ? entity.remainingTime.formatToMMSS()
                             : (entity.focusTime * 60).formatToMMSS()
                        )
                        .font(Font.custom("digital-7", size: 120))
                        .shadow(radius: 10)
                        
                    } else {
                        Text("No Timers Set")
                    }
                }
                
                Spacer()
                
                HStack {
                    //MARK: Set Timer View
                    Button {
                        isShowingSheet.toggle()
                        timers.first?.pause()
                        
                        try? context.save()
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
                    
                    //MARK: Start / Pause
                    Button {
                        if let entity = timers.first {
                            if entity.isRunning {
                                entity.pause()
                            } else {
                                if entity.remainingTime == entity.totalTimeInSec {
                                    entity.start()
                                } else {
                                    entity.resume()
                                }
                            }
                            try? context.save()
                        }
                    } label: {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.blue)
                            .frame(width: 150, height: 80)
                            .shadow(radius: 8)
                            .overlay {
                                Image(systemName: (timers.first?.isRunning ?? false) ? "pause.fill" : "play.fill")
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
            timers.first?.loadState()
        }
        .onReceive(timer) { _ in
            timers.first?.updateRemainingTime()
        }
    }
}

#Preview {
    MainView()
        .modelContainer(for: TimerManager.self, inMemory: true)
}
