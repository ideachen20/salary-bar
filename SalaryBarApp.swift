import SwiftUI

@main
struct SalaryBarApp: App {
    @StateObject private var calculator = SalaryCalculator()

    var body: some Scene {
        MenuBarExtra(calculator.menuBarTitle, systemImage: "dollarsign.circle") {
            MenuBarView(calculator: calculator)
        }
        .menuBarExtraStyle(.window)
    }
}

// MARK: - Menu Bar 主視圖
struct MenuBarView: View {
    @ObservedObject var calculator: SalaryCalculator
    @State private var showSettings = false

    var body: some View {
        VStack(spacing: 0) {
            if calculator.monthlySalary == 0 {
                WelcomeView(calculator: calculator)
            } else if showSettings {
                SettingsView(calculator: calculator, showSettings: $showSettings)
            } else {
                DashboardView(calculator: calculator, showSettings: $showSettings)
            }
        }
        .frame(width: 320)
    }
}

// MARK: - 歡迎/首次設定視圖
struct WelcomeView: View {
    @ObservedObject var calculator: SalaryCalculator
    @State private var salaryInput: String = ""
    @State private var selectedCountry: Country = .taiwan

    var body: some View {
        let lang = selectedCountry.defaultLanguage
        let l = L10n(lang: lang)

        VStack(spacing: 16) {
            VStack(spacing: 4) {
                Text(l.appTitle)
                    .font(.title2)
                    .fontWeight(.bold)
                Text(l.welcomeSubtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 16)

            Divider()

            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(l.selectCountry)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Picker("", selection: $selectedCountry) {
                        ForEach(Country.allCases) { country in
                            Text(country.localizedName(for: lang)).tag(country)
                        }
                    }
                    .labelsHidden()
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("\(l.monthlySalaryLabel) (\(selectedCountry.currencySymbol))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    TextField(l.enterSalary, text: $salaryInput)
                        .textFieldStyle(.roundedBorder)
                }
            }
            .padding(.horizontal, 16)

            Button(action: {
                if let salary = Double(salaryInput.replacingOccurrences(of: ",", with: "")) {
                    calculator.monthlySalary = salary
                    calculator.country = selectedCountry
                    calculator.appLanguage = selectedCountry.defaultLanguage
                    calculator.saveSettings()
                }
            }) {
                Text(l.startCalculating)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal, 16)
            .disabled(Double(salaryInput.replacingOccurrences(of: ",", with: "")) == nil)

            Spacer()
        }
        .padding(.bottom, 16)
        .frame(height: 280)
    }
}

// MARK: - 主面板視圖
struct DashboardView: View {
    @ObservedObject var calculator: SalaryCalculator
    @Binding var showSettings: Bool

