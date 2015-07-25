//
//  Item.swift
//  SellAnything
//
//  Created by Shrikar Archak on 7/12/15.
//  Copyright © 2015 Shrikar Archak. All rights reserved.
//

import Foundation
import Parse

struct Item {
    var title: String!
    var info: String!
    var price : Double!
    var imageData : NSData!
    var thumbnailData : NSData!
    
    init(title: String, info: String, price : Double, imageData : NSData, thumbnailData: NSData) {
        self.title = title
        self.info = info
        self.price = price
        self.imageData = imageData
        self.thumbnailData = thumbnailData
    }
    
    init(obj : PFObject){
        self.title = obj.valueForKey("title") as! String
        self.info = obj.valueForKey("info") as! String
        self.price = obj.valueForKey("price") as! Double
        let tfile = obj.objectForKey("itemImage") as! PFFile
        self.imageData = tfile.getData()
        let thumbfile = obj.objectForKey("thumbnailImage") as! PFFile
        
        self.thumbnailData = thumbfile.getData()
        

    }
}