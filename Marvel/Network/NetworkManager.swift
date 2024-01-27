//
//  NetworkManager.swift
//  Marvel
//
//  Created by Hoda Elnaghy on 1/26/24.
//
import Foundation

final class NetworkManager {

    private func createRequest(endPoint: EndPoint,method: Methods,parameter: [String:Any]? = nil, path: String, offset: Int, limit: Int, search: String) -> URLRequest?{

        var url = EndPoint.baseUrl + path + "?ts=1706212732&apikey=7035af9a5cb24338d1d7ee5917efd56a&hash=387bd776d46b2e5ea17215a7f9b8602e&offset=\(offset)&limit=\(limit)"
        if !search.isEmpty {
            url += "&nameStartsWith=\(search)"
        }
        guard let urll = url.encodeUrl().asURL else{return nil}
        var urlRequest = URLRequest(url: urll)

        urlRequest.httpMethod = "\(method)"

        if let parameter = parameter {
            switch method {
            case .Get:
                var urlComponent = URLComponents(string: url)
                urlComponent?.queryItems = parameter.map { URLQueryItem(name: $0, value: "\($1)")
                }
                urlRequest.url = urlComponent?.url
            case .Post, .Delete, .Patch:
                let bodyData = try? JSONSerialization.data(withJSONObject: parameter, options: [])
                urlRequest.httpBody = bodyData
            }
        }
        
        return urlRequest

    }

    func request<T: Codable>(endPoint: EndPoint,method: Methods,parameters: [String: Any]? = nil, path: String, offset: Int, limit: Int, search: String,completion: @escaping(Result<T, APIError>) -> Void) {
        guard let request = createRequest(endPoint: endPoint, method: method,parameter: parameters, path: path, offset: offset, limit: limit, search: search) else {
            completion(.failure(APIError.unknownError))
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in

            var result: Result<Data, Error>?

            if let data = data {
                result = .success(data)

            } else if let error = error {
                result = .failure(error)
                print("The error is: \(error.localizedDescription)")
            }
            guard let response = response as? HTTPURLResponse else {
                print("Empty Response")
                return
            }

            print("Response status code: \(response.statusCode)")

            DispatchQueue.main.async {
                self.handleResponse(result: result, completion: completion)
            }
        }.resume()
    }


    private func handleResponse<T: Codable>(result: Result<Data, Error>?,
                                            completion: (Result<T, APIError>) -> Void) {
        guard let result = result else {
            completion(.failure(APIError.unknownError))
            return
        }

        switch result {
        case .success(let data):
            let decoder = JSONDecoder()
            guard let response = try? decoder.decode( T.self, from: data) else {

                completion(.failure(APIError.errorDecoding))
                return
            }
            completion(.success(response.self))

        case .failure(let error):
            print("error@@@\(error.localizedDescription)")
            completion(.failure(APIError.parsingError))

        }
    }
}
