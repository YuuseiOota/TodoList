//
//  InputViewController.swift
//  TodoList
//
//  Created by UxU on 2018/07/16.
//  Copyright © 2018 UxU. All rights reserved.
//

import UIKit
import RealmSwift

class InputViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var priorityControl: UISegmentedControl!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var task = Task()
    let realm = try! Realm()
    let data = try! Realm().objects(Category.self).map{ $0.name }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //背景タップでキーボードを格納
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        titleTextField.text = task.title
        contentsTextView.text = task.contents
        priorityControl.selectedSegmentIndex = task.priority
        categoryTextField.text = task.category
        datePicker.date = task.date
        
        //pickerの設定
        let picker = UIPickerView()
        categoryTextField.inputView = picker
        //delegateの設定
        picker.delegate = self
        //dataSourceの設定
        picker.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func dismissKeyboard(){
        // キーボードを閉じる
        view.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        try! realm.write {
            self.task.title = self.titleTextField.text!
            self.task.contents = self.contentsTextView.text
            self.task.priority = self.priorityControl.selectedSegmentIndex
            self.task.category = self.categoryTextField.text!
            self.task.date = self.datePicker.date
            self.realm.add(self.task, update: true)
        }
        
        super.viewWillDisappear(animated)
    }
    
    //画面遷移の際に呼ばれるメソッド
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let addViewController:AddViewController = segue.destination as! AddViewController
        
        if segue.identifier == "Add" {
            let category = Category()
            
            let allCategories = realm.objects(Category.self)
            if allCategories.count != 0 {
                category.id = allCategories.max(ofProperty: "id")! + 1
            }
            addViewController.category = category
        }
    }
    
    //PickerViewの個数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //表示する行数。配列の個数を返している
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    //表示する値
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row] as? String
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
