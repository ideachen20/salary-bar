import Foundation

// MARK: - 支援的國家/地區
enum Country: String, CaseIterable, Identifiable, Codable {
    case taiwan = "台灣"
    case japan = "日本"
    case korea = "韓國"
    case usa = "美國"
    case uk = "英國"
    case germany = "德國"
    case france = "法國"
    case china = "中國"
    case hongkong = "香港"
    case singapore = "新加坡"
    case canada = "加拿大"
    case australia = "澳洲"

    var id: String { rawValue }

    var currencySymbol: String {
        switch self {
        case .taiwan: return "NT$"
        case .japan: return "¥"
        case .korea: return "₩"
        case .usa: return "$"
        case .uk: return "£"
        case .germany, .france: return "€"
        case .china: return "¥"
        case .hongkong: return "HK$"
        case .singapore: return "S$"
        case .canada: return "C$"
        case .australia: return "A$"
        }
    }

    var currencyCode: String {
        switch self {
        case .taiwan: return "TWD"
        case .japan: return "JPY"
        case .korea: return "KRW"
        case .usa: return "USD"
        case .uk: return "GBP"
        case .germany, .france: return "EUR"
        case .china: return "CNY"
        case .hongkong: return "HKD"
        case .singapore: return "SGD"
        case .canada: return "CAD"
        case .australia: return "AUD"
        }
    }

    var countryCode: String {
        switch self {
        case .taiwan: return "TW"
        case .japan: return "JP"
        case .korea: return "KR"
        case .usa: return "US"
        case .uk: return "GB"
        case .germany: return "DE"
        case .france: return "FR"
        case .china: return "CN"
        case .hongkong: return "HK"
        case .singapore: return "SG"
        case .canada: return "CA"
        case .australia: return "AU"
        }
    }
}

// MARK: - 假期資料管理
struct HolidayManager {

    /// 取得指定國家和年份的公定假期日期
    static func holidays(for country: Country, year: Int) -> Set<DateComponents> {
        switch country {
        case .taiwan: return taiwanHolidays(year: year)
        case .japan: return japanHolidays(year: year)
        case .korea: return koreaHolidays(year: year)
        case .usa: return usaHolidays(year: year)
        case .uk: return ukHolidays(year: year)
        case .germany: return germanyHolidays(year: year)
        case .france: return franceHolidays(year: year)
        case .china: return chinaHolidays(year: year)
        case .hongkong: return hongkongHolidays(year: year)
        case .singapore: return singaporeHolidays(year: year)
        case .canada: return canadaHolidays(year: year)
        case .australia: return australiaHolidays(year: year)
        }
    }

    /// 計算指定年份和月份的實際工作日數
    static func workingDays(for country: Country, year: Int, month: Int) -> Int {
        let calendar = Calendar.current
        let holidays = self.holidays(for: country, year: year)

        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = 1

        guard let startDate = calendar.date(from: components),
              let range = calendar.range(of: .day, in: .month, for: startDate) else {
            return 22
        }

        var workDays = 0
        for day in range {
            var dayComponents = DateComponents()
            dayComponents.year = year
            dayComponents.month = month
            dayComponents.day = day

            guard let date = calendar.date(from: dayComponents) else { continue }
            let weekday = calendar.component(.weekday, from: date)

            // 排除週六(7)和週日(1)
            if weekday == 1 || weekday == 7 { continue }

            // 排除公定假期
            let dc = DateComponents(year: year, month: month, day: day)
            if holidays.contains(dc) { continue }

            workDays += 1
        }

        return workDays
    }

    /// 計算指定年份的全年實際工作日數
    static func yearlyWorkingDays(for country: Country, year: Int) -> Int {
        var total = 0
        for month in 1...12 {
            total += workingDays(for: country, year: year, month: month)
        }
        return total
    }

    // MARK: - Helper
    private static func makeDate(_ year: Int, _ month: Int, _ day: Int) -> DateComponents {
        return DateComponents(year: year, month: month, day: day)
    }

