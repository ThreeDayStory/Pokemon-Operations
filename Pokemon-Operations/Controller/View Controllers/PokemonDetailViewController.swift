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
	@IBOutlet weak var abilityLabel: UILabel!
	@IBOutlet weak var typeLabel: UILabel!
	
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
		apiController.fetchPokemon(for: pokemon.url) { result in
			switch result {
			case .success(let pokemon):
				self.updateViews(with: pokemon)
			case .failure(let error):
				print(error)
			}
		}
	}
	
	private func updateViews(with pokemon: Pokemon) {
		heightLabel.text = "\(pokemon.height)"
		weightLabel.text = "\(pokemon.weight)"
		abilityLabel.text = pokemon.abilities
		typeLabel.text = pokemon.types
		// TODO: -  fetch image and display
	}
}
