//
//  HistoryBoxView.swift
//  StudyApp
//
//  Created by Yohan Yoon on 9/13/25.
//

import SwiftUI

struct HistoryBoxView: View {
    var completionDate: Date
    var totalStudiedTimes: Int
    
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color.customColor3)
            .frame(width: 180, height: 150)
            .shadow(radius: 10)
            .overlay(alignment: .bottom) {
                HStack(alignment: .bottom) {
                    Text("\(totalStudiedTimes)")
                        .font(Font.custom("digital-7", size: 70))
                    
                    Text("min")
                        .font(Font.custom("digital-7", size: 40))
                }
                .padding()
            }
            .overlay(alignment: .top) {
                UnevenRoundedRectangle(cornerRadii: .init(topLeading: 16, topTrailing: 16))
                    .fill(.customColor1)
                    .frame(height: 50)
                    .overlay {
                        Text(completionDate, style: .date)
                            .foregroundColor(.white)
                    }
            }
            .padding()
    }
}


