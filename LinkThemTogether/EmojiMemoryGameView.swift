//
//  ContentView.swift
//  LinkThemTogether
//
//  Created by Zhiway Zhang on 2021/4/1.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    var body: some View {
        VStack {
            Grid(viewModel.cards) { card in
                    CardView(card: card).onTapGesture {
                        self.viewModel.choose(card: card)
                        self.viewModel.checkPair(card: card)
                    }
                    .padding(5)
                  }
                    .padding()
                    .foregroundColor(Color.orange)
            
            HStack {
                
                Text("分数：\(self.viewModel.getScore())")
                    .font(.system(size: 30))
                
                Spacer()
                
                Text("重新开始游戏")
                    .font(.system(size: 30))
                    .onTapGesture {
                        self.viewModel.resetGame()
                        print("test")
                    }
            }
                
        }
            
    }
}

struct CardView: View {
    var card: MemoryGame<String>.Card
    
    var body: some View {
        GeometryReader(content: { geomety in
            self.body(for: geomety.size)
        })
    }
    
    func body(for size: CGSize) -> some View {
        ZStack {
            if card.isFaceUp {
                RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: edgeLineWidth)
                if card.isChosing {
                    Circle().padding(5)
                }
                Text(card.content)
            } else {
                //RoundedRectangle(cornerRadius: cornerRadius).fill()
            }
        }
        .font(Font.system(size: fontSize(for: size)))
    }
    
    // MARK - Drawing Constants
    
    let cornerRadius: CGFloat = 10.0
    let edgeLineWidth: CGFloat = 3.0
    func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height)*0.75
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(card: game.cards[0])
        return EmojiMemoryGameView(viewModel: game)
    }
}
