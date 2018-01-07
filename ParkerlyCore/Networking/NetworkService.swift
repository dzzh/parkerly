//
// Created by Zmicier Zaleznicenka on 5/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import Foundation
import os.log

// ⚠️ Be aware that the completion blocks are performed on the background queue.
protocol NetworkServiceType {

    func requestArray<T: ParkerlyModel>(_ request: NetworkRequestType,
                                        completion: @escaping (ParkerlyServiceOperation<[T]>) -> Void)

    func requestModel<T: ParkerlyModel>(_ request: NetworkRequestType, id: NetworkId,
                                        completion: @escaping (ParkerlyServiceOperation<T>) -> Void)

    func requestId(_ request: NetworkRequestType,
                   completion: @escaping (ParkerlyServiceOperation<NetworkId>) -> Void)

    func requestOperation(_ request: NetworkRequestType,
                          completion: @escaping (ParkerlyServiceOperation<Void>) -> Void)
}

// Clearly, this is a poor man's implementation of a network service.
// For a production app, it would require more polishing and features
// (and preferably including Result + Alamofire + Moya).
//
// Missing:
// - check status codes
// - retry failing operations
// - wrap errors into ParkerlyError
// - monitor network status
// - and much more
class NetworkService {

    // MARK: - Constants

    private let operationQueueName = "parkerlyNetworkQueue"

    // MARK: - State

    private let requestFactory: RequestFactoryType
    private let decoder: JSONDecoder
    private let operationQueue = OperationQueue()

    // MARK: - Initialization

    init(requestFactory: RequestFactoryType, decoder: JSONDecoder) {
        self.requestFactory = requestFactory
        self.decoder = decoder
        operationQueue.name = operationQueueName
        operationQueue.maxConcurrentOperationCount = 1
    }
}

extension NetworkService: NetworkServiceType {

    func requestArray<T: ParkerlyModel>(_ request: NetworkRequestType,
                                        completion: @escaping (ParkerlyServiceOperation<[T]>) -> Void) {
        performRawRequest(request) { data, response, error in
            let result: ParkerlyServiceOperation<[T]>
            if let error = error {
                result = ParkerlyServiceOperation.failed(error)
            } else {
                if let data = data, let array: [T] = T.decodeArray(from: data) {
                    result = ParkerlyServiceOperation.completed(array)
                } else {
                    result = ParkerlyServiceOperation.failed(.malformedData)
                }
            }
            completion(result)
        }
    }

    func requestModel<T: ParkerlyModel>(_ request: NetworkRequestType, id: NetworkId,
                                        completion: @escaping (ParkerlyServiceOperation<T>) -> Void) {
        performRawRequest(request) { data, response, error in
            let result: ParkerlyServiceOperation<T>
            if let error = error {
                result = ParkerlyServiceOperation.failed(error)
            } else {
                if let data = data, let model: T = T.decode(from: data) {
                    let modelWithId = model.copy(withId: id)
                    result = ParkerlyServiceOperation.completed(modelWithId)
                } else {
                    result = ParkerlyServiceOperation.failed(.malformedData)
                }
            }
            completion(result)
        }
    }

    func requestId(_ request: NetworkRequestType,
                   completion: @escaping (ParkerlyServiceOperation<NetworkId>) -> Void) {
        performRawRequest(request) { [weak self] data, response, error in
            let result: ParkerlyServiceOperation<NetworkId>
            if let error = error {
                result = ParkerlyServiceOperation.failed(error)
            } else {
                if let data = data, let id: NetworkId = self?.decodeId(from: data) {
                    result = ParkerlyServiceOperation.completed(id)
                } else {
                    result = ParkerlyServiceOperation.failed(.malformedData)
                }
            }
            completion(result)
        }
    }

    func requestOperation(_ request: NetworkRequestType,
                          completion: @escaping (ParkerlyServiceOperation<Void>) -> Void) {
        performRawRequest(request) { data, response, error in
            let result: ParkerlyServiceOperation<Void>
            if let error = error {
                result = ParkerlyServiceOperation.failed(error)
            } else {
                result = ParkerlyServiceOperation.completed(())
            }
            completion(result)
        }
    }
}

private extension NetworkService {

    func performRawRequest(_ request: NetworkRequestType,
                           completion externalCompletion: @escaping (Data?, URLResponse?, ParkerlyError?) -> Void) {
        guard let urlRequest = request.urlRequest(requestFactory) else {
            os_log("Couldn't create URLRequest from string \"%@\"", request.debugDescription)
            externalCompletion(nil, nil, .malformedRequest)
            return
        }

        let internalCompletion: (Data?, URLResponse?, Error?) -> Void = { data, response, error in
            externalCompletion(data, response, error?.parkerlyError)
        }

        let operation = NetworkOperation(request: urlRequest, completion: internalCompletion)
        operationQueue.addOperation(operation)
    }
}

private extension NetworkService {

    private struct EncodedNetworkId: Decodable {
        let name: NetworkId
    }

    func decodeId(from data: Data) -> NetworkId? {
        do {
            return try decoder.decode(EncodedNetworkId.self, from: data).name
        } catch {
            os_log("Caught an error when decoding id: %@", error.localizedDescription)
            return nil
        }
    }
}