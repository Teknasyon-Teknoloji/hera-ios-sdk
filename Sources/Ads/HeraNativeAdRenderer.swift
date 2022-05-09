//
//  HeraNativeAdRenderer.swift
//  HeraSDK
//
//  Created by Ali Ammar Hilal on 6.09.2021.
//

import UIKit
import AMRSDK

public protocol HeraNativeAdRenderer: AnyObject { }

open class DefaultNativeRenderer: UIView, HeraNativeAdRenderer {
 
    @IBOutlet weak var LBLTitle: UILabel!
    @IBOutlet weak var LBLDescription: UILabel!
    @IBOutlet weak var LBLCallToAction: UILabel!
    @IBOutlet weak var IMGIcon: UIImageView!
    @IBOutlet weak var IMGCover: UIImageView!
    @IBOutlet weak var IMGCoverBG: UIImageView!
    @IBOutlet weak var IMGPrivacyIcon: UIImageView!
    @IBOutlet weak var BTNClick: UIButton!
    @IBOutlet weak var BTNClickFB: UIButton!
    @IBOutlet weak var trackingView: UIView!
    
    static var nibName: String = ""
    
    public func nativeMainTextLabel() -> UILabel! {
        LBLDescription
    }
    
    public func nativeCallToActionTextLabel() -> UILabel! {
        LBLCallToAction
    }
    
    public func nativeSponsoredByCompanyTextLabel() -> UILabel! {
        .init()
    }
    
    public func nativeTitleTextLabel() -> UILabel! {
        LBLTitle
    }
    
    public func nativeIconImageView() -> UIImageView! {
        return IMGIcon
    }
    
    public func nativeMainImageView() -> UIImageView! {
        return IMGCoverBG
    }
    
    public func nativePrivacyInformationIconImageView() -> UIImageView! {
        return IMGPrivacyIcon
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        fromNib()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        fromNib()
    }
    
    func fromNib() {
        guard !DefaultNativeRenderer.nibName.isEmpty else { return }
        guard let v = UINib(nibName: DefaultNativeRenderer.nibName, bundle: .main).instantiate(withOwner: self, options: nil).first as? UIView else { return }
        self.addSubview(v)
        v.fillSuperview()
    }
}

public extension UICollectionView {
    func reloadAdsAndKeepOffset() {
        // stop scrolling
        setContentOffset(contentOffset, animated: false)
        
        // calculate the offset and reloadData
        let beforeContentSize = contentSize
        reloadData()
        layoutIfNeeded()
        let afterContentSize = contentSize
        
        // reset the contentOffset after data is updated
        let xOffset = contentOffset.x + (afterContentSize.width - beforeContentSize.width)
        let yOffset = contentOffset.y + (afterContentSize.height - beforeContentSize.height)
        let newOffset = CGPoint(x: xOffset, y: yOffset)
        setContentOffset(newOffset, animated: false)
    }
}
