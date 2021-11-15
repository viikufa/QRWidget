//
//  ScanCodeInteractor.swift
//  QRWidget
//
//  Created by Vitaliy on 15.11.2021.
//

import Foundation
import WidgetKit

private protocol AnyOptional {
    var isNil: Bool { get }
}

extension Optional: AnyOptional {
    var isNil: Bool { self == nil }
}

@propertyWrapper
struct UserDefault<T> {
    private let userDefaults = UserDefaults(suiteName: "group.user-defaults")!
    let key: Key
    let defaultValue: T

    init(_ key: Key, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
            get {
                return userDefaults.value(forKey: key.rawValue) as? T ?? defaultValue
            }
            set {
                if let optional = newValue as? AnyOptional, optional.isNil {
                    userDefaults.removeObject(forKey: key.rawValue)
                    WidgetCenter.shared.reloadAllTimelines()
                } else {
                    userDefaults.setValue(newValue, forKey: key.rawValue)
                    userDefaults.setValue(Date(), forKey: UserDefault.Key.lastUpdate.rawValue)
                    WidgetCenter.shared.reloadAllTimelines()
                }
            }
        }
}

extension UserDefault {
    enum Key: String {
        case qrCode = "QRCode"
        case lastUpdate = "LastUpdate"
    }
}

final class UserDefaultsService {
    @UserDefault(.qrCode, defaultValue: nil)
    static var code: String?


    @UserDefault(.lastUpdate, defaultValue: Date().addingTimeInterval(60))
    static var lastUpdate: Date
}
