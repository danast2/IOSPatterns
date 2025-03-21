import Cocoa

//Кто вообще бы мог подумать, что Singleton такой не самый просто паттерн в iOS?
//Вернее, что есть столько версий. Собственно, в .NET, помнится, наблюдалась
//точно такая же штука, но там в основном были просто апдейты к самой простой
//версии паттерна. Я вообще считаю, что сколько людей - столько и версий
//синглтона.
//Итак, давайте начнем с простого – с описания.
//Singleton - это такой объект, который существует в системе только в
//единственном экземпляре. Очень часто используется для хранения каких-то
//глобальных переменных, например настроек приложения.
//Итак, как и все в Obj-C начнем мы естественно с создания интерфейса:
//Как видим, обычный объект с одним свойством и класс методом


class SingletonObject {
    private static let obj: SingletonObject = {
        return SingletonObject()
    }()
    
    class func singleton() -> SingletonObject {
        return obj
    }
    
    var tempProperty: String!
}

//Собственно вот и все:) iOS сам за нас позаботится о том, чтобы создан был
//только один экземпляр нашего объекта.

//Ну, а использование простое:

SingletonObject.singleton().tempProperty = "Hello 2 you"
print(SingletonObject.singleton().tempProperty)
