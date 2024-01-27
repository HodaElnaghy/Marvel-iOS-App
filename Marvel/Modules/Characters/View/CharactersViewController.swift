//
//  CharactersViewController.swift
//  Marvel
//
//  Created by Hoda Elnaghy on 1/26/24.
//

import UIKit
import OSLog
import RxSwift

class CharactersViewController: UIViewController {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView! {
        didSet {
            activityIndicator.hidesWhenStopped = true
        }
    }
    @IBOutlet weak var charactersTableView: UITableView! {
        didSet {
            charactersTableView.delegate = self
            charactersTableView.dataSource = self
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
extension CharactersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        do {
            let charactersData = try viewModel.charactersData.value()
            print(charactersData.count)
            return charactersData.count
        } catch {
            print("Error getting charactersData: \(error)")
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = charactersTableView.dequeueReusableCell(withIdentifier: Constant.characterCell, for: indexPath) as? CharactersCell else {
            os_log("Error dequeuing cell")
            return UITableViewCell()
        }
        let charactersData = try? viewModel.charactersData.value()

        if let charactersData = charactersData, indexPath.row < charactersData.count {
            cell.setupCell(name: charactersData[indexPath.row].name, image: charactersData[indexPath.row].thumbnail)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
}

// MARK: - UITableView Delegate
extension CharactersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        do {
            let charactersData = try viewModel.charactersData.value()
            navigationController?.pushViewController(DetailsViewController(viewModel: DetailsViewModel(character: charactersData[indexPath.row], useCase: DetailsUseCase(service: DetailsService()))), animated: true)
        } catch {
            print("Error getting charactersData: \(error)")
        }
    }

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
        viewModel.isFetchingData
            .asObservable()
            .subscribe(onNext: { [weak self] isLoading in
                if isLoading {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                }
            })
            .disposed(by: disposeBag)

        viewModel.charactersData
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] charactersData in
                self?.charactersTableView.reloadData()
                self?.viewModel.isFetchingMoreData = false
            })
        .disposed(by: disposeBag)
    }
}
