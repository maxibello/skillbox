import UIKit

//4. Для чего нужны дженерики?
//Дженерики позволяют создавать гибкий код, который не зависит от типа данных. Код становится более абстрактным, понятным и его не нужно дублировать для каждого типа.
//
//5. Чем ассоциированные типы отличаются от дженериков?
//
//Ассоциированные типы используются только в протоколах и помогают создавать универсальные описания. Дженерики используются во всех остальных случаях.

//6. Создайте функцию, которая:

//a. получает на вход два Equatable объекта и в зависимости от того, равны ли они друг другу, выводит разные сообщения в лог

func equals<T:Equatable>(lhr: T, rhr: T) {
    let message = (lhr == rhr) ? "equal" : "not equal"
    print(message)
}

equals(lhr: 2, rhr: 3)
equals(lhr: "test", rhr: "test")

//
//b. получает на вход два сравниваемых (Comparable) друг с другом значения, сравнивает их и выводит в лог наибольшее
//

func compare<T: Comparable>(lhs: T, rhs: T) {
    print("\((lhs >= rhs) ? lhs : rhs)")
}

compare(lhs: 10, rhs: 5)

//
//c. получает на вход два сравниваемых (Comparable) друг с другом значения, сравнивает их и перезаписывает первый входной параметр меньшим из двух значений, а второй параметр – большим
//

func compareSwap<T: Comparable>( lhs: inout T, rhs: inout T) {
    let minElement = min(lhs, rhs)
    let maxElement = max(lhs, rhs)
    
    lhs = minElement
    rhs = maxElement
}

var a = 10
var b = 100

compareSwap(lhs: &a, rhs: &b)
print(a, b)

//
//
//d. получает на вход две функции, которые имеют дженерик входной параметр Т и ничего не возвращают; сама функция должна вернуть новую функцию, которая на вход получает параметр с типом Т и при своем вызове вызывает две функции и передает в них полученное значение (по факту объединяет вместе две функции)

func union<T>(left: @escaping (T) -> Void,
              right: @escaping (T) -> Void) -> (T) -> Void {
    return { t in
        left(t)
        right(t)
    }
}

let f = union(left: { t in print(t) }, right: { t in print(t) })
f("Test")

//7. Создайте расширение для:
//
//a. Array, у которого элементы имеют тип Comparable и добавьте генерируемое свойство, которое возвращает максимальный элемент

extension Array where Element: Comparable {
    var maxELement: Element? {
        return self.max()
    }
}
//b. Array, у которого элементы имеют тип Equatable и добавьте функцию, которая удаляет из массива идентичные элементы

extension Array where Element: Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()

        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }

        return result
    }
}

//8. Создайте специальный оператор для:
//
//a. возведения Int числа в степень: оператор ^^, работает 2^3 возвращает 8

infix operator ^^

func ^^(lhs: Int, rhs: Int) -> Int {
    return NSDecimalNumber(decimal: pow(Decimal(lhs), rhs)).intValue
}

2^^3

//b. копирования во второе Int число удвоенное значение первого 4 ~> a после этого a = 8

infix operator ~>

func ~>(lhs: Int, rhs: inout Int) {
    rhs = 2 * lhs
}

var infixVar = 0
4 ~> infixVar

//c. присваивания в экземпляр tableView делегата: myController <* tableView поле этого myController становится делегатом для tableView

infix operator <*

func <*<T: UITableViewDelegate>(controller: T, tableView: UITableView) {
    tableView.delegate = controller
}

//d. суммирует описание двух объектов с типом CustomStringConvertable и возвращает их описание: 7 + “ string” вернет “7 string”

func +(lhs: CustomStringConvertible, rhs: CustomStringConvertible) -> String {
    return "\(lhs.description) \(rhs.description)"
}

7 + " string"
