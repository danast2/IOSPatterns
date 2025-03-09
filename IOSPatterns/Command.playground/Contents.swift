import Cocoa

import Cocoa

//Стоять, лежать, сидеть – все это команды которые нам очень часто давали
//учителя физкультуры. Так как это очень часто происходит в нашей жизни, глупо
//было бы предполагать что кто нибудь не придумает шаблон с одноименным
//названием.
//Итак, паттерн – команда – позволяет инкапсулировать всю информацию
//необходимую для выполнения определенных операций, которые могут быть
//выполнены потом, используя объект команды.
//Образно говоря, если взять наш с вами пример физрука, родители давным давно
//инкапсулировали в нас команду ”Сидеть”, потому физрук использует ее чтобы мы
//сели, не объясняя при этом как это сделать.
//Когда использовать паттерн:
//Ну, собственно ответ один, и выходит он из описания, когда вы хотите
//инкапсулировать определенную логику в отдельный класс команду. Отличный
//пример – do/undo операции. У вас, вероятнее всего, будет так называемый
//CommandManager, которые будет запоминать что делает команда, и при желании
//отменять предыдущее действие если выполнить команду undo ( кстати, это
//может быть и просто метод ).
//Собственно, есть два пути реализации этого паттерна:
//Для начала создадим базовую команду:

protocol BaseCommand {
    func execute()
    func undo()
}

//Как видим у нашей команды аж два метода – сделать, и вернуть обратно
//изменения.
//Теперь реализации наших команд:

class FirstCommand: BaseCommand {

    private var originalString: String
    private var currentString: String

    init(argument: String) {
        originalString = argument
        currentString = argument
    }

    func printString() {
        print("Current string is equal to " + currentString)
    }

    func execute() {
        currentString = "This is a new string"
        printString()
        print("Execute command called")
    }
    func undo() {
        currentString = originalString
        printString()
        print("Undo of execute command called")
    }
}

//Как видим, наша первая команда просто умеет менять одну строчку. При чем
//всегда хранит оригинал, чтобы можно было отменить изменение.
//Вторая наша команда:

class SecondCommand: BaseCommand {

    private var originalNumber: Int
    private var currentNumber: Int

    init(number: Int) {
        originalNumber = number
        currentNumber = number
    }

    func execute() {
        currentNumber += 1
        printNumber()
    }
    func undo() {
    if currentNumber > originalNumber {
        currentNumber -= 1
    }
        printNumber()
    }

    func printNumber() {
        print("current number is \(currentNumber)")
    }
}

//Вторая команда делает тоже самое, но с числом.

//Давайте теперь создадим объект который будет получать команду и выполнять
//ее:

class CommandExecutor {
    private var arrayOfCommands = [BaseCommand]()

    func addCommand(command: BaseCommand) {
        arrayOfCommands.append(command)
    }

    func executeCommands() {
        for command in arrayOfCommands {
            command.execute()
        }
    }

    func undoAll() {
        for command in arrayOfCommands {
            command.undo()
        }
    }
}

//Как видим, наш менеджер может получать очередь команд, и выполнять их все,
//или даже отменять все действия (пример простой и с багами:) ). Итак, наш
//тестовый код:

let commandE = CommandExecutor()
let cmdF = FirstCommand(argument: "This is a test string")
let cmdS = SecondCommand(number: 3)
commandE.addCommand(command: cmdF)
commandE.addCommand(command: cmdS)
commandE.executeCommands()
commandE.undoAll()
