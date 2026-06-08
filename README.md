# 💰 SalaryBar - macOS Menu Bar 薪資計算器

**讓打工人即時看到今天上班賺了多少錢！**

SalaryBar 是一款 macOS Menu Bar 應用程式，它會根據你的月薪、所在國家的公定假期，自動計算出你的日薪和時薪，並在 Menu Bar 上即時顯示今天已經賺到的金額。

---

## 功能特色

- **即時薪資計算**：每秒更新，看著錢一點一點增加，上班更有動力
- **智慧工作日計算**：自動扣除週末和所在國家的公定假期
- **支援 12 個國家/地區**：台灣、日本、韓國、美國、英國、德國、法國、中國、香港、新加坡、加拿大、澳洲
- **自訂工作時間**：可設定每日工時和上班開始時間
- **進度條顯示**：直觀看到今天的工作進度
- **Menu Bar 常駐**：不佔用 Dock 空間，輕量運行
- **開機自動啟動**：設定後每天自動運行

---

## 系統需求

- macOS 13.0 (Ventura) 或更新版本
- Xcode Command Line Tools（僅編譯時需要）

---

## 安裝方式

### 方法一：使用編譯腳本（推薦）

1. **安裝 Xcode Command Line Tools**（如果尚未安裝）：

```bash
xcode-select --install
```

2. **下載專案並編譯**：

```bash
cd SalaryBar
chmod +x build.sh
./build.sh
```

3. 編譯完成後，應用程式會自動開啟。你也可以在 `build/SalaryBar.app` 找到它。

### 方法二：使用 Xcode 開啟專案

1. 用 Xcode 開啟 `SalaryBar.xcodeproj`
2. 選擇 "My Mac" 作為目標裝置
3. 按下 `Cmd + R` 執行

### 方法三：使用 Swift Package Manager

```bash
cd SalaryBar
swift build -c release
```

---

## 使用說明

### 首次啟動

1. 啟動後，Menu Bar 會出現 `💰 設定薪資` 的圖示
2. 點擊後選擇你的**所在國家/地區**
3. 輸入你的**月薪**金額
4. 點擊「開始計算」

### 日常使用

- **工作時間內**：Menu Bar 顯示 `💰 $XX,XXX`（即時累計金額）
- **非工作時間**：Menu Bar 顯示 `💰 休息中`
- **下班後**：Menu Bar 顯示 `💰 $XX,XXX ✓`（今日總收入）

### 設定修改

點擊 Menu Bar 圖示 → 點擊齒輪圖示 ⚙️ → 修改設定 → 儲存

可調整項目：
- 所在國家/地區
- 月薪金額
- 每日工時（4-12 小時）
- 上班開始時間

---

## 開機自動啟動

1. 開啟「系統設定」
2. 前往「一般」→「登入項目」
3. 點擊「+」加入 SalaryBar.app

---

## 支援的國家/地區與假期

| 國家/地區 | 貨幣 | 公定假期天數 (約) |
|-----------|------|------------------|
| 台灣 🇹🇼 | NT$ | 12 天 |
| 日本 🇯🇵 | ¥ | 16 天 |
| 韓國 🇰🇷 | ₩ | 15 天 |
| 美國 🇺🇸 | $ | 11 天 |
| 英國 🇬🇧 | £ | 8 天 |
| 德國 🇩🇪 | € | 9 天 |
| 法國 🇫🇷 | € | 11 天 |
| 中國 🇨🇳 | ¥ | 11 天 |
| 香港 🇭🇰 | $ | 17 天 |
| 新加坡 🇸🇬 | $ | 11 天 |
| 加拿大 🇨🇦 | $ | 11 天 |
| 澳洲 🇦🇺 | $ | 8 天 |

---

## 計算邏輯

```
本月工作日 = 本月總天數 - 週末天數 - 公定假期天數（落在工作日的）
日薪 = 月薪 ÷ 本月工作日
時薪 = 日薪 ÷ 每日工時
每秒薪資 = 時薪 ÷ 3600

今日已賺 = (當前時間 - 上班時間) × 每秒薪資
```

---

## 專案結構

```
SalaryBar/
├── SalaryBar/
│   ├── SalaryBarApp.swift      # App 入口 + UI 視圖
│   ├── SalaryCalculator.swift  # 薪資計算引擎
│   └── HolidayData.swift       # 各國公定假期資料
├── SalaryBar.xcodeproj/        # Xcode 專案配置
├── Package.swift               # Swift Package Manager 配置
├── build.sh                    # 一鍵編譯腳本
├── build-universal.sh          # 通用架構編譯腳本
└── README.md                   # 使用說明
```

---

## 技術架構

- **語言**：Swift 5.9
- **UI 框架**：SwiftUI (MenuBarExtra)
- **最低系統版本**：macOS 13.0
- **架構**：MVVM
- **資料儲存**：UserDefaults
- **更新頻率**：每秒更新一次

---

## 授權

MIT License - 自由使用、修改和分發。
