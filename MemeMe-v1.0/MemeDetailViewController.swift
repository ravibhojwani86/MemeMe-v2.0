//
//  MemeDetailViewController.swift
//  MemeMe-v2.0
//
//  Created by Ravi on 16/11/17.
//  Copyright © 2017 Ravi. All rights reserved.
//

import UIKit

class MemeDetailViewController : UIViewController {
    var selectedMeme: MemeModel!
    @IBOutlet weak var detailImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailImageView.image = selectedMeme.modifiedImage
        detailImageView.contentMode = .scaleAspectFit
    }
}
