//
//  Date+.swift
//  Weather app
//
//  Created by Kevin Lagat on 04/02/2022.
//

import Foundation


extension Date {
    
    func getNextDate(current: Int) -> String {
        let today = weekDays
        let currentIndex = daysOfTheWeek.firstIndex(of: today) ?? 0
        
        var currentToLast: [String] = Array(daysOfTheWeek[currentIndex...daysOfTheWeek.count - 1])
        let firstToCurrent = Array(daysOfTheWeek[0...currentIndex])
        
        currentToLast.append(contentsOf: firstToCurrent)
        return currentToLast[current]
    }
    
    var weekDays: String {
        let dayNumber = Calendar.current.component(.weekday, from: self)
        return daysOfTheWeek[dayNumber - 1]
    }
    
    private var daysOfTheWeek: [String] {
        return  ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    }
    
    
    var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.locale = Locale.current
        
        return dateFormatter
    }
    
}
