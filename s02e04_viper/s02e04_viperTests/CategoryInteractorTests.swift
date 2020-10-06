//
//  CategoryInteractorTests.swift
//  s02e04_viperTests
//
//  Created by Максим on 03.10.2020.
//  Copyright © 2020 Максим. All rights reserved.
//

import XCTest
import Mockingjay
@testable import s02e04_viper

class CategoryInteractorTests: XCTestCase {

    var categoryInteractor: CategoryInteractor?
    var interactorOutput: MockOutput?
    
    override func setUpWithError() throws {
        categoryInteractor = CategoryInteractor()
        interactorOutput = MockOutput()
        categoryInteractor?.outputDelegate = interactorOutput
    }
    
    func testExample() throws {

        let expectation = XCTestExpectation(description: "Download categories")
        interactorOutput?.expectation = expectation
        
        let path = Bundle(for: type(of: self)).path(forResource: "categories", ofType: "json")!
        let data = NSData(contentsOfFile: path)!
        stub(uri("https://blackstarshop.ru/index.php?route=api/v1/categories"), jsonData(data as Data))
        
        categoryInteractor?.fetchCategories()

        guard let interactorOutput = interactorOutput else {
            return XCTFail()
        }
        
        wait(for: [expectation], timeout: 5)
        XCTAssert(interactorOutput.categoriesCount > 0)
    }
    
    class MockOutput: CategoryInteractorOutput {
        
        var expectation: XCTestExpectation?
        var categoriesCount = 0
        var errorMessage: String?
        
        func categoriesDidReceived(categories: [s02e04_viper.Category]) {
            categoriesCount = categories.count
            expectation?.fulfill()
        }
        
        func categoriesReceiveError(message: String) {
            errorMessage = message
            expectation?.fulfill()
        }
    }

}
