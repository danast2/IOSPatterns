import Cocoa

/*Абстрактная фабрика – еще один очень популярный паттерн, который как и в
 названии так и в реализации слегка похож на фабричный метод.
 Итак, что же делает абстрактная фабрика:
 Абстрактная фабрик дает простой интерфейс для создания объектов которые
 принадлежат к тому или иному семейству объектов.
 Отличия от фабричного метода:
 1. Фабричный метод порождает объекты одного и того же типа, фабрике же
 может создавать независимые объекты
 2. Чтобы добавить новый тип объекта – надо поменять интерфейс фабрики, в
 фабричном методе же легко просто поменять внутренности метода,
 который ответственный за порождение объектов.
 Давайте представим ситуацию: у нас есть две фабрики по производству iPhone и
 iPad. Одна оригинальная, компании Apple, другая – хижина дядюшки Хуа. И вот,
 мы хотим производить эти товары: если в страны 3-го мира – то товар от
 дядюшки, в другие страны – товар любезно предоставлен компанией Apple.
 Итак, пускай у нас есть фабрика, которая умеет производить и айпады и айфоны:*/

protocol IPhoneFactory {
    func getIPhone() -> GenericIPhone
    func getIPad() -> GenericIPad
}

protocol GenericIPhone {
    var osName: String { get }
    var productName: String { get }
}

protocol GenericIPad {
    var osName: String { get }
    var productName: String { get }
    var screenSize: Double { get }
}

//Пускай у нас есть два типа продуктов, оригинальные Apple и продукты которые
//произведены трудолюбивым дядюшкой Хуа:

class AppleIPhone: GenericIPhone {
    var osName = "IOS"
    var productName = "iPhone"
}

class AppleIPad: GenericIPad {
    var osName = "IOS"
    var productName = "iPad"
    var screenSize = 7.7
}


class ChinaPhone: GenericIPhone {
    var osName = "Android"
    var productName = "Chi Huan Hua Phone"
}
class ChinaPad: GenericIPad {
    var osName = "Windows CE"
    var productName = "Buan Que Ipado Killa"
    var screenSize = 12.5
}


//Разные телефоны, конечно же, производятся на различных фабриках, потому мы
//просто обязаны их создать! Приблизительно так должны выглядеть фабрика
//Apple:

class AppleFactory: IPhoneFactory {
    func getIPhone() -> GenericIPhone {
        return AppleIPhone()
    }
    func getIPad() -> GenericIPad {
        return AppleIPad()
    }
}

//Конечно же у нашего китайского дядюшки тоже есть своя фабрика:

class ChinaFactory: IPhoneFactory {
    func getIPhone() -> GenericIPhone {
        return ChinaPhone()
    }
    func getIPad() -> GenericIPad {
        return ChinaPad()
    }
}

//Как видим, фабрики одинаковые, а вот девайсы у них получатся разные
//Ну вот собственно и все, мы приготовили все что надо для демонстрации!
//Теперь, давайте напишем небольшой метод который будет возвращать нам
//фабрику которую мы хотим ( кстати, тут фабричный метод таки будет):

var isChinaWorld = true

func getFactory() -> IPhoneFactory {
    return isChinaWorld ? AppleFactory() : ChinaFactory()
}

isChinaWorld = true

let factory = getFactory()
let ipad = factory.getIPad()
let iphone = factory.getIPhone()

print("IPad named = \(ipad.productName), osname = \(ipad.osName), screensize = \(ipad.screenSize)")
print("IPhone named = \(iphone.productName), osname = \(iphone.osName)")
