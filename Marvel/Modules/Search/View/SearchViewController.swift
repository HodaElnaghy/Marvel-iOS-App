import UIKit
import RxSwift
import OSLog

class SearchViewController: UIViewController {
    // MARK: - @IBOutlet
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView! {
        didSet {
            activityIndicator.hidesWhenStopped = true
        }
    }
    @IBOutlet weak var searchTableView: UITableView! {
        didSet {
            searchTableView.rx.setDelegate(self).disposed(by: disposeBag)
            searchTableView.register(UINib(nibName: Constant.searchCell, bundle: nil), forCellReuseIdentifier: Constant.searchCell)
        }
    }

    // MARK: - Properties
    private var isSearching: Bool = false
    private let searchBar = UISearchBar()
    var viewModel: SearchViewModel
    private let disposeBag = DisposeBag()

    // MARK: - Constants
    private enum Constant {
        static let searchCell = "SearchCell"
    }

    // MARK: - Initializer
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        observeChanges()
    }

    // MARK: - Private Functions
    private func observeChanges() {
        viewModel.charactersData
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] charactersData in
                guard let self = self else { return }

                self.searchTableView.reloadData()
            })
            .disposed(by: disposeBag)

        viewModel.isFetchingData
            .asObservable()
            .subscribe(onNext: { [weak self] isLoading in
                guard let self = self else { return }

                if isLoading {
                    self.activityIndicator.startAnimating()
                } else {
                    self.activityIndicator.stopAnimating()
                }
            })
            .disposed(by: disposeBag)

        searchTableView.rx.modelSelected(CharacterUIModel.self).subscribe(onNext: { [weak self] item in
            guard let self = self else { return }

            self.navigationController?.pushViewController(DetailsViewController(viewModel: DetailsViewModel(character: item, useCase: DetailsUseCase(service: DetailsService()))), animated: true)        }).disposed(by: disposeBag)

        viewModel.charactersData.bind(to: searchTableView.rx.items(cellIdentifier: Constant.searchCell, cellType: SearchCell.self)) { [weak self] index, post, cell in
            guard let self = self else { return }

            cell.configureCell(imagePath: post.thumbnail, name: post.name)
        } .disposed(by: disposeBag)

    }

    private func setupNavigation() {
        title = ""
        searchBar.placeholder = "Search..."
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        navigationItem.hidesBackButton = true

        if let searchTextField = searchBar.value(forKey: "searchField") as? UITextField {
            searchTextField.textColor = .black
            searchTextField.backgroundColor = .white
        }

        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
        cancelButton.tintColor = .red
        navigationItem.rightBarButtonItem = cancelButton
    }

    @objc func cancelButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableView Delegate
extension SearchViewController: UITableViewDelegate {

}

// MARK: - UITableView DataSource
extension SearchViewController {


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }

}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            viewModel.fetchData(search: searchText)
        } else {
            emptyTableView()
        }
    }

    func emptyTableView() {
        viewModel.charactersData.onNext([])
        searchTableView.reloadData()
    }
}
