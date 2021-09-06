//
//  TodayNetworkModel.swift
//  SMHSSchedule (macOS)
//
//  Created by Jevon Mao on 9/3/21.
//
import Combine
import Foundation

struct TodayNetworkModel {
    enum RequestError: Error {
        case notFoundError
        case invalidResponseCode
        case sessionFailed(error: URLError)
        case decodingFailed
        case other(Error)
    }

    static var JSONDecoder: JSONDecoder {
        let decoder = Foundation.JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }

    static func fetch<T: Codable>(with request: URLRequest, type: T.Type) -> AnyPublisher<T, RequestError> {
        return URLSession.shared.dataTaskPublisher(for: request)
            .retry(3)
            .tryMap{data, response in
                guard let response = response as? HTTPURLResponse else {
                    preconditionFailure("Cannot cast response into HTTPURLResponse")
                }
                guard 200..<300 ~= response.statusCode else {
                    switch response.statusCode {
                        case 404:
                            throw RequestError.notFoundError
                        default:
                            throw RequestError.invalidResponseCode
                    }
                }
                return data
            }
            .decode(type: type, decoder: JSONDecoder)
            .mapError {error -> RequestError in
                switch error {
                    case RequestError.notFoundError:
                        return .notFoundError
                    case RequestError.invalidResponseCode:
                        return .invalidResponseCode
                    case is Swift.DecodingError:
                              return .decodingFailed
                    case let urlError as URLError:
                      return .sessionFailed(error: urlError)
                    default:
                      return .other(error)
                }
            }
            .eraseToAnyPublisher()
    }
}


