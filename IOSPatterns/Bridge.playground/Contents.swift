import Cocoa

//Представьте себе, что у нас есть что-то однотипное, к примеру у нас есть
//телефон и куча наушников. Если бы у каждого телефона был свой разъем, то мы
//могли бы пользоваться только одним типом наушников. Но Бог миловал!
//Собственно та же штука и с наушникам. Они могут выдавать различный
//звук, иметь различные дополнительные функции, но основная их цель –
//просто
//звучание:) И хорошо, что во многих случаях штекер у них одинаковый ( я не
//говорю про различные студийные наушники:) ).
//Собственно, Мост (Bridge) позволяет разделить абстракцию от реализации, так
//чтобы реализация в любой момент могла быть поменяна, не меняя при этом
//абстракции.
//Когда использовать?
//1. Вам совершенно не нужна связь между абстракцией и реализацией.
//2. Собственно, как абстракцию так и имплементацию могут наследовать
//независимо. 3. Вы не хотите чтобы изменения в реализации имело влияния на клиентский
//код.
//Давайте создадим теперь базовую абстракцию наушников:

protocol BaseHeadphones {
    func playSimpleSound()
    func playBassSound()
}

//Наушники обычные - китайские
class CheapHeadphones: BaseHeadphones {
    func playSimpleSound() {
        print("beep - beep - bhhhrhrhrep")
    }
    func playBassSound() {
        print("puf - puf - pufhrrr")
    }
}

//наушники дорогие, тоже китайские

class ExpensiveHeadphones: BaseHeadphones {
    func playSimpleSound() {
        print("Beep-Beep-Beep Taram - Rararam")
    }
    func playBassSound() {
        print("Bam-Bam-Bam")
    }
}

class MusicPlayer {
    var headPhones: BaseHeadphones!

    func playMusic() {
        headPhones.playBassSound()
        headPhones.playBassSound()
        headPhones.playSimpleSound()
        headPhones.playSimpleSound()
    }
}


//Как видите, одно из свойств нашего плеера – наушники. Их можно подменять в
//любой момент, так как свойство того же типа, от которого наши дешевые и
//дорогие наушники наследуются.
//Тест!


let p = MusicPlayer()
let ch = CheapHeadphones()
let ep = ExpensiveHeadphones()
p.headPhones = ch
p.playMusic()
p.headPhones = ep
p.playMusic()
