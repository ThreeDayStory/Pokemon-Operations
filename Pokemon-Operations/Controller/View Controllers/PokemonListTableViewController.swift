//
//  PokemonListTableViewController.swift
//  Pokemon-Operations
//
//  Created by Chad Rutherford on 3/23/20.
//

import UIKit

class PokemonListTableViewController: UITableViewController {
	
	let apiController = APIController()
	var pokemon = [PokemonResult]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		apiController.fetchAllPokemon { result in
			switch result {
			case .success(let pokemon):
				self.pokemon = pokemon
				self.tableView.reloadData()
			case .failure(let error):
				print(error)
			}
		}
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return pokemon.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: PokemonCell.reuseID, for: indexPath) as? PokemonCell else { return UITableViewCell() }
		let cellPokemon = pokemon[indexPath.row]
		cell.pokemon = cellPokemon
		return cell
	}
}
