//
//  SignUpViewController.swift
//  TodoApp_firebase
//
//  Created by Emily Nozaki on 2022/02/27.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!

    var auth: Auth?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        auth = Auth.auth()
        
        email.delegate = self
        password.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func createAcount(_ sender: Any) {
        Auth.auth().createUser(withEmail: email.text!, password: password.text!, completion: { (result, error) in
            if let user = result?.user {
                print("ユーザー作成完了 uid:" + user.uid)
                self.performSegue(withIdentifier: "todoList", sender: nil)
            } else if let error = error {
                print("Firebase Auth 新規登録失敗 " + error.localizedDescription)
                let dialog = UIAlertController(title: "新規登録失敗", message: error.localizedDescription, preferredStyle: .alert)
                dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(dialog, animated: true, completion: nil)
            }
        })
    }
    
}
