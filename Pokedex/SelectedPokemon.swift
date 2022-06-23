//
//  SelectedPokemon.swift
//  Pokedex
//
//  Created by Rajiv Keshav Balloo on 2022-06-23.
//

import SwiftUI

class SelectedPokemon: ObservableObject {
    typealias FlavorText = PokeData.PokedexFlavorText
    
    @Published private(set) var currentPokemonFlavorText: FlavorText = FlavorText(flavor_text_entries: [])
    @Published private(set) var currentPokemonTypes: [String] = []
    
    // MARK: - Intent(s):
    
    func fetchCurrentPokemonFlavorText(url: String) {
        self.currentPokemonFlavorText = FlavorText(flavor_text_entries: [])
        
        guard let url = URL(string: url) else {
            return
        }
            
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let pokemonSpecies = try JSONDecoder().decode(PokeData.PokedexFlavorText.self, from: data)
                DispatchQueue.main.async {
                    self.currentPokemonFlavorText = pokemonSpecies
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func fetchCurrentPokemonTypes(entryNum: Int) {
        self.currentPokemonTypes = []
        
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(entryNum)/") else {
            return
        }
            
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let pokemon = try JSONDecoder().decode(PokeData.Pokemon.self, from: data)
                DispatchQueue.main.async {
                    var types: [String] = []
                    types.append("\(pokemon.types[0].type.name)")
                    if pokemon.types.count > 1 {
                        types.append("\(pokemon.types[1].type.name)")
                    }
                    self.currentPokemonTypes = types
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    
    func flavorText() -> String {
        return currentPokemonFlavorText.flavor_text_entries.filter({$0.language.name == "en"}).last?.flavor_text ?? ""
    }
    
    @ViewBuilder
    func displayPokemonTypes() -> some View {
        HStack {
            let shape = RoundedRectangle(cornerRadius: 10)
            if currentPokemonTypes.count > 0 {
                ZStack {
                    shape.foregroundColor(Color(currentPokemonTypes[0]))
                    Text(currentPokemonTypes[0].capitalized)
                    shape.strokeBorder()
                }
                .frame(width: 100)
                if currentPokemonTypes.count > 1 {
                    ZStack {
                        shape.foregroundColor(Color(currentPokemonTypes[1]))
                        Text(currentPokemonTypes[1].capitalized)
                        shape.strokeBorder()
                    }
                    .frame(width: 100)
                }
            }
        }
    }
    
    func pokemonTypeBackgroundColors() -> LinearGradient {
        var colors: [Color] = []
        
        if let type1 = currentPokemonTypes.first {
            let color1 = Color(type1)
            colors.append(color1.opacity(0.3))
            colors.append(color1.opacity(0.2))
            if let type2 = currentPokemonTypes.last {
                let color2 = Color(type2)
                colors.append(color2.opacity(0.3))
            }
        }
        return LinearGradient(colors: colors, startPoint: .top, endPoint: .bottom)
    }
}


