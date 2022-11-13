//
//  Date+Extensions.swift
//  Media Previewer
//
//  Created by Nasibovic Fayzulloh on 12/11/22.
//

import Foundation

public extension Date {
    
    static func secondsToTimer(seconds: Double) -> String {
        let date = Date.init(timeIntervalSinceReferenceDate: seconds)
        let formatter = DateFormatter()
        if seconds < 3600 {
            formatter.dateFormat = "mm:ss"
        } else {
            formatter.dateFormat = "HH:mm:ss"
        }
        
        formatter.timeZone = TimeZone.init(identifier: "GMT")
        return formatter.string(from: date)
    }
}
