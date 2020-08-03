import UIKit

//Привести пример вызова любой функции с замыкающим выражением, используя:
//-  имена параметров, их типы, тип возвращаемого значения
//- имена параметров и их типы
//- имена параметров
//- самый короткий синтаксис, без параметров и типов

var arr = [3, 10, 0, 199]

//1
var sortedArrDesc = arr.sorted(by: { (s1: Int, s2: Int) -> Bool in
    return s1 > s2
})

//2
sortedArrDesc = arr.sorted(by: { (s1: Int, s2: Int) in s1 > s2 })

//3
sortedArrDesc = arr.sorted(by: { s1, s2 in s1 > s2 })

//4
sortedArrDesc = arr.sorted(by: { $0 > $1 })

//Реализовать функцию, которая захватывает значение из окружающего контекста и меняет это значение при вызове функции.
//Вызвать ее несколько раз.

func captureVar() -> () -> Int {
    var captured = 0
    
    return {
        captured += 1
        return captured
    }
}

let cv = captureVar()
cv()
cv()
cv()

//Реализовать функцию, которая принимает в качестве параметра Сбегающее замыкание (escaping).

func testEscaping(completion: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        print("Function body")
        completion()
    }
    print("function has returned")
}

testEscaping {
    print("Closure")
}

//В чем отличие escaping замыкания от nonescaping? Приведите пример этого отличия.
//Ключевое отличие в том, что escaping замыкание вызывается после того, как функция вернула свое значение и компилятору необходимо сохранить ссылку на данное замыкание, чтобы оно не разрушилось вместе с контекcтом функции, которой оно было передано.
//Nonescaping замыкание вызывается внутри функции, которой оно было передано. Escaping замыкания широко используется в асинхронном коде, например, при работе с сетью.

//Приведите пример функции, которая принимает в качестве параметра Автозамыкание (autoclosure).

var testArr = [1, 2, 3, 4, 5]

func getNew(closure: @autoclosure () -> Int) {
    closure()
}

getNew(closure: testArr.remove(at: 0))

// Создать любую структуру. Реализовать для нее оператор +.

infix operator ++: RangeFormationPrecedence
struct BiCurrencyBasket {
    var dollars: Float = 0
    var euros: Float = 0
    
    static func + (left: BiCurrencyBasket, right: BiCurrencyBasket) -> BiCurrencyBasket {
        return BiCurrencyBasket(dollars: left.dollars + right.dollars,
                                euros: left.euros + right.euros)
    }
    
    static func ++ (left: BiCurrencyBasket, right: BiCurrencyBasket) -> BiCurrencyBasket {
        return BiCurrencyBasket(dollars: (left.dollars + right.dollars) * 2, euros:  (left.euros + right.euros) * 2)
    }
}

let final = BiCurrencyBasket(dollars: 10, euros: 10) ++ BiCurrencyBasket(dollars: 10, euros: 10) + BiCurrencyBasket(dollars: 5, euros: 5)
print(final)


//Реализовать функцию apply, которая принимает на вход два параметра.
//Первый (firstValue) - число типа Int, второй (function) - функция с двумя параметрами типа Int и возвращаемым значением типа Int.
//Функция apply возвращает другую функцию (returnedFunction) с одним параметром (secondValue) типа Int и возвращаемым значением типа Int.
//При этом returnedFunction при вызове должна вызывать function с параметрами firstValue и secondValue.
// func apply(_ firstValue: Int, for function: @escaping (Int, Int) -> Int) -> ((Int) -> Int) {
// }
//Предполагается использовать функцию так:
// let sumFunction: (Int, Int) -> Int = { a, b in
//     return a + b
// }
// let tenPlusFunction = apply(10, for: sumFunction)
// let tenSumFiveValue = tenPlusFunction(5)
// print(tenSumFiveValue) // напечатается 15
//
// let multipleFunction: (Int, Int) -> Int = { a, b in
//     return a * b
// }
// let twoMultipleFunction = apply(2, for: multipleFunction)
// let twoMultipleTwelve = twoMultipleFunction(12)
// print(twoMultipleTwelve) // напечатается 24

func apply(_ firstValue: Int, for function: @escaping (Int, Int) -> Int) -> ((Int) -> Int) {
    return { function(firstValue, $0) }
}

 let sumFunction: (Int, Int) -> Int = { a, b in
     return a + b
 }

let tenPlusFunction = apply(10, for: sumFunction)
let tenSumFiveValue = tenPlusFunction(5)
print(tenSumFiveValue)
