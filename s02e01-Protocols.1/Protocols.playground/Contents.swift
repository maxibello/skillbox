import UIKit

//1. Можно ли ограничить протокол только для классов?
//Если да, то приведите примеры.

//Можно
protocol ClassOnly: AnyObject {}

//2. Можно ли создать опциональные функции (необязательные к реализации) у протоколов?
//Если да, то покажите все возможные способы на примерах.

// Можно использовать optional или имплементировать метод по-умолчанию. Также можно рассмотреть вариант выненсения метода в другой протокол.

// optional keyword
@objc protocol OptionalFunction {
   @objc optional func doNotNecessary()
}

class EmptyClass: OptionalFunction {}

// дефолтная имплементация
protocol OptionalDefaultFunction {
    func doNotNecessary()
}

extension OptionalDefaultFunction {
    func doNotNecessary() {
        //TODO
    }
}

class EmptyClass2: OptionalDefaultFunction {}

//3. Можно ли в extension создавать хранимые свойства (stored property)?
//Если да, то в каких случаях?
//А если нет, то есть ли способы обойти данные ограничения?

//Можно создавать только вычисляемые свойства, в тч статические.
//Для свойств объекта класс можно "закостылить" свою реализацию:

class StoredPropertyByExtension { }

extension StoredPropertyByExtension {
    private static var _myComputedProperty = [String:Bool]()
    
    var myComputedProperty:Bool {
        get {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            return StoredPropertyByExtension._myComputedProperty[tmpAddress] ?? false
        }
        set(newValue) {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            StoredPropertyByExtension._myComputedProperty[tmpAddress] = newValue
        }
    }
}

let testStored1 = StoredPropertyByExtension()
let testStored2 = StoredPropertyByExtension()
testStored1.myComputedProperty = true
testStored2.myComputedProperty = false
print(testStored1.myComputedProperty, testStored2.myComputedProperty)

//4. Можно ли в extension объявлять вложенные типы, а именно: классы/структуры/перечисления/протоколы.
//Приведите примеры, если да.

//Можно всё, кроме протоколов

class NestedTypes {}

extension NestedTypes {
    struct NestedStruct {}
    class NestedClass {}
    enum NestedEnum {}
}

//5. Можно ли в extension класса/структуры/перечисления реализовать соответствие протоколу?
//Если да, то приведите пример.

protocol AdoptMe {
    func test()
}

class ClassToTry {}
extension ClassToTry: AdoptMe {
    func test() {}
}

struct StructToTry {}
extension StructToTry: AdoptMe {
    func test() {}
}

enum EnumToTry {}
extension EnumToTry: AdoptMe {
    func test() {}
}


//6. Можно ли в протоколе объявить инициализатор?
//А в extension добавить новый инициализатор для класса/структуры/перечисления/протокола?
//Пример.

//Для класса добавить иницилизацтор можно только в теле объявления класса. Также непонятно зачем это делать для протокола: мы просто наследуемся от него.

protocol InitMe {
    init(message: String)
}

class ClassInit: InitMe {
    required init(message: String) {}
}
//extension ClassInit: InitMe {
//    required init(message: String) {}
//}

struct StructInit {}
extension StructInit: InitMe {
    init(message: String) {}
}

enum EnumInit {
    case foo(String)
}
extension EnumInit: InitMe {
    init(message: String) {
        self = .foo(message)
    }
}

protocol ProtocolInit: InitMe {}
class ClassInit2: ProtocolInit {
    required init(message: String) {}
}

//7. Как в протоколе объявить readonly свойство?
//Можно ли его реализовать в классе/структуре/перечислении с помощью let?

//Можно, кроме перечислений, для них можно определить только вычисляемое свойство. "If the protocol only requires a property to be gettable, the requirement can be satisfied by any kind of property".

protocol ReadOnlyProperty {
    var prop: Int { get }
}

class ReadOnlyClass: ReadOnlyProperty {
    let prop: Int = 0
}

struct ReadOnlyStruct: ReadOnlyProperty {
    let prop: Int = 0
}

enum ReadOnlyEnum: ReadOnlyProperty {
    var prop: Int {
        return 0
    }
}

//8. Поддерживают ли протоколы множественное наследование?
//Пример.

protocol A {
    func doA()
}
protocol B {
    func doB()
}

protocol C: A, B {
    func doC()
}

class ABC: C {
    func doA() {}
    func doB() {}
    func doC() {}
}

//9. Можно ли создать протокол, реализовать который могут только определенные классы/структуры/перечисления?
//Пример.

// Нашел только, как сделать такое для классов

class RestictClass {}
protocol RestrictedProtocol where Self: RestictClass {}


//10. Можно ли определить тип, который реализует одновременно несколько несвязанных между собой протоколов?
//Пример.
// Возможно я не понял вопрос. Что значит определить тип?

protocol Flyable {
    func fly()
}

protocol Game {
    func render()
}

class Combinator {}

extension Combinator: Flyable {
    func fly() {}
}

extension Combinator: Game {
    func render() {}
}
