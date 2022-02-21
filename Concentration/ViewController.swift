//
//  ViewController.swift
//  Concentration
//
//  Created by Vitaly Khryapin on 17.11.2021.
//

import UIKit
var a = 0
class ViewController: UIViewController {
    private lazy var game = ConcentrationGame(numberOfPairsOfCards: numberOfPairsOfCards)
    var numberOfPairsOfCards: Int {
        return (buttonCollection.count + 1) / 2
    }
    private(set) var touches = 0 {
        didSet {
            touchLabel.text = "Touches: \(touches)"
        }
    }
    private var emojiCollection = ["🐶", "🦊", "🐰", "🐭", "🐹","🐻","🐼","🐻‍❄️","🐨","🐯","🦁","🐮","🐷","🐵"]
    private var emojiDictionary = [Card:String]()
    func emojiIdentifier(for card: Card) -> String {
        if emojiDictionary[card] == nil {
            emojiDictionary[card] = emojiCollection.remove(at: emojiCollection.count.arc4randomExtension)
        }
        return emojiDictionary[card] ?? "?"
    }
    private func  updateViewFromModel () {
        for index in buttonCollection.indices {
            let button = buttonCollection[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emojiIdentifier(for: card), for: .normal)
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            }else{
                button.setTitle("", for: .normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
            }
        }
    }
    
    @IBOutlet weak var resetGameOutlet: UIButton!
    @IBOutlet private var buttonCollection: [UIButton]!
    @IBOutlet private weak var touchLabel: UILabel!
    @IBAction func resetGame(_ sender: UIButton) {
        for index in buttonCollection.indices {
            let button = buttonCollection[index]
            button.setTitle("", for: .normal)
            button.backgroundColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
            game.cards[index].isMatched = false
        }
        touches = 0
        game.cards.shuffle()
        resetGameOutlet.isHidden = true
        touchLabel.textColor = .black
        touchLabel.text = "Touches: \(touches)"
    }
    
    @IBAction private func buttonAction(_ sender: UIButton) {
        touches += 1
        if  let buttonIndex = buttonCollection.firstIndex(of: sender) {
            game.chooseCard(at: buttonIndex)
            updateViewFromModel()
        }
        a = 0
        for i in 0..<game.cards.count {
            if  game.cards[i].isMatched == true  {
                a += 1
                if a == 16 {
                    touchLabel.text = "You Win! Touch: \(touches)"
                    touchLabel.textColor = .systemGreen
                    resetGameOutlet.isHidden = false
                }
            }
        }
    }
}

extension Int {
    var arc4randomExtension: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        }else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        }else {
            return 0
        }
    }
}
