//
//  CharacterModel.swift
//  Marvel
//
//  Created by Hoda Elnaghy on 1/26/24.
//

import Foundation

import Foundation

struct RootClass: Codable {

    let code: Int?
    let data: DataModel?

}

struct DataModel: Codable {


    let results: [Results]?

}

struct Results: Codable {

    let id: Int?
    let description: String?
    let name: String?
    let title: String?
    let series: Series?
    let events: Events?
    let stories: Stories?
    let comics: Comics?
    let thumbnail: Thumbnail?
}
struct Thumbnail: Codable {

    let path: String?
    let extensionField: String?

}

struct CharacterUIModel {
    let id: Int
    let name: String
    let description: String
    let thumbnail: String
}

struct Comics: Codable {
    let collectionURI: String?
}

struct Series: Codable {
    let collectionURI: String?
}

struct Events: Codable {
    let collectionURI: String?
}

struct Stories: Codable {
    let collectionURI: String?
}

