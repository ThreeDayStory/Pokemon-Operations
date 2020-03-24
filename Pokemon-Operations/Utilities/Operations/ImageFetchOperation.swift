//
//  ImageFetchOperation.swift
//  Pokemon-Operations
//
//  Created by Chad Rutherford on 3/24/20.
//

import UIKit

class ImageFetchOperation: ConcurrentOperation {
	
	var url: URL
	var apiController: APIController
	var image: UIImage?
	
	init(apiController: APIController, url: URL) {
		self.apiController = apiController
		self.url = url
	}
	
	override func start() {
		self.state = .isExecuting
		apiController.fetchImage(for: url) { [weak self] result in
			guard let self = self else { return }
			defer { self.state = .isFinished }
			switch result {
			case .success(let image):
				self.image = image
			case .failure(let error):
				print(error)
			}
		}
	}
}
