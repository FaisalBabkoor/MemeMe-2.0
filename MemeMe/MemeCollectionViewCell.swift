//
//  MemeCollectionViewCell.swift
//  MemeMe
//
//  Created by Faisal Babkoor on 10/11/19.
//  Copyright © 2019 Faisal Babkoor. All rights reserved.
//

import UIKit

class MemeCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageName: UIImageView!
    
    func configCell(meme: Meme) {
        self.imageName.image = meme.memedImage
    }
}
