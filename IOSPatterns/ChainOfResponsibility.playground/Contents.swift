import Cocoa

//Паттерн с моим любимым названием:)
//Представьте себе очередь людей которые пришли за посылками. Выдающий
//посылки человек, дает первую посылку первому в очереди человеку, он смотрит на
//имя-фамилию на коробке, видит что посылка не для него, и передает посылку
//дальше. Второй человек делает собственно тоже самое, и так пока не найдется
//получатель.
//Цепочка ответственности (chain of responsibility) – позволяет вам передавать
//объекте по цепочке объектов-обработчиков, пока не будет найден необходимый
//объект обработчик.
//Когда использовать этот паттерн:
//1. У вас более чем один объект-обработчик.
//2. У вас есть несколько объектов обработчика, при этом вы не хотите
//специфицировать который объект должен обрабатывать в данный момент
//времени.
//Как всегда – пример:
//Представим что у нас есть конвейер, который обрабатывает различные
//предметы которые на нем: игрушки, электронику и другие.
//Для начала создадим классы объектов которые могут быть обработаны нашими
//обработчиками:

//базовый объект
protocol BasicItem {}

//игрушка
class Toy: BasicItem {}

//электроника

class Electronics: BasicItem {}

// и мусор

class Trash: BasicItem {}

//Теперь создадим обработчики:


protocol BasicHandler {
    var nextHandler: BasicHandler? { get set }
    func handleItem(item: BasicItem)
}

//Как видим, наш базовый обработчик, умеет обрабатывать объекты типа BasicItem.
//И самое важное – он имеет ссылку на следующий обработчик ( как в нашей
//очереди, про людей передающие посылку ).
//Давайте создадим код обработчика игрушки:

class ToysHandler: BasicHandler {
    var nextHandler: BasicHandler?

    func handleItem(item: BasicItem) {
        switch item {
        case is Toy:
            print("Toy found. Handling")
        default:
            print("Toy not found. Handling using next handler")
        nextHandler?.handleItem(item: item)
        }
    }
}

//Как видим, если обработчик получает объект класса Toy – то он его
//обрабатывает, если нет – то обработчик передает объект следующему
//обработчику.
//По аналогии создадим два следующих обработчика: для электроники, и мусора:


class ElectronicsHandler: BasicHandler {
    var nextHandler: BasicHandler?

    func handleItem(item: BasicItem) {
        switch item {
        case is Electronics:
            print("Electronics found. Handling")
        default:
            print("Electronics not found. Handling using next handler")
        nextHandler?.handleItem(item: item)
        }
    }
}

class OtherItemsHandler: BasicHandler {
    var nextHandler: BasicHandler?

    func handleItem(item: BasicItem) {
        print("Found undefined item. Destroying")
    }
}

//Как видим OtherItemsHandler в случае, когда до него дошло дело – объект
//уничтожает, и не пробует дергать следующий обработчик.
//Давайте тестировать:

let toysHandler = ToysHandler()
let electronicsHandler = ElectronicsHandler()
let otherItemHandler = OtherItemsHandler()
electronicsHandler.nextHandler = otherItemHandler
toysHandler.nextHandler = electronicsHandler
let toy = Toy()
let electronic = Electronics()
let trash = Trash()
toysHandler.handleItem(item: toy)
toysHandler.handleItem(item: electronic)
toysHandler.handleItem(item: trash)
