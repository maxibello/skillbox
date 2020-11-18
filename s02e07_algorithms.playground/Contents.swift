import UIKit

//Реализуйте класс linked list, работающий только со строками. Сделайте в нём функцию поиска строки.

var linkedList = LinkedList<String>()

linkedList.append("lol")
linkedList.append("kek")
linkedList.append("kukarek")

print(linkedList.search(what: "kek"))
print(linkedList.search(what: "keks"))
print("________________________________")
//Реализуйте класс для бинарного дерева поиска, работающий только со строками. Сделайте в нём функцию поиска.

var exampleTree: BinarySearchTree<String> {
    var bst = BinarySearchTree<String>()
    bst.insert("Леонид")
    bst.insert("Ольга")
    bst.insert("Мирон")
    bst.insert("Евлампий")
    bst.insert("Семен")
    bst.insert("Анатолий")
    return bst
}
print(exampleTree)
print(exampleTree.search("Семен"))
print("________________________________")

//Реализуйте класс для графа со станциями метро, где рёбра хранят в себе длительность переезда между двумя станциями. Сделайте в нём поиск пути (любым способом) с одной станции на другую.

let graph = AdjacencyList<String>()

let gorkovskoeShosse = graph.createVertex(data: "Горьковское шоссе")
let frunzenskaya = graph.createVertex(data: "Фрунзенская")
let dekabristov = graph.createVertex(data: "Декабристов")
let volgogradskaya = graph.createVertex(data: "Волгоградская")
let moskovskaya = graph.createVertex(data: "Московская")
let kozyaSloboda = graph.createVertex(data: "Козья слобода")
let kremlevskaya = graph.createVertex(data: "Кремлевская")

graph.add(.undirected, from: gorkovskoeShosse, to: frunzenskaya, weight: 2)
graph.add(.undirected, from: frunzenskaya, to: dekabristov, weight: 3)
graph.add(.undirected, from: dekabristov, to: volgogradskaya, weight: 4)
graph.add(.undirected, from: dekabristov, to: moskovskaya, weight: 2)
graph.add(.undirected, from: dekabristov, to: kozyaSloboda, weight: 1)
graph.add(.undirected, from: kozyaSloboda, to: kremlevskaya, weight: 4)

let dijkstra = Dijkstra(graph: graph)
let pathsFromDekabristov = dijkstra.shortestPath(from: dekabristov)
let pathToKremlevskaya = dijkstra.shortestPath(to: kremlevskaya, paths: pathsFromDekabristov)

for edge in pathToKremlevskaya {
  print("\(edge.source) --|\(edge.weight ?? 0.0)|--> \(edge.destination)")
}
print("________________________________")

//Реализуйте функцию сортировки массива ещё двумя способами, кроме рассказанных на уроке.

var arr = [100, -2, 10, 4, 0, 13]
InsertionSort.insertionSort(&arr)
print(arr)


arr = [100, -2, 10, 4, 0, 13]
print(MergeSort.mergeSort(arr))
