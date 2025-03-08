import Cocoa

//Вот у каждого дома вероятнее всего есть холодильник. В ВАШЕМ доме, ВАШ
//холодильник. Что будет если холодильник сломается? Некоторые пойдут
//почитают в интернете как чинить холодильник, какая модель, попробуют
//поколдовать над ним, и разочаровавшись вызовут мастера по ремонту
//холодильников. Заметьте – холодильник ваш, но функцию “Чинить Холодильник”
//выполняет совершенно другой человек, про которого вы ничего не знаете, а
//попросту – обычный визитер.
//Паттерн визитер – позволяет вынести из наших объектов логику, которая относится к
//этим объектам, в отдельный класс, что позволяет нам легко изменять /
//добавлять алгоритмы, при этом не меняя логику самого класса.
//Когда мы захотим использовать этот паттерн:
//1. Когда у нас есть сложный объект, в котором содержится большое
//количество различных элементов, и вы хотите выполнять различные
//операции в зависимости от типа этих элементов.
//2. Вам необходимо выполнять различные операции над классами, и при
//этом Вы не хотите писать вагон кода внутри реализации этих классов.
//3. В конце – концов, вам нужно добавлять различные операции над
//элементами, и вы не хотите постоянно обновлять классы этих элементов.
//Чтож, давайте вернемся к примеру из прошлой статьи, только теперь сложнее – у
//нас есть несколько складов, в каждом складе может хранится товар. Один визитер
//будет смотреть склады, другой визитер будет называть цену товара в складе.
//Итак, для начала сам товар:

class WarehouseItem {
    let name: String
    let isBroken: Bool
    let price: Int

    init(name: String, isBroken: Bool, price: Int) {
        self.name = name
        self.isBroken = isBroken
        self.price = price
    }
}

//И естественно сам склад:

class Warehouse {
    private var itemsArray = [WarehouseItem]()

    func addItem(item: WarehouseItem) {
        itemsArray.append(item)
    }

    func accept(visitor: BasicVisitor) {
        for item in itemsArray {
            visitor.visit(object: item)
        }
    }
}


//Как видим, наш склад умеет хранить и добавлять товар, но также обладает
//таинственным методом accept который принимает в себя визитор и вызывает
//его
//метод visit. Чтобы картинка сложилась, давайте создадим протокол BasicVisitor и
//различных визиторов:

protocol BasicVisitor {
    func visit(object: AnyObject)
}

//Как видим, протокол требует реализацию только одного метода. Теперь давайте
//перейдем к самим визитерам:

class QualityCheckerVisitor: BasicVisitor {
    func visit(object: AnyObject) {
    switch object {
    case let item as WarehouseItem:
        if item.isBroken {
            print("Item: \(item.name) is broken")
        } else {
            print("Item: \(item.name) is pretty cool!")
        }
    case is Warehouse:
        print("Hmmm, nice warehouse!")
    default:
        break
        }
    }
}

//Если почитать код, то сразу видно что визитер при вызове своего метода visit
//определяет тип объекта который ему передался, и выполняет определенные
//функции в зависимости от этого типа. Данный объект просто говорит или вещи
//на
//складе поломаны, а так же что ему нравится склад:)

class PriceCheckerVisitor: BasicVisitor {
    func visit(object: AnyObject) {
    switch object {
    case let item as WarehouseItem:
        print("Item: \(item.name) have price = \(item.price)")
    case is Warehouse:
        print("Hmmm, I don't know how much Warehouse costs!")
    default:
        break
        }
    }
}

//принципе этот визитер делает тоже самое, только в случае склада он
//признается что растерян, а в случае товара говорит цену товара!
//Теперь давайте запустим то что у нас получилось! Код генерации тестовых даных:


let localWarehouse = Warehouse()
localWarehouse.addItem(item: WarehouseItem(name: "Item1", isBroken: false, price: 25))
localWarehouse.addItem(item: WarehouseItem(name: "Item2", isBroken: false, price: 32))
localWarehouse.addItem(item: WarehouseItem(name: "Item3", isBroken: true, price: 45))
localWarehouse.addItem(item: WarehouseItem(name: "Item4", isBroken: false, price: 33))
localWarehouse.addItem(item: WarehouseItem(name: "Item5", isBroken: false, price: 12))
localWarehouse.addItem(item: WarehouseItem(name: "Item6", isBroken: true, price: 78))
localWarehouse.addItem(item: WarehouseItem(name: "Item7", isBroken: true, price: 34))
localWarehouse.addItem(item: WarehouseItem(name: "Item8", isBroken: false, price: 51))
localWarehouse.addItem(item: WarehouseItem(name: "Item9", isBroken: false, price: 25))
let visitor = PriceCheckerVisitor()
let qualityVisitor = QualityCheckerVisitor()
localWarehouse.accept(visitor: visitor)
localWarehouse.accept(visitor: qualityVisitor)
