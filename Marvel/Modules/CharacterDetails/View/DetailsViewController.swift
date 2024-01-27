//
//  DetailsViewController.swift
//  Marvel
//
//  Created by Hoda Elnaghy on 1/26/24.
//

import UIKit
import OSLog
import RxSwift
import DifferenceKit

class DetailsViewController: UIViewController {

    // MARK: - @IBOutlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView! {
        didSet {
            activityIndicator.hidesWhenStopped = true
        }
    }
    @IBOutlet weak var DetailsCollectionView: UICollectionView! {
        didSet {
            DetailsCollectionView.delegate = self
            DetailsCollectionView.dataSource = self

            DetailsCollectionView.register(UINib(nibName: Constants.labelCell, bundle: nil), forCellWithReuseIdentifier: Constants.labelCell)
            DetailsCollectionView.register(UINib(nibName: Constants.optionCell, bundle: nil), forCellWithReuseIdentifier: Constants.optionCell)
            DetailsCollectionView.register(UINib(nibName: Constants.posterCell, bundle: nil), forCellWithReuseIdentifier: Constants.posterCell)
            DetailsCollectionView.register(UINib(nibName: Constants.characterCell, bundle: nil), forCellWithReuseIdentifier: Constants.characterCell)

            if #available(iOS 11.0, *) {
                DetailsCollectionView.contentInsetAdjustmentBehavior = .never
            } else {
                automaticallyAdjustsScrollViewInsets = false
            }

            let backgroundImageView = UIImageView()
            backgroundImageView.setImage(imagePath: viewModel.character.thumbnail.imagePath)
            backgroundImageView.applyBlurredDarkEffect()

            backgroundImageView.contentMode = .scaleAspectFill
            DetailsCollectionView.backgroundView = backgroundImageView

            DetailsCollectionView.register( SectionHeader.self, forSupplementaryViewOfKind: Constants.sectionHeaderElementKind, withReuseIdentifier: SectionHeader.reuseIdentifier)

            let layout = UICollectionViewCompositionalLayout { sectionIndex, enviroment in
                switch sectionIndex {
                case 0:
                    return self.characterLayout()
                case 1:
                    return self.labelLayout()
                case 2:
                    return self.descriptionLayout()
                case 3,4,5,6:
                    return self.posterLayout()
                case 7:
                    return self.optionLayout()
                default:
                    return self.characterLayout()
                }
            }

            DetailsCollectionView.setCollectionViewLayout(layout, animated: true)
        }
    }

    // MARK: - Properties
    var viewModel: DetailsViewModel
    private let disposeBag = DisposeBag()

    // MARK: - Constants
    private enum Constants {
        static let sectionHeaderElementKind = "section-header-element-kind"
        static let labelCell = "LabelCell"
        static let optionCell = "OptionCell"
        static let posterCell = "PosterCell"
        static let characterCell = "CharacterCell"
    }
    // MARK: - Initializer
    init(viewModel: DetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        observeChanges()
    }

    // MARK: - Private Functions
    private func setupNavigation() {
        navigationController?.navigationBar.tintColor = .white
    }

    private func observeChanges() {
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

        viewModel.isDataRetrieved
                    .subscribe(onNext: { [weak self] isDataRetrieved in
                        if isDataRetrieved {
                            self?.DetailsCollectionView.reloadData()
                            // Do something when all data is retrieved
                            print("All data retrieved")
                        }
                    })
                    .disposed(by: disposeBag)
    }
}


// MARK: - UICollectionView Delegate
extension DetailsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 3:
            do {
                let comics = try viewModel.comicsData.value()
                navigationController?.pushViewController(GalleryViewController(viewModel: GalleryViewModel(posterArray: comics, index: indexPath.row)), animated: true)
            } catch {
                print("Error getting charactersData: \(error)")
            }

        case 4:
            do {
                let series = try viewModel.seriesData.value()
                navigationController?.pushViewController(GalleryViewController(viewModel: GalleryViewModel(posterArray: series, index: indexPath.row)), animated: true)
            } catch {
                print("Error getting charactersData: \(error)")
            }

        case 5:
            do {
                let stories = try viewModel.storiesData.value()
                navigationController?.pushViewController(GalleryViewController(viewModel: GalleryViewModel(posterArray: stories, index: indexPath.row)), animated: true)
            } catch {
                print("Error getting charactersData: \(error)")
            }

        case 6:
            do {
                let events = try viewModel.eventsData.value()
                navigationController?.pushViewController(GalleryViewController(viewModel: GalleryViewModel(posterArray: events, index: indexPath.row)), animated: true)
            } catch {
                print("Error getting charactersData: \(error)")
            }

        default:
            return
        }
    }
}

