import Cocoa

//Если Ваша девушка злая, вы скорее всего будете общаться с ней осторожно.
//Если на вашем проекте завал, то вероятнее всего вы не будете предлагать в
//команде вечерком дернуть пива или поиграть в компьютерные игры. В различных
//ситуациях, у нас могут быть очень разные стратегии поведения. К примеру, в
//приложении вы можете использовать различные алгоритмы сжатия, в
//зависимости от того с каким форматом картинки вы работаете, или же куда вы
//хотите после этого картинку деть. Вот мы и добрались до паттерна Стратегия.
//Также отличным примером может быть MVC паттерн – в разных случаях мы
//можем использовать разные контроллеры для одного и того же View (к примеру
//авторизованный и не авторизованный пользователь).
//Паттерн Стратегия определяет семейство алгоритмов, которые могут
//взаимозаменяться.
//Когда использовать паттерн:
//1. Вам необходимы различные алгоритмы
//2. Вы очень не хотите использовать кучу вложенных If-ов
//3. В различных случаях ваш класс работает по разному.
//Давайте напишем пример – RPG игра, в которой у вас есть различные стратегии
//нападения Вашими персонажами:) Каждый раз когда вы делаете ход, ваши
//персонажи делают определенное действие. Итак, для начала управление
//персонажами!
//Создадим базовую стратегию:

protocol BasicStrategy {
    func actionCharacter1()
    func actionCharacter2()
    func actionCharacter3()
}

//Как видно из кода стратегии – у нас есть 3 персонажа, каждый из которых может
//совершать одно действие! Давайте научим персонажей нападать!

class AttackStrategy: BasicStrategy {
    func actionCharacter1() {
        print("Character 1: Attack all enemies!")
    }
    func actionCharacter2() {
        print("Character 2: Attack all enemies!")
    }
    func actionCharacter3() {
        print("Character 3: Attack all enemies!")
    }
}

//Как видим, при использовании такой стратегии наши персонажи нападают на все
//что движется! Давайте научим их защищаться:

class DefenceStrategy: BasicStrategy {
    func actionCharacter1() {
        print("Character 1: Attack all enemies!")
    }
    func actionCharacter2() {
        print("Character 2: Healing Character 1!")
    }
    func actionCharacter3() {
        print("Character 3: Protecting Character 2!")
    }
}

//Как видим во время защитной стратегии, наши персонажи действуют по-другому –
//кто атакует, кто лечит, а некоторый даже защищают:) Ну, теперь как-то надо это
//все использовать. Давайте создадим нашего игрока:


class Player {
    private var strategy: BasicStrategy!

    func makeAction() {
        strategy.actionCharacter1()
        strategy.actionCharacter2()
        strategy.actionCharacter3()
    }

    func changeStrategy(strategy: BasicStrategy) {
        self.strategy = strategy
    }
}

//Как видим наш игрок может только менять стратегию и действовать в зависимости
//от этой стратегии. Код
//для тестирования:

let p = Player()
let a = AttackStrategy()
let d = DefenceStrategy()
p.changeStrategy(strategy: a)
p.makeAction()
p.changeStrategy(strategy: d)
p.makeAction()