    // MARK: - 台灣 (依據行政院人事行政總處公告，含2025年新增5個國定假日)
    private static func taiwanHolidays(year: Int) -> Set<DateComponents> {
        switch year {
        case 2025:
            return Set([
                makeDate(2025, 1, 1),   // 元旦
                makeDate(2025, 1, 27),  // 彈性放假(除夕前一日)
                makeDate(2025, 1, 28),  // 除夕
                makeDate(2025, 1, 29),  // 春節初一
                makeDate(2025, 1, 30),  // 春節初二
                makeDate(2025, 1, 31),  // 春節初三
                makeDate(2025, 2, 28),  // 和平紀念日
                makeDate(2025, 4, 3),   // 兒童節(補假)
                makeDate(2025, 4, 4),   // 清明節/兒童節
                makeDate(2025, 5, 1),   // 勞動節
                makeDate(2025, 5, 30),  // 端午節(補假,逢週六)
                makeDate(2025, 9, 29),  // 教師節(補假,逢週日)
                makeDate(2025, 10, 6),  // 中秋節
                makeDate(2025, 10, 10), // 國慶日
                makeDate(2025, 10, 24), // 台灣光復節(補假,逢週六)
                makeDate(2025, 12, 25), // 行憲紀念日
            ])
        case 2026:
            return Set([
                makeDate(2026, 1, 1),   // 元旦
                makeDate(2026, 2, 16),  // 除夕
                makeDate(2026, 2, 17),  // 春節初一
                makeDate(2026, 2, 18),  // 春節初二
                makeDate(2026, 2, 19),  // 春節初三
                makeDate(2026, 2, 20),  // 小年夜補假
                makeDate(2026, 2, 27),  // 和平紀念日(補假,逢週六)
                makeDate(2026, 4, 3),   // 兒童節(補假,逢週六)
                makeDate(2026, 4, 6),   // 清明節(補假,逢週日)
                makeDate(2026, 5, 1),   // 勞動節
                makeDate(2026, 6, 19),  // 端午節
                makeDate(2026, 9, 25),  // 中秋節
                makeDate(2026, 9, 28),  // 教師節
                makeDate(2026, 10, 9),  // 國慶日(補假,逢週六)
                makeDate(2026, 10, 26), // 台灣光復節(補假,逢週日)
                makeDate(2026, 12, 25), // 行憲紀念日
            ])
        default:
            return Set([
                makeDate(year, 1, 1), makeDate(year, 2, 28),
                makeDate(year, 4, 4), makeDate(year, 4, 5),
                makeDate(year, 5, 1), makeDate(year, 9, 28),
                makeDate(year, 10, 10), makeDate(year, 10, 25),
                makeDate(year, 12, 25),
            ])
        }
    }

    // MARK: - 日本 (依據內閣府「国民の祝日」公告)
    private static func japanHolidays(year: Int) -> Set<DateComponents> {
        switch year {
        case 2025:
            return Set([
                makeDate(2025, 1, 1),   // 元日
                makeDate(2025, 1, 13),  // 成人の日
                makeDate(2025, 2, 11),  // 建国記念の日
                makeDate(2025, 2, 23),  // 天皇誕生日
                makeDate(2025, 2, 24),  // 振替休日
                makeDate(2025, 3, 20),  // 春分の日
                makeDate(2025, 4, 29),  // 昭和の日
                makeDate(2025, 5, 3),   // 憲法記念日
                makeDate(2025, 5, 4),   // みどりの日
                makeDate(2025, 5, 5),   // こどもの日
                makeDate(2025, 5, 6),   // 振替休日
                makeDate(2025, 7, 21),  // 海の日
                makeDate(2025, 8, 11),  // 山の日
                makeDate(2025, 9, 15),  // 敬老の日
                makeDate(2025, 9, 23),  // 秋分の日
                makeDate(2025, 10, 13), // スポーツの日
                makeDate(2025, 11, 3),  // 文化の日
                makeDate(2025, 11, 23), // 勤労感謝の日
                makeDate(2025, 11, 24), // 振替休日
            ])
        case 2026:
            return Set([
                makeDate(2026, 1, 1),   // 元日
                makeDate(2026, 1, 12),  // 成人の日
                makeDate(2026, 2, 11),  // 建国記念の日
                makeDate(2026, 2, 23),  // 天皇誕生日
                makeDate(2026, 3, 20),  // 春分の日
                makeDate(2026, 4, 29),  // 昭和の日
                makeDate(2026, 5, 3),   // 憲法記念日
                makeDate(2026, 5, 4),   // みどりの日
                makeDate(2026, 5, 5),   // こどもの日
                makeDate(2026, 5, 6),   // 振替休日
                makeDate(2026, 7, 20),  // 海の日
                makeDate(2026, 8, 11),  // 山の日
                makeDate(2026, 9, 21),  // 敬老の日
                makeDate(2026, 9, 22),  // 国民の休日
                makeDate(2026, 9, 23),  // 秋分の日
                makeDate(2026, 10, 12), // スポーツの日
                makeDate(2026, 11, 3),  // 文化の日
                makeDate(2026, 11, 23), // 勤労感謝の日
            ])
        default:
            return Set([
                makeDate(year, 1, 1), makeDate(year, 1, 13),
                makeDate(year, 2, 11), makeDate(year, 2, 23),
                makeDate(year, 3, 20), makeDate(year, 4, 29),
                makeDate(year, 5, 3), makeDate(year, 5, 4), makeDate(year, 5, 5),
                makeDate(year, 7, 20), makeDate(year, 8, 11),
                makeDate(year, 9, 21), makeDate(year, 9, 23),
                makeDate(year, 10, 12), makeDate(year, 11, 3), makeDate(year, 11, 23),
            ])
        }
    }

