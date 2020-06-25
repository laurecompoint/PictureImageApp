//
//  ProfileViewController.swift
//  picturepublication
//
//  Created by Laure Compoint on 11/06/2020.
//  Copyright © 2020 Laure Compoint. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    var postImage: UIImage?
    var user: User?
    var headerView: ProfilHeaderView?
    var phototype: Phototype?

    enum Phototype {
        case coverImageView, avatarImageView
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let uid = FireAuth().currentId else {
            dismiss(animated: true, completion: nil)
            return
        }
        FireDB().getUser(withUid: uid) { (error, user) in
            if let error = error {
                self.presentAlert(title: "error", message: error)
                return
            }
            guard let user = user else {
                self.dismiss(animated: true, completion: nil)
                return
            }
            self.user = user
            
            print("Utilisateur :", user.nickname)
            self.collectionView.reloadData()
        }
        // Do any additional setup after lading the view.
    }
   

    @IBAction func btnAdd(_ sender: Any) {
        
        presentActionSheet()
    }
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func updateNickname() {
        guard let uid = FireAuth().currentId else {
            dismiss(animated: true, completion: nil)
            return
        }
        let alertVC = UIAlertController(title: "Modifier votre pseudo", message: nil, preferredStyle: .alert)
        alertVC.addTextField { (textField) in
            textField.placeholder = "Tapez ici votre nouveau pseudo"
        }
        alertVC.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler: nil))
        alertVC.addAction(UIAlertAction(title: "Modifier", style: .default, handler: { (action) in
            if let nickname = alertVC.textFields?.first?.text {
                FireDB().updateUser(withUid: uid, data: ["nickname": nickname]) { (error) in
                    if let error = error {
                        self.presentAlert(title: "Erreur !", message: error)
                        return
                    }
                    self.headerView?.labeltext.text = nickname
                }
            }
        }))
        present(alertVC, animated: true, completion: nil)
    }

}
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Quitter la vue modale de l’Image Picker
        
        dismiss(animated: true, completion: nil)
        
        // Récupérer l’image fournie par l’UIImagePickerController
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            
            return
           
        }
        print("image", image)
       
        guard let uid = FireAuth().currentId else {
            dismiss(animated: true, completion: nil)
            return
        }
        self.postImage = image
        let ref = FireStorage().profileImageRef(uid: uid)
      
        FireStorage().sendImage(ref:  ref , image: image) { (error, url) in
            if let error = error {
                self.presentAlert(title: "error", message: error)
                return
            }
            guard let phototype = self.phototype else{
                return
            }
             var key: String
            switch phototype {
            case .coverImageView:
                key = "coverImageUrl"
            case .avatarImageView:
                key = "avatarImageUrl"
            }
            
           // mettre a jour propriété url image
            FireDB().updateUser(withUid: uid, data: [key: url], completion: { (error) in
                if let error = error {
                    self.presentAlert(title: "error", message: "message")
                    return
                }
            })
        }
        
    
    }
    
    func showImagePickerController(sourceType: UIImagePickerController.SourceType) {
        // Instanciation d’un UIImagePickerController
        let imagePickerController = UIImagePickerController()
        
        // Le ProfileViewController a précédemment adopté le protocole UIImagePickerControllerDelegate
        // Il peut donc être le délégué de l’UIImagePickerController
        imagePickerController.delegate = self
        
        // La fonction showImagePickerController() prend un UIImagePickerController.SourceType en argument
        // Cet argument permet au UIImagePickerController d’utiliser soit la galerie, soit la caméra
        imagePickerController.sourceType = sourceType
        
        // Afficher l’UIImagePickerController
        present(imagePickerController, animated: true, completion: nil)
    }
    func presentActionSheet() {
        // Créer du bouton "Choisir dans la galerie"
        let photoLibraryAction = UIAlertAction(title: "Choisir dans la galerie", style: .default) { (action) in
            // Appeler une fonction que nous devrons créer pour ouvrir la galerie d’iamges
            self.showImagePickerController(sourceType: .photoLibrary)
        }
        
        // Créer du bouton "Utiliser l’appareil photo"
        let cameraAction = UIAlertAction(title: "Utiliser l’appareil photo", style: .default) { (action) in
            // Appeler une fonction que nous devrons créer pour ouvrir l’appareil photo
            self.showImagePickerController(sourceType: .camera)
        }
        
        // Créer du bouton d’annulation
        let cancelAction = UIAlertAction(title: "Annuler", style: .cancel, handler: nil)
        
        // Créer de l’Action Sheet
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // Ajouter les trois boutons précédemment créés
        alert.addAction(photoLibraryAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        
        // Afficher de l’Action Sheeet
        self.present(alert, animated: true, completion: nil)
    }
}
extension ProfileViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return movies.count
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath)
        // let movie = movies[indexPath.row]
        // cell.textLabel?.text = movie.title
        print("test cell")
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerCell", for: indexPath) as? ProfilHeaderView
            else{
               return UICollectionReusableView()
        }
        
        guard let user = user else{
              print("test cellheader")
            return headerView
          
        }
        headerView.setUp(user: user, profilViewController: self)
        //return le bon header
        return headerView
       
}
}
//extension ProfileViewController: UICollectionViewDelegateFlowLayout {
//    // Dimension des cellule
//    // Régler l’attribut Estimate Size de la CollectionView à none pour que ça fonctionne
//    // - 2 correspond à la valeur 1 de Min Spacing for Cell dans les attributs de la CollectionView
//    // Min Spacing for Cell crée un espace de 1 entre chaque cellule
//    // Et il y a deux espaces sur une ligne de trois cellules
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: (collectionView.frame.width / 3) - 2, height: (collectionView.frame.width / 3) - 2)
//    }
//}
