//
//  s02e04_viperTests.swift
//  s02e04_viperTests
//
//  Created by Максим on 03.10.2020.
//  Copyright © 2020 Максим. All rights reserved.
//

import XCTest
import RealmSwift
@testable import s02e04_viper

class TDLInteractorTests: XCTestCase {

    var tdlInteractor: MockInteracor?
    var tdlInteractorOutput: MockOutput?
    
    override func setUpWithError() throws {
        tdlInteractor = MockInteracor()
        tdlInteractorOutput = MockOutput()
        tdlInteractor?.output = tdlInteractorOutput
    }
    
    func testExample() throws {
        tdlInteractor?.fetchItems()

        guard let tdlInteractorOutput = tdlInteractorOutput else {
            return XCTFail()
        }
        
        XCTAssert(tdlInteractorOutput.itemsCount > 0)
    }
    
    class MockInteracor: ToDoListInteractorInput {
        
        var output: ToDoListInteractorOutput?
        
        func fetchItems() {
            let realm = try! Realm()
            output?.itemsDidFetched(items: realm.objects(ToDoItem.self))
        }
        
        func deleteItem(with id: Int) {
            
        }
        
        func addItem(with text: String) {
            
        }
    }
    
    class MockOutput: ToDoListInteractorOutput {
        
        var itemsCount = 0
        var errorMessage: String?
        var deletedItemRow: Int?
        var addedItem: ToDoItem?
        
        func itemsDidFetched(items: Results<ToDoItem>) {
            itemsCount = items.count
        }
        
        func fetchingDidError(message: String) {
            errorMessage = message
        }
        
        func itemDeleted(at row: Int) {
            deletedItemRow = row
        }
        
        func itemAdded() {
            // TODO
        }
        
        func errorOccured(message: String) {
            errorMessage = message
        }
    }

}
