//
//  MemeTableViewCell.swift
//  MemeMe
//
//  Created by Faisal Babkoor on 10/13/19.
//  Copyright © 2019 Faisal Babkoor. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {

    @IBOutlet var imageName: UIImageView!
    @IBOutlet var topText: UILabel!
    @IBOutlet var bottomText: UILabel!
    
    func configCell(meme: Meme) {
        self.imageName.image = meme.memedImage
        self.topText.text = meme.topText
        self.bottomText.text = meme.bottomText
    }

}
