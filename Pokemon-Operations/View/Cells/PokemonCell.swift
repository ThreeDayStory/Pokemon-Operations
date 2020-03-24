//
//  PokemonCell.swift
//  Pokemon-Operations
//
//  Created by Chad Rutherford on 3/23/20.
//

import UIKit

class PokemonCell: UITableViewCell {
	
	@IBOutlet weak var nameLabel: UILabel!
	
	static let reuseID = "PokemonCell"
	var pokemon: PokemonResult? {
		didSet {
			updateViews()
		}
	}
	
	private func updateViews() {
		guard let pokemon = pokemon else { return }
		nameLabel.text = pokemon.name
	}
}