    // MARK: - 韓國 (依據法定公休日及代替休日制度)
    private static func koreaHolidays(year: Int) -> Set<DateComponents> {
        switch year {
        case 2025:
            return Set([
                makeDate(2025, 1, 1),   // 신정
                makeDate(2025, 1, 28),  // 설날
                makeDate(2025, 1, 29),  // 설날
                makeDate(2025, 1, 30),  // 설날
                makeDate(2025, 3, 1),   // 삼일절
                makeDate(2025, 3, 3),   // 삼일절 대체공휴일
                makeDate(2025, 5, 5),   // 어린이날/부처님 오신날
                makeDate(2025, 5, 6),   // 대체공휴일
                makeDate(2025, 6, 3),   // 지방선거일
                makeDate(2025, 6, 6),   // 현충일
                makeDate(2025, 8, 15),  // 광복절
                makeDate(2025, 10, 3),  // 개천절
                makeDate(2025, 10, 5),  // 추석
                makeDate(2025, 10, 6),  // 추석
                makeDate(2025, 10, 7),  // 추석
                makeDate(2025, 10, 8),  // 추석 대체공휴일
                makeDate(2025, 10, 9),  // 한글날
                makeDate(2025, 12, 25), // 성탄절
            ])
        case 2026:
            return Set([
                makeDate(2026, 1, 1),   // 신정
                makeDate(2026, 2, 16),  // 설날
                makeDate(2026, 2, 17),  // 설날
                makeDate(2026, 2, 18),  // 설날
                makeDate(2026, 3, 1),   // 삼일절
                makeDate(2026, 3, 2),   // 삼일절 대체공휴일
                makeDate(2026, 5, 5),   // 어린이날
                makeDate(2026, 5, 25),  // 부처님 오신날 대체공휴일
                makeDate(2026, 6, 6),   // 현충일
                makeDate(2026, 8, 15),  // 광복절
                makeDate(2026, 8, 17),  // 광복절 대체공휴일
                makeDate(2026, 9, 24),  // 추석
                makeDate(2026, 9, 25),  // 추석
                makeDate(2026, 9, 26),  // 추석
                makeDate(2026, 10, 3),  // 개천절
                makeDate(2026, 10, 5),  // 개천절 대체공휴일
                makeDate(2026, 10, 9),  // 한글날
                makeDate(2026, 12, 25), // 성탄절
            ])
        default:
            return Set([
                makeDate(year, 1, 1), makeDate(year, 3, 1),
                makeDate(year, 5, 5), makeDate(year, 6, 6),
                makeDate(year, 8, 15), makeDate(year, 10, 3),
                makeDate(year, 10, 9), makeDate(year, 12, 25),
            ])
        }
    }

