//
//  DateExtension.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/6/18.
//

import Foundation


    /*
extension Calendar {
    static let gregorian = Calendar(identifier: .gregorian)
}
*/

/*
extension Date {
    func startOfWeek(using calendar: Calendar = .gregorian) -> Date {
        calendar.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: self).date!
    }
    
    func startOfMonth(using calendar: Calendar = .gregorian) -> Date {
        calendar.dateComponents([.calendar, .year, .month], from: self).date!
    }
}
*/

extension Date {
    
    func startOfWeek() -> Date {
        let dayOfWeek = fmt6.string(from: self)
        switch dayOfWeek {
        case "Monday":
            return self.startOfDay()
        case "Tuesday":
            return self.addByDay(-1).startOfDay()
        case "Wednesday":
            return self.addByDay(-2).startOfDay()
        case "Thursday":
            return self.addByDay(-3).startOfDay()
        case "Friday":
            return self.addByDay(-4).startOfDay()
        case "Saturday":
            return self.addByDay(-5).startOfDay()
        case "Sunday":
            return self.addByDay(-6).startOfDay()
        default:
            return self
        }
    }
    
    func endOfWeek() -> Date {
        let dayOfWeek = fmt6.string(from: self)
        switch dayOfWeek {
        case "Monday":
            return self.addByDay(7).startOfDay()
        case "Tuesday":
            return self.addByDay(6).startOfDay()
        case "Wednesday":
            return self.addByDay(5).startOfDay()
        case "Thursday":
            return self.addByDay(4).startOfDay()
        case "Friday":
            return self.addByDay(3).startOfDay()
        case "Saturday":
            return self.addByDay(2).startOfDay()
        case "Sunday":
            return self.addByDay(1).startOfDay()
        default:
            return self
        }
    }
    
    /*
    func startOfWeek() -> Date {
        guard let thisWeek = Calendar.current.dateInterval(of: .weekOfYear, for: Date()) else {return Date()}
        return thisWeek.start
    }
    */ 
    func startOfMonth() -> Date {
        guard let thisMonth = Calendar.current.dateInterval(of: .month, for: self) else {return Date()}
        return thisMonth.start
    }
    
    func startOfYear() -> Date {
        guard let thisYear = Calendar.current.dateInterval(of: .year, for: self) else {return Date()}
        return thisYear.start
    }
    
    func endOfMonth() -> Date {
        guard let thisMonth = Calendar.current.dateInterval(of: .month, for: self) else {return Date()}
        return thisMonth.end
    }
    
    func endOfYear() -> Date {
        guard let thisYear = Calendar.current.dateInterval(of: .year, for: self) else {return Date()}
        return thisYear.end
    }
    
    func startOfDay() -> Date {
        guard let thisDay = Calendar.current.dateInterval(of: .day, for: self) else {return Date()}
        return thisDay.start
    }
    
    func endOfDay() -> Date {
        guard let thisDay = Calendar.current.dateInterval(of: .day, for: self) else {return Date()}
        return thisDay.end
    }
    
    
    /*
    let thisYear = Calendar.current.dateInterval(of: .year, for: Date())!
    func startOfMonth() -> Date {
        let dayOfMonth = fmt2.string(from: self)
        return self.addBy(-((Int(dayOfMonth) ?? 1) - 1))
    }
    */
    
    
    func addByDay(_ by: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: by, to: self) ?? self
    }
    
    func addByMonth(_ by: Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: by, to: self) ?? self
    }
    
    func addByYear(_ by: Int) -> Date {
        return Calendar.current.date(byAdding: .year, value: by, to: self) ?? self
    }
    
    func addByHour(_ by: Int) -> Date {
        return Calendar.current.date(byAdding: .hour, value: by, to: self) ?? self
    }
    
    func addByMinute(_ by: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: by, to: self) ?? self
    }
    
    func compareToByDay(_ date: Date) -> Int {
        let result = Calendar.current.compare(self, to: date, toGranularity: .day)
        switch result {
        case .orderedAscending:
            return -1
        case .orderedSame:
            return 0
        case .orderedDescending:
            return 1
        }
    }
    
    func compareTo(_ date: Date) -> Int {
        let result = Calendar.current.compare(self, to: date, toGranularity: .nanosecond)
        switch result {
        case .orderedAscending:
            return -1
        case .orderedSame:
            return 0
        case .orderedDescending:
            return 1
        }
    }
    
    func isSameYear(_ date: Date) -> Bool {
        return fmt3.string(from: self) == fmt3.string(from: date)
    }
    
    func isSameMonth(_ date: Date) -> Bool {
        return fmt9.string(from: self) == fmt9.string(from: date)
    }
    
    func isSameWeek(_ date: Date) -> Bool {
        return fmt9.string(from: self) == fmt9.string(from: date)
    }

}

var fmt : DateFormatter {
    let res = DateFormatter()
    res.dateFormat = "yyyy/MM/dd"
    return res
}

var fmt1 : DateFormatter {
    let fmt = DateFormatter()
    fmt.dateFormat = "E"
    return fmt
}
//d:1 dd: 01
var fmt2 : DateFormatter {
    let fmt = DateFormatter()
    fmt.dateFormat = "dd"
    return fmt
}

var fmt3 : DateFormatter {
    let fmt = DateFormatter()
    fmt.dateFormat = "yyyy"
    return fmt
}

