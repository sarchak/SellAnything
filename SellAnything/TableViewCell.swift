//
//  TableViewCell.swift
//  SellAnything
//
//  Created by Shrikar Archak on 7/14/15.
//  Copyright © 2015 Shrikar Archak. All rights reserved.
//

import UIKit


protocol TableViewCellDelegate {
    func buyTapped(cell : TableViewCell)
}

class TableViewCell: UITableViewCell {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var info: UILabel!
    var delegate: TableViewCellDelegate?
    
    @IBOutlet weak var priceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func buy(sender: AnyObject) {
        delegate?.buyTapped(self)
    }
}
