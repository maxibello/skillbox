import UIKit

//Необходимо добавить базовые методы для данных структур.
//Алгоритмы методов должны быть реализованы.

//1. Используя generic типы реализовать структуру данных Stack.
var stack = Stack<Int>()
stack.push(1)
stack.push(2)
stack.push(3)
print(stack)
stack.pop()
print(stack)

//2. Реализовать очередь Queue.
var queue = QueueArray<String>()
queue.enqueue("Иван")
queue.enqueue("Злата")
queue.enqueue("Серафим")
queue
queue.dequeue()
queue
queue.peek

//3. Реализовать связный список Linked List.

var list = LinkedList<Int>()
list.push(2)
list.push(1)
list.push(0)
print(list)

var list2 = LinkedList<Int>()
list2.push(3)
list2.push(2)
list2.push(1)
print("Before popping list: \(list2)")
let poppedValue = list2.pop()
print("After popping list: \(list2)")
print("Popped value: " + String(describing: poppedValue))

//4. Какие существуют способы указать ограничения (constraints) для generic-типов?
//1. при объявлении generic типа указать класс(тип должен быть сабклассом)/протокол (тип должен его поддерживать)
//2. ключевое слово where
//    1. можно использовать в extension типа
//    2. можно использовать для associatedtype

//5. Привести примеры ограничения для generic с помощью where.

extension Stack where Element: Equatable {
    public var isEmpty: Bool {
        peek() == nil
    }
}

//6. Можно ли использовать протокол с Associated Type в качестве самостоятельного типа?
//Я так понимаю, что из коробки нельзя.

//7. Можно ли обойти это ограничение?
// Либо заменить протокол на generic тип и указать необходимые условия для этого типа, либо type erasure.

//8. Изучить подход https://medium.com/@chris_dus/type-erasure-in-swift-84480c807534
//9. Привести пример использования.

struct 🌩 {}
struct 🔥 {}

protocol Pokemon {
    associatedtype Power
    
    func attack() -> Power
}
 
struct Pikachu: Pokemon {
    
    func attack() -> 🌩 {
        return 🌩()
    }
}
 
struct Charmander: Pokemon {
    
    func attack() -> 🔥 {
        return 🔥()
    }
}

struct AnyPokemon<P: Pokemon>: Pokemon {
    
    private let pokemon: P
    
    init(_ pokemon: P) {
        self.pokemon = pokemon
    }
    
    func attack() -> P.Power {
        return pokemon.attack()
    }
}
 
// Usage
let pokemon = AnyPokemon(Charmander())
pokemon.attack()

//Будет здорово, если попробуете найти в swift standard library применение этого паттерна.
//Классы AnySequence, AnyGenerator, AnyHashable, AnyIterator, AnyCollection; классы в Combine: AnyCancellable, AnyPublisher

//10. Реализовать любой infix, prefix, postfix операторы.
//Указать приоритет и ассоциативность.

precedencegroup BiCurrencyInfixPrecedence {
    lowerThan: MultiplicationPrecedence
    higherThan: AdditionPrecedence
    associativity: left
    assignment: false
}

infix operator ++: BiCurrencyInfixPrecedence
prefix operator *
postfix operator ^

struct BiCurrencyBasket {
    var dollars: Float = 0
    var euros: Float = 0
    
    static func + (left: BiCurrencyBasket, right: BiCurrencyBasket) -> BiCurrencyBasket {
        return BiCurrencyBasket(dollars: left.dollars + right.dollars,
                                euros: left.euros + right.euros)
    }
    
    static prefix func * (basket: BiCurrencyBasket) -> BiCurrencyBasket {
        return BiCurrencyBasket(dollars: basket.dollars * 2, euros: basket.euros * 2)
    }
    
    static postfix func ^ (basket: BiCurrencyBasket) -> BiCurrencyBasket {
        return BiCurrencyBasket(dollars: basket.euros, euros: basket.dollars)
    }
    
    static func ++ (left: BiCurrencyBasket, right: BiCurrencyBasket) -> BiCurrencyBasket {
        return BiCurrencyBasket(dollars: (left.dollars + right.dollars) * 2, euros:  (left.euros + right.euros) * 2)
    }
}

let final = *(BiCurrencyBasket(dollars: 10, euros: 20) ++ BiCurrencyBasket(dollars: 10, euros: 10) + BiCurrencyBasket(dollars: 5, euros: 5))^
print(final)
