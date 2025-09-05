//
//  SetTimerView.swift
//  StudyApp
//
//  Created by Yohan Yoon on 8/29/25.
//

import SwiftUI
import SwiftData

struct SetTimerView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    private var sessions: [PomodoroSetting] = [
        PomodoroSetting(title: "Light Work Session", focusTime: 15, restTime: 3),
        PomodoroSetting(title: "Standard Work Session", focusTime: 25, restTime: 5),
        PomodoroSetting(title: "Deep Work Session", focusTime: 50, restTime: 10),
        PomodoroSetting(title: "Extreme Work Session", focusTime: 90, restTime: 20)
    ]
    
    @State private var selectedSessionID: PomodoroSetting.ID?
    
    
    var body: some View {
        
        Spacer()
        
        ForEach(sessions) { session in
            let isSelected = (session.id == selectedSessionID)
            VStack(spacing: 16) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? Color.black : Color.green)
                    .frame(width: 350, height: 80)
                    .overlay(alignment: .center) {
                        Text(session.title)
                            .foregroundColor(.white)
                            .font(.title)
                            .bold()
                    }
                    .onTapGesture {
                        withAnimation(.spring()) {
                            if isSelected {
                                self.selectedSessionID = nil
                            } else {
                                self.selectedSessionID = session.id
                            }
                        }
                    }
                    .shadow(radius: 10)
                    .padding(8)
                
                if isSelected {
                    Text("Focus for **\(session.focusTime)** minutes & Rest for **\(session.restTime)** minutes")
                        .foregroundColor(.blue)
                        .padding()
                        .shadow(radius: 5)
                        .transition(.opacity.combined(with: .scale))
                }
            }
        }
        
        Spacer()

        Button {
            dismiss()
        } label: {
            Image(systemName: "checkmark")
                .foregroundColor(.white)
                .bold()
                .font(.title)
                .background {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.blue)
                        .frame(width: 150, height: 80)
                }
        }
        .padding()
    }
}

#Preview {
    SetTimerView()
}
