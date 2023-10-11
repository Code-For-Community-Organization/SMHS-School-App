//
//  RequestError.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 6/28/21.
//

import Foundation

enum RequestError: Error {
    case validationError(error: String)
    case failedAttempts(error: String)
    case timeoutError(error: String)
    case emptyPassword(error: String)
    case unknownError(error: String)

    var errorMessage: String {
            switch self {
            case .validationError(let error),
                 .failedAttempts(let error),
                 .timeoutError(let error),
                 .emptyPassword(let error),
                 .unknownError(let error):
                return error
            }
        }
}
