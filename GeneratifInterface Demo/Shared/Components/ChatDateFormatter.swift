import Foundation

/// Formatage des horodatages de la liste des discussions (formatters mis en cache).
enum ChatDateFormatter {
    private static let time: DateFormatter = {
        let f = DateFormatter(); f.timeStyle = .short; f.dateStyle = .none; return f
    }()
    private static let day: DateFormatter = {
        let f = DateFormatter(); f.dateFormat = "EEEE"; return f
    }()
    private static let short: DateFormatter = {
        let f = DateFormatter(); f.dateStyle = .short; f.timeStyle = .none; return f
    }()

    static func time(_ date: Date) -> String { time.string(from: date) }

    /// « 14:32 », « Hier », « lundi », ou « 12/10/2026 ».
    static func listLabel(for date: Date, now: Date = .now, calendar: Calendar = .current) -> String {
        if calendar.isDate(date, inSameDayAs: now) { return time.string(from: date) }
        if calendar.isDateInYesterday(date) { return "Hier" }
        if let days = calendar.dateComponents([.day], from: date, to: now).day, days < 7 {
            return day.string(from: date).capitalized
        }
        return short.string(from: date)
    }
}
