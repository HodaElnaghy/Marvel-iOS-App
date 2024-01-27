//
//  LabelCell.swift
//  Marvel
//
//  Created by Hoda Elnaghy on 1/26/24.
//

import UIKit

class LabelCell: UICollectionViewCell {
    @IBOutlet weak var informationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(informationLabel: String) {
        self.informationLabel.text = informationLabel
    }

}
