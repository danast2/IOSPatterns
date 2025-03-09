import Cocoa

//Ах, как же не хватает в жизни таких штук как Quick Save и Quick Load. На худой
//конец Ctrl + Z. Это я Вам как геймер давнейший говорю! Частенько, такой
//функционал очень полезен для реализации в приложении. Очень правильно
//также защитить наше записанное состояние от других классов, чтобы в них не
//смогли внести изменения.
//Итак, что же за паттерн такой? Memento – паттерн который позволяет, не нарушая
//инкапсуляцию, зафиксировать и сохранить внутреннее состояние объекта, чтобы
//позже восстановить его состояние.
//Состояние, как таковое, может сохраняться как в файловую систему, так и в базу
//даных. Яркий пример использование – может быть сворачивание и выключение
//вашего приложения – во время выключения приложения вы можете сохранить все
//данные с формы, или настройки, или еще что вам угодно в базу даных через
//CoreData, чтобы восстановить при включении.
//Когда использовать паттерн:
//1. Вам необходимо сохранять состояние объекта как слепок(snapshot) за
//определенный период
//2. Вы хотите скрыть интерфейс получения состояния объекта.
//В данном паттерне используется три ключевые объекта: Caretaker ( объект
//который скрывает реализацию сохранения состояния объекта), originator
//( собственно сам объект ) и конечно же сам Memento ( объект который
//сохраняет состояние originator ).
//Давайте небольшой пример:

class OriginatorState {
    var intValue: Int = 0
    var stringValue: String = ""
}


//Допустим, у нас есть состояние, в котором всего лишь два значение –
//целочисленное и строчка.

class Originator {

    private var localState = OriginatorState()

    init() {
        localState.intValue = 100
        localState.stringValue = "Hello World!"
    }

    func changeValues() {
        localState.intValue += 1
        localState.stringValue += "!"

        print("Current state int = \(localState.intValue), string = \(localState.stringValue)")
    }

    func getState() -> OriginatorState {
        return localState
    }

    func setState(oldState: OriginatorState) {
        localState = oldState
        print("Load completed. Current state: int = \(localState.intValue), string = \(localState.stringValue)")
    }
}


//Как видим, мы можем изменять состояние объекта состояния, а так же получить
//состояние и загрузить состояние.
//Пускай у нас есть Memento – объект который будет заведовать состояние нашего
//объекта:

class Memento {
    private let localState = OriginatorState()

    init(state: OriginatorState) {
        localState.intValue = state.intValue
        localState.stringValue = state.stringValue
    }

    func getState() -> OriginatorState {
        return localState
    }
}

//То есть наш объект Memento – умеет хранить состояние, и конечно же отдавать
//состояние:)
//Ну и теперь, соединим все это в единый пазл создавая Caretaker:

class Caretaker {
    private let originator = Originator()
    private var memento: Memento!

    func changeValue() {
        originator.changeValues()
    }
    func saveState() {
        let state = originator.getState()
        memento = Memento(state: state)
        print("Saved state. State int = \(state.intValue) and string = \(state.stringValue)")
    }
    func loadState() {
        originator.setState(oldState: memento.getState())
    }
}

//Как видим Caretaker умеет держать в себе сохраненное состояние(для примера,
//оно все очень просто, но здесь может быть и стек состояний, и так далее), а так
//же загружать его:)
//Давайте протестим:

let crtaker = Caretaker()
crtaker.changeValue()
crtaker.saveState()
crtaker.changeValue()
crtaker.changeValue()
crtaker.changeValue()
crtaker.loadState()