var fmt4 : DateFormatter {
    let fmt = DateFormatter()
    fmt.dateFormat = "MMM dd"
    return fmt
}

var fmt5 : DateFormatter {
    let fmt = DateFormatter()
    fmt.dateFormat = "yyyy MMM dd"
    return fmt
}
//Friday
var fmt6 : DateFormatter {
    let fmt = DateFormatter()
    fmt.dateFormat = "EEEE"
    return fmt
}
//d:1 dd: 01
var fmt7 : DateFormatter {
    let fmt = DateFormatter()
    fmt.dateFormat = "d"
    return fmt
}

var fmt8 : DateFormatter {
    let fmt = DateFormatter()
    fmt.dateFormat = "MMMM"
    return fmt
}

var fmt9 : DateFormatter {
    let fmt = DateFormatter()
    fmt.dateFormat = "yyyy MMM"
    return fmt
}

//Jan 1, 2024
var fmt10 : DateFormatter {
    let fmt = DateFormatter()
    fmt.dateFormat = "MMM d, yyyy"
    return fmt
}

//10:00 AM
var fmt11 : DateFormatter {
    let fmt = DateFormatter()
    fmt.dateFormat = "h:mm a"
    return fmt
}

//18:00
var fmt12 : DateFormatter {
    let fmt = DateFormatter()
    fmt.dateFormat = "HH:mm"
    return fmt
}

var fmt_date_select_localized: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    formatter.locale = Locale.current
    return formatter
}

var fmt_time_select_localized: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateStyle = .none
    formatter.timeStyle = .short
    formatter.locale = Locale.current
    return formatter
}

var fmt_timeStamp: DateFormatter {
    let fmt = DateFormatter()
    fmt.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    return fmt
}

extension Date {
    static func combineDates(date: Date, time: Date) -> Date {
        // Assuming you have two Date objects
        let date = Date()  // Replace this with your first Date
        let time = Date()  // Replace this with your second Date

        // Get the date components from the first Date
        let calendar = Calendar.current
        let date1Components = calendar.dateComponents([.year, .month, .day], from: date)

        // Get the time components from the second Date
        let date2Components = calendar.dateComponents([.hour, .minute], from: time)

        // Create a new Date by combining the date from date1 and the time from date2
        if let combinedDate = calendar.date(bySettingHour: date2Components.hour ?? 0,
                                             minute: date2Components.minute ?? 0,
                                             second: 0,
                                             of: calendar.date(from: date1Components) ?? Date()) {
            print("Combined Date: \(combinedDate)")
            return combinedDate
        } else {
            print("Error creating combined date.")
            return Date()
        }
    }
}

enum Weekday: Int, CaseIterable, Codable {
    case sunday = 1, monday = 2, tuesday = 3, wednesday = 4, thursday = 5, friday = 6, saturday = 7
    var localizedName: String {
        let formatter = DateFormatter()
        return formatter.weekdaySymbols[self.rawValue - 1]
    }
}
/*
func getWeek(for date: Date, startOfWeek: Weekday) -> (startDate: Date, endDate: Date)? {
    var calendar = Calendar.current
    calendar.firstWeekday = startOfWeek.rawValue

    // Find the weekday component of the given date
    let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
    guard let weekStartDate = calendar.date(from: components) else { return nil }
    
    // Calculate the end date of the week
    let weekEndDate = calendar.date(byAdding: .day, value: 6, to: weekStartDate)!
    
    return (startDate: weekStartDate, endDate: weekEndDate)
}

//If the user have stored week with old preference of start of week, when we present in view, we infer the week for conformance.
func inferWeekFromOldPreference(from startDate: Date, to endDate: Date, startOfWeek: Weekday) -> (startDate: Date, endDate: Date)? {
    var calendar = Calendar.current
    calendar.firstWeekday = startOfWeek.rawValue
    
    var weekCount: [String: Int] = [:]
    var currentDate = startDate
    
    while currentDate <= endDate {
        if let week = getWeek(for: currentDate, startOfWeek: startOfWeek) {
            let weekKey = "\(week.startDate)-\(week.endDate)"
            weekCount[weekKey, default: 0] += 1
        }
        
        currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
    }
    
    // Find the week with the highest count
    let mostFrequentWeekKey = weekCount.max { a, b in a.value < b.value }?.key
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    if let weekKey = mostFrequentWeekKey,
       let startDate = dateFormatter.date(from: String(weekKey.split(separator: "-")[0])),
       let endDate = dateFormatter.date(from: String(weekKey.split(separator: "-")[1])) {
        return (startDate, endDate)
    }
    
    return nil
}
*/


extension Date {
    func getMonth() -> Month {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: self)
        
        guard let year = components.year, let month = components.month else {
            return Month(month: 12, year: 1970)
        }
        
        return Month(month: month, year: year)
    }
    
    func getYear() -> Year {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: self)
        
        guard let year = components.year else {
            return Year(year: 1970)
        }
        return Year(year: year)
    }
    
    func getWeek(startOfWeek: Weekday) -> Week {
        var calendar = Calendar.current
        calendar.firstWeekday = startOfWeek.rawValue
        var currentWeek = calendar.dateInterval(of: .weekOfYear, for: Date())!
        return Week(startDate: currentWeek.start, endDate: currentWeek.end.addByMinute(-1))
    }
}
