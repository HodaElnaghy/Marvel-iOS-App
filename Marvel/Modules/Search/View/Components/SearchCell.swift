//
//  SearchCell.swift
//  Marvel
//
//  Created by Hoda Elnaghy on 1/26/24.
//

import UIKit

class SearchCell: UITableViewCell {
    @IBOutlet weak var characterImage: UIImageView!
    @IBOutlet weak var characterName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCell(imagePath: String, name: String) {
        characterName.text = name
        characterImage.setImage(imagePath: imagePath.imagePath, placeholderImage: UIImage(named: "placeholder"))
    }
}
