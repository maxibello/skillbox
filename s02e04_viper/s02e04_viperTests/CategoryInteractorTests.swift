//
//  CategoryInteractorTests.swift
//  s02e04_viperTests
//
//  Created by Максим on 03.10.2020.
//  Copyright © 2020 Максим. All rights reserved.
//

import XCTest
@testable import s02e04_viper

class CategoryInteractorTests: XCTestCase {

    var categoryInteractor: MockInteractor?
    var interactorOutput: MockOutput?
    
    override func setUpWithError() throws {
        categoryInteractor = MockInteractor()
        interactorOutput = MockOutput()
        categoryInteractor?.output = interactorOutput
    }
    
    func testExample() throws {
        categoryInteractor?.fetchCategories()

        guard let interactorOutput = interactorOutput else {
            return XCTFail()
        }
        
        XCTAssert(interactorOutput.categoriesCount > 0)
    }
    
    class MockInteractor: CategoryInteractorInput {
        var output: CategoryInteractorOutput?
        func fetchCategories() {
            let categories = decodeCategories()
            output?.categoriesDidReceived(categories: categories)
        }
        
        func decodeCategories() -> [s02e04_viper.Category] {
            let testBundle = Bundle(for: type(of: self))
            guard let ressourceURL = testBundle.url(forResource: "categories", withExtension: "json") else {
                return []
            }
            let data = try! Data(contentsOf: ressourceURL)
            let categories = try! JSONDecoder().decode(DecodedArray<s02e04_viper.Category>.self, from: data)
            return categories.map( { $0 })
        }
        
    }
    
    class MockOutput: CategoryInteractorOutput {
        
        var categoriesCount = 0
        var errorMessage: String?
        
        func categoriesDidReceived(categories: [s02e04_viper.Category]) {
            categoriesCount = categories.count
        }
        
        func categoriesReceiveError(message: String) {
            errorMessage = message
        }
    }

}
