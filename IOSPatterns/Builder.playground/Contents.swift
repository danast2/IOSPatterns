import Cocoa

/*
 Builder
 Вот представьте что у нас есть фабрика. Но в отличии от фабрики из
 предыдущего поста, она умеет создавать только телефоны на базе андроида, и
 еще при этом различной конфигурации. То есть, есть один объект, но при этом его
 состояние может быть совершенно разным, а еще представьте если его очень
 трудно создавать, и во время создания этого объекта еще и создается миллион
 дочерних объектов. Именно в такие моменты, нам очень помогает такой паттерн
 как строитель.
 Когда использовать:
 1. Создание сложного объекта
 2. Процесс создания объекта тоже очень не тривиальный – к примеру
 получение данных из базы и манипуляция ими.
 Сам паттерн состоит из двух компонент – Bulilder и Director. Builder занимается
 именно построение объекта, а Director знает какой Builder использовать чтобы
 выдать необходимый продукт. Приступим!
 Пускай у нас есть телефон, который обладает следующими свойствами:
 */


class AndroidPhone {
    var osVersion: String!
    var name: String!
    var cpuCodeName: String!
    var RAMsize: Int!
    var osVersionCode: Double!
    var launcher: String!
}

//Давайте создадим дженерик строителя от которого будут наследоваться
//конкретные строители:

protocol BPAndroidPhoneBuilder {
    var phone: AndroidPhone { get }

    func setOSVersion()
    func setName()
    func setCPUCodeName()
    func setRAMSize()
    func setOSVersionCode()
    func setLauncher()
}


class LowPricePhoneBuilder: BPAndroidPhoneBuilder{
    var phone = AndroidPhone()

    func setOSVersion() {
        phone.osVersion = "Android 2.3"
    }
    func setName() {
        phone.name = "Low price phone!"
    }
    func setCPUCodeName() {
        phone.cpuCodeName = "Some shitty CPU"
    }
    func setRAMSize() {
        phone.RAMsize = 256
    }
    func setOSVersionCode() {
        phone.osVersionCode = 3.0
    }
    func setLauncher() {
        phone.launcher = "Hia Tsung!"
    }
}

//И конечно же строительство дорогого телефона:


class HighPricePhoneBuilder: BPAndroidPhoneBuilder {
    var phone = AndroidPhone()

    func setOSVersion() {
        phone.osVersion = "Android 4.1"
    }
    func setName() {
        phone.name = "High price phone!"
    }
    func setCPUCodeName() {
        phone.cpuCodeName = "Some shitty but expensive CPU"
    }
    func setRAMSize() {
        phone.RAMsize = 1024
    }
    func setOSVersionCode() {
        phone.osVersionCode = 4.1
    }
    func setLauncher() {
        phone.launcher = "Samsung Launcher"
    }
}


//Кто-то же должен использовать строителей, потому давайте создадим объект
//который будет с помощью строителей создавать дешевые или дорогие телефоны:

class FactorySalesMan {
    private var builder: BPAndroidPhoneBuilder!
    
    var phone: AndroidPhone {
        return builder.phone
    }
    
    func setBuilder(builder: BPAndroidPhoneBuilder) {
        self.builder = builder
    }
    
    func constructPhone() {
        builder.setOSVersion()
        builder.setName()
        builder.setCPUCodeName()
        builder.setRAMSize()
        builder.setOSVersion()
        builder.setOSVersionCode()
        builder.setLauncher()
    }
}


let cheapPhoneBuilder = LowPricePhoneBuilder()
let expensivePhoneBuilder = HighPricePhoneBuilder()
let salesMan = FactorySalesMan()
salesMan.setBuilder(builder: cheapPhoneBuilder)
salesMan.constructPhone()
var phone = salesMan.phone
print("Phone Name = \(phone.name!), osVersion = \(phone.osVersion!), cpu code name = \(phone.cpuCodeName!), ram size = \(phone.RAMsize!), osversion code = \(phone.osVersionCode), launcher = \(phone.launcher!)")
salesMan.setBuilder(builder: expensivePhoneBuilder)
salesMan.constructPhone()
phone = salesMan.phone
print("Phone Name = \(phone.name!), osVersion = \(phone.osVersion!),cpu code name = \(phone.cpuCodeName!), ram size = \(phone.RAMsize!),osversion code = \(phone.osVersionCode), launcher = \(phone.launcher!)")
