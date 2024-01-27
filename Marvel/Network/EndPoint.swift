//
//  EndPoint.swift
//  Marvel
//
//  Created by Hoda Elnaghy on 1/26/24.
//

import Foundation

enum EndPoint {
    static let baseUrl = "https://gateway.marvel.com/v1/public/characters"

    case characters
    var path: String{
        switch self{
        case .characters:
            return "/characters"

        }
    }

}
