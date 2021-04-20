//
//  IndexView.swift
//  LinkThemTogether
//
//  Created by Zhiway Zhang on 2021/4/8.
//

import SwiftUI

struct IndexView: View {
    var body: some View {
        NavigationView {
            VStack {
                let game = EmojiMemoryGame()
                NavigationLink(destination: EmojiMemoryGameView(viewModel: game)) {
                    Text("New Game")
                        .font(.system(size: 30))
                        .background(
                            ZStack {
                                RoundedRectangle(cornerRadius: 3.0)
                                    .stroke(Color.blue)
                            }
                        )
                }
            }
        }
    }
}

struct IndexView_Previews: PreviewProvider {
    static var previews: some View {
        IndexView()
    }
}
