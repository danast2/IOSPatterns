import Cocoa

//Вы задумывались как много в нашей жизни древовидных структур? Начиная
//собственно от самих деревьев, и заканчивая структурами компаний. Да даже,
//ладно компаний – целые страны используют древовидные структуры, чтобы
//построить власть.
//Во главе компании или страны частенько стоит один человек, у него есть с 10
//помощников. У них тоже есть с десяток помощников, и так далее… Если
//нарисовать их отношения на листе бумаги – увидим дерево!
//Очень часто, и мы используем такие типы даных, которые лучше всего хранятся
//в древовидной структуре. Возьмите к примеру стандартный UI: в начале у нас
//есть View, в нем находятся Subview, в которых могут быть или другие View, или
//все такие компоненты. Та же самая структура:)
//Именно для хранения таких типов данных, а вернее их организации, используется
//паттерн – Композит.
//Когда использовать такой паттерн?
//Собственно когда вы работаете с древовидными типами данных, или хотите
//отобразить иерархию даных таким образом.
//Давайте разберем более детально структуру:
//В начале всегда есть контейнер в котором находятся все остальные объекта.
//Контейнер может хранить как другие контейнеры – ветки нашего дерева, так и
//объекты которые контейнерами не являются – листья нашего дерева. Не сложно
//представить, что контейнеры второго уровня могут хранить как другие
//контейнеры, так и листья.
//Давайте пример!
//Начнем с создания протокола для наших объектов:

protocol CompositeObjectProtocol {
    func getData() -> String
    func addComponent(component: CompositeObjectProtocol)
}
class LeafObject: CompositeObjectProtocol {

    var leafValue: String!

    func getData() -> String {
        return "\n" + "<\(leafValue!)/>"
    }
    func addComponent(component: CompositeObjectProtocol) {
        print("Can't add component. Sorry, man")
    }
}


//Как видим наш объект не может добавлять себе детей (ну он же не контейнер:) ),
//и может возвращать свое значение с помощью метода getData.
//Теперь нам очень необходим контейнер:

class Container: CompositeObjectProtocol {

    private var components = [CompositeObjectProtocol]()

    func getData() -> String {
        var valueToReturn = "<ContainerValues>"

        for component in components {
            valueToReturn += component.getData() + "\n"
        }

        valueToReturn += "</ContainerValues>"

        return valueToReturn
    }
    func addComponent(component: CompositeObjectProtocol) {
        components.append(component)
    }

}

//Как видим, наш контейнер может добавлять в себя детей, которые могут быть как
//типа Container так и типа LeafObject. Метод getData же, бегает по всем объектам в
//массиве components, и вызывает тот же самый метод в детях. Вот собственно и
//все.
//Теперь, конечно же пример:

let rootContainer = Container()
let object = LeafObject()
object.leafValue = "level1 value"
rootContainer.addComponent(component: object)
let firstLevelContainer1 = Container()
let object2 = LeafObject()
object2.leafValue = "level2 value"
firstLevelContainer1.addComponent(component: object2)
rootContainer.addComponent(component: firstLevelContainer1)
let firstLevelContainer2 = Container()
let object3 = LeafObject()
object3.leafValue = "level2 value 2"
firstLevelContainer2.addComponent(component: object3)
rootContainer.addComponent(component: firstLevelContainer2)
print(rootContainer.getData())
