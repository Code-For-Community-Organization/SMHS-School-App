//
//  RequestError.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 6/28/21.
//

import Foundation

enum RequestError: Error {
    case serverError(error: Error)
    case validationError(error: String)
    case failedAttempts(error: String)
    case timeoutError(error: String)
    case emptyPassword(error: String)
    case unknownError(error: String)
}
