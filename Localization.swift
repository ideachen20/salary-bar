import Foundation

// MARK: - 支援的語言
enum AppLanguage: String, CaseIterable, Codable {
    case zhHant = "zh-Hant"  // 繁體中文
    case zhHans = "zh-Hans"  // 簡體中文
    case ja = "ja"           // 日本語
    case ko = "ko"           // 한국어
    case en = "en"           // English
    case de = "de"           // Deutsch
    case fr = "fr"           // Français

    var displayName: String {
        switch self {
        case .zhHant: return "繁體中文"
        case .zhHans: return "简体中文"
        case .ja: return "日本語"
        case .ko: return "한국어"
        case .en: return "English"
        case .de: return "Deutsch"
        case .fr: return "Français"
        }
    }
}

// MARK: - 國家對應語言
extension Country {
    var defaultLanguage: AppLanguage {
        switch self {
        case .taiwan, .hongkong: return .zhHant
        case .china: return .zhHans
        case .singapore: return .en
        case .japan: return .ja
        case .korea: return .ko
        case .usa, .canada, .australia, .uk: return .en
        case .germany: return .de
        case .france: return .fr
        }
    }

    /// 國家名稱（根據當前語言顯示）
    func localizedName(for lang: AppLanguage) -> String {
        switch lang {
        case .zhHant:
            switch self {
            case .taiwan: return "台灣"
            case .japan: return "日本"
            case .korea: return "韓國"
            case .usa: return "美國"
            case .uk: return "英國"
            case .germany: return "德國"
            case .france: return "法國"
            case .china: return "中國"
            case .hongkong: return "香港"
            case .singapore: return "新加坡"
            case .canada: return "加拿大"
            case .australia: return "澳洲"
            }
        case .zhHans:
            switch self {
            case .taiwan: return "台湾"
            case .japan: return "日本"
            case .korea: return "韩国"
            case .usa: return "美国"
            case .uk: return "英国"
            case .germany: return "德国"
            case .france: return "法国"
            case .china: return "中国"
            case .hongkong: return "香港"
            case .singapore: return "新加坡"
            case .canada: return "加拿大"
            case .australia: return "澳洲"
            }
        case .ja:
            switch self {
            case .taiwan: return "台湾"
            case .japan: return "日本"
            case .korea: return "韓国"
            case .usa: return "アメリカ"
            case .uk: return "イギリス"
            case .germany: return "ドイツ"
            case .france: return "フランス"
            case .china: return "中国"
            case .hongkong: return "香港"
            case .singapore: return "シンガポール"
            case .canada: return "カナダ"
            case .australia: return "オーストラリア"
            }
        case .ko:
            switch self {
            case .taiwan: return "대만"
            case .japan: return "일본"
            case .korea: return "한국"
            case .usa: return "미국"
            case .uk: return "영국"
            case .germany: return "독일"
            case .france: return "프랑스"
            case .china: return "중국"
            case .hongkong: return "홍콩"
            case .singapore: return "싱가포르"
            case .canada: return "캐나다"
            case .australia: return "호주"
            }
        case .en:
            switch self {
            case .taiwan: return "Taiwan"
            case .japan: return "Japan"
            case .korea: return "South Korea"
            case .usa: return "United States"
            case .uk: return "United Kingdom"
            case .germany: return "Germany"
            case .france: return "France"
            case .china: return "China"
            case .hongkong: return "Hong Kong"
            case .singapore: return "Singapore"
            case .canada: return "Canada"
            case .australia: return "Australia"
            }
        case .de:
            switch self {
            case .taiwan: return "Taiwan"
            case .japan: return "Japan"
            case .korea: return "Südkorea"
            case .usa: return "USA"
            case .uk: return "Großbritannien"
            case .germany: return "Deutschland"
            case .france: return "Frankreich"
            case .china: return "China"
            case .hongkong: return "Hongkong"
            case .singapore: return "Singapur"
            case .canada: return "Kanada"
            case .australia: return "Australien"
            }
        case .fr:
            switch self {
            case .taiwan: return "Taïwan"
            case .japan: return "Japon"
            case .korea: return "Corée du Sud"
            case .usa: return "États-Unis"
            case .uk: return "Royaume-Uni"
            case .germany: return "Allemagne"
            case .france: return "France"
            case .china: return "Chine"
            case .hongkong: return "Hong Kong"
            case .singapore: return "Singapour"
            case .canada: return "Canada"
            case .australia: return "Australie"
            }
        }
    }
}

