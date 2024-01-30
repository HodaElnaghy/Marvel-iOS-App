//
//  CharactersViewController.swift
//  Marvel
//
//  Created by Hoda Elnaghy on 1/26/24.
//

import UIKit
import OSLog
import RxSwift
import SwiftMessages
import RxCocoa

class CharactersViewController: UIViewController {

    
    
    let blockingView = BlockingView()
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView! {
        didSet {
            activityIndicator.hidesWhenStopped = true
        }
    }
    @IBOutlet weak var charactersTableView: UITableView! {
        didSet {
            charactersTableView.rx.setDelegate(self).disposed(by: disposeBag)
            let nib = UINib(nibName: Constant.characterCell, bundle: nil)
            charactersTableView.register(nib, forCellReuseIdentifier: Constant.characterCell)
        }
    }
    
    // MARK: - Properties
    private var viewModel = CharactersViewModel(useCase: CharacterUseCase(charactersService: CharacterService()))
    private let disposeBag = DisposeBag()

    // MARK: - Constants
    private enum Constant {
        static let characterCell = "CharactersCell"
    }
    
    // MARK: - LifeCycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        addSearchIcon()
        addTitle()
        setupBindings()
    }
}

// MARK: - UITable View data source
extension CharactersViewController {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
}

// MARK: - UITableView Delegate
extension CharactersViewController: UITableViewDelegate {

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        do {
//            let charactersData = try viewModel.charactersData.value()
//            navigationController?.pushViewController(DetailsViewController(viewModel: DetailsViewModel(character: charactersData[indexPath.row], useCase: DetailsUseCase(service: DetailsService()))), animated: true)
//        } catch {
//            print("Error getting charactersData: \(error)")
//        }
//    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        viewModel.fetchMoreData()
    }
}

// MARK: - Private Functions
extension CharactersViewController {
    private func addSearchIcon() {
        let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(searchButtonTapped))
        searchButton.tintColor = .red
        navigationItem.rightBarButtonItem = searchButton
    }

    @objc func searchButtonTapped() {
        navigationController?.pushViewController(SearchViewController(viewModel: SearchViewModel(useCase: SearchUseCase(searchService: SearchService()))), animated: true)
    }

    private func addTitle() {
        title = " "
        let logoImageView = UIImageView(image: UIImage(named: "logo"))
        logoImageView.contentMode = .scaleAspectFit

        let titleView = UIView()
        titleView.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 80),
            logoImageView.heightAnchor.constraint(equalToConstant: 30)
        ])
        navigationItem.titleView = titleView
    }

    private func setupBindings() {
        
        charactersTableView.rx.modelSelected(CharacterUIModel.self).subscribe(onNext: { [weak self] item in
            guard let self = self else { return }
            
            self.navigationController?.pushViewController(DetailsViewController(viewModel: DetailsViewModel(character: item, useCase: DetailsUseCase(service: DetailsService()))), animated: true)        }).disposed(by: disposeBag)

        charactersTableView.rx.didEndDecelerating
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.fetchMoreData()
            })
            .disposed(by: disposeBag)

        ConnectionManager.shared.isInternetConnected
            .subscribe(onNext: { [ weak self ] isConnected in
                guard let self = self else { return }

                if isConnected {
                    self.viewModel.fetchData()
                } else {
                    SwiftMessagesClass.showSwiftMessage(theme: .error, title: "No internet connection", body: "")
                    self.activityIndicator.stopAnimating()
                }
            })
            .disposed(by: disposeBag)

        viewModel.isFetchingData
            .asObservable()
            .subscribe(onNext: { [weak self] isLoading in
                guard let self = self else { return }

                if isLoading {
                    viewModel.isFetchingMoreData = true
                    self.activityIndicator.startAnimating()
                } else {
                    viewModel.isFetchingMoreData = false
                    self.activityIndicator.stopAnimating()
                }
            })
            .disposed(by: disposeBag)

        viewModel.charactersData.bind(to: charactersTableView.rx.items(cellIdentifier: Constant.characterCell, cellType: CharactersCell.self)) { [weak self] index, post, cell in
            guard let self = self else { return }

            cell.setupCell(name: post.name, image: post.thumbnail)
        } .disposed(by: disposeBag)
    }
}

extension UIViewController {

func showToast(message : String, font: UIFont) {

    let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
    toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    toastLabel.textColor = UIColor.white
    toastLabel.font = font
    toastLabel.textAlignment = .center;
    toastLabel.text = message
    toastLabel.alpha = 1.0
    toastLabel.layer.cornerRadius = 10;
    toastLabel.clipsToBounds  =  true
    self.view.addSubview(toastLabel)
    UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
         toastLabel.alpha = 0.0
    }, completion: {(isCompleted) in
        toastLabel.removeFromSuperview()
    })
} }
