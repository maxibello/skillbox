import Foundation

enum ValidationError: Error, Equatable {
    case emailError(text: String)
    case passwordError(text: String)
    
    static var emailErrorText: String {
        return "Ошибка валидации email"
    }
    
    static var passwordErrorText: String {
        return "Пароль должен содержать минимум одну цифру, одну букву в нижнем регистре и одну в верхнем и не менее 6 символов"
    }
}

final class ViewModel {

    @discardableResult
    func checkEmail(_ email: String) throws -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if !emailPred.evaluate(with: email) {
            throw ValidationError.emailError(text: ValidationError.emailErrorText)
        }
        return true
    }
    
    @discardableResult
    func checkPassword(_ password: String) throws -> Bool {
        let passwordRegEx = "(?=.*\\d)(?=.*[a-z])(?=.*[A-Z]).{6,}"
        let passwordPred = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        if !passwordPred.evaluate(with: password) {
            throw ValidationError.passwordError(text: ValidationError.passwordErrorText)
        }
        return true
    }
}
