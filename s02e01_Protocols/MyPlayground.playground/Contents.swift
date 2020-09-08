import UIKit
import PlaygroundSupport

//4. В чем отличие класса от протокола?
//В протоколах мы определяем образцы методов и свойств без их реализации. Хотя и можем написать дефолтную реализацию методов и вычисляемых свойств в расширении протокола. Протокол, как и класс, является типом данных, но мы не можем создать экземпляр протокола. Протокол - абстракное определения, а класс и его экземпляры - реальные.

//5. Могут ли реализовывать несколько протоколов:
//
//     a. классы (Class)
//
//     b. структуры (Struct)
//
//     c. перечисления (Enum)
//
//     d. кортежи (Tuples)

//Все, кроме кортежей, могут реализовывать несколько протоколов

//6. Создайте протоколы для:
//
//     a. игры в шахматы против компьютера: протокол-делегат с функцией, через которую шахматный движок будет сообщать о ходе компьютера (с какой на какую клеточку);
//    протокол для шахматного движка, в который передается ход фигуры игрока (с какой на какую клеточку), Double свойство, возвращающая текущую оценку позиции (без возможности изменения этого свойства) и свойство делегата;
//
//     b. компьютерной игры: один протокол для всех, кто может летать (Flyable), второй – для тех, кого можно отрисовывать приложении (Drawable).
//
//Напишите класс, который реализует эти два протокола

protocol ChessField {}

protocol ChessGamePlayerDelegate {
    func playerDidMove(from: ChessField, to: ChessField)
}

protocol ChessGameEngineDelegate {
    var disposition: Double { get }
    var playerDelegate: ChessGamePlayerDelegate { get set }
    
    init(playerDelegate: ChessGamePlayerDelegate)
}

protocol ComputerGameFlyable {
    func fly()
}

protocol ComputerGameDrawable {
    func draw()
}

class AllInOne: ChessGamePlayerDelegate, ChessGameEngineDelegate {
    var playerDelegate: ChessGamePlayerDelegate
    
    required init(playerDelegate: ChessGamePlayerDelegate) {
        self.playerDelegate = playerDelegate
    }
    
    var disposition: Double {
        return Double()
    }
    func playerDidMove(from: ChessField, to: ChessField) {}
}

extension AllInOne: ComputerGameFlyable, ComputerGameDrawable {
    func fly() {}
    func draw() {}
}

//7. Создайте расширение с функцией для:
//
//     a. CGRect, которая возвращает CGPoint с центром этого CGRect’а
//
//     b. CGRect, которая возвращает площадь этого CGRect’а

extension CGRect {
    var center: CGPoint {
        return CGPoint(x: origin.x + width / 2, y: origin.y + height / 2)
    }
    
    var square: CGFloat {
        return width * height
    }
}

let c = CGRect(x: 10, y: 10, width: 100, height: 60)
c.center
c.square

//
//     c. UIView, которое анимированно её скрывает (делает alpha = 0)

extension UIView {
    func fadeOut(withDuration: TimeInterval = 0.3, completion: ((Bool) -> Void)?) {
        UIView.animate(withDuration: withDuration,
                       animations: { self.alpha = 0 },
                       completion: completion)
    }
}

class MasterVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let subview = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        subview.backgroundColor = .yellow
        
        view.addSubview(subview)
        subview.fadeOut(withDuration: 1, completion: nil)
    }
}
PlaygroundPage.current.liveView = MasterVC()

//
//     d. протокола Comparable, на вход получает еще два параметра того же типа: первое ограничивает минимальное значение, второе – максимальное; возвращает текущее значение. ограниченное этими двумя параметрами. Пример использования:
//
//            7.bound(minValue: 10, maxValue: 21) -> 10
//            7.bound(minValue: 3, maxValue: 6) -> 6
//            7.bound(minValue: 3, maxValue: 10) -> 7

extension Comparable {
    func bound(minValue: Self, maxValue: Self) -> Self {
        guard (self < minValue || self > maxValue) else { return self }
        
        return (self < minValue) ? minValue : maxValue
    }
}

7.bound(minValue: 10, maxValue: 21)
7.bound(minValue: 3, maxValue: 6)
7.bound(minValue: 3, maxValue: 10)


//
//     e. Array, который содержит элементы типа Int: функцию для подсчета суммы всех элементов

extension Array where Element == Int {
    func sum() -> Int {
        return self.reduce(0, +)
    }
}

let array = [3, 4, 100]
array.sum()

//8. В чем основная идея Protocol oriented programming?

//Протоколы решают проблему множественного наследования и делают код более безопасным, особенно в условиях многопоточности за счет использования value types вместо reference types, которыми являются классы.


