//
//  CollectionViewCell.swift
//  picturepublication
//
//  Created by Laure Compoint on 11/06/2020.
//  Copyright © 2020 Laure Compoint. All rights reserved.
//

import UIKit

class ProfilImageViewCell: UICollectionViewCell {
    @IBOutlet weak var Image: UIImageView!
    
    func setUp(with post: Post) {
        Imageimage = UIImage(data: post.image)
        
    }
    
}
