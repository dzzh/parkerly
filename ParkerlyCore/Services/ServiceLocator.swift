//
// Created by Zmicier Zaleznicenka on 3/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import Foundation

public protocol ServiceLocatorType {

    func add<T>(_ service: T)

    func getOptional<T>() -> T?

    func getUnwrapped<T>() -> T
}

public class ServiceLocator {

    private var services: Dictionary<String, Any> = [:]

    public init() {
        registerServices()
    }
}

extension ServiceLocator: ServiceLocatorType {

    public func add<T>(_ service: T) {
        let serviceKey = "\(type(of: service))"
        services[serviceKey] = service
    }

    public func getOptional<T>() -> T? {
        let serviceKey = String(describing: T.self)
        return services[serviceKey] as? T
    }

    public func getUnwrapped<T>() -> T {
        return getOptional()!
    }
}

private extension ServiceLocator {

    private func registerServices() {
        let decoder = JSONDecoder()
        let networkService = NetworkService(requestFactory: RequestFactory(), decoder: decoder)
        let crudService = CrudService(networkService: networkService)

        add(ParkingActionsService(crudService: crudService) as ParkingActionsServiceType)
        add(ParkingZonesService(crudService: crudService) as ParkingZonesServiceType)
        add(UserService(crudService: crudService) as UserServiceType)
        add(VehiclesService(crudService: crudService) as VehiclesServiceType)
    }

    private func name(of some: Any) -> String {
        return some is Any.Type ? String(describing: some) : "\(type(of: some))"
    }
}
