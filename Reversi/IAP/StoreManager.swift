/*
 Copyright © 2019 Apple Inc.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Abstract:
Retrieves product information from the App Store using SKRequestDelegate, SKProductsRequestDelegate, SKProductsResponse, and SKProductsRequest.
Notifies its observer with a list of products available for sale along with a list of invalid product identifiers. Logs an error message if the
product request failed.
*/

import StoreKit
import Foundation

class StoreManager: NSObject {
	// MARK: - Types

	static let shared = StoreManager()

	// MARK: - Properties

	/// Keeps track of all valid products. These products are available for sale in the App Store.
	fileprivate var availableProducts = [SKProduct]()

	/// Keeps track of all invalid product identifiers.
	fileprivate var invalidProductIdentifiers = [String]()

	/// Keeps a strong reference to the product request.
	fileprivate var productRequest: SKProductsRequest!

	/// Keeps track of all valid products (these products are available for sale in the App Store) and of all invalid product identifiers.
	fileprivate var storeResponse = [Section]()

	weak var delegate: StoreManagerDelegate?

	// MARK: - Initializer

	private override init() {}

	// MARK: - Request Product Information

	/// Starts the product request with the specified identifiers.
	func startProductRequest(with identifiers: [String]) {
		fetchProducts(matchingIdentifiers: identifiers)
	}
    func getAvailableProducts() -> [SKProduct]{
        return availableProducts
    }
	/// Fetches information about your products from the App Store.
	/// - Tag: FetchProductInformation
	fileprivate func fetchProducts(matchingIdentifiers identifiers: [String]) {
		// Create a set for the product identifiers.
		let productIdentifiers = Set(identifiers)

		// Initialize the product request with the above identifiers.
		productRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
		productRequest.delegate = self

		// Send the request to the App Store.
		productRequest.start()
	}

	// MARK: - Helper Methods

	/// - returns: Existing product's title matching the specified product identifier.
	func title(matchingIdentifier identifier: String) -> String? {
		var title: String?
		guard !availableProducts.isEmpty else { return nil }

		// Search availableProducts for a product whose productIdentifier property matches identifier. Return its localized title when found.
		let result = availableProducts.filter({ (product: SKProduct) in product.productIdentifier == identifier })

		if !result.isEmpty {
			title = result.first!.localizedTitle
		}
		return title
	}

	/// - returns: Existing product's title associated with the specified payment transaction.
	func title(matchingPaymentTransaction transaction: SKPaymentTransaction) -> String {
		let title = self.title(matchingIdentifier: transaction.payment.productIdentifier)
		return title ?? transaction.payment.productIdentifier
	}
}

// MARK: - SKProductsRequestDelegate

/// Extends StoreManager to conform to SKProductsRequestDelegate.
extension StoreManager: SKProductsRequestDelegate {
	/// Used to get the App Store's response to your request and notify your observer.
	/// - Tag: ProductRequest
	func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
		if !storeResponse.isEmpty {
			storeResponse.removeAll()
		}

		// products contains products whose identifiers have been recognized by the App Store. As such, they can be purchased.
		if !response.products.isEmpty {
			availableProducts = response.products
			storeResponse.append(Section(type: .availableProducts, elements: availableProducts))
		}

		// invalidProductIdentifiers contains all product identifiers not recognized by the App Store.
		if !response.invalidProductIdentifiers.isEmpty {
			invalidProductIdentifiers = response.invalidProductIdentifiers
			storeResponse.append(Section(type: .invalidProductIdentifiers, elements: invalidProductIdentifiers))
		}

		if !storeResponse.isEmpty {
			DispatchQueue.main.async {
				self.delegate?.storeManagerDidReceiveResponse(self.storeResponse)
			}
		}
	}
}

// MARK: - SKRequestDelegate

/// Extends StoreManager to conform to SKRequestDelegate.
extension StoreManager: SKRequestDelegate {
	/// Called when the product request failed.
	func request(_ request: SKRequest, didFailWithError error: Error) {
		DispatchQueue.main.async {
			self.delegate?.storeManagerDidReceiveMessage(error.localizedDescription)
		}
	}
}
