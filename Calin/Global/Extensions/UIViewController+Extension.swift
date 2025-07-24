//
//  UIViewController+Ext.swift
//  Calin
//
//  Created by shinisac on 7/21/25.
//

import UIKit

extension UIViewController {
    /// Returns a viewController of type T from the storyboard with the specified name.
    static func getViewController<T: UIViewController>(fromStoryboard name: String? = nil) -> T {
        // storyboard 이름이 nil이면 클래스 이름 사용
        let storyboardName = name ?? String(describing: self)
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        
        let identifier = String(describing: self)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as? T else {
            fatalError("Could not instantiate view controller with identifier \(identifier) from storyboard \(storyboardName)")
        }
        return viewController
    }
    
    static func instantiateFromNib() -> Self {
        return Self.init(nibName: String(describing: Self.self), bundle: nil)
    }
    
    static var nibName: String {
        return String(describing: Self.self)
    }
}
