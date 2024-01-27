//
//  OptionCell.swift
//  Marvel
//
//  Created by Hoda Elnaghy on 1/26/24.
//

import UIKit

class OptionCell: UICollectionViewCell {
    @IBOutlet weak var optionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configureCell(optionLabel: String) {
        self.optionLabel.text = optionLabel
    }
}
