//
//  ContentView.swift
//  SomeAppswiftUI
//
//  Created by Sergio Torres Landa González on 23/05/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext //Capa entre los objetos y la memoria.
    @State private var viewmodel: MyViewModel? //opcional por ser "late init"
    
    var body: some View {
        ZStack{
            if let vm = viewmodel {
                if vm.isLoading{
                    ProgressView()
                }else{
                    NavigationView {
                        VStack{
                            Spacer()
                            NavigationLink(destination: FavoritesView(viewmodel: vm)) {
                                ButtonView()
                            }
                            Spacer()
                            Text("Amiibos:  \(vm.amiibos.count)").bold().font(.largeTitle)
                            List{
                                ForEach(vm.amiibos, id: \.id) { card in
                                    CardView(amiibo: card, viewmodel: vm)
                                }
                                .onDelete { indexSet in
                                    vm.deleteAmiibos(at: indexSet)
                                }
                                .listRowSeparator(.hidden)
                            }
                            .listStyle(.plain)
                        }
                    }
                }
            }
        }.task {//trabajo asyncrono se usará el patrón (async/await) en lugar de completion handlers (@escaping).
            do {
                try await viewmodel?.fetchData()
            } catch {
                print (error)
            }
        }
        .onAppear{
            if viewmodel == nil { 
                // Inicializar solo una vez todo el esquema del ViewModel usando la variable ambiental "modelContext"
                viewmodel = MyViewModel(
                    repository: AmiiboRepository(
                        remoteDataSource: RemoteAmiiboDataSource(),
                        localDataSource: LocalAmiiboDataSource(
                            modelContext: modelContext)
                    )
                )
            }
        }
        .onDisappear{
            //manejar la desaparicion de la vista (similar a viewDidDissapear en controllers)
        }
    }
}


struct ButtonView: View {
    var body: some View {
        Text("Favoritos").font(.title)
            .frame(width: 150, height: 50, alignment: .center)
            .background(Color.red)
            .foregroundColor(Color.white)
            .border(.red, width: 5)
            .cornerRadius(25)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: AmiiboObj.self, configurations: config)
        return ContentView()
            .modelContainer(container)
    } catch {
        fatalError("Failed to create ModelContainer for preview: \(error)")
    }
}

