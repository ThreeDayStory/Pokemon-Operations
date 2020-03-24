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
	var pokemonQueue = OperationQueue()
	
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
		// Version 1 - Without NSOperation and Queues
		//		guard let apiController = apiController else { return }
		//		heightLabel.text = "\(pokemon.height)"
		//		weightLabel.text = "\(pokemon.weight)"
		//		abilityLabel.text = pokemon.abilities
		//		typeLabel.text = pokemon.types
		//		// TODO: -  fetch image and display
		//		apiController.fetchImage(for: pokemon.imageURL) { result in
		//			switch result {
		//			case .success(let image):
		//				self.pokemonImageView.image = image
		//			case .failure(let error):
		//				print(error)
		//			}
		//		}
		
		// Version 2 - Using Operations
		guard let apiController = apiController else { return }
		let imageFetchOperation = ImageFetchOperation(apiController: apiController, url: pokemon.imageURL)
		let completionOperation = BlockOperation {
			guard let image = imageFetchOperation.image else { return }
			self.pokemonImageView.image = image
			self.heightLabel.text = "\(pokemon.height)"
			self.weightLabel.text = "\(pokemon.weight)"
			self.abilityLabel.text = pokemon.abilities
			self.typeLabel.text = pokemon.types
		}
		
		completionOperation.addDependency(imageFetchOperation)
		pokemonQueue.addOperation(imageFetchOperation)
		OperationQueue.main.addOperation(completionOperation)
	}
}
