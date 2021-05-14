//
//  s02e11_agileUITests.swift
//  s02e11-agileUITests
//
//  Created by Maxim Kuznetsov on 25.04.2021.
//

import XCTest

class s02e11_agileUITests: XCTestCase {
    var app: XCUIApplication!
    
    var loginButton: XCUIElement {
        return app.buttons["Войти"]
    }
    
    var emailTextField: XCUIElement {
        return app.textFields["email"]
    }
    
    var passwordTextField: XCUIElement {
        return app.secureTextFields["password"]
    }
    
    var successLabel: XCUIElement {
        return app.staticTexts["success"]
    }
    
    var errorLabel: XCUIElement {
        return app.staticTexts["error"]
    }
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
        
    }
    
    func testEnterButtonStateChanging() {
        XCTAssertFalse(loginButton.isEnabled)
        emailTextField.tap()
        emailTextField.typeText("test@test.com")
        
        pastePassword("somepass")
        waitLoginButtonIsEnabled()
    }
    
    func testSuccessLogin() {
        emailTextField.tap()
        emailTextField.typeText("test@test.com")
        pastePassword("somepass1D")
        waitLoginButtonIsEnabled()
        loginButton.tap()
        
        XCTAssertTrue(successLabel.waitForExistence(timeout: 3))
    }
    
    func testShortPassword() {
        emailTextField.tap()
        emailTextField.typeText("test@test.com")
        pastePassword("short")
        waitLoginButtonIsEnabled()
        loginButton.tap()
        
        XCTAssertTrue(errorLabel.label == "Пароль должен содержать минимум одну цифру, одну букву в нижнем регистре и одну в верхнем и не менее 6 символов")
    }
    
    
    private func pastePassword(_ text: String) {
        UIPasteboard.general.string = text   // substitute "the password" with the actual password
        passwordTextField.tap()
        passwordTextField.tap()
        app.menuItems["Paste"].tap()
    }
    
    private func waitLoginButtonIsEnabled() {
        let exists = NSPredicate(format:"enabled == true")
        expectation(for: exists, evaluatedWith: loginButton, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
    }
    
}
