//
//  Publisher+.swift
//  Walkie-iOS
//
//  Created by ahra on 3/11/25.
//

import Foundation

import Moya
import Combine

extension Publisher where Failure == MoyaError {
    
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
                switch error {
                case .underlying(_, let response):
                    if let statusCode = response?.statusCode,
                       let networkError = NetworkError(rawValue: statusCode) {
                        receiveFailure?(object, networkError)
                    } else {
                        receiveFailure?(object, nil)
                    }
                default:
                    receiveFailure?(object, nil)
                }
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
}

extension Publisher where Output == Moya.Response, Failure == MoyaError {
    func mapWalkieResponse<Response: Decodable>(_ type: Response.Type) -> AnyPublisher<Response, Error> {
        self
            .map { $0.data }
            .decode(type: WalkieResponse<Response>.self, decoder: JSONDecoder())
            .tryMap { response in
                guard let data = response.data else {
                    throw NetworkError.emptyDataError
                }
                return data
            }
            .eraseToAnyPublisher()
    }
}
