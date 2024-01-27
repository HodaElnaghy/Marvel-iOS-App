//
//  SectionHeader.swift
//  Marvel
//
//  Created by Hoda Elnaghy on 1/26/24.
//

import UIKit

class SectionHeader: UICollectionReusableView {

    static let reuseIdentifier = "SectionHeader"
    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension SectionHeader {
    func configure() {
        backgroundColor = .clear

        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true


        let inset = CGFloat(10)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
            label.topAnchor.constraint(equalTo: topAnchor, constant: inset),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset)
        ])
        label.textColor = .red

        label.font = UIFont.preferredFont(forTextStyle: .headline)
        if let descriptor = label.font.fontDescriptor.withSymbolicTraits(.traitBold) {
            label.font = UIFont(descriptor: descriptor, size: 14)
        }


    }
}

