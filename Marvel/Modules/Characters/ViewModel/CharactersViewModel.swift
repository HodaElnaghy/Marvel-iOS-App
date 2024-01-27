//
//  CharactersViewModel.swift
//  Marvel
//
//  Created by Hoda Elnaghy on 1/26/24.
//

import Foundation
import RxSwift
import RxRelay

class CharactersViewModel {
    var isFetchingData = BehaviorRelay<Bool>(value: false)
    private var offset = 0
    private var limit = 10
    private var count = 0
    var isFetchingMoreData = false
    private let disposeBag = DisposeBag()
    private let useCase: CharacterUseCase
    private(set) var charactersData: BehaviorSubject<[CharacterUIModel]> = BehaviorSubject(value: [])

    init(useCase: CharacterUseCase) {
        self.useCase = useCase
    }

    func fetchData() {
        isFetchingData.accept(true)
        isFetchingMoreData = true
        useCase.fetchCharacters(path: "", offset: offset, limit: limit)
            .subscribe(onNext: { [weak self] data in
                self?.charactersData.onNext(data)
                self?.isFetchingData.accept(false)
            }, onError: { error in
                print("Error fetching characters: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }

    func fetchMoreData() {
        if !isFetchingMoreData {
            limit += 10
            if limit <= 100 {
                fetchData()
            }
        }
    }
}
