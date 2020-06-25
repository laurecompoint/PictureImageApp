//
//  FireDB.swift
//  PasswordBackUp
//
//  Created by Laure Compoint on 14/05/2020.
//  Copyright © 2020 Laure Compoint. All rights reserved.
//

import Foundation
import Firebase

class FireDB {
    var data = [String: Any]()
    let store = Firestore.firestore()
    var users: CollectionReference {
        return store.collection("users")
    }
    var credit: CollectionReference {
        return store.collection("credentials")
    }
    func addUser(_ uid: String, data: [String: Any]){
        users.document(uid).setData(data)
    }
    func getUser(withUid uid: String, completion: @escaping (String?, User?) -> Void) {
        users.document(uid).addSnapshotListener { (document, error) in
            if let error = error {
                completion(error.localizedDescription, nil)
                return
            }
            guard document != nil else {
                completion("Utilisateur non trouvé", nil)
                return
            }
            completion(nil, User(document: document!))
        }
    }
    func addCredentials( data: [String : Any], completion: @escaping (_ error: String?) -> Void){
        
        guard let uid = FireAuth().currentId else {
            completion("Error: vous n'etez pas authentifié")
            return
        }
        users.document(uid).collection("credentialscollection").document().setData(data) { (error) in
            if let error = error {
                completion(error.localizedDescription)
                return
            }
            completion(nil)
        }
        
        
    }
    func updateUser(withUid uid: String, data: [String:Any], completion: @escaping (String? ) -> Void){
        users.document(uid).updateData(data) { (error) in
            if let error = error {
                completion(error.localizedDescription)
                return
            }
            completion(nil)
        }
        
    }
    
    
}
