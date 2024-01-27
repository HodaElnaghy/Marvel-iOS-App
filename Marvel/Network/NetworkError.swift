//
//  NetworkError.swift
//  Marvel
//
//  Created by Hoda Elnaghy on 1/26/24.
//

import Foundation

enum APIError: String, Error {
    case internalError = "internalError"
    case serverError = "serverError"
    case parsingError = "parsingError"
    case urlBadFormmated = "urlBadFormmated"
    case unknownError = "unknownError"
    case errorDecoding = "errorDecoding"
}
