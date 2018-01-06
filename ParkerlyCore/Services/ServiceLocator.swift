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

        add(ParkingActionsService(networkService: networkService) as ParkingActionsServiceType)
        add(ParkingZonesService(networkService: networkService) as ParkingZonesServiceType)
        add(UserService(networkService: networkService) as UserServiceType)
        add(VehiclesService(networkService: networkService) as VehiclesServiceType)
    }

    private func name(of some: Any) -> String {
        return some is Any.Type ? String(describing: some) : "\(type(of: some))"
    }
}
