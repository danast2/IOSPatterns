import Cocoa

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
