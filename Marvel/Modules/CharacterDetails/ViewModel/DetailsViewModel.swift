//
//  DetailsViewModel.swift
//  Marvel
//
//  Created by Hoda Elnaghy on 1/26/24.
//

import Foundation
import RxSwift

class DetailsViewModel {
    let useCase = DetailsUseCase()
    let optionArray: [String] = ["Detail", "Wiki", "Comiclink"]
    let character: CharacterUIModel
    private let disposeBag = DisposeBag()
    private(set) var comicsData: BehaviorSubject<[PosterUIModel]> = BehaviorSubject(value: [])
    private(set) var seriesData: BehaviorSubject<[PosterUIModel]> = BehaviorSubject(value: [])
    private(set) var storiesData: BehaviorSubject<[PosterUIModel]> = BehaviorSubject(value: [])
    private(set) var eventsData: BehaviorSubject<[PosterUIModel]> = BehaviorSubject(value: [])
    init(character: CharacterUIModel) {
        self.character = character
    }

    func fetchComics() {
        useCase.fetchCharacters(path: "/\(character.id)/comics", offset: 0, limit: 100) 
            .subscribe(onNext: { [weak self] data in
                self?.comicsData.onNext(data)
            }, onError: { error in
                print("Error fetching characters: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
    func fetchSeries() {
        useCase.fetchCharacters(path: "/\(character.id)/series", offset: 0, limit: 100)
            .subscribe(onNext: { [weak self] data in
                self?.seriesData.onNext(data)
            }, onError: { error in
                print("Error fetching characters: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
    func fetchStories() {
        useCase.fetchCharacters(path: "/\(character.id)/stories", offset: 0, limit: 100)
            .subscribe(onNext: { [weak self] data in
                self?.storiesData.onNext(data)
            }, onError: { error in
                print("Error fetching characters: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }

    func fetchEvents() {
        useCase.fetchCharacters(path: "/\(character.id)/events", offset: 0, limit: 100)
            .subscribe(onNext: { [weak self] data in
                self?.eventsData.onNext(data)
            }, onError: { error in
                print("Error fetching characters: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
}
