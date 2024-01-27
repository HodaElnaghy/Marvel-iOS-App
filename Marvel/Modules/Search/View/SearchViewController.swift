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
            searchTableView.delegate = self
            searchTableView.dataSource = self
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
                self?.searchTableView.reloadData()
            })
            .disposed(by: disposeBag)

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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        do {
            let charactersData = try viewModel.charactersData.value()
            navigationController?.pushViewController(DetailsViewController(viewModel: DetailsViewModel(character: charactersData[indexPath.row], useCase: DetailsUseCase(service: DetailsService()))), animated: true)
        } catch {
            print("Error getting charactersData: \(error)")
        }

    }
}

// MARK: - UITableView DataSource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if ((searchBar.text?.isEmpty ?? true)) {
            return 0
        }
        do {
            let charactersData = try viewModel.charactersData.value()
            return charactersData.count
        } catch {
            print("Error getting charactersData: \(error)")
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = searchTableView.dequeueReusableCell(withIdentifier: Constant.searchCell, for: indexPath) as? SearchCell else {
            os_log("Error dequeuing cell")
            return UITableViewCell()
        }
        let charactersData = try? viewModel.charactersData.value()

        if let charactersData = charactersData, indexPath.row < charactersData.count {
            cell.configureCell(imagePath: charactersData[indexPath.row].thumbnail, name: charactersData[indexPath.row].name)
        }
        return cell
    }
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
