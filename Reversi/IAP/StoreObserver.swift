/*
 Copyright © 2019 Apple Inc.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Abstract:
Implements the SKPaymentTransactionObserver protocol. Handles purchasing and restoring products using paymentQueue:updatedTransactions:.
*/

import StoreKit
import Foundation

class StoreObserver: NSObject {
	// MARK: - Types

	static let shared = StoreObserver()

	// MARK: - Properties

	/**
	Indicates whether the user is allowed to make payments.
	- returns: true if the user is allowed to make payments and false, otherwise. Tell StoreManager to query the App Store when the user is
	allowed to make payments and there are product identifiers to be queried.
	*/
	var isAuthorizedForPayments: Bool {
		return SKPaymentQueue.canMakePayments()
	}

	/// Keeps track of all purchases.
	var purchased = [SKPaymentTransaction]()

	/// Keeps track of all restored purchases.
	var restored = [SKPaymentTransaction]()

	/// Indicates whether there are restorable purchases.
	fileprivate var hasRestorablePurchases = false

	weak var delegate: StoreObserverDelegate?

	// MARK: - Initializer

	private override init() {}

	// MARK: - Submit Payment Request

	/// Create and add a payment request to the payment queue.
	func buy(_ product: SKProduct) {
		let payment = SKMutablePayment(product: product)
		SKPaymentQueue.default().add(payment)
	}

	// MARK: - Restore All Restorable Purchases

	/// Restores all previously completed purchases.
	func restore() {
		if !restored.isEmpty {
			restored.removeAll()
		}
		SKPaymentQueue.default().restoreCompletedTransactions()
	}

	// MARK: - Handle Payment Transactions

	/// Handles successful purchase transactions.
	fileprivate func handlePurchased(_ transaction: SKPaymentTransaction) {
		purchased.append(transaction)
		print("\(Messages.deliverContent) \(transaction.payment.productIdentifier).")
        
        DispatchQueue.main.async {
            self.delegate?.storeObserverPurchasedDidSucceed()
        }
		// Finish the successful transaction.
		SKPaymentQueue.default().finishTransaction(transaction)
        
	}

	/// Handles failed purchase transactions.
	fileprivate func handleFailed(_ transaction: SKPaymentTransaction) {
		var message = "\(Messages.purchaseOf) \(transaction.payment.productIdentifier) \(Messages.failed)"

		if let error = transaction.error {
			message += "\n\(Messages.error) \(error.localizedDescription)"
			print("\(Messages.error) \(error.localizedDescription)")
		}

		// Do not send any notifications when the user cancels the purchase.
		if (transaction.error as? SKError)?.code != .paymentCancelled {
			DispatchQueue.main.async {
				self.delegate?.storeObserverDidReceiveMessage(message)
			}
		}
		// Finish the failed transaction.
		SKPaymentQueue.default().finishTransaction(transaction)
	}

	/// Handles restored purchase transactions.
	fileprivate func handleRestored(_ transaction: SKPaymentTransaction) {
		hasRestorablePurchases = true
		restored.append(transaction)
		print("\(Messages.restoreContent) \(transaction.payment.productIdentifier).")

		DispatchQueue.main.async {
			self.delegate?.storeObserverRestoreDidSucceed()
		}
		// Finishes the restored transaction.
		SKPaymentQueue.default().finishTransaction(transaction)
	}
}

// MARK: - SKPaymentTransactionObserver

/// Extends StoreObserver to conform to SKPaymentTransactionObserver.
extension StoreObserver: SKPaymentTransactionObserver {
	/// Called when there are transactions in the payment queue.
	func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
		for transaction in transactions {
            if transaction.transactionState != .purchasing{
                Utilities.purchaseInProgress = false
            }
			switch transaction.transactionState {
			case .purchasing:
                Utilities.purchaseInProgress = true
			// Do not block your UI. Allow the user to continue using your app.
			case .deferred: print(Messages.deferred)
			// The purchase was successful.
			case .purchased: handlePurchased(transaction)
			// The transaction failed.
			case .failed: handleFailed(transaction)
			// There are restored products.
			case .restored: handleRestored(transaction)
			@unknown default: fatalError("\(Messages.unknownDefault)")
			}
		}
	}

	/// Logs all transactions that have been removed from the payment queue.
	func paymentQueue(_ queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
		for transaction in transactions {
			print ("\(transaction.payment.productIdentifier) \(Messages.removed)")
		}
	}

	/// Called when an error occur while restoring purchases. Notify the user about the error.
	func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
		if let error = error as? SKError, error.code != .paymentCancelled {
			DispatchQueue.main.async {
				self.delegate?.storeObserverDidReceiveMessage(error.localizedDescription)
			}
		}
	}

	/// Called when all restorable transactions have been processed by the payment queue.
	func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
		print(Messages.restorable)

		if !hasRestorablePurchases {
			DispatchQueue.main.async {
				self.delegate?.storeObserverDidReceiveMessage(Messages.noRestorablePurchases)
			}
		}
	}
}

