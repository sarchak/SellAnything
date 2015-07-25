//
//  PhotoCaptureViewController.swift
//  SellAnything
//
//  Created by Shrikar Archak on 7/12/15.
//  Copyright © 2015 Shrikar Archak. All rights reserved.
//

import UIKit
import Parse

class PhotoCaptureViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var titleLabel: UITextField!
    
    @IBOutlet weak var priceLabel: UITextField!
    @IBOutlet weak var infoLabel: UITextField!
    
    @IBOutlet weak var itemImageView: UIImageView!
    var photoPicker : UIImagePickerController!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        print("Selected image")
        picker.dismissViewControllerAnimated(true , completion: nil)
        self.itemImageView.image = image
    }

    
    @IBAction func post(sender: AnyObject) {

        guard let currTitle = self.titleLabel.text , info = self.infoLabel.text, price = Double(self.priceLabel.text!) , imageData = UIImageJPEGRepresentation(self.itemImageView.image!, 0.1) else {
            return
        }
//        var item = Item(title: currTitle, info : info, price: price, imageData: imageData, thumbnailData: imageData)
        

        let pimageFile = PFFile(data: imageData)
        let timageFile = PFFile(data: imageData)
        let photo = PFObject(className: "Item")
        photo.setValue(currTitle, forKey: "title")
        photo.setValue(info, forKey: "info")
        photo.setValue(price, forKey: "price")
        photo.setObject(pimageFile, forKey: "itemImage")
        photo.setObject(timageFile, forKey: "thumbnailImage")
        photo.saveInBackgroundWithBlock { (success, error ) -> Void in
            print("Photo uploaded")
            self.dismissViewControllerAnimated(true , completion: nil)
        }

    }

    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true , completion: nil)        
    }
    
    @IBAction func tapped(sender: AnyObject) {
        photoPicker = UIImagePickerController()
        photoPicker.delegate = self
        photoPicker.editing = false
        photoPicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(photoPicker, animated: true, completion: nil)

    }
    
}
