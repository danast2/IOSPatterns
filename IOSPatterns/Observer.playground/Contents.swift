import Cocoa

//Что такое паттерн Observer? Вот вы когда нибудь подписывались на газету? Вы
//подписываетесь, и каждый раз когда выходит новый номер газеты вы получаете
//ее к своему дому. Вы никуда не ходите, просто даете информацию про себя, и
//организация которая выпускает газету сама знает куда и какую газету отнесут.
//Второе название этого паттерна – Publish – Subscriber.
//Как описывает этот паттерн наша любимая GoF книга – Observer определяет
//одно-ко-многим отношение между объектами, и если изменения происходят в
//объекте – все подписанные на него объекты тут же узнают про это изменение.
//Идея проста, объект который мы называем Subject – дает возможность другим
//объектам, которые реализуют интерфейс Observer, подписываться и отписываться от
//изменений происходящих в Subject. Когда изменение происходит
//– всем заинтересованным объектам высылается сообщение, что изменение
//произошло. В нашем случае – Subject – это издатель газеты, Observer это мы с
//вами – те кто подписывается на газету, ну и собственно изменение – это выход
//новой газеты, а оповещение – отправка газеты всем кто подписался.
//Когда используется паттерн:
//1. Когда Вам необходимо сообщить всем объектам подписанным на
//изменения, что изменение произошло, при этом вы не знаете типы этих
//объектов.
//2. Изменения в одном объекте, требуют чтоб состояние изменилось в других
//объектах, при чем количество объектов может быть разное.
//Реализация этого паттерна возможно двумя способами:
//1. Notification
//Notificaiton – механизм использования возможностей NotificationCenter самой
//операционной системы. Использование NSNotificationCenter позволяет объектам
//комуницировать, даже не зная друг про друга. Это очень удобно использовать
//когда у вас в паралельном потоке пришел push-notification, или же обновилась
//база, и вы хотите дать об этом знать активному на данный момент View.
//Чтобы послать такое сообщение стоит использовать конструкцию типа

//let broadCastMessage = Notification(name:
//Notification.Name("broadcastMessage"), object: self)
//NotificationCenter.default().post(broadCastMessage)

//Как видим мы создали объект типа NSNotification в котором мы указали имя
//нашего оповещения: “broadcastMessage”, и собственно сообщили о нем через
//NotificationCenter.
//Чтобы подписаться на событие в объекте который заинтересован в изменении
//стоит использовать следующую конструкцию:

//NotificationCenter.default().addObserver(self, selector: #selector(update),
//name: Notification.Name("broadcastMessage"), object: nil)

//Собственно, из кода все более-менее понятно: мы подписываемся на событие, и
//вызывается метод который задан в свойстве selector.

//2. Стандартный метод.
//Стандартный метод, это реализация этого паттерна тогда, когда Subject знает про
//всех подписчиков, но при этом не знает их типа. Давайте начнем с того, что
//создадим протокол Subject и класс Observer:

func ==(lhs: StandardObserver, rhs: StandardObserver) -> Bool {
    return lhs.hashValue == rhs.hashValue
}
class StandardObserver: Hashable {
    var hashValue: Int {
        return "\(Mirror(reflecting: self).subjectType)".hashValue
    }
    func valueChanged(name: String, value: String) {}
}
protocol StandardSubject {
    func addObserver(observer: StandardObserver)
    func removeObserver(observer: StandardObserver)
    func notifyObjects()
}

//Теперь, давайте создадим реализацию Subject:


class StandardSubjectImplementation: StandardSubject {

    private var name: String!
    private var value: String!

    var observerCollection = Set<StandardObserver>()

    func addObserver(observer: StandardObserver) {
        observerCollection.insert(observer)
    }
    func removeObserver(observer: StandardObserver) {
        observerCollection.remove(observer)
    }
    func notifyObjects() {
        for observer in observerCollection {
            observer.valueChanged(name: name, value: value)
        }
    }
    func changeValue(name: String, value: String) {
        self.name = name
        self.value = value
        notifyObjects()
    }
}


//Ну и куда же без обсерверов:

class SomeSubscriber: StandardObserver {
    override func valueChanged(name: String, value: String) {
        print("And some subscriber tells: Hmm, value \(value) changed to \(name)")
    }
}
class OtherSubscriber: StandardObserver {
    override func valueChanged(name: String, value: String) {
        print("And some another subscriber tells: Hmm, value \(value) changed to \(name)")
    }
}
let subj = StandardSubjectImplementation()
let someSubscriber = SomeSubscriber()
let otherSubscriber = OtherSubscriber()
subj.addObserver(observer: someSubscriber)
subj.addObserver(observer: otherSubscriber)
subj.changeValue(name: "strange value", value: "newValue")


//Ну и конечно же без использования KVO описание паттерна выглядело бы
//неполным.
//Одна из моих самых любимых особенностей Obj-C – это key-value coding. Про
//него очень клево описанно в официальной документации, но если объяснять на
//валенках – то это возможность изменять значения свойств объекта с помощью
//строчек – которые указывают именно само название свойства. Как пример такие
//две конструкции идентичны:

//changeableProperty = "new value"
//setValue("new value", forKey: "changeableProperty")

//Такая гибкость дает нам доступ к еще одной очень замечательной возможности,
//которая называется key-value observing. Опять же, все круто описано в
//документации, но если объяснять на валенках:) то это возможность подписаться
//на изменение любого свойства, у любого объекта который KV compilant, любым
//объектом. На самом деле легче объяснить на примере.
//Давайте создадим класс с одним свойством, которое мы будем менять:


class KVOSubject: NSObject {
    var changeableProperty: String!
}


//создадим объект который будет слушать изменение свойства
//changeableProperty:


//class KVOObserver: NSObject {
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : AnyObject]?, context: UnsafeMutableRawPointer) {
//     print("KVO: Value changed;")
// }
//}


//Как видим, этот класс реализует только один метод: observeValueForKeyPath.
//Этот метод будет вызван когда поменяется свойство объекта за которым мы
//наблюдаем.
//Теперь тест:


//let kvoSubj = KVOSubject()
//let kvoObserver = KVOObserver()
//kvoSubj.addObserver(kvoObserver, forKeyPath: "changeableProperty" ,
//options: .new, context: nil)
//kvoSubj.setValue("new value", forKey: "changeableProperty")
//kvoSubj.removeObserver(kvoObserver, forKeyPath: "changeableProperty")
//

//Как видно из примера, мы для объекта за которым мы наблюдаем, выполняем
//функцию addObserver – где устанавливаем кто будет наблюдать за изменениями,
//за изменениями какого свойства мы будем наблюдать и остальные опции. Дальше
//меняем значение свойства, и так как мы все это проделываем на нажатие кнопки
//– в конце мы удаляем наблюдателя с нашего объекта, что бы память не текла.
//Лог говорит сам за себя:
