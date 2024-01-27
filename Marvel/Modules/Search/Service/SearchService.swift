//
//  SearchService.swift
//  Marvel
//
//  Created by Hoda Elnaghy on 1/26/24.
//

import Foundation

class SearchService: CharacterServiceProtocol {

    private let networkManager = NetworkManager()

    func fetchcharacters(path: String, offset: Int, limit: Int,search: String, completion: @escaping (Result<RootClass, APIError>) -> Void) {
        networkManager.request(endPoint: EndPoint.characters, method: .Get, path: path, offset: offset, limit: limit, search: search, completion: completion)
    }
}
