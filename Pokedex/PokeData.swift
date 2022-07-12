//
//  PokeData.swift
//  Pokedex
//
//  Created by Rajiv Keshav Balloo on 2022-06-23.
//

import Foundation

/// Based on PokeAPI: https://pokeapi.co/docs/v2
struct PokeData {
    struct Pokedex: Identifiable, Codable {
        let id: Int
        let pokemon_entries: [PokemonEntry]
    }
    
    struct PokemonEntry: Codable {
        let entry_number: Int
        let pokemon_species: Link
    }
    
    struct Link: Codable {
        let name: String
        let url: String
    }
    
    struct PokedexFlavorText: Codable {
        let flavor_text_entries: [FlavorTextEntry]
    }
    
    struct FlavorTextEntry: Codable {
        let flavor_text: String
        let language: Link
        let version: Link
    }
    
    struct Pokemon: Codable {
        let stats: [PokeStat]
        let types: [PokemonType]
    }
    
    struct PokeStat: Codable {
        let base_stat: Int
        let effort: Int
        let stat: Link
    }
    
    struct PokemonType: Codable {
        let slot: Int
        let type: Link
    }
}

