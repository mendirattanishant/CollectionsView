//
//  ItemCell.swift
//  Mercari
//
//  Created by Nishant Mendiratta on 8/18/17.
//  Copyright © 2017 Mercari. All rights reserved.
//

import UIKit

class ItemCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var soldimageView: UIImageView!
    
    func updateUI() {
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        price.layer.cornerRadius = price.frame.size.height / 4
        price.clipsToBounds = true
        price.layer.masksToBounds = true
    }
}
