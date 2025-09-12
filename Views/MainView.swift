//
//  MainView.swift
//  StudyApp
//
//  Created by Yohan Yoon on 8/29/25.
//

import SwiftUI
import SwiftData
import Combine
import UserNotifications

struct MainView: View {
    
    @Environment(\.modelContext) private var context
    @Query(sort: \TimerManager.startTime, order: .reverse) private var timers: [TimerManager]
    @State private var isShowingSheet: Bool = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State var remainingTime: Int = 0
    @State private var isRunning: Bool = false
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                Color.customColor4
                    .ignoresSafeArea()
                
                VStack {
                    
                    Spacer()
                    
                    if let entity = timers.first {
                        Text(entity.isFocusing ? "Let's Focus 🔥" : "Taking a break 😴")
                            .padding()
                            .foregroundColor(.customColor1)
                            .font(.system(size: 21))
                    }
                    
                    ZStack {
                        Circle()
                            .fill((timers.first?.isRunning ?? false) ? .customColor1.opacity(0.4) : .yellow.opacity(0.4))
                            .frame(width: 290, height: 290)
                        
                        MyProgressBar()
                            .frame(width: 350, height: 320)
                        
                        if let entity = timers.first {
                            Text(entity.remainingTime > 0
                                 ? entity.remainingTime.formatToMMSS()
                                 : (entity.focusTime * 60).formatToMMSS()
                            )
                            .font(Font.custom("digital-7", size: 110))
                            .foregroundColor(.customColor1)
                            .shadow(radius: 10)
                            
                        } else {
                            Text("No Timers Set")
                        }
                    }
                    .padding()
                    
                    Spacer()
                    
                    HStack {
                        //MARK: Set Timer View
                        Button {
                            isShowingSheet.toggle()
                            timers.first?.pause()
                            
                            try? context.save()
                        } label: {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.customColor21)
                                .frame(width: 150, height: 80)
                                .shadow(radius: 8)
                                .overlay {
                                    Image(systemName: "timer")
                                        .foregroundColor(.customColor4)
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
                                .fill((timers.first?.isRunning ?? false) ? .customColor21 : .yellow)
                                .frame(width: 150, height: 80)
                                .shadow(radius: 8)
                                .overlay {
                                    Image(systemName: (timers.first?.isRunning ?? false) ? "pause.fill" : "play.fill")
                                        .foregroundColor(.customColor4)
                                        .bold()
                                        .font(.title)
                                }
                        }
                        .padding()
                    }
                    
                    //MARK: For Testing (Changing isFocusing)
//                    Button {
//                        timers.first?.isFocusing.toggle()
//                        timers.first?.stop()
//                    } label: {
//                        RoundedRectangle(cornerRadius: 16)
//                            .fill(.yellow)
//                            .frame(width: 150, height: 80)
//                            .shadow(radius: 8)
//                            .overlay {
//                                Text("changine isFocusing")
//                            }
//                    }
                    
                    Spacer()
                }
                .navigationTitle("POMODORO")
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground (
                    Color.customColor4, for: .navigationBar
                )
                .toolbarBackground(.visible, for: .navigationBar)
            }
        }
        .onAppear {
            timers.first?.loadState()
            
            //MARK: Ask for notification permission
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                if success {
                    print("Alert Permission given")
                } else if let error {
                    print(error.localizedDescription)
                }
            }
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
