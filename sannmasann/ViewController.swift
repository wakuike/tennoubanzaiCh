//
//  ViewController.swift
//  sannmasann
//
//  Created by 池内将真 on 2019/10/19.
//  Copyright © 2019 wakuike. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var nameInputView: UITextField!
    @IBOutlet weak var messageInputView: UITextField!
    @IBOutlet weak var inputViewBottomMargin: NSLayoutConstraint!
    
    var databaseRef: DatabaseReference!
   //どこで宣言すればいいの？

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        databaseRef = Database.database().reference()//インスタンスの獲得
        
        databaseRef.observe(.childAdded, with: { snapshot in if let obj = snapshot.value as? [String : AnyObject], let name = obj["name"] as? String, let message = obj["message"]{
            let currentText = self.textView.text
            self.textView.text = (currentText ?? "") + "\n\(name) : \(message)"
            //observeでイベントの監視，.childAddedでを指定することで子要素が追加された時にwithで与えた処理が実行されるようになる。データに追加があると自動で呼ばれるので，更新処理を実装する必要がない。
            }
            
        })
    
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
        
    }

    @IBAction func tappedSendButoon(_ sender: Any) {
        view.endEditing(true)
        
        if let name = nameInputView.text, let message = messageInputView.text {
            let messageData = ["name": name, "message": message]
            databaseRef.childByAutoId().setValue(messageData)
        
            messageInputView.text = ""
            
        }
    }
    @objc func keyboardWillShow(_ notification: NSNotification){
        if let userInfo = notification.userInfo, let keyboardFrameInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            inputViewBottomMargin.constant = keyboardFrameInfo.cgRectValue.height
            //キーボードが表示されるタイミングと非表示になるタイミングを監視してくれるもの。
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification){
        inputViewBottomMargin.constant = 0
        //上の塊によって呼び出されるメソッドにて入力域の末端の制約を動的に変更させる働き。
    }
    
}

