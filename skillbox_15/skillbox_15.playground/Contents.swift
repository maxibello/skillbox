import UIKit

// Напишите своими словами, что такое pure function
//Это функция, которая не создает побочных эффектов для экосистемы, в которой она запущена и которая не зависит от каких-либо внешних состояний. Она всегда возвращает один и тот же результат для одного и того же набора входных параметров, независимо от того, когда и сколько раз была вызвана.

// Отсортируйте массив чисел по возрастанию используя функцию sorted
let intArr = [23, 100, 344, 0, -10, 43]
let newArr = intArr.sorted()

// Переведите массив числе в массив строк с помощью функции map
let stringArr = newArr.map { String($0) }

// Переведите массив строк с именами людей в одну строку, содержащую все эти имена, с помощью функции reduce
let names = ["Jacob", "Sarah", "Peter", "John", "Milana"]
let oneLiner = names.reduce("", { $0 + $1 })


print(oneLiner)

// Напишите функцию, которая принимает в себя функцию c типом (Void) -> Void, которая будет вызвана с задержкой в 2 секунды
func delayedForTwoSec(f:@escaping () -> ()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
       f()
    }
}

// Напишите функцию, которая принимает в себя две функции и возвращает функцию, которая при вызове выполнит первые две функции
func delegateFunctions(f1: @escaping () -> (), f2: @escaping () -> ()) -> () -> () {
    let f = {
        f1()
        f2()
    }
    return f
}

//delegateFunctions(f1: { print("f1") }, f2: { print("f2") })()

//Напишите функцию, которая сортирует массив по переданному алгоритму: принимает в себя массив чисел и функцию, которая берет на вход два числа и возвращает Bool (должно ли первое число идти после второго) и возвращает массив, отсортированный по этому алгоритму

func setupSort(for arr: [Int], f: (Int, Int) -> Bool) -> [Int] {
    return arr.sorted(by: f)
}

// Напишите своими словами что такое infix, suffix, prefix операторы.
//Операторы позволяют добавлять типам кастомное поведение, например:
// - infix, добавлять такие операторы как +-
// - prefix, определить свою логику для унарного минуса
// - postfix, определить свою логику операторы, который следует за операндом (b!)
