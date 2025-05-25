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
        List{
            ForEach(viewmodel.favs, id: \.id) { card in
                CardView(amiibo: card,
                         viewmodel: viewmodel,
                         isInFavoritesList: true //Not redundant as far as I see, I need to pass this to CardView() si it knows im in favorites section and disable the "favorites" button. when CardView() ins getting instansiated from ContentView() this property is the default value (false)
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
        .navigationBarTitleDisplayMode(.large)
        .task {
        }
        .onAppear{
        }
        .onDisappear{
        }
    }
}
