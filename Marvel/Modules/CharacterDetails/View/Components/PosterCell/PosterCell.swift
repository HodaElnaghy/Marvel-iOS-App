//
//  PosterCell.swift
//  Marvel
//
//  Created by Hoda Elnaghy on 1/26/24.
//

import UIKit

class PosterCell: UICollectionViewCell {
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var posterName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(imagePath: String, posterName: String) {
        self.posterName.text = posterName
        posterImage.setImage(imagePath: imagePath.imagePath, placeholderImage: UIImage(named: "placeholder"))
    }
}
