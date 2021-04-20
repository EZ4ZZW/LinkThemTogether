//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Zhiway Zhang on 2021/3/31.
//

import SwiftUI


class EmojiMemoryGame: ObservableObject {
    @Published private var model: MemoryGame<String> = EmojiMemoryGame.createMemoryGame()
    
    static func createMemoryGame() -> MemoryGame<String> {
        let emojis: Array<String> = ["🐶","🐼","🦁","🐱","🐷","🐸","🐰","🐒","🐲","👽"]
        return MemoryGame<String>.init(numberOfParisOfCards: emojis.count) { pairIndex in
            return emojis[pairIndex]
        }
    }
    // MARK: - Access to the Model
    var cards: Array<MemoryGame<String>.Card> {
        return model.cards
    }
    
    // MARK: - Intent(s)
    func choose(card: MemoryGame<String>.Card) {
//        objectWillChange.send()
        model.choose(card: card)
    }
    
    func checkPair(card: MemoryGame<String>.Card) {
        model.checkPair(card: card)
    }
    
    func resetGame() {
        self.model = EmojiMemoryGame.createMemoryGame()
    }
    
}
