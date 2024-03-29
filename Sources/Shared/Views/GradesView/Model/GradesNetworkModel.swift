//
//  GradesNetworkRequest.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 6/27/21.
//

import Combine
import Foundation

struct GradesNetworkModel {
    func fetch(with request: URLRequest) -> AnyPublisher<Bool, RequestError> {
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap{_, response in
                guard let response = response as? HTTPURLResponse else {
                    preconditionFailure("Cannot cast response into HTTPURLResponse")
                }
                guard 200..<300 ~= response.statusCode else {
                      switch response.statusCode {
                      case 401:
                          throw RequestError.validationError(error: "The username and password entered are incorrect.")
                      case 429:
                          throw RequestError.failedAttempts(error: "Too many failed login attempts, try again after 5 minutes.")
                      case 408:
                          throw RequestError.timeoutError(error: "Timeout waiting for the main grades page to load, try again later.")
                      case 400:
                          throw RequestError.emptyPassword(error: "Password must not be empty")
                      default:
                          throw RequestError.unknownError(error: "Unknown error occured. Please file a bug report.")
                      }
                }
                return true
            }
            .mapError {error -> RequestError in
                return .unknownError(error: String(describing: error))
            }
            .eraseToAnyPublisher()
    }

    func fetch<T: Decodable>(with request: URLRequest, type: T.Type) -> AnyPublisher<T, RequestError> {
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap{data, response in
                guard let response = response as? HTTPURLResponse else {
                    preconditionFailure("Cannot cast response into HTTPURLResponse")
                }
                guard 200..<300 ~= response.statusCode else {
                      switch response.statusCode {
                      case 401:
                          throw RequestError.validationError(error: "The username and password entered are incorrect.")
                      case 429:
                          throw RequestError.failedAttempts(error: "Too many failed login attempts, try again after 5 minutes.")
                      case 408:
                          throw RequestError.timeoutError(error: "Timeout waiting for the main grades page to load, try again later.")
                      case 400:
                          throw RequestError.emptyPassword(error: "Password must not be empty")
                      default:
                          throw RequestError.unknownError(error: "Unknown error occured. Please file a bug report.")
                      }
                }
                return data
            }
            .decode(type: type, decoder: JSONDecoder())
            .mapError {error -> RequestError in
                return .unknownError(error: String(describing: error))
            }
            .eraseToAnyPublisher()
    }
}
