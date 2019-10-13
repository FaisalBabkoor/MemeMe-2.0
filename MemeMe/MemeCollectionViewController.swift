//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Faisal Babkoor on 10/10/19.
//  Copyright © 2019 Faisal Babkoor. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var collectionView: UICollectionView!
    var memes: [Meme] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes
    }
    
    @IBOutlet var flowLayout: UICollectionViewFlowLayout!
    override func viewDidLoad() {
        super.viewDidLoad()
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemeCollectionViewIdentifier, for: indexPath) as! MemeCollectionViewCell
        let meme = memes[indexPath.row]
        cell.configCell(meme: meme)
        
        return cell
    }
    
    @IBAction func addMeme(_ sender: Any) {
        let memeEditorVC = storyboard?.instantiateViewController(withIdentifier: MemeEditorViewController_ID) as! MemeEditorViewController
        navigationController?.pushViewController(memeEditorVC, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let memeDetailVC = storyboard?.instantiateViewController(withIdentifier: MemeDetailVCIdentifier) as? MemeDetailViewController {
            let meme = memes[indexPath.row]
            memeDetailVC.memeImage = meme.memedImage
            memeDetailVC.meme = meme
            memeDetailVC.numberInList = indexPath.row
            navigationController?.pushViewController(memeDetailVC, animated: true)
        }
    }
    
}
