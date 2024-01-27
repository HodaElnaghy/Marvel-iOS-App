//
//  GalleryViewController.swift
//  Marvel
//
//  Created by Hoda Elnaghy on 1/27/24.
//

import UIKit
import OSLog

class GalleryViewController: UIViewController {
    // MARK: - @IBOutlet
    @IBOutlet weak var galleryCollectionView: UICollectionView! {
        didSet {
            galleryCollectionView.delegate = self
            galleryCollectionView.dataSource = self

            galleryCollectionView.register(UINib(nibName: Constant.galleyCell, bundle: nil), forCellWithReuseIdentifier: Constant.galleyCell)

            let layout = UICollectionViewCompositionalLayout { sectionIndex, enviroment in
                    return self.characterLayout()
            }

            galleryCollectionView.setCollectionViewLayout(layout, animated: true)
        }
    }

    // MARK: - Constants
    private enum Constant {
        static let galleyCell = "GalleryCell"
    }

    // MARK: - Initializer
    init(viewModel: GalleryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Properties
    let viewModel: GalleryViewModel

    // MARK: - LifeCycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
    }

    override func viewDidAppear(_ animated: Bool) {
        let targetIndexPath = IndexPath(item: viewModel.index, section: 0)
        UIView.animate(withDuration: 10, animations: {
            self.galleryCollectionView.scrollToItem(at: targetIndexPath, at: .centeredHorizontally, animated: true)
        })
    }

    // MARK: - @IBAction
    @IBAction func exitButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Private Functions
    private func setupNavigation() {
        navigationItem.hidesBackButton = true
    }
}

extension GalleryViewController: UICollectionViewDelegate {

}

extension GalleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.posterArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = galleryCollectionView.dequeueReusableCell(withReuseIdentifier: Constant.galleyCell, for: indexPath) as? GalleryCell else {
            os_log("Error dequeuing cell")
            return UICollectionViewCell()
        }

        cell.configureCell(imagePath: viewModel.posterArray[indexPath.row].image , title: viewModel.posterArray[indexPath.row].title, index: indexPath.row, count: viewModel.posterArray.count)

        return cell
    }
}

// MARK: - CollectionView Layout
extension GalleryViewController {
    private func characterLayout()-> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(350), heightDimension: .absolute(600))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 0)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        section.orthogonalScrollingBehavior = .continuous

        return section
    }
}
