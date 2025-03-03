import Cocoa

/*Еще один порождающий паттерн, довольно прост и популярен.Паттерн позволяет
 переложить создание специфических объектов, на наследников родительского
 класса, потому можно манипулировать объектами на более высоком уровне, не
 заморачиваясь объект какого класса будет создан. Частенько этот паттерн
 называют виртуальный конструктор, что по моему мнению более выражает его
 предназначение.
 Когда использовать:
 1. Мы не до конца уверены объект какого типа нам необходим.
 2. Мы хотим чтобы не родительский объект решал какой тип создавать, а его
 наследники.
 Почему хорошо использовать:
 Объекты созданные фабричным методом – схожи, потому как у них один и тот же
 родительский объект. Потому, если локализировать создание таких объектов, то
 можно добавлять новые типы, не меняя при это код который использует
 фабричный метод.
 Пример:
 Давайте представим, что мы такой неправильный магазин в котором тип товара
 оценивается по цене:) На данный момент товар есть 2х типов – Игрушки и
 Одежда.
 В чеке мы получаем только цены, и нам надо сохранить объекты которые
 куплены.
 Для начала создадим класс протокол Product. Его реализация нас особо не
 интересует, хотя он может содержать в себе общие для разных типов товаров
 методы (сделано
 для примера, мы их особо не используем):*/

protocol Product {
    var price: Int { get }
    var name: String { get }
    
    func getTotalPrice(sum: Int) -> Int
    func saveObject()
}

extension Product {
    func getTotalPrice(sum: Int) -> Int {
        return price + sum
    }
}

class Toy: Product {
    var price = 50
    var name = "Toy"
    
    func saveObject() {
        print("Saying object into Toys database")
    }
}

class Dress: Product {
    var price = 150
    var name = "Dress"
    
    func saveObject() {
        print("Saying object into Dress database")
    }
}


//теперь надо создать метод, который будет по цене определять, что же это за продукт, и создавать объект необходимого типа

class ProductGenerator {
    func getProduct(price: Int) -> Product? {
        switch price {
        case 0..<100:
            return Toy()
        case 100..<Int.max:
            return Dress()
        default:
            return nil
        }
    }
}


//теперь создадим метод, который будет считать и записывать расходы

func saveExpenses(price: Int) {
    let pd = ProductGenerator()
    let expense = pd.getProduct(price: price)
    expense?.saveObject()
}

saveExpenses(price: 50)
saveExpenses(price: 56)
saveExpenses(price: 79)
saveExpenses(price: 100)
saveExpenses(price: 123)
saveExpenses(price: 51)

