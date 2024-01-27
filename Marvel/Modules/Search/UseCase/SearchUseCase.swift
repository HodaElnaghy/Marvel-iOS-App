//
//  SearchUseCase.swift
//  Marvel
//
//  Created by Hoda Elnaghy on 1/26/24.
//

import Foundation
import RxSwift

class SearchUseCase {
    let searchService: CharacterServiceProtocol
    private let disposeBag = DisposeBag()

    init(searchService: CharacterServiceProtocol) {
        self.searchService = searchService
    }

    func fetchCharacters(path: String, offset: Int, limit: Int, search: String) -> Observable<[CharacterUIModel]> {
        return Observable.create { observer in
            self.searchService.fetchcharacters(path: "", offset: offset, limit: limit, search: search) { result in
                switch result {
                case .success(let charactersData):
                    let characterArray = self.mapToUIModel(resultArray: charactersData.data?.results ?? [])
                    observer.onNext(characterArray)
                    observer.onCompleted()
                case .failure(let error):
                    print(error.localizedDescription)
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }

    private func mapToUIModel(resultArray: [Results]) -> [CharacterUIModel] {
        var characterArray: [CharacterUIModel] = []
        for character in resultArray {
            if let image = character.thumbnail?.path, let name = character.name, let id = character.id, let descriptionn = character.description {
                characterArray.append(CharacterUIModel(id: id, name: name, description: descriptionn, thumbnail: image))
            }
        }
        return characterArray
    }
}
