//
//  NetworkingService.swift
//  WeatherApp
//
//  Created by Marina Aguiar on 5/4/23.
//

import Foundation

protocol NetworkingServiceProtocol {

  func fetchGenericData<T: Decodable>(url: URL, completion: @escaping(Result<T, Error>) -> Void)
}

final class NetworkingService: NetworkingServiceProtocol {

    private var sharedSession: URLSession { URLSession.shared }

    func fetchGenericData<T: Decodable>(
        url: URL,
        completion: @escaping(Result<T, Error>) -> Void
    ) {

        let task = sharedSession.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    switch error {
                    case let apiError as APIError:
                        completion(.failure(apiError))
                    case URLError.notConnectedToInternet:
                        completion(.failure(APIError.noInternetConnection))
                    default:
                        completion(.failure(APIError.failedRequest))
                    }
                }
                return
            }

            guard
                let response = response as? HTTPURLResponse,
                (200..<300).contains(response.statusCode)
            else {
                completion(.failure(APIError.failedRequest))
                return
            }

            guard let data = data else {
                fatalError("Not able to fetch data")
            }

            do {
                let genericData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(genericData))
            }
            catch {
                completion(.failure(APIError.invalidResponse))
                print("Unable to Decode Response \(error)")
            }
        }
        task.resume()
    }
}



