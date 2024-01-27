//
//  CharactersCell.swift
//  Marvel
//
//  Created by Hoda Elnaghy on 1/26/24.
//

import UIKit

class CharactersCell: UITableViewCell {
    @IBOutlet weak var characterImage: UIImageView!
    @IBOutlet weak var characterName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func setupCell(name: String, image: String) {

        if image.contains("image_not_available") {
            characterImage.image = UIImage(named: "placeholder2")
        } else {
            characterImage.setImage(imagePath: image.imagePath, placeholderImage: UIImage(named: "placeholder"))
        }
        characterName.text = removeParenthesesContent(from: name)
    }
    private func removeParenthesesContent(from input: String) -> String {
        let result = input.replacingOccurrences(of: "\\([^)]+\\)", with: "", options: .regularExpression)
        return result.trimmingCharacters(in: .whitespacesAndNewlines)
    }

}
