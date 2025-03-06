import Cocoa

//Тяжело найти более красочно описание паттерна Адаптер, чем пример из жизни
//каждого, кто покупал технику из США. Розетка! Вот почему не сделать одинаковую
//розетку всюду? Но нет, в США розетка с квадратными дырками, в Европе с
//круглыми, а в некоторых странах вообще треугольные. Следовательно – потому
//вилки на зарядный устройствах, и других устройствах питания тоже различные.
//Представьте, что Вы едете в командировку в США. У Вас есть, допустим,
//ноутбук купленный в Европе – следовательно вилка на проводе от блока питания
//имеет круглые окончания. Что делать? Покупать зарядку для американского типа
//розетки? А когда вы вернетесь домой – она будет лежать у Вас мертвым грузом?
//Потому, вероятнее всего, Вы приобретете один из адаптеров, которые
//надеваются на вилку, и которая позволяет Вам использовать старую зарядку и
//заряжаться от совершенно другой розетки.
//Так и с Адаптером – он конвертит интерфейс класса – на такой, который
//ожидается.
//Сам паттерн состоит из трех частей: Цели (target), Адаптера (adapter), и
//адаптируемого (adaptee).
//В нашей с вами проблеме:
//1. Target – ноутбук со старой зарядкой
//2. Adapter – переходник.
//3.Adaptee – розетка с квадртаными дырками.


//Итак, первая – это простенькая имплементация. Пускай у нас есть объект Bird,
//который реализует протокол BirdProtocol:

protocol BirdProtocol {
    func sing()
    func fly()
}

class Bird: BirdProtocol {
    func sing() {
        print("Tew-tew-tew")
    }
    func fly() {
        print("OMG! I am flying!")
    }
}

//И пускай у нас есть объект Raven, у которого есть свой интерфейс:

class Raven {
    func flySearchAndDestroy() {
        print("I am flying and seak for killing!")
    }
    func voice() {
        print("Kaaaar-kaaaaar-kaaaaaaar!")
    }
}

//Чтобы использовать ворону в методах которые ждут птицу:) стоит создать так
//называемый адаптер:

class RavenAdapter: BirdProtocol {
    private var raven: Raven

    init(adaptee: Raven) {
        raven = adaptee
    }

    func sing() {
        raven.voice()
    }
    func fly() {
        raven.flySearchAndDestroy()
    }
}


func makeTheBirdTest(bird: BirdProtocol) {
    bird.fly()
    bird.sing()
}

let simpleBird = Bird()
let simpleRaven = Raven()
let ravenAdapter = RavenAdapter(adaptee: simpleRaven)

makeTheBirdTest(bird: simpleBird)
makeTheBirdTest(bird: ravenAdapter)


//Теперь более сложная реализация, которая все еще зависит от протоколов, но
//уже использует делегирование. Вернемся к нашему несчастному ноутбуку и
//зарядке: Допустим у нас есть базовый протокол Charger:


protocol Charger {
    func charge()
}

// И есть протокол для европейской зарядки:

protocol EuropeanNotebookChargerDelegate {
    func chargetNotebookRoundHoles(charger: Charger)
}
extension EuropeanNotebookChargerDelegate {
    func chargetNotebookRoundHoles(charger: Charger) {
        print("Charging with 220 and round holes!")
    }
}

//Если сделать просто реализацию – то получится тоже самое, что и в прошлом
//примере:) Потому, давайте добавим делегат:

class EuropeanNotebookCharger: Charger, EuropeanNotebookChargerDelegate {
    var delegate: EuropeanNotebookChargerDelegate!

    init() {
        delegate = self
    }

    func charge() {
        delegate.chargetNotebookRoundHoles(charger: self)
    }
}


//Как видим, у нашего класса есть свойство которое реализует тип
//EuropeanNotebookChargerDelegate. Так как, наш класс этот протокол реализует, он
//может свойству присвоить себя, потому когда происходит вызов:

//delegate.chargetNotebookRoundHoles(charger: self)

//просто вызывается реализация по умолчанию. Вы увидите дальше,
//для чего это сделано. Теперь, давайте глянем что ж за зверь такой –
//американская зарядка:

class USANotebookCharger {
    func chargeNotebookRectHoles() {
        print("Charge Notebook Rect Holes")
    }
}


//Как видим, в американской зарядке совсем другой метод и мировозрение.
//Давайте, создадим адаптер для зарядки:

class USANotebookEuropeanAdapter: Charger, EuropeanNotebookChargerDelegate {

    var usaCharger: USANotebookCharger!

    init(charger: USANotebookCharger) {
        usaCharger = charger
    }

    func chargetNotebookRoundHoles(charger: Charger) {
        usaCharger.chargeNotebookRectHoles()
    }

    func charge() {
        let euroCharge = EuropeanNotebookCharger()
        euroCharge.delegate = self
        euroCharge.charge()
    }

}


//Как видим, наш адаптер реализует интерфейс EuropeanNotebookChargerDelegate
//и его метод chargetNotebookRoundHoles. Потому, когда вызывается метод charge
//–
//на самом деле создается тип европейской зарядки, ей присваивается наш адаптер
//как делегат, и вызывается ее метод charge. Так как делегатом присвоен наш
//адаптер, при вызове метода chargetNotebookRoundHoles, будет вызван этот метод
//нашего адаптера, который в свою очередь вызывает метод зарядки США:)
//Давайте посмотрим тест код и вывод лога:


func makeTheNotebookCharge(charger: Charger) {
    charger.charge()
}
let euroCharger = EuropeanNotebookCharger()
makeTheNotebookCharge(charger: euroCharger)
let charger = USANotebookCharger()
let adapter = USANotebookEuropeanAdapter(charger: charger)
makeTheNotebookCharge(charger: adapter)
