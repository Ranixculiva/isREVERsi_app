/*
 Copyright © 2019 Apple Inc.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Abstract:
Provides the Purchases view's data source and creates an alert.
*/

import StoreKit
#if os (macOS)
import Cocoa
#else
import UIKit
#endif

class Utilities {

	// MARK: - Properties

	/// Indicates whether the user has initiated a restore.
	var restoreWasCalled: Bool

	/// - returns: An array that will be used to populate the Purchases view.
	var dataSourceForPurchasesUI: [Section] {
		var dataSource = [Section]()
		let purchased = StoreObserver.shared.purchased
		let restored = StoreObserver.shared.restored

		if restoreWasCalled && (!restored.isEmpty) && (!purchased.isEmpty) {
			dataSource.append(Section(type: .purchased, elements: purchased))
			dataSource.append(Section(type: .restored, elements: restored))
		} else if restoreWasCalled && (!restored.isEmpty) {
			dataSource.append(Section(type: .restored, elements: restored))
		} else if !purchased.isEmpty {
			dataSource.append(Section(type: .purchased, elements: purchased))
		}

		/*
		Only want to display restored products when the "Restore" button(iOS), "Store > Restore" (macOS), or "Restore all restorable purchases"
		(tvOS) was tapped and there are restored products.
		*/
		restoreWasCalled = false
		return dataSource
	}

	// MARK: - Initialization

	init() {
		restoreWasCalled = false
	}

	// MARK: - Create Alert

	#if os (iOS) || os (tvOS)
	/// - returns: An alert with a given title and message.
	func alert(_ title: String, message: String) -> UIAlertController {
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
		let action = UIAlertAction(title: NSLocalizedString(Messages.okButton, comment: Messages.emptyString),
								   style: .default, handler: nil)
		alertController.addAction(action)
		return alertController
	}
	#endif
}
