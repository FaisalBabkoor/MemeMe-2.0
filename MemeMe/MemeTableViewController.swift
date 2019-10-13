//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Faisal Babkoor on 10/10/19.
//  Copyright © 2019 Faisal Babkoor. All rights reserved.
//

import UIKit

class MemeTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var memes: [Meme] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes
    }
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    @objc func refreshView() {
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MemTabelViewIdentifier, for: indexPath) as! MemeTableViewCell
        let meme = memes[indexPath.row]
        cell.configCell(meme: meme)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let memeDetailVC = storyboard?.instantiateViewController(withIdentifier: MemeDetailVCIdentifier) as? MemeDetailViewController {
            let meme = memes[indexPath.row]
            memeDetailVC.memeImage = meme.memedImage
            memeDetailVC.meme = meme
            memeDetailVC.numberInList = indexPath.row
            navigationController?.pushViewController(memeDetailVC, animated: true)
        }
    }
    
    @IBAction func addMeme(_ sender: Any) {
        let memeEditorVC = storyboard?.instantiateViewController(withIdentifier: MemeEditorViewController_ID) as! MemeEditorViewController
        navigationController?.pushViewController(memeEditorVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.memes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
}
