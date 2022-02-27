//
//  AddTodoViewController.swift
//  TodoApp_firebase
//
//  Created by Emily Nozaki on 2022/02/21.
//

import UIKit
import FirebaseFirestore
import Firebase

class AddTodoViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate {
    
    
    @IBOutlet weak var todoText: UITextField!
    
    @IBOutlet weak var detail: UITextView!
    
    @IBOutlet weak var duePicker: UIDatePicker!
    
    @IBOutlet weak var addButton: UIButton!
    
    //配列
    var todoArray: Array<String> = []
    var detailArray: Array<String> = []
    var dueArray: Array<Any> = []
    //全部をまとめるためのdictionary
    var todoDictionary: Dictionary<String, Array<Any>> = [:]
    
    //日付
    let date:Date = Date()
    
    //firebase周り
    var userUid: String!
    
    let db = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        todoText.delegate = self
        detail.delegate = self
        
        todoDictionary = ["todo": todoArray, "detail": detailArray, "due": dueArray]
        
        //pickerViewの設定
        duePicker.datePickerMode = .date
        
        addButton.layer.cornerRadius = 5
        
        //すでに保存されているものをとってくる
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
                    if let dueTimestamp = document.get("todoAll.due") {
                        
                        self.dueArray = dueTimestamp as! Array<Timestamp>
                    }
                    
                } else {
                    print("Document does not exist")
                }
                
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Auth.auth().addStateDidChangeListener{ (auth, user) in
            
            guard let user = user else {
                
                
                return
            }
            
            self.userUid = user.uid
            print(self.userUid!)
            
        }
        
    }
    
    //配列をdictionaryにセットして、保存する
    //firebaseに保存していたら、保存している最新を取ってくる。配列をdictionaryに突っ込む。その後保存する。かな
    func save() {
        
        todoDictionary = ["todo": todoArray, "detail": detailArray, "due": dueArray]
    }
    
    //returnキーでキーボード閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //todoのみ
        todoText.resignFirstResponder()
        return true
    }
    //画面以外をタップ
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
        self.detail.resignFirstResponder()
    }
    
    //pickerViewについて
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    @IBAction func addTodo(_ sender: Any) {
        todoArray.append(todoText.text!)
        detailArray.append(detail.text!)
        dueArray.append(duePicker.date)
        save()
        print(todoDictionary)
        //firebaseに保存する
        db.collection("users").document(userUid).setData([
            "todoAll": todoDictionary
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    
}
