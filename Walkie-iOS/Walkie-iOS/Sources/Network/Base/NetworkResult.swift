//
//  NetworkError.swift
//  Walkie-iOS
//
//  Created by ahra on 3/11/25.
//

import Foundation

enum NetworkResult<T> {
    case success(T?)
    case failure(NetworkError)
}

enum NetworkError: Int, Error {
    case emptyDataError
    case responseDecodingError
    case unknownError
    case invalidURLError
    case invalidRequestError = 400
    case unauthorizedError = 401
    case forbiddenError = 403
    case notFoundError = 404
    case notAllowedHTTPMethodError = 405
    case timeoutError = 408
    case internalServerError = 500
}
