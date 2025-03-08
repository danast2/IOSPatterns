import Cocoa

//Я задумался о том, какой бы пример из жизни привести, чтобы показать пример
//как работает паттерн итератор, и оказалось что это не такой простое задание. И
//как показывает практика, самый простой пример – это обычная вендинг машина. (
//сам пример взят из книги Pro Objective-C Design Patterns for iOS. ) . У нас есть
//контейнер, который разделен на секции, каждая из которых содержит
//определенный вид товара, к примеру набор бутылок Coca-Cola. Когда мы
//заказываем товар, то нам выпадет следующий из коллекции. Образно говоря,
//команда cocaColaCollection.next. Две независимые части – контейнер и итератор.
//Паттерн итератор позволяет последовательно обращаться к коллекции
//объектов,не особо вникая что же это за коллекция.
//Разделяют два вида итераторов – внутренний и внешний. Как видно из
//названия, внешний итератор – итератор про который знает клиент, и собственно
//он
//сам(клиент) скармливает коллекцию по которой надо бегать итератору.
//Внутренний итератор – это внутренняя кухня самой коллекции, которая
//предоставляет
//интерфейс клиенту для итерирования.
//При внешнем итераторе, клиенту надо:
//1. Вообще знать про существование итератора, хоть это и дает больше
//контроля.
//2. Создавать и управлять итератором.
//3. Можно использовать различные итераторы, для различных алгоритмов
//итерации.
//При внутренем:
//1. Клиенту совершенно не известно существование итератора. Он просто
//дергает интерфейс коллекции.
//2. Коллекция сама создает и управляет итератором
//3. Коллекция может менять различные итераторы, при этом не трогая код
//клиента.
//Когда использовать итератор:


//1. Вам необходимо доступиться к объектам коллекции, без того чтобу щупать
//внутренности коллекции.
//2. Вам надо обходить объекты коллекции различными способами (вспомните
//Композит – у вас коллекция может быть древовидной )
//3. Вам необходимо дать унифицированный интерфейс для различных подходов
//итерации.
//Самый просто пример внешнего итератора, это использование класса

let internallArrayCollection = ["A", "B", "C"]
var iterator = internallArrayCollection.makeIterator()
while let str = iterator.next() {
    print(str)
}

//Как видим, мы просто вызываем у объекта internallArrayCollection метод
// – и получаем необходимый нам итератор. Вообще можно не
//заморачиваться, и использовать обычный цикл for:

for str in internallArrayCollection {
    print(str)
}

//Я не уверен что смогу правильно объяснить разницу между созданием итератора
//и цикла for (если она есть), потому этот момент будет упущен.
//Одним из примеров реализации внешнего итератора – может быть итерация с
//помощью блоков:


var block: (Int, String, inout Bool) -> () = { index, str, stop in
    print("Index: \(index) Value: \(str)")
    if index == 1 {
        stop = true
    }
}
for (index, str) in internallArrayCollection.enumerated() {
    var stop = false
    block(index, str, &stop)
    if stop { break }
}


//Радость этого метода в том, что сам алгоритм итерации может написать другой
//программист, вам же необходимо будет только использовать блок написанный
//этим программистом.
//Приятно же:)
//Теперь давайте создадим свой итератор, а то и два:) Пускай у нас будет
//коллекция товаров, одни их них будут сломаны, другие же – целыми. Создадим
//два итератора, которые будут бегать по разным типам товаров. Итак, для начала
//сам клас товаров:


class ItemInShop {
    let name: String
    let isBroken: Bool

    init(name: String, isBroken: Bool) {
        self.name = name
        self.isBroken = isBroken
    }
}


//Как видим не густо – два свойства, и инициализатор.
//Теперь давайте создадим склад в котором собственно товары то и будут:

class ShopWarehouse {
    private var allItems = [ItemInShop]()

    var goodItemsIterator: GoodItemsIterator {
        return GoodItemsIterator(items: allItems)
    }

    var badItemsIterator: BadItemsIterator {
        return BadItemsIterator(items: allItems)
    }

    func addItem(item: ItemInShop) {
        allItems.append(item)
    }
}

//Как видим, наш склад умеет добавлять товары, а также возвращать два
//таинственных объекта под названием GoodItemsIterator и BadItemsIterator.
//Собственно их назначение очевидно, давайте посмотрим на реализацию. Для
//начала создадим базовый протокол для обоих:

protocol BasicIterator: IteratorProtocol {
    init(items: [ItemInShop])
    func allObjects() -> [ItemInShop]
}

//Как видим, это просто интерфейс, который предполагает реализацию 3х методов:
//инициализация, вернуть все объекты, и вернуть следующий объект. Давайте
//создадим два итератора как и задумывалось:


class BadItemsIterator: BasicIterator {

    typealias Element = ItemInShop

    private var items: [ItemInShop]
    private var internalIterator: IndexingIterator<[ItemInShop]>

    required init(items: [ItemInShop]) {
        self.items = items.filter { $0.isBroken }
        internalIterator = self.items.makeIterator()
    }

    func allObjects() -> [ItemInShop] {
        return items
    }

    func next() -> Element? {
        return internalIterator.next()
    }
}


class GoodItemsIterator: BasicIterator {

    typealias Element = ItemInShop

    private var items: [ItemInShop]
    private var internalIterator: IndexingIterator<[ItemInShop]>

    required init(items: [ItemInShop]) {
        self.items = items.filter { !$0.isBroken }
        internalIterator = self.items.makeIterator()
    }

    func allObjects() -> [ItemInShop] {
        return items
    }

    func next() -> Element? {
        return internalIterator.next()
    }
}

//Как видим во время инициализации, мы создаем свою копию данных, в которых
//только плохие товары. Так же создаем свой внутренний итератор, из стандартных
//Cocoa.
//Ну что, тестим:

let shopWarehouse = ShopWarehouse()
shopWarehouse.addItem(item: ItemInShop(name: "Item1", isBroken: false))
shopWarehouse.addItem(item: ItemInShop(name: "Item2", isBroken: false))
shopWarehouse.addItem(item: ItemInShop(name: "Item3", isBroken: true))
shopWarehouse.addItem(item: ItemInShop(name: "Item4", isBroken: true))
shopWarehouse.addItem(item: ItemInShop(name: "Item5", isBroken: false))

//Сам тест:

let goodIterator = shopWarehouse.goodItemsIterator
let badIterator = shopWarehouse.badItemsIterator
while let element = goodIterator.next() {
    print("Good Item = \(element.name)")
}
while let element = badIterator.next() {
    print("Bad Item = \(element.name)")
}
