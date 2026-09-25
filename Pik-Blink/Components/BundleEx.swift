//
//  BundleEx.swift
//  Pik-Blink
//
//  Created by Arnau on 25/09/2026.
//

import Foundation
import ObjectiveC

private var bundleKey: UInt8 = 0

func localized(_ key: String.LocalizationValue) -> String {
    let stored = UserDefaults.standard.string(forKey: "appLanguage") ?? AppLanguage.system.rawValue
    let locale = AppLanguage(rawValue: stored)?.locale ?? .autoupdatingCurrent
    return String(localized: key, locale: locale)
}

final class BundleEx: Bundle, @unchecked Sendable {
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        print("🔍 localizedString called for key:", key)

        guard let path = objc_getAssociatedObject(self, &bundleKey) as? String,
              let bundle = Bundle(path: path) else {
            print("⚠️ no path found, fallback to super")
            return super.localizedString(forKey: key, value: value, table: tableName)
        }

        print("✅ using bundle at path:", path)
        return bundle.localizedString(forKey: key, value: value, table: tableName)
    }
}

extension Bundle {
    static func setLanguage(_ languageCode: String?) {
        object_setClass(Bundle.main, BundleEx.self)

        guard let languageCode,
              let path = Bundle.main.path(forResource: languageCode, ofType: "lproj") else {
            print("🌐 setLanguage(nil) — usando idioma del sistema")
            objc_setAssociatedObject(Bundle.main, &bundleKey, nil, .OBJC_ASSOCIATION_RETAIN)
            return
        }

        print("🌐 setLanguage(\(languageCode)) — path:", path)
        objc_setAssociatedObject(Bundle.main, &bundleKey, path, .OBJC_ASSOCIATION_RETAIN)
    }
}
