//
//  SelectedPokemonView.swift
//  Pokedex
//
//  Created by Rajiv Keshav Balloo on 2022-06-23.
//

import SwiftUI

struct SelectedPokemonView: View {
    @StateObject var selectedPokemon = SelectedPokemon()
    
    let entryNum: Int
    let name: String
    let url: String
    
    var body: some View {
        VStack {
            ScrollView {
                Text("\(entryNum): \(name)".capitalized)
                    .font(.title)
                AsyncImage(url: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(entryNum).png")) { asyncImage in
                    if let image = asyncImage.image {
                        image.resizable()
                            .scaledToFit()
                    } else if asyncImage.error != nil {
                        Color.red
                    } else {
                        Color.clear
                    }
                }
                .onAppear {
                    selectedPokemon.fetchCurrentPokemonFlavorText(url: url)
                    selectedPokemon.fetchCurrentPokemonTypes(entryNum: entryNum)
                }
                selectedPokemon.displayPokemonTypes()
                flavorText
            }
        }
        .background(selectedPokemon.pokemonTypeBackgroundColors())
    }
    
    var flavorText: some View {
        VStack {
            Text("Pokedex Entry")
                .font(.title2)
            Text(selectedPokemon.flavorText())
        }
    }
}

struct SelectedPokemonView_Previews: PreviewProvider {
    static var previews: some View {
        SelectedPokemonView(
            entryNum: 1,
            name: "bulbasaur",
            url: "https://pokeapi.co/api/v2/pokemon-species/1/")
        .preferredColorScheme(.light)
        
        SelectedPokemonView(
            entryNum: 1,
            name: "bulbasaur",
            url: "https://pokeapi.co/api/v2/pokemon-species/1/")
        .preferredColorScheme(.dark)
    }
}
