//
//  AuthViewController.swift
//  picturepublication
//
//  Created by Laure Compoint on 29/05/2020.
//  Copyright © 2020 Laure Compoint. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {

    
    
    @IBOutlet weak var SegmentedControl: UISegmentedControl!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var nicknameTF: UITextField!
    @IBOutlet weak var validateBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Observation de l’état d’authentification de l’utilisateur
        FireAuth().auth.addStateDidChangeListener { (auth, user) in
            if user != nil {
                self.performSegue(withIdentifier: "segueToMain", sender: nil)
                self.emailTF.text = ""
                self.passwordTF.text = ""
                self.nicknameTF.text = ""
                self.SegmentedControl.selectedSegmentIndex = 0
                
            }
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func unwindToAuth(segue: UIStoryboardSegue){
       
        if let error = FireAuth().signOut() {
            let alertVC = UIAlertController(title: "Erreur !", message: error, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "J’ai compris", style: .default, handler: nil))
            present(alertVC, animated: true, completion: nil)
            return
        }
       
    }
    @IBAction func ButtonEyesPassword(_ sender: Any) {
        self.passwordTF.isSecureTextEntry = self.passwordTF.isSecureTextEntry ? false : true
    }
    
    @IBAction func segmentedChanged(_ sender: Any) {
        setupUI()
        
    }
    
    @IBAction func validateBtnDidPressed(_ sender: Any) {
        guard let email = emailTF.text, email != "" else {
            presentAlert(title: "Attention !", message: "Vous n’avez pas renseigné d’e-mail !")
            return
        }
        guard let password = passwordTF.text, password != "" else {
            presentAlert(title: "Attention !", message: "Vous n’avez pas renseigné de mot de passe !")
            return
        }
        if SegmentedControl.selectedSegmentIndex == 0 {
            // Connexion
            FireAuth().signIn(email: email, password: password) { (error, uid) in
                if let error = error {
                    self.presentAlert(title: "Erreur", message: error)
                }
            }
        } else {
            guard let nickname = nicknameTF.text, nickname != "" else {
                presentAlert(title: "Attention !", message: "Vous n’avez pas renseigné de mot de passe !")
                return
            }
            // Inscription
            FireAuth().signUp(email: email, password: password, nickname: nickname) { (error, uid ) in
                if let error = error {
                   self.presentAlert(title: "Erreur !", message: error)
                }
                if let uid = uid {
                    // Créer la collection Credentials(mdp + pseudo) de l'utilisateur dans la DB
                    let data: [String: Any] = ["uid" : uid, "nickname" : nickname]
                    FireDB().addUser(uid, data: data)
                    
                }
                
            }
        }
    }
    private func setupUI() {
        let isConnexionSegment = SegmentedControl.selectedSegmentIndex == 0
        let title = isConnexionSegment ? "Se connecter" : "S’inscrire"
        validateBtn.setTitle(title, for: .normal)
        nicknameTF.isHidden = isConnexionSegment
    }
//    private func presentAlert(title: String, message: String) {
//        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        alertVC.addAction(UIAlertAction(title: "J’ai compris", style: .default, handler: nil))
//        present(alertVC, animated: true, completion: nil)
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
