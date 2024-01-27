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
    private(set) var comicsData: BehaviorSubject<[PosterUIModel]> = BehaviorSubject(value: [])
    private(set) var seriesData: BehaviorSubject<[PosterUIModel]> = BehaviorSubject(value: [])
    private(set) var storiesData: BehaviorSubject<[PosterUIModel]> = BehaviorSubject(value: [])
    private(set) var eventsData: BehaviorSubject<[PosterUIModel]> = BehaviorSubject(value: [])
    var comcsRetrieved = false
    var storiesRetrieved = false
    var seriesRetrieved = false
    var eventsRetrieved = false

    init(character: CharacterUIModel, useCase: DetailsUseCaseProtocol) {
        self.character = character
        self.useCase = useCase
        checkAllDataRetrieved()
        fetchComics()
        fetchEvents()
        fetchSeries()
        fetchStories()

    }

    func fetchComics() {
        isFetchingData.accept(true)
        useCase.fetchCharacters(path: "/\(character.id)/comics", offset: 0, limit: 100)
            .subscribe(onNext: { [weak self] data in
                self?.comicsData.onNext(data)
                self?.comcsRetrieved = true
                self?.checkAllDataRetrieved()
            }, onError: { error in
                print("Error fetching characters: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }

    func fetchSeries() {
        isFetchingData.accept(true)
        useCase.fetchCharacters(path: "/\(character.id)/series", offset: 0, limit: 100)
            .subscribe(onNext: { [weak self] data in
                self?.seriesData.onNext(data)
                self?.seriesRetrieved = true
                self?.checkAllDataRetrieved()
            }, onError: { error in
                print("Error fetching characters: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }

    func fetchStories() {
        isFetchingData.accept(true)
        useCase.fetchCharacters(path: "/\(character.id)/stories", offset: 0, limit: 100)
            .subscribe(onNext: { [weak self] data in
                self?.storiesData.onNext(data)
                self?.storiesRetrieved = true
                self?.checkAllDataRetrieved()
            }, onError: { error in
                print("Error fetching characters: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }

    func fetchEvents() {
        isFetchingData.accept(true)
        useCase.fetchCharacters(path: "/\(character.id)/events", offset: 0, limit: 100)
            .subscribe(onNext: { [weak self] data in
                self?.eventsData.onNext(data)
                self?.eventsRetrieved = true
                self?.checkAllDataRetrieved()
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
