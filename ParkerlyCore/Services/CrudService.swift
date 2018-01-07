//
// Created by Zmicier Zaleznicenka on 7/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import Foundation

protocol CrudServiceType {

    func createModel<T: ParkerlyModel>(createRequest: NetworkRequestType,
                                       getRequest: @escaping (NetworkId) -> NetworkRequestType?,
                                       completion: ((ParkerlyServiceOperation<T>) -> Void)?)

    func deleteModel(request: NetworkRequestType,
                     completion: ((ParkerlyServiceOperation<Void>) -> Void)?)

    func editModel<T: ParkerlyModel>(request: NetworkRequestType, id: NetworkId,
                                     completion: ((ParkerlyServiceOperation<T>) -> Void)?)

    func getModel<T: ParkerlyModel>(request: NetworkRequestType, id: NetworkId,
                                    completion: ((ParkerlyServiceOperation<T>) -> Void)?)

    func getModels<T: ParkerlyModel>(request: NetworkRequestType,
                                     completion: ((ParkerlyServiceOperation<[T]>) -> Void)?)
}

class CrudService: CrudServiceType {

    private let networkService: NetworkServiceType

    init(networkService: NetworkServiceType) {
        self.networkService = networkService
    }

    func createModel<T: ParkerlyModel>(createRequest: NetworkRequestType,
                                       getRequest: @escaping (NetworkId) -> NetworkRequestType?,
                                       completion: ((ParkerlyServiceOperation<T>) -> Void)?) {
        networkService.requestId(createRequest) { [weak self] operation in
            guard let `self` = self else {
                DispatchQueue.main.async {
                    completion?(ParkerlyServiceOperation.failed(.internalError(description: "memory leak")))
                }
                return
            }

            switch operation {
            case .completed(let id):
                guard let nextRequest = getRequest(id) else {
                    DispatchQueue.main.async {
                        completion?(ParkerlyServiceOperation.failed(
                            .internalError(description: "Couldn't create operation for get request with id \(id)"))
                        )
                    }
                    return
                }
                self.getModel(request: nextRequest, id: id, completion: completion)
            case .failed(let error):
                DispatchQueue.main.async {
                    completion?(ParkerlyServiceOperation.failed(error))
                }
            }
        };
    }

    func deleteModel(request: NetworkRequestType,
                     completion: ((ParkerlyServiceOperation<Void>) -> Void)?) {
        networkService.requestOperation(request) { operation in
            DispatchQueue.main.async {
                completion?(operation)
            }
        };
    }

    func editModel<T: ParkerlyModel>(request: NetworkRequestType, id: NetworkId,
                                     completion: ((ParkerlyServiceOperation<T>) -> Void)?) {
        networkService.requestModel(request, id: id) { operation in
            DispatchQueue.main.async {
                completion?(operation)
            }
        }
    }

    func getModel<T: ParkerlyModel>(request: NetworkRequestType, id: NetworkId,
                                    completion: ((ParkerlyServiceOperation<T>) -> Void)?) {
        networkService.requestModel(request, id: id) { operation in
            DispatchQueue.main.async {
                completion?(operation)
            }
        };
    }

    func getModels<T: ParkerlyModel>(request: NetworkRequestType,
                                     completion: ((ParkerlyServiceOperation<[T]>) -> Void)?) {
        networkService.requestArray(request) { operation in
            DispatchQueue.main.async {
                completion?(operation)
            }
        };
    }
}