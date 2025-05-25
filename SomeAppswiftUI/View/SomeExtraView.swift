//
//  SomeExtraView.swift
//  SomeAppswiftUI
//
//  Created by Sergio Torres Landa González on 23/05/25.
//

import Foundation
import SwiftUI

struct CardD: View {
    let card: AmiiboObj
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading) {
                Divider()
                info
                Divider()
                info2
                Divider()
                release
                Divider()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(.gray.opacity(0.1),in: RoundedRectangle(cornerRadius: 10, style: .continuous))
            .padding()
            .navigationTitle("Card Detail")
        }
    }
}

private extension CardD{
    
    var info: some View {
        VStack(alignment: .leading, spacing: 12){
            Text("Información").bold()
            Text(card.amiiboSeries)
            Text(card.character)
            Text(card.gameSeries)
        }
    }
    
    var info2: some View {
        HStack{
            VStack(alignment: .leading, spacing: 12){
                Text("Gráficos").bold()
                Text(card.head)
          
                Text(card.name)
                Text(card.tail)
            }
            AsyncImage(url: URL(string: card.image), scale: 3)
              
        }
    }
    var release: some View {
        VStack(alignment: .leading, spacing: 12){
            Text("Releases").bold()
            Text("au:" + (card.release.au ?? ""))
            Text("jp:" + (card.release.jp ?? ""))
            Text("eu:" + (card.release.eu ?? ""))
            Text("na:" + (card.release.na ?? ""))
        }
    }
}

struct UserDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CardD(card: .dummy)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
