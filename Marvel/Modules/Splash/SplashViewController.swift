//
//  SplashViewController.swift
//  Marvel
//
//  Created by Hoda Elnaghy on 1/27/24.
//

import UIKit
import Lottie

class SplashViewController: UIViewController {
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    private var animationView: LottieAnimationView?
    private var animationLoadingView: LottieAnimationView?

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

        animationView = .init(name: "loading3")
        animationView!.frame = loadingView.bounds
        animationView!.contentMode = .scaleToFill
        animationView!.loopMode = .loop
        loadingView.addSubview(animationView!)
        animationView!.play()
        
    }

    @objc func MainNav() {
        let homeViewController = CharactersViewController()
        navigationController?.setViewControllers([homeViewController], animated: true)
    }
}
