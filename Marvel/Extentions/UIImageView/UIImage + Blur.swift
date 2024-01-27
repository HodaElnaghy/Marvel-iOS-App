//
//  UIImage + Blur.swift
//  Marvel
//
//  Created by Hoda Elnaghy on 1/26/24.
//

import Foundation

import UIKit

extension UIImageView {
    func applyBlurredDarkEffect() {
        let darkBlur = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame = bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurView)
    }
}