    // MARK: - 美國 (依據 OPM Federal Holidays)
    private static func usaHolidays(year: Int) -> Set<DateComponents> {
        switch year {
        case 2025:
            return Set([
                makeDate(2025, 1, 1),   // New Year's Day
                makeDate(2025, 1, 20),  // MLK Day
                makeDate(2025, 2, 17),  // Presidents' Day
                makeDate(2025, 5, 26),  // Memorial Day
                makeDate(2025, 6, 19),  // Juneteenth
                makeDate(2025, 7, 4),   // Independence Day
                makeDate(2025, 9, 1),   // Labor Day
                makeDate(2025, 10, 13), // Columbus Day
                makeDate(2025, 11, 11), // Veterans Day
                makeDate(2025, 11, 27), // Thanksgiving
                makeDate(2025, 12, 25), // Christmas Day
            ])
        case 2026:
            return Set([
                makeDate(2026, 1, 1),   // New Year's Day
                makeDate(2026, 1, 19),  // MLK Day
                makeDate(2026, 2, 16),  // Presidents' Day
                makeDate(2026, 5, 25),  // Memorial Day
                makeDate(2026, 6, 19),  // Juneteenth
                makeDate(2026, 7, 3),   // Independence Day (observed, 7/4 is Sat)
                makeDate(2026, 9, 7),   // Labor Day
                makeDate(2026, 10, 12), // Columbus Day
                makeDate(2026, 11, 11), // Veterans Day
                makeDate(2026, 11, 26), // Thanksgiving
                makeDate(2026, 12, 25), // Christmas Day
            ])
        default:
            return Set([
                makeDate(year, 1, 1), makeDate(year, 1, 20),
                makeDate(year, 2, 17), makeDate(year, 5, 26),
                makeDate(year, 6, 19), makeDate(year, 7, 4),
                makeDate(year, 9, 1), makeDate(year, 10, 13),
                makeDate(year, 11, 11), makeDate(year, 11, 27),
                makeDate(year, 12, 25),
            ])
        }
    }

    // MARK: - 英國 (依據 GOV.UK Bank Holidays - England & Wales)
    private static func ukHolidays(year: Int) -> Set<DateComponents> {
        switch year {
        case 2025:
            return Set([
                makeDate(2025, 1, 1),   // New Year's Day
                makeDate(2025, 4, 18),  // Good Friday
                makeDate(2025, 4, 21),  // Easter Monday
                makeDate(2025, 5, 5),   // Early May Bank Holiday
                makeDate(2025, 5, 26),  // Spring Bank Holiday
                makeDate(2025, 8, 25),  // Summer Bank Holiday
                makeDate(2025, 12, 25), // Christmas Day
                makeDate(2025, 12, 26), // Boxing Day
            ])
        case 2026:
            return Set([
                makeDate(2026, 1, 1),   // New Year's Day
                makeDate(2026, 4, 3),   // Good Friday
                makeDate(2026, 4, 6),   // Easter Monday
                makeDate(2026, 5, 4),   // Early May Bank Holiday
                makeDate(2026, 5, 25),  // Spring Bank Holiday
                makeDate(2026, 8, 31),  // Summer Bank Holiday
                makeDate(2026, 12, 25), // Christmas Day
                makeDate(2026, 12, 28), // Boxing Day (observed, 12/26 is Sat)
            ])
        default:
            return Set([
                makeDate(year, 1, 1), makeDate(year, 5, 5),
                makeDate(year, 5, 26), makeDate(year, 8, 25),
                makeDate(year, 12, 25), makeDate(year, 12, 26),
            ])
        }
    }

    // MARK: - 德國 (全國性公定假期)
    private static func germanyHolidays(year: Int) -> Set<DateComponents> {
        switch year {
        case 2025:
            return Set([
                makeDate(2025, 1, 1),   // Neujahr
                makeDate(2025, 4, 18),  // Karfreitag
                makeDate(2025, 4, 21),  // Ostermontag
                makeDate(2025, 5, 1),   // Tag der Arbeit
                makeDate(2025, 5, 29),  // Christi Himmelfahrt
                makeDate(2025, 6, 9),   // Pfingstmontag
                makeDate(2025, 10, 3),  // Tag der Deutschen Einheit
                makeDate(2025, 12, 25), // 1. Weihnachtsfeiertag
                makeDate(2025, 12, 26), // 2. Weihnachtsfeiertag
            ])
        case 2026:
            return Set([
                makeDate(2026, 1, 1),   // Neujahr
                makeDate(2026, 4, 3),   // Karfreitag
                makeDate(2026, 4, 6),   // Ostermontag
                makeDate(2026, 5, 1),   // Tag der Arbeit
                makeDate(2026, 5, 14),  // Christi Himmelfahrt
                makeDate(2026, 5, 25),  // Pfingstmontag
                makeDate(2026, 10, 3),  // Tag der Deutschen Einheit
                makeDate(2026, 12, 25), // 1. Weihnachtsfeiertag
                makeDate(2026, 12, 26), // 2. Weihnachtsfeiertag
            ])
        default:
            return Set([
                makeDate(year, 1, 1), makeDate(year, 5, 1),
                makeDate(year, 10, 3), makeDate(year, 12, 25), makeDate(year, 12, 26),
            ])
        }
    }

