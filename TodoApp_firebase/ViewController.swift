//
//  ViewController.swift
//  TodoApp_firebase
//
//  Created by Emily Nozaki on 2022/02/21.
//

import UIKit
import Firebase
import FirebaseFirestore


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    
    var todoAll: Array<Any> = []
    var todoDictionary: Dictionary<String, Array<Any>>!
    var todoArray: Array<String> = []
    var detailArray: Array<String> = []
    var dueArray: Array<Date> = []
    
    //firebase
    var userUid: String!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
        table.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //firebaseから最新の保存データを取得
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
                    self.todoArray = document.get("todoAll.todo") as! Array<String>
                    self.detailArray = document.get("todoAll.detail") as! Array<String>
                    //                    if let dueArray = document.get("todoAll.due") {
                    //                        self.dueArray = dueArray as! Array<Date>
                    //
                    
                    print(self.todoArray)
                    
                    
                } else {
                    print("Document does not exist")
                }
                
            }
        }
        //画面が戻ってきた時に更新する
        self.presentingViewController?.beginAppearanceTransition(true, animated: animated)
        self.presentingViewController?.endAppearanceTransition()
        self.table.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = "こんんひ"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toEdit", sender: nil)
        // セルの選択を解除
        table.deselectRow(at: indexPath, animated: true)
    }
    
    //削除機能
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        table.reloadData()
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //配列から削除
            
        }
    }
    
    
}

