//
//  NoInternetView.swift
//  Marvel
//
//  Created by Hoda Elnaghy on 1/27/24.
//

import UIKit

class NoInternetConnectionView: UIView {
    lazy var contentImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "noInternet")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.frame = self.bounds
        return image
    }()
}

import UIKit

class BlockingView: UIView {

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        backgroundColor = UIColor.black.withAlphaComponent(0.8)
        addSubview(messageLabel)

        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }

    func show(message: String) {
        messageLabel.text = message
        UIApplication.shared.keyWindow?.addSubview(self)
    }

    func hide() {
        removeFromSuperview()
    }
}
