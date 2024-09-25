//
//  StakesMatchedCardsVC.swift
//  HighStakesDynamo
//
//  Created by SunTory on 2024/9/25.
//

import UIKit

class StakesMatchedCardsVC: UIViewController {
    
    
    @IBOutlet weak var restartBtn: UIButton!
    
    private lazy var game = MatchEmoji(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
    private lazy var theme = game.getRandomTheme()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        restartBtn.layer.cornerRadius = 25
        startNewGame()
    }
    
    @IBAction private func createNewGame(_ sender: UIButton) {
        startNewGame()
        sender.setTitleColor(theme.cardColor, for: UIControl.State.normal)
    }
    
    private func startNewGame() {
        game = MatchEmoji(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
       
        theme = game.getRandomTheme()
        emoji = [Int:String]()
        emojiChoices = theme.emojiList
        view.backgroundColor = theme.backgroundColor
        
        for index in cardButtons.indices  {
            let button =  cardButtons[index]
            button.setTitle("", for: UIControl.State.normal)
            button.backgroundColor = theme.cardColor
        }
        flipCountLbl.text = "Flips: \(game.flipCount)"
        scoreCountlbl.text = "Score: \(game.score)"
    }

    @IBOutlet private weak var flipCountLbl: UILabel!
    @IBOutlet private weak var scoreCountlbl: UILabel!
    @IBOutlet private var cardButtons: [UIButton]!
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        }
        
        flipCountLbl.text = "Flips: \(game.flipCount)"
        scoreCountlbl.text = "Score: \(game.score)"
    }
    
    private func updateViewFromModel() {
        
        for index in cardButtons.indices  {
            let button = cardButtons[index]
            let card = game.mainCards[index]
            
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = theme.cardColor
            } else {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0) : theme.cardColor
            }
        }
    }
    
    private lazy var emojiChoices = theme.emojiList
    private var emoji = [Int:String]()
    
    private func emoji(for card: patti) -> String {
        
        if emoji[card.identifier] == nil, emojiChoices.count > 0 {
            emoji[card.identifier] = emojiChoices.remove(at: emojiChoices.count.arc4random)
        }
        
        return emoji[card.identifier] ?? "?"
    }
    
    @IBAction func infoBtntapped(_ sender: Any) {
        
        showAboutUs()
    }
    
    func showAboutUs() {
           let aboutUs = "Match Cards in this game you have to matched the card if the selected cards are matched then the matched cards will be removed and you have to matched all the cards you can also see the numbers of flip you have done and you can also see your score on the screen"
           
           let aboutUsAlert = UIAlertController(title: "About Us", message: aboutUs, preferredStyle: .alert)
           let okayAction = UIAlertAction(title: "Done", style: .default, handler: nil)
           aboutUsAlert.addAction(okayAction)
           
           present(aboutUsAlert, animated: true, completion: nil)
       }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
