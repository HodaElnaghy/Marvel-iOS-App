//
//  SplashViewController.swift
//  Marvel
//
//  Created by Hoda Elnaghy on 1/27/24.
//

import UIKit
import Lottie

class SplashViewController: UIViewController {
    @IBOutlet weak var backgroundView: UIView!
    private var animationView: LottieAnimationView?
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        animationView = .init(name: "marvel")
        animationView!.frame = backgroundView.bounds
        animationView!.contentMode = .scaleAspectFit
        animationView!.loopMode = .loop
        backgroundView.addSubview(animationView!)
        animationView!.play()
        Timer.scheduledTimer(timeInterval: 2 , target: self, selector: #selector(MainNav), userInfo: nil, repeats: false)
    }

    @objc func MainNav() {
        let homeViewController = CharactersViewController()
        navigationController?.setViewControllers([homeViewController], animated: true)
    }
}
