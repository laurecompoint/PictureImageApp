//
//  FireStorage.swift
//  picturepublication
//
//  Created by Laure Compoint on 18/06/2020.
//  Copyright © 2020 Laure Compoint. All rights reserved.
//

import Foundation
import Firebase
class FireStorage {
    let baseRef = Storage.storage().reference()
//    func userCover(uid: String) => storage().reference() {
//        return
//    }
    func profileImageRef(uid: String) -> StorageReference {
        return baseRef.child(uid).child("profileImage.jpg")
    }
    func sendImage(ref: StorageReference, image: UIImage, completion: @escaping (_ error: String?, _ urlString: String?) -> Void) {
        // Conversion de l’image en Jpeg, qualité 30
        guard let data = image.jpegData(compressionQuality: 0.3) else { return }
        // Envoi de l’image
        ref.putData(data, metadata: nil) { (meta, error) in
            if let error = error {
                completion(error.localizedDescription, nil)
                return
            }
            guard meta != nil else { return }
            
            // Récupération de l’URL de l’image sur le Google Cloud
            ref.downloadURL { (url, error) in
                if let error = error {
                    completion(error.localizedDescription, nil)
                    return
                }
                guard let url = url else {
                    completion("Une erreur est survenue pendant l’enregistrement de l’image", nil)
                    return
                }
                completion(nil, url.absoluteString)
            }
        }
    }
}
