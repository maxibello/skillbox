//
//  BasicServiceLocator.swift
//  skillbox_14
//
//  Created by Максим Кузнецов on 30.07.2020.
//  Copyright © 2020 Максим Кузнецов. All rights reserved.
//

import Foundation

class ServiceLocator {
    static let shared = ServiceLocator()
    
    lazy var serviceList = [String: Any]()
    
    func add(services: Any...) {
        for service in services {
            serviceList[typeName(some: service)] = service
        }
    }
    
    func get<T>(_: T.Type) -> T? {
        return serviceList[typeName(some: T.self)] as? T
    }
    
    private func typeName(some: Any) -> String {
        return (some is Any.Type) ? "\(some)" : "\(type(of: some))"
    }
}
