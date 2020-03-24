//
//  PokemonDetailViewController.swift
//  Pokemon-Operations
//
//  Created by Chad Rutherford on 3/23/20.
//

import UIKit

class PokemonDetailViewController: UIViewController {
	
	@IBOutlet weak var pokemonImageView: UIImageView!
	@IBOutlet weak var heightLabel: UILabel!
	@IBOutlet weak var weightLabel: UILabel!
	@IBOutlet weak var typesLabel: UILabel!
	@IBOutlet weak var abilitiesLabel: UILabel!
	
	// --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
	// MARK: - Properties
	var apiController: APIController?
	var pokemonResult: PokemonResult? {
		didSet {
			fetchDetails()
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	private func fetchDetails() {
		guard let pokemon = pokemonResult, let apiController = apiController else { return }
		apiController.fetchPokemon(for: pokemon.url) { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let pokemon):
				self.updateViews(with: pokemon)
				print(pokemon.weight)
			case .failure(let error):
				print(error)
			}
		}
	}
	
	private func updateViews(with pokemon: Pokemon) {
		heightLabel.text = "\(pokemon.height)"
		weightLabel.text = "\(pokemon.weight)"
		abilitiesLabel.text = pokemon.abilities
		typesLabel.text = pokemon.types
		apiController?.fetchImage(for: pokemon.imageURL) { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let image):
				self.pokemonImageView.image = image
			case .failure(let error):
				print(error)
			}
		}
	}
}