    // MARK: - 法國 (11 jours fériés)
    private static func franceHolidays(year: Int) -> Set<DateComponents> {
        switch year {
        case 2025:
            return Set([
                makeDate(2025, 1, 1),   // Jour de l'An
                makeDate(2025, 4, 21),  // Lundi de Pâques
                makeDate(2025, 5, 1),   // Fête du Travail
                makeDate(2025, 5, 8),   // Victoire 1945
                makeDate(2025, 5, 29),  // Ascension
                makeDate(2025, 6, 9),   // Lundi de Pentecôte
                makeDate(2025, 7, 14),  // Fête nationale
                makeDate(2025, 8, 15),  // Assomption
                makeDate(2025, 11, 1),  // Toussaint
                makeDate(2025, 11, 11), // Armistice
                makeDate(2025, 12, 25), // Noël
            ])
        case 2026:
            return Set([
                makeDate(2026, 1, 1),   // Jour de l'An
                makeDate(2026, 4, 6),   // Lundi de Pâques
                makeDate(2026, 5, 1),   // Fête du Travail
                makeDate(2026, 5, 8),   // Victoire 1945
                makeDate(2026, 5, 14),  // Ascension
                makeDate(2026, 5, 25),  // Lundi de Pentecôte
                makeDate(2026, 7, 14),  // Fête nationale
                makeDate(2026, 8, 15),  // Assomption
                makeDate(2026, 11, 1),  // Toussaint
                makeDate(2026, 11, 11), // Armistice
                makeDate(2026, 12, 25), // Noël
            ])
        default:
            return Set([
                makeDate(year, 1, 1), makeDate(year, 5, 1), makeDate(year, 5, 8),
                makeDate(year, 7, 14), makeDate(year, 8, 15),
                makeDate(year, 11, 1), makeDate(year, 11, 11), makeDate(year, 12, 25),
            ])
        }
    }

    // MARK: - 中國 (依據國務院辦公廳通知)
    private static func chinaHolidays(year: Int) -> Set<DateComponents> {
        switch year {
        case 2025:
            return Set([
                makeDate(2025, 1, 1),   // 元旦
                makeDate(2025, 1, 28),  // 春節
                makeDate(2025, 1, 29),
                makeDate(2025, 1, 30),
                makeDate(2025, 1, 31),
                makeDate(2025, 2, 1),
                makeDate(2025, 2, 2),
                makeDate(2025, 2, 3),
                makeDate(2025, 2, 4),   // 春節8天
                makeDate(2025, 4, 4),   // 清明節
                makeDate(2025, 4, 5),
                makeDate(2025, 4, 6),
                makeDate(2025, 5, 1),   // 勞動節
                makeDate(2025, 5, 2),
                makeDate(2025, 5, 3),
                makeDate(2025, 5, 4),
                makeDate(2025, 5, 5),
                makeDate(2025, 5, 31),  // 端午節
                makeDate(2025, 6, 1),
                makeDate(2025, 6, 2),
                makeDate(2025, 10, 1),  // 國慶節+中秋節
                makeDate(2025, 10, 2),
                makeDate(2025, 10, 3),
                makeDate(2025, 10, 4),
                makeDate(2025, 10, 5),
                makeDate(2025, 10, 6),
                makeDate(2025, 10, 7),
                makeDate(2025, 10, 8),
            ])
        case 2026:
            return Set([
                makeDate(2026, 1, 1),   // 元旦
                makeDate(2026, 1, 2),
                makeDate(2026, 1, 3),
                makeDate(2026, 2, 15),  // 春節 (9天)
                makeDate(2026, 2, 16),
                makeDate(2026, 2, 17),
                makeDate(2026, 2, 18),
                makeDate(2026, 2, 19),
                makeDate(2026, 2, 20),
                makeDate(2026, 2, 21),
                makeDate(2026, 2, 22),
                makeDate(2026, 2, 23),
                makeDate(2026, 4, 4),   // 清明節
                makeDate(2026, 4, 5),
                makeDate(2026, 4, 6),
                makeDate(2026, 5, 1),   // 勞動節
                makeDate(2026, 5, 2),
                makeDate(2026, 5, 3),
                makeDate(2026, 5, 4),
                makeDate(2026, 5, 5),
                makeDate(2026, 6, 19),  // 端午節
                makeDate(2026, 6, 20),
                makeDate(2026, 6, 21),
                makeDate(2026, 9, 25),  // 中秋節
                makeDate(2026, 9, 26),
                makeDate(2026, 9, 27),
                makeDate(2026, 10, 1),  // 國慶節
                makeDate(2026, 10, 2),
                makeDate(2026, 10, 3),
                makeDate(2026, 10, 4),
                makeDate(2026, 10, 5),
                makeDate(2026, 10, 6),
                makeDate(2026, 10, 7),
                makeDate(2026, 10, 8),
            ])
        default:
            return Set([
                makeDate(year, 1, 1), makeDate(year, 5, 1),
                makeDate(year, 10, 1), makeDate(year, 10, 2), makeDate(year, 10, 3),
            ])
        }
    }

    // MARK: - 香港 (依據勞工處法定假日公告)
    private static func hongkongHolidays(year: Int) -> Set<DateComponents> {
        switch year {
        case 2025:
            return Set([
                makeDate(2025, 1, 1),   // 元旦
                makeDate(2025, 1, 29),  // 農曆年初一
                makeDate(2025, 1, 30),  // 農曆年初二
                makeDate(2025, 1, 31),  // 農曆年初三
                makeDate(2025, 4, 4),   // 清明節
                makeDate(2025, 4, 18),  // 耶穌受難節
                makeDate(2025, 4, 19),  // 耶穌受難節翌日
                makeDate(2025, 4, 21),  // 復活節星期一
                makeDate(2025, 5, 1),   // 勞動節
                makeDate(2025, 5, 5),   // 佛誕
                makeDate(2025, 5, 31),  // 端午節
                makeDate(2025, 7, 1),   // 香港特別行政區成立紀念日
                makeDate(2025, 10, 1),  // 國慶日
                makeDate(2025, 10, 7),  // 中秋節翌日
                makeDate(2025, 10, 29), // 重陽節
                makeDate(2025, 12, 25), // 聖誕節
                makeDate(2025, 12, 26), // 聖誕節後第一個周日
            ])
        case 2026:
            return Set([
                makeDate(2026, 1, 1),   // 元旦
                makeDate(2026, 2, 17),  // 農曆年初一
                makeDate(2026, 2, 18),  // 農曆年初二
                makeDate(2026, 2, 19),  // 農曆年初三
                makeDate(2026, 4, 3),   // 耶穌受難節
                makeDate(2026, 4, 4),   // 耶穌受難節翌日
                makeDate(2026, 4, 5),   // 清明節
                makeDate(2026, 4, 6),   // 復活節星期一
                makeDate(2026, 5, 1),   // 勞動節
                makeDate(2026, 5, 25),  // 佛誕翌日
                makeDate(2026, 6, 19),  // 端午節
                makeDate(2026, 7, 1),   // 香港特別行政區成立紀念日
                makeDate(2026, 9, 26),  // 中秋節翌日
                makeDate(2026, 10, 1),  // 國慶日
                makeDate(2026, 10, 19), // 重陽節(代休)
                makeDate(2026, 12, 25), // 聖誕節
                makeDate(2026, 12, 26), // 聖誕節後第一個周日
            ])
        default:
            return Set([
                makeDate(year, 1, 1), makeDate(year, 5, 1),
                makeDate(year, 7, 1), makeDate(year, 10, 1),
                makeDate(year, 12, 25), makeDate(year, 12, 26),
            ])
        }
    }

    // MARK: - 新加坡 (依據 MOM Gazetted Public Holidays)
    private static func singaporeHolidays(year: Int) -> Set<DateComponents> {
        switch year {
        case 2025:
            return Set([
                makeDate(2025, 1, 1),   // New Year's Day
                makeDate(2025, 1, 29),  // Chinese New Year
                makeDate(2025, 1, 30),  // Chinese New Year
                makeDate(2025, 3, 31),  // Hari Raya Puasa
                makeDate(2025, 4, 18),  // Good Friday
                makeDate(2025, 5, 1),   // Labour Day
                makeDate(2025, 5, 12),  // Vesak Day
                makeDate(2025, 6, 7),   // Hari Raya Haji
                makeDate(2025, 8, 9),   // National Day
                makeDate(2025, 10, 20), // Deepavali
                makeDate(2025, 12, 25), // Christmas Day
            ])
        case 2026:
            return Set([
                makeDate(2026, 1, 1),   // New Year's Day
                makeDate(2026, 2, 17),  // Chinese New Year
                makeDate(2026, 2, 18),  // Chinese New Year
                makeDate(2026, 3, 21),  // Hari Raya Puasa
                makeDate(2026, 4, 3),   // Good Friday
                makeDate(2026, 5, 1),   // Labour Day
                makeDate(2026, 5, 27),  // Hari Raya Haji
                makeDate(2026, 6, 1),   // Vesak Day (observed, 5/31 is Sun)
                makeDate(2026, 8, 10),  // National Day (observed, 8/9 is Sun)
                makeDate(2026, 11, 9),  // Deepavali (observed, 11/8 is Sun)
                makeDate(2026, 12, 25), // Christmas Day
            ])
        default:
            return Set([
                makeDate(year, 1, 1), makeDate(year, 5, 1),
                makeDate(year, 8, 9), makeDate(year, 12, 25),
            ])
        }
    }

