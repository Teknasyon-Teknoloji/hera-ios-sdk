//
//  UIKit+extensions.swift
//  HeraSDK
//
//  Created by Ali Ammar Hilal on 16.04.2021.
//

import UIKit

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

extension UIView {
    func fillSuperview(padding: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        guard let superviewTopAnchor = superview?.topAnchor,
            let superviewBottomAnchor = superview?.bottomAnchor,
            let superviewLeadingAnchor = superview?.leadingAnchor,
            let superviewTrailingAnchor = superview?.trailingAnchor else { return }
        let top = self.topAnchor.constraint(equalTo: superviewTopAnchor, constant: padding.top)
        let bottom = self.bottomAnchor.constraint(equalTo: superviewBottomAnchor, constant: padding.bottom)
        let leading = self.leadingAnchor.constraint(equalTo: superviewLeadingAnchor, constant: padding.left)
        let trailing = self.trailingAnchor.constraint(equalTo: superviewTrailingAnchor, constant: padding.right)
        [top, bottom, leading, trailing].forEach { $0.isActive = true }
    }
}
