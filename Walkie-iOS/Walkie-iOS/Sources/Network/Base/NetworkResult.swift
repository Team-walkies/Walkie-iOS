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

enum NetworkError: Int, Error, CustomStringConvertible {
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
    
    var description: String {
        switch self {
        case .emptyDataError: return "데이터가 비어 있습니다."
        case .responseDecodingError: return "응답을 해석할 수 없습니다."
        case .unknownError: return "알 수 없는 오류가 발생했습니다."
        case .invalidURLError: return "잘못된 URL입니다."
        case .invalidRequestError: return "잘못된 요청입니다."
        case .unauthorizedError: return "인증이 필요합니다."
        case .forbiddenError: return "접근이 금지되었습니다."
        case .notFoundError: return "찾을 수 없습니다."
        case .notAllowedHTTPMethodError: return "허용되지 않는 요청 방식입니다."
        case .timeoutError: return "요청 시간이 초과되었습니다."
        case .internalServerError: return "서버 오류가 발생했습니다."
        }
    }
}
