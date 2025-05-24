//
//  SomeExtraView.swift
//  SomeAppswiftUI
//
//  Created by Sergio Torres Landa González on 23/05/25.
//

import Foundation
import SwiftUI

struct CardD: View {
    let card: Amiibo
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
            Text("Info").bold()
            Text(card.amiiboSeries)
            Text(card.character)
            Text(card.gameSeries)
        }
    }
    
    var info2: some View {
        HStack{
            VStack(alignment: .leading, spacing: 12){
                Text("Category").bold()
                Text(card.head)
          
                Text(card.name)
                Text(card.tail)
            }
            AsyncImage(url: URL(string: card.image), scale: 3)
              
        }
    }
    var release: some View {
        VStack(alignment: .leading, spacing: 12){
            Text("Release:").bold()
            Text(card.release.au ?? "")
            Text(card.release.jp ?? "")
            Text(card.release.eu ?? "")
            Text(card.release.na ?? "")
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
