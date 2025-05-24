//
//  CardView.swift
//  SomeAppswiftUI
//
//  Created by Sergio Torres Landa González on 23/05/25.
//

import Foundation
import SwiftUI

struct CardView: View {
    let cardTitle: String
    let image: String
    var body: some View {
        HStack{
            Text(cardTitle).bold()
            Spacer()
            AsyncImage(url: URL(string: image)) { image in
                image.resizable()
            } placeholder: {
                Color.red
            }
            .frame(width: 90, height: 90)
            .clipShape(.rect(cornerRadius: 25))
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.gray.opacity(0.1),
                    in: RoundedRectangle(cornerRadius: 10,
                                         style: .continuous))
        .listRowSeparator(.hidden)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(cardTitle: "Mario - Super Smash", 
                 image: "https://raw.githubusercontent.com/N3evin/AmiiboAPI/master/images/icon_04380001-03000502.png")
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
