//
//  MemeCollectionViewController.swift
//  MemeMe-v2.0
//
//  Created by Ravi on 15/11/17.
//  Copyright © 2017 Ravi. All rights reserved.
//

import UIKit

class MemeCollectionViewController : UICollectionViewController{
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let TITLE = "Saved Items"
    let CELL_IDENTIFIER = "CollectionViewCell"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView!.reloadData()
        for tabBarItem in tabBarController!.tabBar.items! {
            tabBarItem.title = ""
            tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = TITLE
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appDelegate.memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_IDENTIFIER, for: indexPath) as! MemeCollectionViewCell
        
        // Configure the cell
        let meme = appDelegate.memes[indexPath.row]
        cell.memeImageView.image = meme.modifiedImage
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMeme = appDelegate.memes[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let memeDetailVC = storyboard.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        memeDetailVC.selectedMeme = selectedMeme
        navigationController?.pushViewController(memeDetailVC, animated: true)
    }

}
