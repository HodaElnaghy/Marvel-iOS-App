//
//  SplashViewController.swift
//  Marvel
//
//  Created by Hoda Elnaghy on 1/27/24.
//

import UIKit
import Lottie

class SplashViewController: UIViewController {
    private var animationView: LottieAnimationView?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let viewControllers = self.navigationController?.viewControllers {
            print("Current View Controllers in Stack: \(viewControllers)")

        }
        view.backgroundColor = .white
        animationView = .init(name: "marvel")
        animationView!.frame = view.bounds
        animationView!.contentMode = .scaleAspectFit
        animationView!.loopMode = .loop
        view.addSubview(animationView!)
        animationView!.play()
        Timer.scheduledTimer(timeInterval: 3 , target: self, selector: #selector(MainNav), userInfo: nil, repeats: false)
    }

    @objc func MainNav() {
        let homeViewController = CharactersViewController()
        navigationController?.setViewControllers([homeViewController], animated: true)
    }
}
