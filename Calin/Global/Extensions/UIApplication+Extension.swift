//
//  UIApplication+Ext.swift
//  Calin
//
//  Created by shinisac on 7/21/25.
//

import UIKit

extension UIApplication {
    /// 최상위 UIViewController Return
    static var topMostViewController: UIViewController? {
        guard let keyWindow = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow }),
              let root = keyWindow.rootViewController else {
            return nil
        }
        return topMostViewController(from: root)
    }

    private static func topMostViewController(from vc: UIViewController) -> UIViewController {
        if let presented = vc.presentedViewController {
            return topMostViewController(from: presented)
        }
        if let nav = vc as? UINavigationController, let visible = nav.visibleViewController {
            return topMostViewController(from: visible)
        }
        if let tab = vc as? UITabBarController, let selected = tab.selectedViewController {
            return topMostViewController(from: selected)
        }
        return vc
    }
}
