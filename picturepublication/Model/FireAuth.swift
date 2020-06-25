//
//  File.swift
//  picturepublication
//
//  Created by Laure Compoint on 29/05/2020.
//  Copyright © 2020 Laure Compoint. All rights reserved.
//

import Foundation
import Firebase

class FireAuth{
    let auth = Auth.auth()
    var currentId: String? {
        return auth.currentUser?.uid
    }
    func signIn(email: String, password: String, completion: @escaping (_ error: String?,_ uid: String?) -> Void) {
        // Se connecter
        auth.signIn(withEmail: email, password: password) { (data, error) in
            if let error = error {
                completion(error.localizedDescription, nil)
            }
            if let uid = data?.user.uid {
                completion(nil, uid)
            }
        }
    }
    func signUp(email: String, password: String, nickname: String, completion: @escaping (_ error: String?, _ uid: String?) -> Void) {
        auth.createUser(withEmail: email, password: password) { (data, error) in
            if let error = error {
                completion(error.localizedDescription, nil )
            }
            if let uid = data?.user.uid{
                completion(nil, uid)
            }
            
        }
    }
    func signOut() -> String? {
        do {
            try auth.signOut()
            return nil
        } catch {
            return error.localizedDescription
        }
    }
}
