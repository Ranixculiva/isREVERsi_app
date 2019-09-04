/*
 Copyright © 2019 Apple Inc.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Abstract:
Creates the DiscloseView, EnableItem, SettingsDelegate, StoreManagerDelegate, and StoreObserverDelegate protocols that allow you to
show/hide UI elements, enable/disable UI elements, notifies a listener about restoring purchases, manage StoreManager operations,and
handle StoreObserver operations, respectively.
*/

import Foundation

// MARK: - DiscloseView

protocol DiscloseView {
	func show()
	func hide()
}

// MARK: - EnableItem

protocol EnableItem {
	func enable()
	func disable()
}

// MARK: - StoreManagerDelegate

protocol StoreManagerDelegate: AnyObject {
	/// Provides the delegate with the App Store's response.
	func storeManagerDidReceiveResponse(_ response: [Section])

	/// Provides the delegate with the error encountered during the product request.
	func storeManagerDidReceiveMessage(_ message: String)
}

// MARK: - StoreObserverDelegate

protocol StoreObserverDelegate: AnyObject {
    ///Tells the delegate that the purchase operation was successful.
    func storeObserverPurchasedDidSucceed()
    
	/// Tells the delegate that the restore operation was successful.
	func storeObserverRestoreDidSucceed()

	/// Provides the delegate with messages.
	func storeObserverDidReceiveMessage(_ message: String)
}

// MARK: - SettingsDelegate

protocol SettingsDelegate: AnyObject {
	/// Tells the delegate that the user has requested the restoration of their purchases.
	func settingDidSelectRestore()
}
