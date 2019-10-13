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
    var meme: Meme?
    var numberInList: Int?
    
    @IBOutlet var memeImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButtonWasPressed))
        if let memeImage = memeImage {
            memeImageView.image = memeImage
        }
        
    }
    
    @objc func editButtonWasPressed() {
        guard let meme = meme else { return }
        guard let numberInList = numberInList else { return }
        if let memeVC = storyboard?.instantiateViewController(withIdentifier: MemeEditorViewController_ID) as? MemeEditorViewController{
            memeVC.editMeme = meme
            memeVC.numberInList = numberInList
            navigationController?.pushViewController(memeVC, animated: true)
        }
    }
    
    
    
}
