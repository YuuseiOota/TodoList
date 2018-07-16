//
//  ViewController.swift
//  TodoList
//
//  Created by UxU on 2018/07/12.
//  Copyright © 2018年 UxU. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    //Realmのインスタンスを設定
    let realm = try! Realm()
    //DB内でタスクが格納されるリスト
    var taskArray = try! Realm().objects(Task.self).sorted(byKeyPath: "date", ascending: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: "TaskTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "CustomCell")
        
        //cellの高さを自動で調整する
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight += 100
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // データの数（＝セルの数）を返すメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
    }
    
    // 各セルの内容を返すメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 再利用可能な cell を得る
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! TaskTableViewCell
        
        // Cellに値を設定する.
        let task = taskArray[indexPath.row]
        cell.titleLabel.text = task.title
        
        cell.categoryLabel.text = task.category
        
        let priority = task.priority
        switch priority {
        case 0:
            cell.priorityLabel.text = "High"
            cell.priorityLabel.backgroundColor = UIColor.red
            cell.priorityLabel.layer.cornerRadius = 3
            cell.priorityLabel.clipsToBounds = true
        case 1:
            cell.priorityLabel.text = "Normal"
            cell.priorityLabel.backgroundColor = UIColor.green
            cell.priorityLabel.layer.cornerRadius = 3
            cell.priorityLabel.clipsToBounds = true
        default:
            cell.priorityLabel.text = "Low"
            cell.priorityLabel.backgroundColor = UIColor.blue
            cell.priorityLabel.layer.cornerRadius = 3
            cell.priorityLabel.clipsToBounds = true
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd HH:mm"
        let dateString:String = formatter.string(from: task.date)
        cell.dateLabel.text = dateString
        
        return cell
    }
    
    // セルが削除が可能なことを伝えるメソッド
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath)-> UITableViewCellEditingStyle {
        return .delete
    }
    
    // Delete ボタンが押された時に呼ばれるメソッド
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // データベースから削除する
            try! realm.write {
                self.realm.delete(self.taskArray[indexPath.row])
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
    // 各セルを選択した時に実行されるメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "cellSegue",sender: nil)
    }
    
    //画面遷移の際に呼ばれるメソッド
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let inputViewController:InputViewController = segue.destination as! InputViewController
        
        if segue.identifier == "cellSegue" {
            let indexPath = self.tableView.indexPathForSelectedRow
            inputViewController.task = taskArray[indexPath!.row]
        } else {
            let task = Task()
            task.date = Date()
            
            let allTasks = realm.objects(Task.self)
            if allTasks.count != 0 {
                task.id = allTasks.max(ofProperty: "id")! + 1
            }
            inputViewController.task = task
        }
    }
    
    // 入力画面から戻ってきた時に TableView を更新させる
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }


}
