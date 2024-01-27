//
//  GalleryCell.swift
//  Marvel
//
//  Created by Hoda Elnaghy on 1/27/24.
//

import UIKit

class GalleryCell: UICollectionViewCell {
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!

    func configureCell(imagePath: String, title: String, index: Int, count: Int) {
        posterImage.setImage(imagePath: imagePath.imagePath, placeholderImage: UIImage(named: "placeholder"))
        titleLabel.text = title
        indexLabel.text = "\(index+1)/\(count)"
    }

}
