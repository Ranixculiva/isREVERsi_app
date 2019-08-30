//
//  PurchaseButtons.swift
//  Reversi
//
//Copyright © 2019 Apple Inc.

//Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

//  Created by john gospai on 2019/7/22.
//  Copyright © 2019 john gospai. All rights reserved.
//

import SpriteKit
class PurchaseButtons: SKNode {
    fileprivate var purchaseButton: Button!
    fileprivate var restoreButton: Button!
    fileprivate var purchasedButton: Button!
    fileprivate var IAP_utility: Utilities!
    override var frame: CGRect{
        let height = max(purchaseButton.frame.height,restoreButton.frame.height,purchasedButton.frame.height)
        let width = max(purchaseButton.frame.width,restoreButton.frame.width,purchasedButton.frame.width)
        
        return CGRect(x: -width/2, y: -height/2, width: width, height: height)
    }
    override init() {
        super.init()
        IAP_utility = Utilities()
        self.isUserInteractionEnabled = true
        //MARK: set up purchased button
        purchasedButton = Button(buttonColor: UI.purchasedButtonColor, cornerRadius: UI.purchasedButtonCornerRadius)!
        purchasedButton.fontSize = UI.purchasedButtonFontSize
        purchasedButton.zPosition = UI.zPosition.purchasedButton
        purchasedButton.text = UI.Texts.purchased
        addChild(purchasedButton)
        //MARk: set up purchase button
        purchaseButton = Button(buttonColor: UI.purchaseButtonColor, cornerRadius: UI.purchaseButtonCornerRadius)!
        purchaseButton.fontSize = UI.purchaseButtonFontSize
        purchaseButton.position.x = -150
        purchaseButton.zPosition = UI.zPosition.purchaseButton
        purchaseButton.text = UI.Texts.purchase
        purchaseButton.isUserInteractionEnabled = false
        addChild(purchaseButton)
        
//        //MARK: set up purchase button
//        purchaseButton = SKSpriteNode(color: .red, size: CGSize(width: 100, height: 50))
//        purchaseButton.zPosition = 1
//        purchaseButton.position = CGPoint(x: -200, y: 0)
//        purchaseButton.isUserInteractionEnabled = false
//        addChild(purchaseButton)
        
        //MARK: set up restore button
        restoreButton = Button(buttonColor: UI.restoreButtonColor, cornerRadius: UI.restoreButtonCornerRadius)!
        restoreButton.position.x = 150
        restoreButton.isUserInteractionEnabled = false
        restoreButton.fontSize = UI.restoreButtonFontSize
        restoreButton.zPosition = UI.zPosition.restoreButton
        restoreButton.text = UI.Texts.restore
        addChild(restoreButton)
        
        
//        restoreButton = SKSpriteNode(color: .blue, size: CGSize(width: 100, height: 50))
//        restoreButton.zPosition = 1
//        restoreButton.position = CGPoint(x: 200, y: 0)
//        restoreButton.isUserInteractionEnabled = false
//        addChild(restoreButton)
        
        if SharedVariable.withAds{
            purchasedButton.isHidden = true
            purchaseButton.isHidden = false
            restoreButton.isHidden = false
        }
        else {
            purchasedButton.isHidden = false
            purchaseButton.isHidden = true
            restoreButton.isHidden = true
        }
        disableRestoreButton()
        StoreManager.shared.delegate = self
        StoreObserver.shared.delegate = self
        if StoreObserver.shared.isAuthorizedForPayments {
            enableRestoreButton()}
    }
    fileprivate var isRestoreButtonEnabled = false
    fileprivate func enableRestoreButton(){
        isRestoreButtonEnabled = true
        restoreButton.alpha = 1
    }
    fileprivate func disableRestoreButton(){
        isRestoreButtonEnabled = false
        restoreButton.alpha = 0.5
    }
    fileprivate func fetchProductInformation() {
        // First, let's check whether the user is allowed to make purchases. Proceed if they are allowed. Display an alert, otherwise.
        if StoreObserver.shared.isAuthorizedForPayments {
            enableRestoreButton()
            let resourceFile = ProductIdentifiers()
            guard let identifiers = resourceFile.identifiers else {
                // Warn the user that the resource file could not be found.
                alert(with: Messages.status, message: resourceFile.wasNotFound)
                return
            }
            
            if !identifiers.isEmpty {
//                switchToViewController(segment: .products)
                // Refresh the UI with identifiers to be queried.
//                products.reload(with: [Section(type: .invalidProductIdentifiers, elements: identifiers)])
                
                // Fetch product information.
                StoreManager.shared.startProductRequest(with: identifiers)
            } else {
                // Warn the user that the resource file does not contain anything.
                alert(with: Messages.status, message: resourceFile.isEmpty)
            }
        } else {
            // Warn the user that they are not allowed to make purchases.
            alert(with: Messages.status, message: Messages.cannotMakePayments)
        }
    }
    
    // MARK: - Display Alert
    
    /// Creates and displays an alert.
    fileprivate func alert(with title: String, message: String) {
        let alertController = IAP_utility.alert(title, message: message)
        UIApplication.getPresentedViewController()?.present(alertController, animated: true, completion: nil)
    }
    fileprivate func purchase() {
        // Fetch product information.
        fetchProductInformation()
        if let product = StoreManager.shared.getAvailableProducts().first{
            StoreObserver.shared.buy(product)
        }
        print("purchaseButton has been pressed!")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            let pos = touch.location(in: self)
            let node = atPoint(pos)
            if purchaseButton.nodesTouched.contains(node){
                purchase()
            }
            else if restoreButton.nodesTouched.contains(node){
                restore()
            }
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate func restore(){
        StoreObserver.shared.restore()
    }
    fileprivate func handleRestoredSucceededTransaction() {
        IAP_utility.restoreWasCalled = true
        handlePurchasedSucceededTransaction()
    }
    fileprivate func handlePurchasedSucceededTransaction() {
        purchasedButton.isHidden = false
        purchaseButton.isHidden = true
        restoreButton.isHidden = true
        SharedVariable.withAds = false
        KeychainWrapper.standard.set(false, forKey: SharedVariable.key.withAds.rawValue)
    }
    
    
}
// MARK: - StoreManagerDelegate

/// Extends ParentViewController to conform to StoreManagerDelegate.
extension PurchaseButtons: StoreManagerDelegate {
    func storeManagerDidReceiveResponse(_ response: [Section]) {
    }
    
    func storeManagerDidReceiveMessage(_ message: String) {
        alert(with: Messages.productRequestStatus, message: message)
    }
}

// MARK: - StoreObserverDelegate

/// Extends ParentViewController to conform to StoreObserverDelegate.
extension PurchaseButtons: StoreObserverDelegate {
    func storeObserverDidReceiveMessage(_ message: String) {
        alert(with: Messages.purchaseStatus, message: message)
    }
    
    func storeObserverRestoreDidSucceed() {
        handleRestoredSucceededTransaction()
    }
    func storeObserverPurchasedDidSucceed() {
        handlePurchasedSucceededTransaction()
    }
}