    var body: some View {
        let l = calculator.l10n

        VStack(spacing: 0) {
            // 頂部標題列
            HStack {
                Text(l.appTitle)
                    .font(.headline)
                Spacer()
                Button(action: { showSettings = true }) {
                    Image(systemName: "gearshape")
                        .font(.system(size: 14))
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 8)

            Divider()

            // 今日收入 - 大數字顯示
            VStack(spacing: 4) {
                Text(l.earnedToday)
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text(calculator.formattedEarnings)
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(calculator.isWorkingNow ? .green : .primary)

                // 進度條
                if calculator.isWorkingNow || calculator.workProgress > 0 {
                    VStack(spacing: 2) {
                        ProgressView(value: calculator.workProgress)
                            .progressViewStyle(.linear)
                            .tint(calculator.isWorkingNow ? .green : .blue)

                        HStack {
                            Text(calculator.workTimeDescription)
                                .font(.system(size: 10))
                                .foregroundColor(.secondary)
                            Spacer()
                            Text(String(format: "%.0f%%", calculator.workProgress * 100))
                                .font(.system(size: 10))
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.horizontal, 4)
                }

                if calculator.isWorkingNow {
                    Text(l.working)
                        .font(.caption2)
                        .foregroundColor(.green)
                        .padding(.top, 2)
                } else if calculator.workProgress >= 1.0 {
                    Text(l.dayCompleted)
                        .font(.caption2)
                        .foregroundColor(.blue)
                        .padding(.top, 2)
                } else {
                    Text(l.notWorking)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .padding(.top, 2)
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)

            Divider()

            // 薪資明細
            VStack(spacing: 8) {
                InfoRow(label: l.monthlySalaryInfo, value: "\(calculator.country.currencySymbol)\(calculator.formattedMonthlySalary)")
                InfoRow(label: l.workingDaysThisMonth, value: "\(calculator.workingDaysThisMonth) \(l.daysUnit)")
                InfoRow(label: l.dailySalary, value: calculator.formattedDailySalary)
                InfoRow(label: l.hourlySalary, value: calculator.formattedHourlySalary)
                InfoRow(label: l.perMinute, value: calculator.formattedPerMinuteSalary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)

            Divider()

            // 底部按鈕
            HStack {
                Text(calculator.country.localizedName(for: calculator.appLanguage))
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Button(l.quit) {
                    NSApplication.shared.terminate(nil)
                }
                .font(.caption)
                .buttonStyle(.plain)
                .foregroundColor(.red)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
        .frame(height: 380)
    }
}

// MARK: - 設定視圖
struct SettingsView: View {
    @ObservedObject var calculator: SalaryCalculator
    @Binding var showSettings: Bool
    @State private var salaryInput: String = ""
    @State private var selectedCountry: Country = .taiwan
    @State private var selectedLanguage: AppLanguage = .zhHant
    @State private var workHours: Double = 8
    @State private var startHour: Int = 9
    @State private var startMinute: Int = 0

    var body: some View {
        let l = L10n(lang: selectedLanguage)

        VStack(spacing: 0) {
            // 標題
            HStack {
                Button(action: { showSettings = false }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 12))
                    Text(l.back)
                        .font(.caption)
                }
                .buttonStyle(.plain)
                Spacer()
                Text(l.settings)
                    .font(.headline)
                Spacer()
                Text("      ")
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 8)

            Divider()

            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    // 國家選擇
                    VStack(alignment: .leading, spacing: 4) {
                        Text(l.selectCountry)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Picker("", selection: $selectedCountry) {
                            ForEach(Country.allCases) { country in
                                Text(country.localizedName(for: selectedLanguage)).tag(country)
                            }
                        }
                        .labelsHidden()
                        .onChange(of: selectedCountry) { newCountry in
                            selectedLanguage = newCountry.defaultLanguage
                        }
                    }

                    // 語言選擇
                    VStack(alignment: .leading, spacing: 4) {
                        Text(l.language)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Picker("", selection: $selectedLanguage) {
                            ForEach(AppLanguage.allCases, id: \.self) { lang in
                                Text(lang.displayName).tag(lang)
                            }
                        }
                        .labelsHidden()
                    }

                    // 月薪
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(l.monthlySalaryLabel) (\(selectedCountry.currencySymbol))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        TextField(l.enterSalary, text: $salaryInput)
                            .textFieldStyle(.roundedBorder)
                    }

                    // 每日工時
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(l.workHoursPerDay): \(String(format: "%.1f", workHours)) \(l.hoursUnit)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Slider(value: $workHours, in: 4...12, step: 0.5)
                    }

                    // 上班時間
                    VStack(alignment: .leading, spacing: 4) {
                        Text(l.workStartTime)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        HStack {
                            Picker("", selection: $startHour) {
                                ForEach(5..<22) { hour in
                                    Text(String(format: "%02d", hour)).tag(hour)
                                }
                            }
                            .frame(width: 70)
                            Text(":")
                            Picker("", selection: $startMinute) {
                                ForEach([0, 15, 30, 45], id: \.self) { minute in
                                    Text(String(format: "%02d", minute)).tag(minute)
                                }
                            }
                            .frame(width: 70)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }

            Divider()

            // 儲存按鈕
            Button(action: {
                if let salary = Double(salaryInput.replacingOccurrences(of: ",", with: "")) {
                    calculator.monthlySalary = salary
                    calculator.country = selectedCountry
                    calculator.appLanguage = selectedLanguage
                    calculator.workHoursPerDay = workHours
                    calculator.workStartHour = startHour
                    calculator.workStartMinute = startMinute
                    calculator.saveSettings()
                    showSettings = false
                }
            }) {
                Text(l.saveSettings)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        }
        .frame(height: 420)
        .onAppear {
            salaryInput = String(format: "%.0f", calculator.monthlySalary)
            selectedCountry = calculator.country
            selectedLanguage = calculator.appLanguage
            workHours = calculator.workHoursPerDay
            startHour = calculator.workStartHour
            startMinute = calculator.workStartMinute
        }
    }
}

// MARK: - 輔助視圖
struct InfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 12))
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.system(size: 12, weight: .medium, design: .monospaced))
        }
    }
}
