import Foundation

// MARK: - 薪資計算器
class SalaryCalculator: ObservableObject {
    @Published var monthlySalary: Double = 0
    @Published var country: Country = .taiwan
    @Published var workHoursPerDay: Double = 8
    @Published var workStartHour: Int = 9
    @Published var workStartMinute: Int = 0
    @Published var appLanguage: AppLanguage = .zhHant

    // 計算結果
    @Published var dailySalary: Double = 0
    @Published var hourlySalary: Double = 0
    @Published var perSecondSalary: Double = 0
    @Published var earnedToday: Double = 0
    @Published var workingDaysThisMonth: Int = 22
    @Published var isWorkingNow: Bool = false
    @Published var workProgress: Double = 0

    private var timer: Timer?
    private let calendar = Calendar.current

    /// 本地化字串
    var l10n: L10n { L10n(lang: appLanguage) }

    init() {
        loadSettings()
        recalculate()
        startTimer()
    }

    // MARK: - 核心計算

    func recalculate() {
        let now = Date()
        let year = calendar.component(.year, from: now)
        let month = calendar.component(.month, from: now)

        workingDaysThisMonth = HolidayManager.workingDays(for: country, year: year, month: month)

        if workingDaysThisMonth > 0 {
            dailySalary = monthlySalary / Double(workingDaysThisMonth)
        } else {
            dailySalary = 0
        }

        if workHoursPerDay > 0 {
            hourlySalary = dailySalary / workHoursPerDay
        } else {
            hourlySalary = 0
        }

        perSecondSalary = hourlySalary / 3600.0
        updateEarnings()
    }

    func updateEarnings() {
        let now = Date()
        let year = calendar.component(.year, from: now)
        let month = calendar.component(.month, from: now)
        let day = calendar.component(.day, from: now)
        let weekday = calendar.component(.weekday, from: now)

        let isWeekday = weekday != 1 && weekday != 7
        let holidays = HolidayManager.holidays(for: country, year: year)
        let todayComponents = DateComponents(year: year, month: month, day: day)
        let isHoliday = holidays.contains(todayComponents)

        guard isWeekday && !isHoliday else {
            earnedToday = 0
            isWorkingNow = false
            workProgress = 0
            return
        }

        var workStartComponents = calendar.dateComponents([.year, .month, .day], from: now)
        workStartComponents.hour = workStartHour
        workStartComponents.minute = workStartMinute
        workStartComponents.second = 0

        guard let workStart = calendar.date(from: workStartComponents) else {
            earnedToday = 0
            isWorkingNow = false
            workProgress = 0
            return
        }

        let workEndSeconds = workHoursPerDay * 3600
        let workEnd = workStart.addingTimeInterval(workEndSeconds)

        if now < workStart {
            earnedToday = 0
            isWorkingNow = false
            workProgress = 0
        } else if now > workEnd {
            earnedToday = dailySalary
            isWorkingNow = false
            workProgress = 1.0
        } else {
            let elapsed = now.timeIntervalSince(workStart)
            earnedToday = elapsed * perSecondSalary
            isWorkingNow = true
            workProgress = elapsed / workEndSeconds
        }
    }

    // MARK: - 計時器

    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            DispatchQueue.main.async {
                self?.updateEarnings()
            }
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    // MARK: - 設定存取

    func saveSettings() {
        UserDefaults.standard.set(monthlySalary, forKey: "monthlySalary")
        UserDefaults.standard.set(country.rawValue, forKey: "country")
        UserDefaults.standard.set(workHoursPerDay, forKey: "workHoursPerDay")
        UserDefaults.standard.set(workStartHour, forKey: "workStartHour")
        UserDefaults.standard.set(workStartMinute, forKey: "workStartMinute")
        UserDefaults.standard.set(appLanguage.rawValue, forKey: "appLanguage")
        recalculate()
    }

    func loadSettings() {
        if UserDefaults.standard.object(forKey: "monthlySalary") != nil {
            monthlySalary = UserDefaults.standard.double(forKey: "monthlySalary")
        }
        if let countryRaw = UserDefaults.standard.string(forKey: "country"),
           let savedCountry = Country(rawValue: countryRaw) {
            country = savedCountry
        }
        if UserDefaults.standard.object(forKey: "workHoursPerDay") != nil {
            workHoursPerDay = UserDefaults.standard.double(forKey: "workHoursPerDay")
        } else {
            workHoursPerDay = 8
        }
        if UserDefaults.standard.object(forKey: "workStartHour") != nil {
            workStartHour = UserDefaults.standard.integer(forKey: "workStartHour")
        } else {
            workStartHour = 9
        }
        if UserDefaults.standard.object(forKey: "workStartMinute") != nil {
            workStartMinute = UserDefaults.standard.integer(forKey: "workStartMinute")
        } else {
            workStartMinute = 0
        }
        if let langRaw = UserDefaults.standard.string(forKey: "appLanguage"),
           let savedLang = AppLanguage(rawValue: langRaw) {
            appLanguage = savedLang
        } else {
            appLanguage = country.defaultLanguage
        }
    }

    /// 切換國家時同步更新語言
    func updateLanguageForCountry() {
        appLanguage = country.defaultLanguage
    }

    // MARK: - 格式化

    private func formatNumber(_ value: Double, decimals: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = decimals
        formatter.maximumFractionDigits = decimals
        formatter.groupingSeparator = ","
        formatter.decimalSeparator = "."
        formatter.usesGroupingSeparator = true
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: NSNumber(value: value)) ?? String(format: "%.*f", decimals, value)
    }

    var formattedEarnings: String {
        let symbol = country.currencySymbol
        if earnedToday >= 1000 {
            return "\(symbol)\(formatNumber(earnedToday, decimals: 0))"
        } else if earnedToday >= 100 {
            return "\(symbol)\(formatNumber(earnedToday, decimals: 1))"
        } else {
            return "\(symbol)\(formatNumber(earnedToday, decimals: 2))"
        }
    }

    var menuBarTitle: String {
        if monthlySalary == 0 {
            return "💰 \(l10n.setupSalary)"
        }
        if !isWorkingNow && workProgress >= 1.0 {
            return "💰 \(formattedEarnings) ✓"
        } else if !isWorkingNow {
            return "💰 \(l10n.resting)"
        }
        return "💰 \(formattedEarnings)"
    }

    var formattedMonthlySalary: String {
        return formatNumber(monthlySalary, decimals: 0)
    }

    var formattedDailySalary: String {
        return "\(country.currencySymbol)\(formatNumber(dailySalary, decimals: 0))"
    }

    var formattedHourlySalary: String {
        return "\(country.currencySymbol)\(formatNumber(hourlySalary, decimals: 1))"
    }

    var formattedPerMinuteSalary: String {
        let perMinute = hourlySalary / 60.0
        return "\(country.currencySymbol)\(formatNumber(perMinute, decimals: 2))"
    }

    var workTimeDescription: String {
        let endHour = workStartHour + Int(workHoursPerDay)
        let endMinute = workStartMinute + Int((workHoursPerDay - Double(Int(workHoursPerDay))) * 60)
        return String(format: "%02d:%02d - %02d:%02d", workStartHour, workStartMinute, endHour, endMinute)
    }
}
