//
//  Array+Extension.swift
//  Calin
//
//  Created by shinisac on 7/23/25.
//

import Foundation

public extension Array {
    subscript (safe index: Int) -> Element? {
        guard index > -1 else {
            return nil
        }
        return index < count ? self[index] : nil
    }
}