// MARK: - 本地化字串
struct L10n {
    let lang: AppLanguage

    // MARK: - App 標題
    var appTitle: String { "💰 SalaryBar" }

    // MARK: - 歡迎頁面
    var welcomeSubtitle: String {
        switch lang {
        case .zhHant: return "看看今天上班賺了多少錢"
        case .zhHans: return "看看今天上班赚了多少钱"
        case .ja: return "今日いくら稼いだか見てみよう"
        case .ko: return "오늘 얼마나 벌었는지 확인하세요"
        case .en: return "See how much you've earned today"
        case .de: return "Sieh wie viel du heute verdient hast"
        case .fr: return "Voyez combien vous avez gagné aujourd'hui"
        }
    }

    var selectCountry: String {
        switch lang {
        case .zhHant: return "所在國家/地區"
        case .zhHans: return "所在国家/地区"
        case .ja: return "国/地域"
        case .ko: return "국가/지역"
        case .en: return "Country/Region"
        case .de: return "Land/Region"
        case .fr: return "Pays/Région"
        }
    }

    var monthlySalaryLabel: String {
        switch lang {
        case .zhHant: return "月薪"
        case .zhHans: return "月薪"
        case .ja: return "月給"
        case .ko: return "월급"
        case .en: return "Monthly Salary"
        case .de: return "Monatsgehalt"
        case .fr: return "Salaire mensuel"
        }
    }

    var enterSalary: String {
        switch lang {
        case .zhHant: return "輸入月薪"
        case .zhHans: return "输入月薪"
        case .ja: return "月給を入力"
        case .ko: return "월급 입력"
        case .en: return "Enter salary"
        case .de: return "Gehalt eingeben"
        case .fr: return "Entrer le salaire"
        }
    }

    var startCalculating: String {
        switch lang {
        case .zhHant: return "開始計算"
        case .zhHans: return "开始计算"
        case .ja: return "計算開始"
        case .ko: return "계산 시작"
        case .en: return "Start"
        case .de: return "Berechnung starten"
        case .fr: return "Commencer"
        }
    }

    // MARK: - 儀表板
    var earnedToday: String {
        switch lang {
        case .zhHant: return "今日已賺"
        case .zhHans: return "今日已赚"
        case .ja: return "本日の収入"
        case .ko: return "오늘 번 금액"
        case .en: return "Earned Today"
        case .de: return "Heute verdient"
        case .fr: return "Gagné aujourd'hui"
        }
    }

    var working: String {
        switch lang {
        case .zhHant: return "🟢 工作中"
        case .zhHans: return "🟢 工作中"
        case .ja: return "🟢 勤務中"
        case .ko: return "🟢 근무 중"
        case .en: return "🟢 Working"
        case .de: return "🟢 Arbeitet"
        case .fr: return "🟢 En cours"
        }
    }

    var dayCompleted: String {
        switch lang {
        case .zhHant: return "✅ 今日已完成"
        case .zhHans: return "✅ 今日已完成"
        case .ja: return "✅ 本日完了"
        case .ko: return "✅ 오늘 완료"
        case .en: return "✅ Day Complete"
        case .de: return "✅ Tag abgeschlossen"
        case .fr: return "✅ Journée terminée"
        }
    }

    var notWorking: String {
        switch lang {
        case .zhHant: return "⏸ 非工作時間"
        case .zhHans: return "⏸ 非工作时间"
        case .ja: return "⏸ 勤務時間外"
        case .ko: return "⏸ 근무 외 시간"
        case .en: return "⏸ Off Hours"
        case .de: return "⏸ Außerhalb der Arbeitszeit"
        case .fr: return "⏸ Hors heures de travail"
        }
    }

    var monthlySalaryInfo: String { monthlySalaryLabel }

    var workingDaysThisMonth: String {
        switch lang {
        case .zhHant: return "本月工作日"
        case .zhHans: return "本月工作日"
        case .ja: return "今月の稼働日"
        case .ko: return "이번 달 근무일"
        case .en: return "Work Days"
        case .de: return "Arbeitstage"
        case .fr: return "Jours ouvrés"
        }
    }

