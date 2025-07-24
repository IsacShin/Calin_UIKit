//
//  Font+Ext.swift
//  Calin
//
//  Created by shinisac on 7/22/25.
//

import Foundation
import UIKit

extension UIFont {
    static func nanumDaHaeng(size: CGFloat) -> UIFont {
        return UIFont(name: "NanumDaHaengCe", size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
