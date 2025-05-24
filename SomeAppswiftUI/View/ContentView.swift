//
//  ContentView.swift
//  SomeAppswiftUI
//
//  Created by Sergio Torres Landa González on 23/05/25.
//

import SwiftUI

struct ContentView: View {
  
    @StateObject private var viewmodel = MyViewModel()
      
    var body: some View {
            ZStack {
                if viewmodel.isLoading{
                    ProgressView()
                }else{
                    NavigationView{
                        List{
                            ForEach(viewmodel.cards, id: \.tail) { card in
                                CardView(cardTitle: card.character + " - " + card.amiiboSeries, image: card.image)
                                    .background(
                                      NavigationLink("", destination: CardD(card: card))
                                          .opacity(0)
                                    )
                            }
                            .onDelete(perform: viewmodel.deleteCard)
                            .listRowSeparator(.hidden)
                        }
                        .listStyle(.plain)
                        .navigationTitle("Amiibo's disponibles")
                    }
                }
            }
            .task {//async work
                do {
                    try await viewmodel.fetchData()
                } catch {
                    print (error)
                }
            }
            .onAppear{
                //manejar la aparicion de la vista (similar a viewDidAppear en controllers)
            }
            .onDisappear{
                //manejar la desaparicion de la vista (similar a viewDidDissapear en controllers)
            }
            // 6. React specifically to the state change we care about
              // .onChange(of: appState.isInBackground) { wasInBackground, nowInBackground in
                   // handleBackgroundStateChange(isEnteringBackground: nowInBackground)
               //}
        }
    }


#Preview {
    ContentView()
}
