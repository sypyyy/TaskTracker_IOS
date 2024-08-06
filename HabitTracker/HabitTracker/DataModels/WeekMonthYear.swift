//
//  WeekAndMonth.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/7/24.
//

import Foundation

struct Week: Codable {
    static func getCurrentWeek(startOfWeek: Weekday) -> Week {
        return Date().getWeek(startOfWeek: startOfWeek)
    }
    
    var startDate: Date
    var endDate: Date
}

extension Week: Hashable {
    
    static func == (lhs: Week, rhs: Week) -> Bool {
        return lhs.localizedString == rhs.localizedString
    }
    
    var localizedString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MMM dd"
        return "\(dateFormatter.string(from: startDate)) - \(dateFormatter.string(from: endDate))"
    }
}


struct Month: Codable {
    //1: Jan
    var month: Int
    var year: Int
    
}

extension Month {
    static let currentMonth = Month(month: Calendar.current.component(.month, from: Date()), year: Calendar.current.component(.year, from: Date()))
    var localizedString: String {
        var components = DateComponents()
        components.month = self.month
        components.year = self.year
        
        // Use the current calendar
        let calendar = Calendar.current
        if let date = calendar.date(from: components) {
            // Create and configure the DateFormatter
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM yyyy" // This will give you "July 2024"
            dateFormatter.locale = Locale.current // Set the locale to the current locale
            
            return dateFormatter.string(from: date)
        } else {
            return "Invalid date"
        }
    }
    
    func comeUpWithaDate() -> Date {
        var components = DateComponents()
        components.month = self.month
        components.year = self.year
        
        // Use the current calendar
        let calendar = Calendar.current
        if let date = calendar.date(from: components) {
            return date
        } else {
            return Date()
        }
    }
}

struct Year: Codable {
    static let currentYear = Year(year: Calendar.current.component(.year, from: Date()))
    var year: Int
}

extension Year: Hashable {
    static func == (lhs: Year, rhs: Year) -> Bool {
        return lhs.year == rhs.year
    }
}

extension Year {
    var localizedString: String {
        var components = DateComponents()
        components.year = self.year
        
        // Use the current calendar
        let calendar = Calendar.current
        if let date = calendar.date(from: components) {
            // Create and configure the DateFormatter
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy" // This will give you "2024"
            dateFormatter.locale = Locale.current // Set the locale to the current locale
            
            return dateFormatter.string(from: date)
        } else {
            return "Invalid date"
        }
    }
}

extension Year {
    func getAllWeeksInside(startOfWeek: Weekday) -> [Week] {
        var calendar = Calendar.current
        calendar.firstWeekday = startOfWeek.rawValue
        
        guard let startOfYear = calendar.date(from: DateComponents(year: year, month: 1, day: 1)),
              let endOfYear = calendar.date(from: DateComponents(year: year, month: 12, day: 31)) else {
            return []
        }
        
        var currentWeek = calendar.dateInterval(of: .weekOfYear, for: startOfYear)!
        var weeks: [Week] = []
        
        while currentWeek.start <= endOfYear {
            weeks.append(Week(startDate: currentWeek.start, endDate: currentWeek.end.addByMinute(-1)))
            if let nextWeek = calendar.date(byAdding: .weekOfYear, value: 1, to: currentWeek.start) {
                currentWeek = calendar.dateInterval(of: .weekOfYear, for: nextWeek)!
            } else {
                break
            }
        }
        
        return weeks
    }
}

