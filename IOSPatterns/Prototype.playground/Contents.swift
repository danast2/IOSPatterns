import Cocoa
/*Прототип – один из самых простых паттернов, который позволяет нам получить
 точную копию необходимого объекта. То есть использовать как прототип для
 нового объекта
 Когда использовать:
 1. У нас есть семейство схожих объектов, разница между которыми только в
 состоянии их полей.
 2. Чтобы создать объект вам надо пройти через огонь, воду и медные трубы.
 Особенно если этот объект состоит из еще одной кучи объектов, многие из
 которых для заполнения требуют подгрузку даных из базы, веб сервисов и
 тому подобных источников. Часто, легче скопировать объект и поменять
 несколько полей
 3. Да и в принципе, нам особо и не важно как создается объект. Ну есть и
 есть.
 4. Нам страшно лень писать иерархию фабрик (читай дальше), которые будут
 инкапсулировать всю противную работу создания объекта.
 Да, и есть еще частое заблуждение ( вероятнее всего из названия ) – прототип –
 это архетип, которые никогда не должен использоваться, и служит только для
 создания себе подобных объектов. Хотя, прототип, как архетип – тоже
 достаточно популярный кейс. Собственно, нам ничего не мешает делать
 прототипом любой объект который у нас в подчинении.*/

//поверхностное копирование
class Person {
    var name: String!
    var surname: String!
    var age: Int!
}

let firstPerson = Person()
firstPerson.name = "Dima"
firstPerson.surname = "Surname"
let secondPerson = firstPerson

print("First Person name = \(firstPerson.name!) and surname = \(firstPerson.surname!)")
secondPerson.name = "Roma"
print("Second Person name = \(secondPerson.name!) and surname = \(firstPerson.surname!)")
print("First Person name = \(firstPerson.name!) and surname = \(firstPerson.surname!)")



//глубокое копирование
protocol Copying {
    init(instance: Self)
}

extension Copying {
    func copy() -> Self {
        return Self.init(instance: self)
    }
}
class PersonNew: Copying {
    var name: String!
    var surname: String!
    
    init() {}
    required init(instance: PersonNew) {
        self.name = instance.name
        self.surname = instance.surname
    }
}

let firstPersonNew = PersonNew()
firstPersonNew.name = "Dima"
firstPersonNew.surname = "Surname"

let secondPersonNew = firstPersonNew.copy()

print("First Person name = \(firstPersonNew.name!) and surname = \(firstPersonNew.surname!)")
secondPersonNew.name = "Roma"
print("Second Person name = \(secondPersonNew.name!) and surname = \(firstPersonNew.surname!)")
print("First Person name = \(firstPersonNew.name!) and surname = \(firstPersonNew.surname!)")

//это порождающий паттерн