    var daysUnit: String {
        switch lang {
        case .zhHant: return "天"
        case .zhHans: return "天"
        case .ja: return "日"
        case .ko: return "일"
        case .en: return "days"
        case .de: return "Tage"
        case .fr: return "jours"
        }
    }

    var dailySalary: String {
        switch lang {
        case .zhHant: return "日薪"
        case .zhHans: return "日薪"
        case .ja: return "日給"
        case .ko: return "일급"
        case .en: return "Daily"
        case .de: return "Tagesgehalt"
        case .fr: return "Journalier"
        }
    }

    var hourlySalary: String {
        switch lang {
        case .zhHant: return "時薪"
        case .zhHans: return "时薪"
        case .ja: return "時給"
        case .ko: return "시급"
        case .en: return "Hourly"
        case .de: return "Stundenlohn"
        case .fr: return "Horaire"
        }
    }

    var perMinute: String {
        switch lang {
        case .zhHant: return "每分鐘"
        case .zhHans: return "每分钟"
        case .ja: return "毎分"
        case .ko: return "분당"
        case .en: return "Per Minute"
        case .de: return "Pro Minute"
        case .fr: return "Par minute"
        }
    }

    var quit: String {
        switch lang {
        case .zhHant: return "結束"
        case .zhHans: return "退出"
        case .ja: return "終了"
        case .ko: return "종료"
        case .en: return "Quit"
        case .de: return "Beenden"
        case .fr: return "Quitter"
        }
    }

    // MARK: - 設定頁面
    var settings: String {
        switch lang {
        case .zhHant: return "設定"
        case .zhHans: return "设置"
        case .ja: return "設定"
        case .ko: return "설정"
        case .en: return "Settings"
        case .de: return "Einstellungen"
        case .fr: return "Paramètres"
        }
    }

    var back: String {
        switch lang {
        case .zhHant: return "返回"
        case .zhHans: return "返回"
        case .ja: return "戻る"
        case .ko: return "뒤로"
        case .en: return "Back"
        case .de: return "Zurück"
        case .fr: return "Retour"
        }
    }

    var workHoursPerDay: String {
        switch lang {
        case .zhHant: return "每日工時"
        case .zhHans: return "每日工时"
        case .ja: return "1日の労働時間"
        case .ko: return "일일 근무시간"
        case .en: return "Hours/Day"
        case .de: return "Stunden/Tag"
        case .fr: return "Heures/Jour"
        }
    }

    var hoursUnit: String {
        switch lang {
        case .zhHant: return "小時"
        case .zhHans: return "小时"
        case .ja: return "時間"
        case .ko: return "시간"
        case .en: return "hours"
        case .de: return "Stunden"
        case .fr: return "heures"
        }
    }

    var workStartTime: String {
        switch lang {
        case .zhHant: return "上班開始時間"
        case .zhHans: return "上班开始时间"
        case .ja: return "始業時刻"
        case .ko: return "출근 시간"
        case .en: return "Start Time"
        case .de: return "Arbeitsbeginn"
        case .fr: return "Heure de début"
        }
    }

    var saveSettings: String {
        switch lang {
        case .zhHant: return "儲存設定"
        case .zhHans: return "保存设置"
        case .ja: return "設定を保存"
        case .ko: return "설정 저장"
        case .en: return "Save"
        case .de: return "Speichern"
        case .fr: return "Enregistrer"
        }
    }

    var language: String {
        switch lang {
        case .zhHant: return "介面語言"
        case .zhHans: return "界面语言"
        case .ja: return "表示言語"
        case .ko: return "표시 언어"
        case .en: return "Language"
        case .de: return "Sprache"
        case .fr: return "Langue"
        }
    }

    // MARK: - Menu Bar
    var setupSalary: String {
        switch lang {
        case .zhHant: return "設定薪資"
        case .zhHans: return "设定薪资"
        case .ja: return "給与を設定"
        case .ko: return "급여 설정"
        case .en: return "Set Salary"
        case .de: return "Gehalt einstellen"
        case .fr: return "Définir salaire"
        }
    }

    var resting: String {
        switch lang {
        case .zhHant: return "休息中"
        case .zhHans: return "休息中"
        case .ja: return "休憩中"
        case .ko: return "휴식 중"
        case .en: return "Off"
        case .de: return "Pause"
        case .fr: return "Repos"
        }
    }
}