    // MARK: - 加拿大 (依據 Canada.ca Federal Holidays)
    private static func canadaHolidays(year: Int) -> Set<DateComponents> {
        switch year {
        case 2025:
            return Set([
                makeDate(2025, 1, 1),   // New Year's Day
                makeDate(2025, 4, 18),  // Good Friday
                makeDate(2025, 4, 21),  // Easter Monday
                makeDate(2025, 5, 19),  // Victoria Day
                makeDate(2025, 7, 1),   // Canada Day
                makeDate(2025, 9, 1),   // Labour Day
                makeDate(2025, 9, 30),  // National Day for Truth and Reconciliation
                makeDate(2025, 10, 13), // Thanksgiving Day
                makeDate(2025, 11, 11), // Remembrance Day
                makeDate(2025, 12, 25), // Christmas Day
                makeDate(2025, 12, 26), // Boxing Day
            ])
        case 2026:
            return Set([
                makeDate(2026, 1, 1),   // New Year's Day
                makeDate(2026, 4, 3),   // Good Friday
                makeDate(2026, 4, 6),   // Easter Monday
                makeDate(2026, 5, 18),  // Victoria Day
                makeDate(2026, 7, 1),   // Canada Day
                makeDate(2026, 9, 7),   // Labour Day
                makeDate(2026, 9, 30),  // National Day for Truth and Reconciliation
                makeDate(2026, 10, 12), // Thanksgiving Day
                makeDate(2026, 11, 11), // Remembrance Day
                makeDate(2026, 12, 25), // Christmas Day
                makeDate(2026, 12, 28), // Boxing Day (observed, 12/26 is Sat)
            ])
        default:
            return Set([
                makeDate(year, 1, 1), makeDate(year, 7, 1),
                makeDate(year, 9, 1), makeDate(year, 9, 30),
                makeDate(year, 11, 11), makeDate(year, 12, 25), makeDate(year, 12, 26),
            ])
        }
    }

    // MARK: - 澳洲 (依據 Fair Work National Public Holidays)
    private static func australiaHolidays(year: Int) -> Set<DateComponents> {
        switch year {
        case 2025:
            return Set([
                makeDate(2025, 1, 1),   // New Year's Day
                makeDate(2025, 1, 27),  // Australia Day
                makeDate(2025, 4, 18),  // Good Friday
                makeDate(2025, 4, 19),  // Saturday before Easter Sunday
                makeDate(2025, 4, 21),  // Easter Monday
                makeDate(2025, 4, 25),  // ANZAC Day
                makeDate(2025, 6, 9),   // Queen's Birthday
                makeDate(2025, 12, 25), // Christmas Day
                makeDate(2025, 12, 26), // Boxing Day
            ])
        case 2026:
            return Set([
                makeDate(2026, 1, 1),   // New Year's Day
                makeDate(2026, 1, 26),  // Australia Day
                makeDate(2026, 4, 3),   // Good Friday
                makeDate(2026, 4, 4),   // Saturday before Easter Sunday
                makeDate(2026, 4, 6),   // Easter Monday
                makeDate(2026, 4, 25),  // ANZAC Day
                makeDate(2026, 6, 8),   // King's Birthday
                makeDate(2026, 12, 25), // Christmas Day
                makeDate(2026, 12, 26), // Boxing Day
            ])
        default:
            return Set([
                makeDate(year, 1, 1), makeDate(year, 1, 26),
                makeDate(year, 4, 25), makeDate(year, 12, 25), makeDate(year, 12, 26),
            ])
        }
    }
}
