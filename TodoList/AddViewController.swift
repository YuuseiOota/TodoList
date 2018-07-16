//
//  AddViewController.swift
//  TodoList
//
//  Created by UxU on 2018/07/16.
//  Copyright © 2018 UxU. All rights reserved.
//

import UIKit
import RealmSwift

class AddViewController: UIViewController {
    @IBOutlet weak var addTextField: UITextField!
    
    var category = Category()
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //背景タップでキーボードを格納
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard(){
        // キーボードを閉じる
        view.endEditing(true)
    }
    
    @IBAction func addButton(_ sender: Any) {
        let allCategories = realm.objects(Category.self)
        if allCategories.count != 0 {
            category.id = allCategories.max(ofProperty: "id")! + 1
        }

        try! realm.write {
            self.category.name = addTextField.text!
            self.realm.add(self.category, update: true)
        }
    }
    
    //実装予定
    @IBAction func deleteButton(_ sender: Any) {
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
