//
//  StakesDataModel.swift
//  HighStakesDynamo
//
//  Created by SunTory on 2024/9/25.
//
import Foundation
import UIKit

struct StakesCard {
    let name: String
    let value: Int
}

struct StakesPokerCoinModel {
    
    let symbolText: String
    let id: Int
}

class MatchEmoji {
    
    private(set) var mainCards = [patti] ()
    
    private var indexOfOneAndOnlyFaceUpCard: Int?
    
    var score = 0, flipCount = 0
    
    var themes: [String: Theme] = [
        "Smileys": Theme(emojiList: ["🃏", "🂲", "🂳", "🂴", "🂵", "🂶", "🂷", "🂸", "🂹", "🂺"], backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), cardColor: #colorLiteral(red: 0.9058823529, green: 0.7882352941, blue: 0.6117647059, alpha: 1))
    ]
    
    func chooseCard(at index: Int) {
        assert(mainCards.indices.contains(index), "EmojiMatch.chooseCard(at: \(index)): choosen index not in cards")
        
        if !mainCards[index].isMatched {
            
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                
                if mainCards[matchIndex].identifier == mainCards[index].identifier {
                    mainCards[matchIndex].isMatched = true
                    mainCards[index].isMatched = true
                    score += 2
                } else if mainCards[index].hasBeenViewed {
                    score -= 1
                }
                mainCards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = nil
            } else {
                
                for flipdownIndex in mainCards.indices {
                    mainCards[flipdownIndex].isFaceUp = false
                }
                mainCards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
        
        flipCount += 1
    }
    
    func getRandomTheme() -> Theme {
        return themes.randomElement()!.value
    }
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "EmojiMatch.init(at: \(numberOfPairsOfCards )): must have at least one pair of cards")

        for _ in 1...numberOfPairsOfCards {
            let card = patti()
            mainCards += [card, card]
        }
        
        mainCards.shuffle()
    }
}

struct patti {
    
    var isFaceUp = false {
        didSet {
            if isFaceUp {
                hasBeenViewed = true
            }
        }
    }
    var isMatched = false
    var identifier: Int
    var hasBeenViewed = false
    
    
    private static var identifierFactory = 0
    
    
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init() {
        self.identifier = patti.getUniqueIdentifier()
    }
}

struct Theme {
    var emojiList: [String] = []
    var backgroundColor: UIColor?
    var cardColor: UIColor?
    
    
    init(emojiList: [String], backgroundColor: UIColor?, cardColor: UIColor?) {
        self.emojiList = emojiList
        self.backgroundColor = backgroundColor
        self.cardColor = cardColor
    }
}
