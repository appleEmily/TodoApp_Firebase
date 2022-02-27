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
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var goNext: UIButton!
    
    @IBOutlet weak var switchText: UILabel!
    
    @IBOutlet weak var switchButton: UIButton!
    
    var acount: Bool = true
    //trueがアカウントなし
    var auth: Auth?
    
    var stateLogin:Bool = false
    
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
    func switchMode() {
        if acount == true {
            titleLabel.text = "Sign Up"
            switchText.text = "you already have an account?"
            goNext.setTitle("Create an acount →", for: .normal)
            switchButton.setTitle("login→", for: .normal)
        } else {
            titleLabel.text = "login"
            switchText.text = "Create a new Account?"
            goNext.setTitle("login→", for: .normal)
            switchButton.setTitle("Create an acount →", for: .normal)
        }
    }
    @IBAction func login(_ sender: Any) {
        if acount == true {
            acount = false
        } else {
            acount = true
        }
        switchMode()
        
    }
    
    @IBAction func createAcount(_ sender: Any) {
        if acount == true {
            Auth.auth().createUser(withEmail: email.text!, password: password.text!, completion: { (result, error) in
                if let user = result?.user {
                    print("ユーザー作成完了 uid:" + user.uid)
                    self.performSegue(withIdentifier: "todoList", sender: nil)
                } else if let error = error {
                    print("Firebase Auth 新規登録失敗 " + error.localizedDescription)
                    let dialog = UIAlertController(title: "新規登録失敗", message: error.localizedDescription, preferredStyle: .alert)
                    dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(dialog, animated: true)
                }
            })
        } else if acount == false {
            Auth.auth().signIn(withEmail: email.text!, password: password.text!) { [weak self] result, error in
                guard let self = self else { return }
                if let user = result?.user {
                    self.performSegue(withIdentifier: "todoList", sender: nil)
                }
//                self.showErrorIfNeeded(error)
            }
            
        }
        
    }
}
