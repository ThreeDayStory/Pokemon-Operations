//
//  PokemonCell.swift
//  Pokemon-Operations
//
//  Created by Chad Rutherford on 3/23/20.
//

import UIKit

class PokemonCell: UITableViewCell {
	
	// --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
	// MARK: - Outlets
	@IBOutlet weak var nameLabel: UILabel!
	
	// --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
	// MARK: - Properties
	static let reuseID = "PokemonCell"
	var pokemon: PokemonResult? {
		didSet {
			updateViews()
		}
	}
	
	// --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
	// MARK: - Configuration
	private func updateViews() {
		guard let pokemon = pokemon else { return }
		nameLabel.text = pokemon.name
	}
}
