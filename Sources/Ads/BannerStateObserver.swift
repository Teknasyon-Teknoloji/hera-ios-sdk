//
//  BannerStateObserver.swift
//  HeraSDK
//
//  Created by Ali Ammar Hilal on 8.04.2021.
//

import AMRSDK

/// The banner ads doesnt provide full life cycle events. `BannerStateObserver`
/// tries to observe those event and notify the intersted adapter about it.
final class BannerStateObserver {
    
    /// A call back triggered when a banner has shown.
    static var bannerDidShowHandler: (() -> Void)?
    
    /// A call back triggered in case a banner failed to show,
    static var bannerDidFalilToShowHandler: ((_ error: Error) -> Void)?
    
    /// Notifies the interested adaper about the current banner state
    /// - Parameter reult: The banner state result. `Void` if
    /// it succeds or `HeraError` if it falis.
    static func notify(with result: Result<Void, HeraError>) {
        switch result {
        case .success:
            bannerDidShowHandler?()
        case .failure(let error):
            bannerDidFalilToShowHandler?(error)
        }
    }
}

// MARK: - AMR
extension AMRBannerView {
    
    @objc dynamic func swizzled_viewWillMove(toWindow newWindow: UIWindow?) {
        if newWindow != nil || superview?.isHidden == false {
            BannerStateObserver.notify(with: .success(()))
        } else {
			BannerStateObserver.notify(with: .failure(.viewDoesNotHaveVisibleUIWindow))
        }
        
        swizzled_viewWillMove(toWindow: newWindow)
    }

    static func observeLifeCycles() {
        let originalSelector = #selector(self.willMove(toWindow:))
        let swizzledSelector = #selector(self.swizzled_viewWillMove(toWindow:))
		guard let originalMethod = class_getInstanceMethod(self, originalSelector) else { return }
		guard let swizzledMethod = class_getInstanceMethod(self, swizzledSelector) else { return }
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
}
