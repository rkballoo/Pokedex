# Pokedex

This is a Pokedex App built in Swift fetching data from the public PokeAPI: https://pokeapi.co/

Using V2 of the PokeAPI: https://pokeapi.co/docs/v2

Data is pulled from the API for the species name and entry number of each Pokemon in the NationalDex (currently 898 in total) to display them as a list.
The sprites are also pulled from https://github.com/PokeAPI/sprites to display alongside the entry number and name in the list.

Tapping on one of the entries opens a new View and fetches the selected Pokemon's type and latest English flavor text from the PokeAPI,
along with the official artwork image from the PokeAPI GitHub repo for sprites.
