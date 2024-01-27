//
//  UIImageView + KingFisher.swift
//  Marvel
//
//  Created by Hoda Elnaghy on 1/26/24.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setImage(imagePath: String, placeholderImage: UIImage? = nil) {
        let imageURL = URL(string: imagePath)
        self.kf.setImage(with: imageURL, placeholder: placeholderImage, options: [.transition(.fade(0.5))] )
    }
}
