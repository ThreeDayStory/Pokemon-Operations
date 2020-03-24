//
//  Pokemon.swift
//  Pokemon-Operations
//
//  Created by Chad Rutherford on 3/23/20.
//

import Foundation

struct Pokemon: Codable {
	let name: String
	let imageURL: URL
	let height: Int
	let weight: Int
	let types: String
	let abilities: String
	
	enum PokemonKeys: String, CodingKey {
		case name
		case height
		case weight
		case sprites
		case abilities
		case types
		
		enum SpriteKeys: String, CodingKey {
			case imageURL = "front_default"
		}
		
		enum AbilitiesKeys: String, CodingKey {
			case ability
			enum AbilityKeys: String, CodingKey {
				case name
			}
		}
		
		enum TypesKeys: String, CodingKey {
			case type
			
			enum TypeKeys: String, CodingKey {
				case name
			}
		}
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: PokemonKeys.self)
		name = try container.decode(String.self, forKey: .name).capitalized
		height = try container.decode(Int.self, forKey: .height)
		weight = try container.decode(Int.self, forKey: .weight)
		let spritesContainer = try container.nestedContainer(keyedBy: PokemonKeys.SpriteKeys.self, forKey: .sprites)
		imageURL = try spritesContainer.decode(URL.self, forKey: .imageURL)
		var abilitiesContainer = try container.nestedUnkeyedContainer(forKey: .abilities)
		var abilityString = ""
		while !abilitiesContainer.isAtEnd {
			let abilitiesOuterContainer = try abilitiesContainer.nestedContainer(keyedBy: PokemonKeys.AbilitiesKeys.self)
			let abilityInnerContainer = try abilitiesOuterContainer.nestedContainer(keyedBy: PokemonKeys.AbilitiesKeys.AbilityKeys.self, forKey: .ability)
			let ability = try abilityInnerContainer.decode(String.self, forKey: .name).capitalized
			abilityString += " \(ability)"
		}
		abilities = abilityString
		var typesContainer = try container.nestedUnkeyedContainer(forKey: .types)
		var typeString = ""
		while !typesContainer.isAtEnd {
			let typeOuterContainer = try typesContainer.nestedContainer(keyedBy: PokemonKeys.TypesKeys.self)
			let typeInnerContainer = try typeOuterContainer.nestedContainer(keyedBy: PokemonKeys.TypesKeys.TypeKeys.self, forKey: .type)
			let name = try typeInnerContainer.decode(String.self, forKey: .name).capitalized
			typeString += " \(name)"
		}
		types = typeString
	}
}
