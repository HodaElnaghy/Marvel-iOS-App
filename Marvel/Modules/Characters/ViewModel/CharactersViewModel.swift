//
//  CharactersViewModel.swift
//  Marvel
//
//  Created by Hoda Elnaghy on 1/26/24.
//

import Foundation
import RxSwift

class CharactersViewModel {
    private var offset = 0
    private var limit = 10
    private var count = 0
    private let disposeBag = DisposeBag()
    private let useCase: CharacterUseCase
    private(set) var charactersData: BehaviorSubject<[CharacterUIModel]> = BehaviorSubject(value: [])
    init(useCase: CharacterUseCase) {
        self.useCase = useCase
        fetchData()
    }
    private func fetchData() {
        useCase.fetchCharacters(path: "", offset: offset, limit: limit)
            .subscribe(onNext: { [weak self] data in
                self?.charactersData.onNext(data)
            }, onError: { error in
                print("Error fetching characters: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }

    func fetchMoreData() {
        limit += limit
        if limit <= 100 {
            fetchData()
        }
    }
}
