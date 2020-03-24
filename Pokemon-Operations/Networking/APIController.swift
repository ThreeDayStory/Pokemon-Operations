//
//  APIController.swift
//  Pokemon-Operations
//
//  Created by Chad Rutherford on 3/23/20.
//

import Foundation

class APIController {
	
	func fetchAllPokemon(completion: @escaping (Result<[PokemonResult], NetworkError>) -> Void) {
		guard let baseURL = URL(string: APIKeys.baseURL)?.appendingPathComponent(APIKeys.pokemonEndpoint) else {
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
					completion(.failure(.invalidResponse))
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
				completion(.failure(.decodeError))
			}
		}.resume()
	}
}
