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
                    selectedPokemon.fetchCurrentPokemon(entryNum: entryNum)
                }
                selectedPokemon.displayPokemonTypes()
                flavorText
                    .padding()
                pokemonStats
                    .padding()
            }
        }
        .background(selectedPokemon.pokemonTypeBackgroundColors())
    }
    
    var flavorText: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(Color("pokedexEntryColor").opacity(0.15))
            VStack {
                Spacer()
                Text("Pokedex Entry")
                    .font(.title2)
                Divider()
                Text(selectedPokemon.flavorText())
                    .padding(.horizontal)
                Spacer()
            }
        }
    }
    
    var pokemonStats: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(Color("pokedexEntryColor").opacity(0.15))
            VStack {
                Spacer()
                Text("Pokedex Stats")
                    .font(.title2)
                Divider()
                selectedPokemon.displayPokemonStats()
                Spacer()
            }
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
