//
//  PokedexList.swift
//  Pokedex
//
//  Created by Rajiv Keshav Balloo on 2022-06-23.
//

import SwiftUI

class PokedexList: ObservableObject {
    typealias Pokedex = PokeData.Pokedex
    
    @Published private(set) var pokedex: Pokedex = Pokedex(id: 0, pokemon_entries: [])
    
    // MARK: - Intent(s):
    
    func fetchPokedex() {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokedex/1") else {
            return
        }
            
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let pokedex = try JSONDecoder().decode(PokeData.Pokedex.self, from: data)
                DispatchQueue.main.async {
                    self.pokedex = pokedex
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    @ViewBuilder
    func fetchPokemonSprite(entryNum: Int) -> some View {
        AsyncImage(url: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(entryNum).png")) { asyncImage in
            if let image = asyncImage.image {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                // Error is not being handled so this is removed for now
                // Images can attempt reloading when scrolling in and out of view
//            } else if asyncImage.error != nil {
//                Text("Error loading")
//                    .font(.footnote)
//                    .frame(width: 80, height: 80)
            } else {
                ProgressView()
//                Color.clear
                    .frame(width: 80, height: 80)
            }
        }
    }
}
