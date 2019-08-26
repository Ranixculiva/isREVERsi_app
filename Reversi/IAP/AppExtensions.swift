/*
 Copyright © 2019 Apple Inc.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Abstract:
Creates extensions for the DateFormatter, ProductIdentifiers, Section, SKDownload, and SKProduct classes. Extends NSView and UIView to the
DiscloseView protocol. Extends UIBarButtonItem to conform to the EnableItem protocol.
*/

#if os (macOS)
import Cocoa
#elseif os (iOS)
import UIKit
#endif
import Foundation
import StoreKit

// MARK: - DateFormatter

extension DateFormatter {
	/// - returns: A string representation of date using the short time and date style.
	class func short(_ date: Date) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .short
		dateFormatter.timeStyle = .short
		return dateFormatter.string(from: date)
	}

	/// - returns: A string representation of date using the long time and date style.
	class func long(_ date: Date) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .long
		dateFormatter.timeStyle = .long
		return dateFormatter.string(from: date)
	}
}

// MARK: - Section

extension Section {
	/// - returns: A Section object matching the specified name in the data array.
	static func parse(_ data: [Section], for type: SectionType) -> Section? {
		let section = (data.filter({ (item: Section) in item.type == type }))
		return (!section.isEmpty) ? section.first : nil
	}
}

// MARK: - SKProduct
extension SKProduct {
	/// - returns: The cost of the product formatted in the local currency.
	var regularPrice: String? {
		let formatter = NumberFormatter()
		formatter.numberStyle = .currency
		formatter.locale = self.priceLocale
		return formatter.string(from: self.price)
	}
}

// MARK: - SKDownload

extension SKDownload {
	/// - returns: A string representation of the downloadable content length.
	var downloadContentSize: String {
		#if os (macOS)
		return ByteCountFormatter.string(fromByteCount: Int64(truncating: self.contentLength), countStyle: .file)
		#else
		return ByteCountFormatter.string(fromByteCount: self.contentLength, countStyle: .file)
		#endif
	}
}

// MARK: - DiscloseView

#if os (macOS)
extension NSView: DiscloseView {
	/// Show the view.
	func show() {
		self.isHidden = false
	}

	/// Hide the view.
	func hide() {
		self.isHidden = true
	}
}
#else
extension UIView: DiscloseView {
	/// Show the view.
	func show() {
		self.isHidden = false
	}

	/// Hide the view.
	func hide() {
		self.isHidden = true
	}
}

// MARK: - EnableItem

extension UIBarItem: EnableItem {
	/// Enable the bar item.
	func enable() {
		self.isEnabled = true
	}

	/// Disable the bar item.
	func disable() {
		self.isEnabled = false
	}
}
#endif

// MARK: - ProductIdentifiers

extension ProductIdentifiers {
	var isEmpty: String {
		return "\(name).\(fileExtension) is empty. \(Messages.updateResource)"
	}

	var wasNotFound: String {
		return "\(Messages.couldNotFind) \(name).\(fileExtension)."
	}

	/// - returns: An array with the product identifiers to be queried.
	var identifiers: [String]? {
		guard let path = Bundle.main.path(forResource: self.name, ofType: self.fileExtension) else { return nil }
		return NSArray(contentsOfFile: path) as? [String]
	}
}

