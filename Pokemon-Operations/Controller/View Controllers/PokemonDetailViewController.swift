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
	var pokemonQueue = OperationQueue()
	
	
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
			case .failure(let error):
				print(error)
			}
		}
	}
	
	private func updateViews(with pokemon: Pokemon) {
		guard let apiController = apiController else { return }
		
		let imageFetchOperation = ImageFetchOperation(apiController: apiController, url: pokemon.imageURL)
		let completionOperation = BlockOperation {
			guard let image = imageFetchOperation.image else { return }
			self.pokemonImageView.image = image
			self.heightLabel.text = "\(pokemon.height)"
			self.weightLabel.text = "\(pokemon.weight)"
			self.abilitiesLabel.text = pokemon.abilities
			self.typesLabel.text = pokemon.types
		}
		
		completionOperation.addDependency(imageFetchOperation)
		pokemonQueue.addOperation(imageFetchOperation)
		OperationQueue.main.addOperation(completionOperation)
	}
}
