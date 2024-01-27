//
//  SearchViewModel.swift
//  Marvel
//
//  Created by Hoda Elnaghy on 1/26/24.
//

import Foundation
import RxSwift
import RxRelay

class SearchViewModel {
    private var offset = 0
    private var limit = 10
    var isFetchingData = BehaviorRelay<Bool>(value: false)
    private let disposeBag = DisposeBag()
    private let useCase: SearchUseCase
    private(set) var charactersData: BehaviorSubject<[CharacterUIModel]> = BehaviorSubject(value: [])
    init(useCase: SearchUseCase) {
        self.useCase = useCase
    }
    func fetchData(search: String) {
        isFetchingData.accept(true)
        useCase.fetchCharacters(path: "", offset: offset, limit: 100, search: search)
            .subscribe(onNext: { [weak self] data in
                self?.charactersData.onNext(data)
                self?.isFetchingData.accept(false)
            }, onError: { error in
                print("Error fetching characters: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
}
