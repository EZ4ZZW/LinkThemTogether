//
//  MemoryGame.swift
//  Memorize
//
//  Created by Zhiway Zhang on 2021/3/31.
//

import Foundation
import SwiftUI

struct MemoryGame<CardContent:Comparable> {
    var cards: Array<Card>
    
    var lastCard: Card
    
    var Vis: Array<Array<Bool>>
    var Graph: Array<Array<CardContent>>
    var CanPair: Bool
    
    mutating func choose(card: Card) {
        //card.ChangeFaceUp()
        print("这是个没什么用的函数")
//        if let chosenIndex = cards.firstIndex(matching: card) {
//            self.cards[chosenIndex].isFaceUp = true
//        }
    }
    
    func isEquals<T: Comparable>(a: T, b: T) -> Bool {
        return (a == b)
    }

    mutating func InitVisArray() {
        for i in 1..<4 {
            for j in 1..<5 {
                self.Vis[i][j] = false
            }
        }
    }
    
    // Direction Tour
    // 1 for left
    // 2 for right
    // 3 for up
    // 4 for down
    mutating func dfs(x: Int, y: Int, Direction: Int, DirChangeCnt: Int, desX: Int, desY: Int) {
        if CanPair || x < 1 || y < 1 || x > 4 || y > 5 || Direction > 2{
            return
        }
        if x == desX && y == desY {
            if DirChangeCnt <= 2 {
                CanPair = true
            }
            return
        }
        
        dfs(x: x+1, y: <#T##Int#>, Direction: <#T##Int#>, DirChangeCnt: <#T##Int#>, desX: <#T##Int#>, desY: <#T##Int#>)
    }
    
    mutating func checkPair(card: Card) {
        print("card chosen: \(lastCard)")
        if lastCard.id == 25 {
            lastCard = card
        } else {
            if isEquals(a: card.content, b: lastCard.content) {
                
                var IdA: Int
                var IdB: Int
                
                if let chosenIndex = cards.firstIndex(matching: card) {
                    IdA = chosenIndex
                    //self.cards[chosenIndex].isFaceUp = false
                }
                if let chosenIndex = cards.firstIndex(matching: lastCard) {
                    IdB = chosenIndex
                    //self.cards[chosenIndex].isFaceUp = false
                }
                
                
                
            }
            lastCard.id = 25
        }
    }
    
    init(numberOfParisOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = Array<Card>()
        
        CanPair = false
        
        // INIT: Vis Array
        Vis = Array<Array<Bool>>()
        Vis.append(Array<Bool>())
        for i in 0..<10 {
            for _ in 0..<10 {
                Vis[i].append(false)
            }
            Vis.append(Array<Bool>())
        }
        
        // INIT: G Array
        Graph = Array<Array<CardContent>>()
        Graph.append(Array<CardContent>())
        for i in 0..<10 {
            for _ in 0..<10 {
                Graph[i].append(cardContentFactory(0))
            }
            Graph.append(Array<CardContent>())
        }
            
        
        lastCard = Card(id: 25, content: cardContentFactory(0), position: CGPoint.init(x: -1, y: -1))
        var EmojiCnt = [Int]()
        for _ in 0..<numberOfParisOfCards {
            EmojiCnt.append(0)
        }
        
        var posx: Int
        var posy: Int
        posx = 1
        posy = 1
        for pairIndex in 0..<numberOfParisOfCards {
            var eIndex = arc4random() % 10
            while EmojiCnt[Int(eIndex)] >= 2 {
                eIndex = arc4random() % 10
            }
            EmojiCnt[Int(eIndex)] += 1;
            
            
            cards.append(Card(id: pairIndex*2, content: cardContentFactory(Int(eIndex)), position: CGPoint.init(x: posx, y: posy)))
            
            posy += 1
            if posy == 6 {
                posy = 1
                posx += 1
            }
            
             eIndex = arc4random() % 10
             while EmojiCnt[Int(eIndex)] >= 2 {
                 eIndex = arc4random() % 10
             }
            EmojiCnt[Int(eIndex)] += 1;
            
            
            cards.append(Card(id: pairIndex*2+1, content: cardContentFactory(Int(eIndex)), position: CGPoint.init(x: posx, y: posy)))
            
            
            
            posy += 1
            if posy == 6 {
                posy = 1
                posx += 1
            }
        }
        
        for i in 0..<20 {
            print(cards[i].position)
        }
        
        for i in 0..<cards.count {
            Graph[Int(cards[i].position.x)][Int(cards[i].position.y)] = cards[i].content
        }
    }
    
    struct Card: Identifiable {
        var id: Int
        var isFaceUp: Bool = true
        var isMatched: Bool = false
        var content: CardContent
        
        var position: CGPoint
        
        mutating func ChangeFaceUp() {
            self.isFaceUp = true
        }
        
    }
    
}
