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
    @Published private(set) var currentPokemonStats =
    [
        "hp": 0,
        "attack": 0,
        "defense": 0,
        "special-attack": 0,
        "special-defense": 0,
        "speed": 0
    ]
    @Published private(set) var currentPokemonBaseStatTotal = 0
    @Published private(set) var currentPokemonTypes: [String] = []
    
    private let statShorthandNames =
    [
        "hp": "HP",
        "attack": "Atk",
        "defense": "Def",
        "special-attack": "SpA",
        "special-defense": "SpD",
        "speed": "Spe"
    ]
    
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
    
    func fetchCurrentPokemon(entryNum: Int) {
        self.currentPokemonStats = [:]
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
                    
                    pokemon.stats.forEach { stat in
                        self.currentPokemonStats[stat.stat.name] = stat.base_stat
                        self.currentPokemonBaseStatTotal += stat.base_stat
                    }
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    
    func flavorText() -> String {
        return currentPokemonFlavorText.flavor_text_entries.filter( {
            $0.language.name == "en"
            &&
            (
                $0.version.name != "red" &&
                $0.version.name != "blue" &&
                $0.version.name != "yellow" &&
                $0.version.name != "gold" &&
                $0.version.name != "silver" &&
                $0.version.name != "crystal" &&
                $0.version.name != "ruby" &&
                $0.version.name != "sapphire" &&
                $0.version.name != "emerald" &&
                $0.version.name != "firered" &&
                $0.version.name != "leafgreen" &&
                $0.version.name != "diamond" &&
                $0.version.name != "pearl" &&
                $0.version.name != "platinum" &&
                $0.version.name != "heartgold" &&
                $0.version.name != "soulsilver" &&
                $0.version.name != "colosseum" &&
                $0.version.name != "xd" &&
                $0.version.name != "legends-arceus"
            )
        } ).first?.flavor_text ?? ""
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
    
    @ViewBuilder
    func displayPokemonStats() -> some View {
        VStack {
            HStack {
                Spacer()
                Text("Base Stat Total: \(currentPokemonBaseStatTotal)")
                Spacer()
            }
            Divider()
            displayPokemonStat(statName: "hp")
            displayPokemonStat(statName: "attack")
            displayPokemonStat(statName: "defense")
            displayPokemonStat(statName: "special-attack")
            displayPokemonStat(statName: "special-defense")
            displayPokemonStat(statName: "speed")
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func displayPokemonStat(statName: String) -> some View {
        let currentStat = currentPokemonStats[statName] ?? 0
        LazyVGrid(
            columns:
                [flexibleGridItem(minimum: 0, alignment: .leading),
                 flexibleGridItem(minimum: 0, alignment: .leading),
//                 flexibleGridItem(minimum: 0, alignment: .trailing),
                 flexibleGridItem(minimum: 0, alignment: .trailing)
                ])
        {
            Text(statShorthandNames[statName] ?? statName)
            statBar(for: currentStat)
//            Spacer()
            Text("\(currentStat)")
        }
    }
    
    func flexibleGridItem(minimum: CGFloat, alignment: Alignment) -> GridItem {
        var gridItem = GridItem(.flexible(minimum: minimum))
        gridItem.spacing = 0
        gridItem.alignment = alignment
        return gridItem
    }
    
    @ViewBuilder
    func statBar(for currentStat: Int) -> some View {
        GeometryReader { geometry in
            RoundedRectangle(cornerRadius: 2)
                .frame(width: self.statBarWidth(stat: currentStat, size: geometry.size))
        }
    }
    
    func statBarWidth(stat: Int, size: CGSize) -> CGFloat {
        CGFloat(stat) / 255 * size.width
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


