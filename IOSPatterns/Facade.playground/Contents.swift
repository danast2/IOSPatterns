import Cocoa

//Многие сложные системы состоят из огромной кучи компонент. Так же и в жизни,
//очень часто для совершения одного основного действия, мы должны выполнить
//много маленьких.
//К примеру, чтобы пойти в кино нам надо:
//1. Посмотреть расписание фильмов, выбрать фильм, посмотреть когда есть
//сеансы, посмотреть когда у нас есть время.
//2. Необходимо купить билет, для этого ввести номер карточки, секретный код,
//дождаться снятия денег, распечатать билет.
//3. Приехать в кинотеатр, припарковать машину, купить попкорн, найти
//места, смотреть.
//И все это для того, чтобы просто посмотреть фильм, который нам, очень
//вероятно, не понравится.
//Или же возьмем пример Amazon – покупка с одного клика – как много систем
//задействовано в операции покупки? И проверка Вашей карточки, и проверка
//Вашего адреса, проверка товара на складе, проверка или возможна доставка
//данного товара в даную точку мира… В результате очень много действий
//которые происходят всего по одному клику.
//Для таких вот процессов был изобретен паттерн – Фасад ( Facade )
//который предоставляет унифицированный интерфейса к большому
//количеству интерфейсов системы, в следствии чего систему стает гораздо
//проще в использовании.
//Давайте, попробуем создать систему которая нас переносит в другую точку мира с
//одного нажатия кнопки! С начала нам нужна система которая проложит путь от
//нашего места пребывания в место назначения:

class PathFinder {
    func findCurrentLocation() {
        print("Finding your location. Hmmm, here you are!")
    }

    func findLocationToTravel(location: String) {
        print("So you wanna travell to " + location)
    }
    func makeARoute() {
        print("Okay, to travell to this location we are using google maps....")
    }
}

//Естественно нам необходима сама система заказа транспорта и собственно
//путешествия:

class TravellEngine {
    func findTransport() {
        print("Okay, to travell there you will probabply need dragon! Arghhhhh")
    }
    func orderTransport() {
        print("Maaaam, can I order a dragon?... Yes... Yes, green one... Yes, with fire!... No, not a dragon of death... Thank you!")
    }
    func travel() {
        print("Maaan, you are flying on dragon!")
    }
}

//Ну и какие же путешествия без билетика:
class TicketPrinitingSystem {
    func createTicket() {
        print("Connecting to our ticketing system...")
    }
    func printingTicket() {
        print("Hmmm, ticket for travelling on the green dragon.Interesting...")
    }
}

//А теперь, давайте создадим единый доступ ко всем этим системам:

class TravellSystemFacade {
    func travellTo(location: String) {
        let pf = PathFinder()
        let te = TravellEngine()
        let tp = TicketPrinitingSystem()

        pf.findCurrentLocation()
        pf.findLocationToTravel(location: location)
        pf.makeARoute()

        te.findTransport()
        te.orderTransport()

        tp.createTicket()
        tp.printingTicket()

        te.travel()
    }
}

let facade = TravellSystemFacade()
facade.travellTo(location: "Moscow")
