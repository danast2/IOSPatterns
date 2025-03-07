import Cocoa

//Медиатор – паттерн которые определяет внутри себя объект, в котором
//реализуется взаимодействие между некоторым количеством объектов. При этом
//эти объекты, могут даже не знать про существования друг друга, потому
//взаимодействий реализованных в медиаторе может быть огромное количество.
//Когда стоит использовать:
//1. Когда у вас есть некоторое количество объектов, и очень тяжело
//реализовать взаимодействие между ними. Яркий пример – умный дом.
//Однозначно есть несколько датчиков, и несколько устройств. К примеру, датчик
//температуры следит за тем какая на данный момент температура, а
//кондиционер умеет охлаждать воздух. При чем кондиционер, не обязательно
//что знает про существования датчика температуры. Есть центральный
//компьютер, который получает сигналы от каждого из устройств и понимает,
//что делать в том или ином случает.
//2. Тяжело переиспользовать объект, так как он взаимодействует и
//коммуницирует с огромным количеством других объектов.
//3. Логика взаимодействия должна легко настраиваться и расширяться.
//Собственно, пример медиатора даже писать бессмысленно, потому как это любой
//контроллер который мы используем во время нашей разработки. Посудите сами –
//на view есть очень много контролов, и все правила взаимодействия мы
//прописываем в контроллере. Элементарно.
//И все же пример не будет лишним Давайте все же создадим пример который
//показывает создание аля умного дома.
//Пускай у нас есть оборудование которое может взаимодействовать с нашим умным
//домом:


class SmartHousePart {
    private var processor: CentrallProcessor

    init(processor: CentrallProcessor) {
        self.processor = processor
    }

    func numbersChanged() {
        processor.valueChanged(part: self)
    }
}

class CentrallProcessor {

    var thermometer: Thermometer!
    var condSystem: ConditioningSystem!

    func valueChanged(part: SmartHousePart) {
        print("Value changed! We need to do smth!")
        if part is Thermometer {
            condSystem.startCondition()
        }
    }
}

//Дальше в классе CentrallPart в методе valueChanged мы определяем с какой
//деталью и что произошло, чтобы адекватно среагировать. В нашем примере –
//изменение температуры приводит к тому что мы включаем кондиционер.
//А вот, и код термометра и кондиционера:

class Thermometer: SmartHousePart {
    private var temperature: Int!
    func temperatureChanged(temperature: Int) {
        self.temperature = temperature
        numbersChanged()
    }
}
class ConditioningSystem: SmartHousePart {
    func startCondition() {
        print("Conditioning...")
    }
}

//Как видим в результате у нас есть два объекта, которые друг про друга не в курсе, и
//все таки они взаимодействуют друг с другом посредством нашего медиатора
//CentrallProcessor.
//Код для тестинга:


let proccessor = CentrallProcessor()
let therm = Thermometer(processor: proccessor)
let condSystem = ConditioningSystem(processor: proccessor)
proccessor.condSystem = condSystem
proccessor.thermometer = therm
therm.temperatureChanged(temperature: 45)
