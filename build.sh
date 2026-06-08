#!/bin/bash

# SalaryBar - macOS Menu Bar 薪資計算器
# 一鍵編譯腳本 (多語言版)

set -e

echo "🔨 SalaryBar Build Script"
echo "========================"

# 檢查 Swift 是否可用
if ! command -v swiftc &> /dev/null; then
    echo "❌ Error: Swift compiler not found"
    echo "Please install Xcode Command Line Tools:"
    echo "  xcode-select --install"
    exit 1
fi

echo "✅ Swift compiler ready"

# 建立輸出目錄
BUILD_DIR="$(pwd)/build"
APP_DIR="$BUILD_DIR/SalaryBar.app"
CONTENTS_DIR="$APP_DIR/Contents"
MACOS_DIR="$CONTENTS_DIR/MacOS"
RESOURCES_DIR="$CONTENTS_DIR/Resources"

rm -rf "$BUILD_DIR"
mkdir -p "$MACOS_DIR"
mkdir -p "$RESOURCES_DIR"

echo "📦 Compiling..."

# 編譯 Swift 源碼 (包含 Localization.swift)
swiftc \
    -O \
    -target arm64-apple-macos13.0 \
    -sdk $(xcrun --show-sdk-path) \
    -parse-as-library \
    -framework SwiftUI \
    -framework AppKit \
    -framework Foundation \
    SalaryBar/SalaryBarApp.swift \
    SalaryBar/SalaryCalculator.swift \
    SalaryBar/HolidayData.swift \
    SalaryBar/Localization.swift \
    -o "$MACOS_DIR/SalaryBar"

echo "✅ Build successful"

# 建立 Info.plist
cat > "$CONTENTS_DIR/Info.plist" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>en</string>
    <key>CFBundleExecutable</key>
    <string>SalaryBar</string>
    <key>CFBundleIconFile</key>
    <string>AppIcon</string>
    <key>CFBundleIdentifier</key>
    <string>com.salarybar.app</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>SalaryBar</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.1</string>
    <key>CFBundleVersion</key>
    <string>2</string>
    <key>LSApplicationCategoryType</key>
    <string>public.app-category.utilities</string>
    <key>LSMinimumSystemVersion</key>
    <string>13.0</string>
    <key>LSUIElement</key>
    <true/>
    <key>NSHumanReadableCopyright</key>
    <string>Copyright © 2024 SalaryBar. All rights reserved.</string>
</dict>
</plist>
EOF

echo "✅ Info.plist created"
echo ""
echo "🎉 Build complete!"
echo "📍 App location: $APP_DIR"
echo ""
echo "Opening app..."
open "$APP_DIR"
