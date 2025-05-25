//
//  FavoritesView.swift
//  SomeAppswiftUI
//
//  Created by Sergio Torres Landa González on 24/05/25.
//

import Foundation
import SwiftUI
import SwiftData


struct FavoritesView: View {
    @State var viewmodel: MyViewModel
    @State var showingDetail = false

    var body: some View {
        ZStack {
            NavigationView{
                List{
                    ForEach(viewmodel.favs, id: \.id) { card in
                        CardView(amiibo: card, 
                                 viewmodel: viewmodel,
                                 isInFavoritesList: true
                        )
                        .onTapGesture {
                            showingDetail.toggle()
                        }.sheet(isPresented: $showingDetail) {
                            CardD(card: card)
                        }
                    }
                    .onDelete { indexSet in
                        viewmodel.deleteFavoriteFromIndex(at: indexSet)
                    }
                    .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                .navigationTitle("Favoritos:  \(viewmodel.favs.count)")
            }
        }
        .task {
        }
        .onAppear{
        }
        .onDisappear{
        }
    }
}
