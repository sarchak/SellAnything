//
//  ViewController.swift
//  SellAnything
//
//  Created by Shrikar Archak on 7/11/15.
//  Copyright © 2015 Shrikar Archak. All rights reserved.
//

import UIKit
import PassKit

class ViewController: UIViewController, PKPaymentAuthorizationViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        let paymentNetworks = [PKPaymentNetworkAmex, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa]
        if PKPaymentAuthorizationViewController.canMakePaymentsUsingNetworks(paymentNetworks) {
            // Pay is available!
            print("Apple pay is available")
            let request = PKPaymentRequest()
            request.supportedNetworks = [PKPaymentNetworkAmex, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa]
            request.countryCode = "US"
            request.currencyCode = "USD"
            request.merchantIdentifier = "merchant.com.shrikar.sellanything"
            request.merchantCapabilities = .Capability3DS
            let wax = PKPaymentSummaryItem(label: "Shrikar Archak iOS programming", amount: NSDecimalNumber(string: "10.00"))
            let discount = PKPaymentSummaryItem(label: "Discount", amount: NSDecimalNumber(string: "-1.00"))
            let shipping = PKPaymentSummaryItem(label: "Shipping", amount: NSDecimalNumber(string: "4.99"))
            let totalAmount = wax.amount.decimalNumberByAdding(discount.amount)
                .decimalNumberByAdding(shipping.amount)
            let total = PKPaymentSummaryItem(label: "Shrikar Archak", amount: totalAmount)
            request.paymentSummaryItems = [wax, discount, shipping, total]
            
            let viewController = PKPaymentAuthorizationViewController(paymentRequest: request)
            viewController.delegate = self
            presentViewController(viewController, animated: true, completion: nil)
            
        }

    }

    func paymentAuthorizationViewController(controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: (PKPaymentAuthorizationStatus) -> Void) {
        print("Did authorize : \(payment)")
        completion(PKPaymentAuthorizationStatus.Success)
    }
    
    func paymentAuthorizationViewControllerDidFinish(controller: PKPaymentAuthorizationViewController) {
        print("Did finish")
        controller.dismissViewControllerAnimated(true , completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

