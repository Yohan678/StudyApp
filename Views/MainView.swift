//
//  MainView.swift
//  StudyApp
//
//  Created by Yohan Yoon on 8/29/25.
//

import SwiftUI

struct MainView: View {
    //boolean for setting timer view sheet
    @State private var isShowingSheet: Bool = false
    
    var body: some View {
        TabView {
            NavigationView {
                VStack {
                    Button {
                        isShowingSheet.toggle()
                    } label: {
                        Text("show timer set view")
                    }
                    .sheet(isPresented: $isShowingSheet) {
                        SetTimerView()
                    }
                }
                .navigationTitle("POMODORO")
                .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
        }
    }
}

#Preview {
    MainView()
}
