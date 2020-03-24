//
//  APIController.swift
//  Pokemon-Operations
//
//  Created by Chad Rutherford on 3/23/20.
//

import UIKit

class APIController {
	
	func fetchAllPokemon(completion: @escaping (Result<[PokemonResult], NetworkError>) -> Void) {
		guard let baseURL = URL(string: "https://pokeapi.co/api/v2")?.appendingPathComponent("pokemon") else {
			completion(.failure(.invalidURL))
			return
		}
		
		URLSession.shared.dataTask(with: baseURL) { data, response, error in
			guard error == nil else {
				DispatchQueue.main.async {
					completion(.failure(.unableToComplete))
				}
				return
			}
			
			if let response = response as? HTTPURLResponse, response.statusCode != 200 {
				DispatchQueue.main.async {
					completion(.failure(.invalideResponse))
				}
				return
			}
			
			guard let data = data else {
				DispatchQueue.main.async {
					completion(.failure(.noData))
				}
				return
			}
			
			let decoder = JSONDecoder()
			do {
				let pokemon = try decoder.decode(PokemonResults.self, from: data).results
				DispatchQueue.main.async {
					completion(.success(pokemon))
				}
			} catch {
				DispatchQueue.main.async {
					completion(.failure(.decodeError))
				}
			}
		}.resume()
	}
	
	func fetchPokemon(for url: URL, completion: @escaping (Result<Pokemon, NetworkError>) -> Void) {
		URLSession.shared.dataTask(with: url) { data, response, error in
			guard error == nil else {
				DispatchQueue.main.async {
					completion(.failure(.unableToComplete))
				}
				return
			}
			
			if let response = response as? HTTPURLResponse, response.statusCode != 200 {
				DispatchQueue.main.async {
					completion(.failure(.invalideResponse))
				}
				return
			}
			
			guard let data = data else {
				DispatchQueue.main.async {
					completion(.failure(.noData))
				}
				return
			}
			
			let decoder = JSONDecoder()
			do {
				let pokemon = try decoder.decode(Pokemon.self, from: data)
				DispatchQueue.main.async {
					completion(.success(pokemon))
				}
			} catch {
				DispatchQueue.main.async {
					completion(.failure(.decodeError))
				}
			}
		}.resume()
	}
	
	func fetchImage(for url: URL, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
		URLSession.shared.dataTask(with: url) { data, response, error in
			guard error == nil else {
				DispatchQueue.main.async {
					completion(.failure(.unableToComplete))
				}
				return
			}
			
			if let response = response as? HTTPURLResponse, response.statusCode != 200 {
				DispatchQueue.main.async {
					completion(.failure(.invalideResponse))
				}
				return
			}
			
			guard let data = data else {
				DispatchQueue.main.async {
					completion(.failure(.noData))
				}
				return
			}
			
			guard let image = UIImage(data: data) else {
				DispatchQueue.main.async {
					completion(.failure(.noImage))
				}
				return
			}
			
			DispatchQueue.main.async {
				completion(.success(image))
			}
		}.resume()
	}
}
