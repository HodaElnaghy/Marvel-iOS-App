//
//  DetailsViewModel.swift
//  Marvel
//
//  Created by Hoda Elnaghy on 1/26/24.
//

import Foundation
import RxSwift
import RxRelay

class DetailsViewModel {
    var isFetchingData = BehaviorRelay<Bool>(value: false)
    private(set) var isDataRetrieved: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    let useCase: DetailsUseCaseProtocol
    var optionArray: [String] = []
    let character: CharacterUIModel
    private let disposeBag = DisposeBag()
    var comicsDataArray: [PosterUIModel] = []
    var seriesDataArray: [PosterUIModel] = []
    var eventsDataArray: [PosterUIModel] = []
    var storiesDataArray: [PosterUIModel] = []

    var comcsRetrieved = false
    var storiesRetrieved = false
    var seriesRetrieved = false
    var eventsRetrieved = false

    init(character: CharacterUIModel, useCase: DetailsUseCaseProtocol) {
        self.character = character
        self.useCase = useCase
        checkAllDataRetrieved()
    }

    func fetchData() {
        fetchComics()
        fetchEvents()
        fetchSeries()
        fetchStories()
    }

    private func fetchComics() {
        isFetchingData.accept(true)
        useCase.fetchCharacters(path: "/\(character.id)/comics", offset: 0, limit: 100)
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }

                self.comicsDataArray.append(contentsOf: data)
                self.comcsRetrieved = true
                self.checkAllDataRetrieved()
            }, onError: { error in
                print("Error fetching characters: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }

    private func fetchSeries() {
        isFetchingData.accept(true)
        useCase.fetchCharacters(path: "/\(character.id)/series", offset: 0, limit: 100)
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }

                self.seriesDataArray.append(contentsOf: data)
                self.seriesRetrieved = true
                self.checkAllDataRetrieved()
            }, onError: { error in
                print("Error fetching characters: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }

    private func fetchStories() {
        isFetchingData.accept(true)
        useCase.fetchCharacters(path: "/\(character.id)/stories", offset: 0, limit: 100)
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }

                self.storiesDataArray.append(contentsOf: data)
                self.storiesRetrieved = true
                self.checkAllDataRetrieved()
            }, onError: { error in
                print("Error fetching characters: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }

    private func fetchEvents() {
        isFetchingData.accept(true)
        useCase.fetchCharacters(path: "/\(character.id)/events", offset: 0, limit: 100)
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }

                self.eventsDataArray.append(contentsOf: data)
                self.eventsRetrieved = true
                self.checkAllDataRetrieved()
            }, onError: { error in
                print("Error fetching characters: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }

    private func checkAllDataRetrieved() {

        if comcsRetrieved && seriesRetrieved && storiesRetrieved && eventsRetrieved {
            isFetchingData.accept(false)
            optionArray = ["Detail", "Wiki", "Comiclink"]
            isDataRetrieved.onNext(true)
        }
    }

}
