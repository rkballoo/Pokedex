//
//  PokedexView.swift
//  Pokedex
//
//  Created by Rajiv Keshav Balloo on 2022-06-23.
//

import SwiftUI

struct PokedexView: View {
    @StateObject var pokedex = PokedexList()
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [flexibleGridItemNoSpacing(minimum: 100)]) {
                    ForEach(searchResults, id: \.self.entry_number) { pokedexEntry in
                        NavigationLink {
                            SelectedPokemonView(
                                entryNum: pokedexEntry.entry_number,
                                name: pokedexEntry.pokemon_species.name,
                                url: pokedexEntry.pokemon_species.url)
                        } label: {
                            displayPokemonEntry(
                                entryNum: pokedexEntry.entry_number,
                                name: pokedexEntry.pokemon_species.name)
                            .padding(.horizontal)
                        }
                        .foregroundColor(Color("pokedexEntryColor"))
                    }
                }
                .searchable(text: $searchText)
            }
            .navigationTitle("Pokemon")
        }
        .onAppear {
            pokedex.fetchPokedex()
        }
    }
    
    var searchResults: [PokeData.PokemonEntry] {
        if searchText.isEmpty {
            return pokedex.pokedex.pokemon_entries
        } else {
            return pokedex.pokedex.pokemon_entries.filter( {
                $0.pokemon_species.name.contains(searchText.lowercased())
                ||
                $0.entry_number == Int(searchText)
            } )
        }
    }
    
    func flexibleGridItemNoSpacing(minimum: CGFloat) -> GridItem {
        var gridItem = GridItem(.flexible(minimum: 200))
        gridItem.spacing = 0
        return gridItem
    }
    
    @ViewBuilder
    func displayPokemonEntry(entryNum: Int, name: String) -> some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(Color("pokedexEntryColor").opacity(0.15))
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("\(entryNum)")
                        .fontWeight(.semibold)
                        .font(.title2)
                        .padding(.top)
                    Text("\(name)".capitalized)
                        .fontWeight(.light)
                        .font(.title3)
                }
                .padding(.horizontal)
                Spacer()
                pokedex.fetchPokemonSprite(entryNum: entryNum)
            }
        }
    }
}

struct PokedexView_Previews: PreviewProvider {
    static var previews: some View {
        PokedexView()
            .preferredColorScheme(.light)
        PokedexView()
            .preferredColorScheme(.dark)
    }
}
