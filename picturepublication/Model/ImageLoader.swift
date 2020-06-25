//
//  ImageLoader.swift
//  picturepublication
//
//  Created by Laure Compoint on 18/06/2020.
//  Copyright © 2020 Laure Compoint. All rights reserved.
//

import Foundation
import SDWebImage

class ImageLoader{
    func load(stringurl: String?, imageView: UIImageView){
        guard let stringurl = stringurl, let url = URL(string: stringurl) else{
          return
        }
        imageView.sd_setImage(with: url, completed: nil)
    }
}
