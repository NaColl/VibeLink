//
//  WeeklyTimerService.swift
//  VibeLink
//
//  Created on 2025-10-17.
//

import Foundation
import Combine

@MainActor
class WeeklyTimerService: ObservableObject {
    @Published var weekStartDate: Date
    @Published var currentDay: Int
    @Published var isWeekComplete: Bool = false
    @Published var progress: Double = 0.0
    
    static let shared = WeeklyTimerService()
    
    private var timer: Timer?
    
    private init() {
        // Load or create week start date
        if let savedDate = UserDefaults.standard.object(forKey: "weekStartDate") as? Date {
            weekStartDate = savedDate
        } else {
            weekStartDate = Date()
            UserDefaults.standard.set(weekStartDate, forKey: "weekStartDate")
        }
        
        updateProgress()
        startTimer()
    }
    
    func updateProgress() {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: weekStartDate, to: Date())
        currentDay = min((components.day ?? 0) + 1, 7)
        progress = Double(currentDay) / 7.0
        isWeekComplete = currentDay >= 7
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 3600, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.updateProgress()
            }
        }
    }
    
    func resetWeek() {
        weekStartDate = Date()
        UserDefaults.standard.set(weekStartDate, forKey: "weekStartDate")
        updateProgress()
    }
    
    var daysRemaining: Int {
        max(0, 7 - currentDay)
    }
    
    var formattedTimeRemaining: String {
        if daysRemaining == 0 {
            return "Week Complete!"
        } else if daysRemaining == 1 {
            return "1 day left"
        } else {
            return "\(daysRemaining) days left"
        }
    }
}
