//
//  Publisher+.swift
//  Walkie-iOS
//
//  Created by ahra on 3/11/25.
//

import Foundation

import Moya
import Combine

extension Publisher {
    
    func walkieSink<Object: AnyObject>(
        with object: Object,
        receiveValue: ((Object, Output) -> Void)? = nil,
        receiveFailure: ((Object, NetworkError?) -> Void)? = nil,
        onCancel: ((Object) -> Void)? = nil
    ) -> AnyCancellable {
        let cancellable = sink { [weak object] completion in
            guard let object else { return }
            switch completion {
            case .finished:
                onCancel?(object)
            case .failure(let error):
                receiveFailure?(object, error as? NetworkError)
                onCancel?(object)
            }
        } receiveValue: { [weak object] value in
            guard let object else { return }
            receiveValue?(object, value)
        }
        
        return AnyCancellable {
            cancellable.cancel()
            onCancel?(object)
        }
    }
    
    func mapToNetworkError() -> AnyPublisher<Output, NetworkError> {
        mapError { error -> NetworkError in
            if let moyaError = error as? MoyaError {
                switch moyaError {
                case .statusCode(let response):
                    return NetworkError(rawValue: response.statusCode) ?? .unknownError
                default:
                    return .unknownError
                }
            }
            return .unknownError
        }
        .eraseToAnyPublisher()
    }
}

extension Publisher where Output == Moya.Response {
    
    func mapWalkieResponse<Response: Decodable>(_ type: Response.Type) -> AnyPublisher<Response, Error> {
        self
            .map { $0.data }
            .decode(type: WalkieResponse<Response>.self, decoder: JSONDecoder())
            .tryMap { response in
                if let data = response.data {
                    return data
                } else {
                    if let emptyResponseType = Response.self as? EmptyResponse.Type {
                        if let empty = emptyResponseType.empty as? Response {
                            return empty
                        } else {
                            throw NetworkError.emptyDataError
                        }
                    } else {
                        throw NetworkError.emptyDataError
                    }
                }
            }
            .eraseToAnyPublisher()
    }
    
    func mapVoidResponse() -> AnyPublisher<Void, Error> {
        self
            .map { _ in }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
