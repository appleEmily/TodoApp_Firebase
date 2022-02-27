//
//  TodoListViewController.swift
//  TodoApp_firebase
//
//  Created by Emily Nozaki on 2022/02/27.
//

import UIKit
import Firebase
import FirebaseFirestore

class TodoListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var table: UITableView!
    
    var todoAll: Array<Any> = []
    var todoDictionary: Dictionary<String, Array<Any>>!
    var todoArray: Array<String> = []
    var detailArray: Array<String> = []
    var dueArray: Array<Timestamp> = []
    
    //firebase
    var userUid: String!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
        table.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Auth.auth().addStateDidChangeListener{ (auth, user) in
            
            guard let user = user else {
                
                
                return
            }
            self.userUid = user.uid
            
            let docRef = self.db.collection("users").document(self.userUid)
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    print("Document data: \(dataDescription)")
                    if let todoArray = document.get("todoAll.todo") {
                        self.todoArray = todoArray as! Array<String>
                    }
                    if let detailArray = document.get("todoAll.detail") {
                        self.detailArray = detailArray as! Array<String>
                    }
                    if let dueArray = document.get("todoAll.due") {
                        self.dueArray = dueArray as! Array<Timestamp>
                        print(self.dueArray[0].dateValue())
                    }
                        //画面が戻ってきた時に更新する
                        self.presentingViewController?.beginAppearanceTransition(true, animated: animated)
                        self.presentingViewController?.endAppearanceTransition()
                        self.table.reloadData()
                        
                        
                    } else {
                        print("Document does not exist")
                    }
                    
                }
            }
            
        }
        
        @IBAction func signOut(_ sender: Any) {
            do {
                try Auth.auth().signOut()
                self.dismiss(animated: true, completion: nil)
            } catch let error {
                print("エラー")
            }
        }
        
        
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            print("🦄")
            return todoArray.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            cell.textLabel?.text = todoArray[indexPath.row]
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            performSegue(withIdentifier: "toEdit", sender: nil)
            // セルの選択を解除
            table.deselectRow(at: indexPath, animated: true)
        }
        
        //削除機能
        func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            
            
            
            
            return true
        }
        
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                todoArray.remove(at: indexPath.row)
                detailArray.remove(at: indexPath.row)
                table.reloadData()
                //更新バージョンを保存
                db.collection("users").document(userUid).setData([
                    "todoAll.todo": todoArray,
                    "todoAll.detail": detailArray
                ]) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written!")
                    }
                }
            }
        }
        
    }
