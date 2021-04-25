//
//  s02e11_agileTests.swift
//  s02e11-agileTests
//
//  Created by Maxim Kuznetsov on 24.04.2021.
//

import XCTest
@testable import s02e11_agile

class s02e11_agileTests: XCTestCase {
    
    var model: ViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        model = ViewModel()
    }
    
    override func tearDownWithError() throws {
        model = nil
        try super.tearDownWithError()
    }
    
    func testCorrectEmail() throws {
        let email = "test@test.test"
        XCTAssertTrue(try model.checkEmail("test@test.test"), "email: \(email)")
    }
    
    func testEmptyEmail() {
        XCTAssertThrowsError(try model.checkEmail("")) { error in
            XCTAssertEqual(error as! ValidationError, ValidationError.emailError(text: ValidationError.emailErrorText), "Пустой email")
        }
    }
    
    func testEmailWithoutHost() {
        XCTAssertThrowsError(try model.checkEmail("mymail")) { error in
            XCTAssertEqual(error as! ValidationError, ValidationError.emailError(text: ValidationError.emailErrorText), "Email без хоста")
        }
    }
    
    func testEmailWithoutDomain() {
        XCTAssertThrowsError(try model.checkEmail("mymail@mail.")) { error in
            XCTAssertEqual(error as! ValidationError, ValidationError.emailError(text: ValidationError.emailErrorText), "Email без домена")
        }
    }
    
    func testCorrectPassword() throws {
        let password = "Kek123"
        XCTAssertTrue(try model.checkPassword(password), "password: \(password)")
    }
    
    func testEmptyPassword() {
        XCTAssertThrowsError(try model.checkPassword("")) { error in
            XCTAssertEqual(error as! ValidationError, ValidationError.passwordError(text: ValidationError.passwordErrorText), "Пустой пароль")
        }
    }
    
    func testPasswordWithoutDigits() {
        XCTAssertThrowsError(try model.checkPassword("dsfDDf")) { error in
            XCTAssertEqual(error as! ValidationError, ValidationError.passwordError(text: ValidationError.passwordErrorText), "Пароль без цифр")
        }
    }
    
    func testShortPassword() {
        XCTAssertThrowsError(try model.checkPassword("1Some")) { error in
            XCTAssertEqual(error as! ValidationError, ValidationError.passwordError(text: ValidationError.passwordErrorText), "Короткий пароль")
        }
    }
    
}
