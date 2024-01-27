//
//  DetailsUseCase.swift
//  Marvel
//
//  Created by Hoda Elnaghy on 1/26/24.
//

import Foundation
import RxSwift

class DetailsUseCase {
    private let disposeBag = DisposeBag()
    let service = DetailsService()

    func fetchCharacters(path: String, offset: Int, limit: Int) -> Observable<[PosterUIModel]> {
        return Observable.create { observer in
            self.service.fetchcharacters(path: path, offset: offset, limit: limit, search: "") { result in
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

    private func mapToUIModel(resultArray: [Results]) -> [PosterUIModel] {
        var postersArray: [PosterUIModel] = []
        for character in resultArray {
            if let image = character.thumbnail?.path, let title = character.title {

                postersArray.append(PosterUIModel(title: title, image: image))

            }
        }
        return postersArray
    }
}



