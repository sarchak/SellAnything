//
//  ListViewController.swift
//  SellAnything
//
//  Created by Shrikar Archak on 7/14/15.
//  Copyright © 2015 Shrikar Archak. All rights reserved.
//

import UIKit
import Parse
import PassKit

class ListViewController: UITableViewController, TableViewCellDelegate, PKPaymentAuthorizationViewControllerDelegate{

    var query = PFQuery(className: "Item")
    var items :[Item]? = []
    var currItem: Item!
    var viewController: PKPaymentAuthorizationViewController?
    let request = PKPaymentRequest()
    override func viewDidLoad() {
        super.viewDidLoad()
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock { (data: [AnyObject]?, error) -> Void in
            let objects = data as! [PFObject]
            for tmp in objects {
                print(tmp.valueForKey("info"))
                self.items?.append(Item(obj: tmp))
            }
            print(self.items?.count)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })

        }
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let titems = items {
            print("REturning \(titems.count)")
            return titems.count
        }
        return 0
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TableViewCell
        let item = self.items![indexPath.row]
        cell.delegate = self
        cell.itemImageView.image = UIImage(data: item.imageData)
        cell.title.text = item.title
        cell.info.text = item.info
        cell.priceLabel.text = "$\(item.price)"
        print("Got some data")
        return cell
    }
    
    func getPayments(item : Item, shipping: String) -> [PKPaymentSummaryItem] {
        let wax = PKPaymentSummaryItem(label: "Shrikar Archak iOS programming : \(item.price)", amount: NSDecimalNumber(string: "\(item.price)"))
        let discount = PKPaymentSummaryItem(label: "Discount", amount: NSDecimalNumber(string: "-1.00"))
        let shipping = PKPaymentSummaryItem(label: "Shipping", amount: NSDecimalNumber(string: shipping))
        let totalAmount = wax.amount.decimalNumberByAdding(discount.amount)
            .decimalNumberByAdding(shipping.amount)
        let total = PKPaymentSummaryItem(label: "Shrikar Archak", amount: totalAmount)
        return [wax, discount, shipping, total]
    }

    func buyTapped(cell: TableViewCell) {
        let indexPath = self.tableView.indexPathForCell(cell)! as NSIndexPath
        let item = self.items![indexPath.row]
        currItem = item
        let paymentNetworks = [PKPaymentNetworkAmex, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa]
        if PKPaymentAuthorizationViewController.canMakePaymentsUsingNetworks(paymentNetworks) {

            print("Apple pay is available")

            request.supportedNetworks = [PKPaymentNetworkAmex, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa]
            request.countryCode = "US"
            request.currencyCode = "USD"
            request.merchantIdentifier = "merchant.com.shrikar.sellanything"
            request.merchantCapabilities = .Capability3DS
            request.requiredShippingAddressFields = PKAddressField.PostalAddress
            request.paymentSummaryItems = getPayments(item, shipping: "9.99")
            
            let sameday = PKShippingMethod(label: "Same Day", amount: NSDecimalNumber(string: "9.99"))
            sameday.detail = "Guranteed Same day"
            sameday.identifier = "sameday"
            
            let twoday = PKShippingMethod(label: "Two Day", amount: NSDecimalNumber(string: "4.99"))
            twoday.detail = "2 Day delivery"
            twoday.identifier = "2day"

            let shippingMethods : [PKShippingMethod] = [sameday, twoday]
            request.shippingMethods = shippingMethods
            
            viewController = PKPaymentAuthorizationViewController(paymentRequest: request)
            viewController?.delegate = self
            presentViewController(viewController!, animated: true, completion: nil)
            
        }
    }

    func paymentAuthorizationViewController(controller: PKPaymentAuthorizationViewController, didSelectShippingMethod shippingMethod: PKShippingMethod, completion: (PKPaymentAuthorizationStatus, [PKPaymentSummaryItem]) -> Void) {
        completion(PKPaymentAuthorizationStatus.Success, getPayments(currItem, shipping: "\(shippingMethod.amount)"))
    }
    

    
    func paymentAuthorizationViewController(controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: (PKPaymentAuthorizationStatus) -> Void) {

        print("Did authorize : \(payment)")
        completion(PKPaymentAuthorizationStatus.Success)
    }
    
    func paymentAuthorizationViewControllerDidFinish(controller: PKPaymentAuthorizationViewController) {
        print("Did finish")
        controller.dismissViewControllerAnimated(true , completion: nil)
    }
    

}
