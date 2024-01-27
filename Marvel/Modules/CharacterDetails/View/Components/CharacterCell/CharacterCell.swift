//
//  CharacterCell.swift
//  Marvel
//
//  Created by Hoda Elnaghy on 1/26/24.
//

import UIKit

class CharacterCell: UICollectionViewCell {

    @IBOutlet weak var characterImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configureCell(imagePath: String) {
        if imagePath.contains("image_not_available") {
            characterImage.image = UIImage(named: "placeholder2")
        } else {

            characterImage.setImage(imagePath: imagePath.imagePath, placeholderImage: UIImage(named: "placeholder"))
        }
    }
}