// MARK: - UICOllectionView DataSource
extension DetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0, 1:
            return 1
        case 2:
            return viewModel.character.description.isEmpty ? 0 : 1
        case 7:
            return viewModel.optionArray.count
        case 3:
            do {
                let comics = try viewModel.comicsData.value()
                return comics.count
            } catch {
                return 0
            }
        case 4:
            do {
                let series = try viewModel.seriesData.value()
                return series.count
            } catch {
                return 0
            }
        case 5:
            do {
                let stories = try viewModel.storiesData.value()
                return stories.count
            } catch {
                return 0
            }
        case 6:
            do {
                let events = try viewModel.eventsData.value()
                return events.count
            } catch {
                return 0
            }
        default:
            return 10
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = DetailsCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.characterCell, for: indexPath) as? CharacterCell else {
                os_log("Error dequeuing cell")
                return UICollectionViewCell()
            }
            cell.configureCell(imagePath: viewModel.character.thumbnail)
            return cell

        case 1:
            guard let cell = DetailsCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.labelCell, for: indexPath) as? LabelCell else {
                os_log("Error dequeuing cell")
                return UICollectionViewCell()
            }
            cell.configureCell(informationLabel: viewModel.character.name)
            return cell

        case 2:
            guard let cell = DetailsCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.labelCell, for: indexPath) as? LabelCell else {
                os_log("Error dequeuing cell")
                return UICollectionViewCell()
            }
            cell.configureCell(informationLabel: viewModel.character.description)
            return cell

        case 3:
            guard let cell = DetailsCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.posterCell, for: indexPath) as? PosterCell else {
                os_log("Error dequeuing cell")
                return UICollectionViewCell()
            }
            let comicsData = try? viewModel.comicsData.value()

            if let comicsData = comicsData, indexPath.row < comicsData.count {
                cell.configureCell(imagePath: comicsData[indexPath.row].image, posterName: comicsData[indexPath.row].title)
            }
            cell.alpha = 0.0
                UIView.animate(withDuration: 0.2, delay: 0.1 * Double(indexPath.row)/4, options: .curveEaseInOut, animations: {
                    cell.alpha = 1.0
                }, completion: nil)
            return cell

        case 4:
            guard let cell = DetailsCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.posterCell, for: indexPath) as? PosterCell else {
                os_log("Error dequeuing cell")
                return UICollectionViewCell()
            }
            let seriesData = try? viewModel.seriesData.value()

            if let seriesData = seriesData, indexPath.row < seriesData.count {
                cell.configureCell(imagePath: seriesData[indexPath.row].image, posterName: seriesData[indexPath.row].title)
            }
            cell.alpha = 0.0
                UIView.animate(withDuration: 0.2, delay: 0.1 * Double(indexPath.row)/4, options: .curveEaseInOut, animations: {
                    cell.alpha = 1.0
                }, completion: nil)
            return cell

        case 5:
            guard let cell = DetailsCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.posterCell, for: indexPath) as? PosterCell else {
                os_log("Error dequeuing cell")
                return UICollectionViewCell()
            }
            cell.alpha = 0.0
                UIView.animate(withDuration: 0.2, delay: 0.1 * Double(indexPath.row)/4, options: .curveEaseInOut, animations: {
                    cell.alpha = 1.0
                }, completion: nil)
            let storiesData = try? viewModel.storiesData.value()

            if let storiesData = storiesData, indexPath.row < storiesData.count {
                cell.configureCell(imagePath: storiesData[indexPath.row].image, posterName: storiesData[indexPath.row].title)
            }
            return cell

        case 6:
            guard let cell = DetailsCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.posterCell, for: indexPath) as? PosterCell else {
                os_log("Error dequeuing cell")
                return UICollectionViewCell()
            }
            
            let eventsData = try? viewModel.eventsData.value()

            if let eventsData = eventsData, indexPath.row < eventsData.count {
                cell.configureCell(imagePath: eventsData[indexPath.row].image, posterName: eventsData[indexPath.row].title)
            }
            cell.alpha = 0.0
                UIView.animate(withDuration: 0.2, delay: 0.1 * Double(indexPath.row)/4, options: .curveEaseInOut, animations: {
                    cell.alpha = 1.0
                }, completion: nil)
            return cell

        case 7:
            guard let cell = DetailsCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.optionCell, for: indexPath) as? OptionCell else {
                os_log("Error dequeuing cell")
                return UICollectionViewCell()
            }
            cell.configureCell(optionLabel: viewModel.optionArray[indexPath.row])
            return cell

        default:
            return UICollectionViewCell()
        }

    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if viewModel.optionArray.isEmpty {
            return 7
        }
        return 8
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionHeaderArray: [String] = ["dewd", "NAME", "DESCRIPTION", "COMICS", "SERIES", "STORIES", "EVENTS", "RELATED LINKS"]
        if kind == Constants.sectionHeaderElementKind {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as! SectionHeader
            headerView.label.text = sectionHeaderArray[indexPath.section]

            return headerView
        }
        return UICollectionReusableView()
    }

}

// MARK: - CollectionView Layout
extension DetailsViewController {
    private func characterLayout()-> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        section.orthogonalScrollingBehavior = .continuous

        return section
    }

    private func labelLayout()-> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(25))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(0))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: Constants.sectionHeaderElementKind, alignment: .top)
        section.boundarySupplementaryItems = [sectionHeader]

        return section
    }

    private func descriptionLayout()-> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(90))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(0))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: Constants.sectionHeaderElementKind, alignment: .top)
        section.boundarySupplementaryItems = [sectionHeader]

        return section
    }

    private func optionLayout()-> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 60, trailing: 0)
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(0))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: Constants.sectionHeaderElementKind, alignment: .top)
        section.boundarySupplementaryItems = [sectionHeader]

        return section
    }

    private func posterLayout()-> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(350))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(120), heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 4, trailing: 0)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10)
        section.orthogonalScrollingBehavior = .continuous
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(0))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: Constants.sectionHeaderElementKind, alignment: .top)
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
}
