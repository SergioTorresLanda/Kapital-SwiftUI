//
//  CardView.swift
//  SomeAppswiftUI
//
//  Created by Sergio Torres Landa González on 23/05/25.
//

import Foundation
import SwiftUI

struct CardView: View {
    @State var amiibo: AmiiboObj
    @State var viewmodel: MyViewModel
    @State private var didTap:Bool = false
    @State var isInFavoritesList = false
    
    var body: some View {
        HStack{
            Text(amiibo.character + " - " + amiibo.amiiboSeries).bold()
            Spacer()
            AsyncImage(url: URL(string: amiibo.image)) { image in
                image.resizable()
            } placeholder: {
                Color.red
            }
            .frame(width: 90, height: 90)
            .clipShape(.rect(cornerRadius: 25))
            Spacer()
            !isInFavoritesList ? //configure favorite button actions
            Button{
                didTap.toggle()
                saveToOrRemoveFromFavorites()
            } label: {
                Image(systemName: "heart.fill")
            }.background(Color.black)
                .foregroundColor(didTap ? Color.red : Color.white)
            :  // is in favorite list, configure static button as Image
            Button{
            } label: {
                Image(systemName: "heart.fill")
            }.background(Color.black)
                .foregroundColor(Color.red)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.gray.opacity(0.1),
                    in: RoundedRectangle(cornerRadius: 10,
                                         style: .continuous))
        .listRowSeparator(.hidden)
    }
    
    func saveToOrRemoveFromFavorites(){
        didTap ? viewmodel.addFavoriteToSD(with: amiibo) : viewmodel.deleteFavoriteFromSD(id: amiibo.id)
    }
}
/*
struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(cardTitle: "Mario - Super Smash", 
                 image: "https://raw.githubusercontent.com/N3evin/AmiiboAPI/master/images/icon_04380001-03000502.png")
            .padding()
            .previewLayout(.sizeThatFits)
    }
}*/
