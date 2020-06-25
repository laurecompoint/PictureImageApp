//
//  ProfilHeaderView.swift
//  picturepublication
//
//  Created by Laure Compoint on 11/06/2020.
//  Copyright © 2020 Laure Compoint. All rights reserved.
//

import UIKit

class ProfilHeaderView: UICollectionReusableView {
        
    
    @IBOutlet weak var coverImageView: UIImageView!
    
    @IBOutlet weak var profilImageView: UIImageView!
    
    @IBOutlet weak var labeltext: UILabel!
    var user: User?
    var profilViewController: ProfileViewController?
   
  
    func setUp(user: User, profilViewController: ProfileViewController){
        self.user = user
         self.profilViewController = profilViewController
        labeltext.text = user.nickname
    
      
       ImageLoader().load(stringurl: user.avatarImageUrl, imageView: profilImageView)
         ImageLoader().load(stringurl: user.coverImageUrl, imageView: coverImageView)
        
    }
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            print("vide: ")
            return
        }
        
        switch touch.view {
        case coverImageView:
            print("cover image")
            //lancer action sheet
            profilViewController?.phototype = .coverImageView
            profilViewController?.presentActionSheet()
          
            
        case profilImageView:
            print("profil image")
            profilViewController?.phototype = .avatarImageView
            profilViewController?.presentActionSheet()
        case labeltext:
            print("nickname")
            profilViewController?.updateNickname()
        default:
            print("default")
        }
    }
    
}
