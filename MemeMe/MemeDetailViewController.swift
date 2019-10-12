//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Faisal Babkoor on 10/13/19.
//  Copyright © 2019 Faisal Babkoor. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    var memeImage: UIImage?
    @IBOutlet var memeImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let memeImage = memeImage {
            memeImageView.image = memeImage
        }
        
    }
    



}
