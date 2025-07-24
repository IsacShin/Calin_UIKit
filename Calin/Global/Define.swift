//
//  Define.swift
//  Calin
//
//  Created by shinisac on 7/22/25.
//

import Foundation
import UIKit

// MARK: - App Constants
enum Define {
    
    // MARK: - App Info
    enum AppInfo {
        static let appName = "Calin"
        static let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        static let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        static let bundleIdentifier = Bundle.main.bundleIdentifier ?? "com.isac.Calin"
    }
    
    // MARK: - Device Info
    enum Device {
        private static let uuidKey = "com.isac.\(AppInfo.appName).deviceUUID"
        
        static let uuid: String = {
            if let saved = KeychainHelper.load(key: uuidKey) {
                return saved
            } else {
                let newUUID = UUID().uuidString
                KeychainHelper.save(key: uuidKey, value: newUUID)
                return newUUID
            }
        }()
        
        static let isIpad = UIDevice.current.userInterfaceIdiom == .pad
        
        // ✅ Screen size
        static let screenBounds = UIScreen.main.bounds
        static let screenWidth = UIScreen.main.bounds.width
        static let screenHeight = UIScreen.main.bounds.height
    }
    
    // MARK: - UI Sizes
    enum Size {
        static let cornerRadius: CGFloat = 12
        static let padding: CGFloat = 16
        static let iconSize: CGFloat = 24
    }
    
    // MARK: - Colors
    enum ColorSet {
        static let primary = UIColor(named: "PrimaryColor") ?? .systemBlue
        static let secondary = UIColor(named: "SecondaryColor") ?? .systemGray
        static let background = UIColor(named: "BackgroundColor") ?? .white
        static let text = UIColor(named: "TextColor") ?? .label
    }
    
    // MARK: - URLs
    enum URLSet {
        static let baseURL = URL(string: "https://api.yourapp.com")!
        static let termsOfService = URL(string: "https://yourapp.com/terms")!
        static let privacyPolicy = URL(string: "https://yourapp.com/privacy")!
    }
}
