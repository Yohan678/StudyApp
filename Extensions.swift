//
//  Extensions.swift
//  StudyApp
//
//  Created by Yohan Yoon on 9/8/25.
//

import Foundation

extension Int {
    func formatToMMSS() -> String {
        let minutes = self / 60
        let seconds = self % 60
        
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

