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
    
    var dx: Array<Int>
    var dy: Array<Int>
    
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
    
    func getDir(cx: Int, cy: Int) -> Int {
        if cx == 0 && cy == 1 {
            return 4
        } else if cx == 0 && cy == -1 {
            return 3
        } else if cx == 1 && cy == 0 {
            return 2
        } else if cx == -1 && cy == 0 {
            return 1
        }
        return 0
    }
    
    func checkNextPoint(cx: Int, cy: Int) -> Bool {
        return cx <= 4 && cx >= 1 && cy <= 5 && cy >= 1 && !Vis[cx][cy] && isEquals(a: Graph[cx][cy], b: "❌" as! CardContent)
    }
    
    // Direction Tour
    // 1 for left
    // 2 for right
    // 3 for up
    // 4 for down
    mutating func dfs(x: Int, y: Int, Direction: Int, DirChangeCnt: Int, desX: Int, desY: Int) {
        if CanPair || DirChangeCnt > 2{
            return
        }
        print("Path to des (\(x),\(y))")
        if x == desX && y == desY {
            if DirChangeCnt <= 2 {
                print("Got It 🐼")
                CanPair = true
            }
            return
        }
        
        var nextX: Int
        var nextY: Int
        var nextDir: Int
        
        for i in 0..<4 {
            nextX = x + dx[i]
            nextY = y + dy[i]
            if !checkNextPoint(cx: nextX, cy: nextY) && (nextX != desX || nextY != desY){
                continue
            }
            nextDir = getDir(cx: dx[i], cy: dy[i])
            Vis[nextX][nextY] = true
    
            if nextDir == Direction || Direction == 0 {
                dfs(x: nextX, y: nextY, Direction: nextDir, DirChangeCnt: DirChangeCnt, desX: desX, desY: desY)
            } else {
                dfs(x: nextX, y: nextY, Direction: nextDir
                    , DirChangeCnt: DirChangeCnt+1, desX: desX, desY: desY)
            }
            Vis[nextX][nextY] = false
        }
        
    }
    
    mutating func checkPair(card: Card) {
        print("card chosen: \(card)")
        if lastCard.id == 25 || lastCard.id == card.id{
            lastCard = card
            print("last card  : \(card)")
            return
        } else {
            if isEquals(a: card.content, b: lastCard.content) {
                self.CanPair = false
                InitVisArray()
                var IdA: Int
                var IdB: Int
                IdB = 0
                IdA = 0
                if let chosenIndex = cards.firstIndex(matching: card) {
                    IdA = chosenIndex
                    //self.cards[chosenIndex].isFaceUp = false
                }
                if let chosenIndex = cards.firstIndex(matching: lastCard) {
                    IdB = chosenIndex
                    //self.cards[chosenIndex].isFaceUp = false
                }
                Vis[Int(self.cards[IdA].position.x)][Int(self.cards[IdB].position.y)] = true
                dfs(x: Int(self.cards[IdA].position.x), y: Int(self.cards[IdA].position.y), Direction: 0, DirChangeCnt: 0, desX: Int(self.cards[IdB].position.x), desY: Int(self.cards[IdB].position.y))
                
                if CanPair {
                    self.cards[IdA].isFaceUp = false
                    self.cards[IdB].isFaceUp = false
                    self.Graph[Int(self.cards[IdA].position.x)][Int(self.cards[IdA].position.y)] = "❌" as! CardContent
                    print( Graph[Int(self.cards[IdA].position.x)][Int(self.cards[IdA].position.y)])
                    self.Graph[Int(self.cards[IdB].position.x)][Int(self.cards[IdB].position.y)] = "❌" as! CardContent
                }
            }
            lastCard.id = 25
        }
    }
    
    init(numberOfParisOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = Array<Card>()
        
        CanPair = false
        
        // INIT: dx and dy array
        dx = Array<Int>()
        dy = Array<Int>()
        dx.append(0)
        dx.append(1)
        dx.append(0)
        dx.append(-1)
        
        dy.append(1)
        dy.append(0)
        dy.append(-1)
        dy.append(0)
        
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
