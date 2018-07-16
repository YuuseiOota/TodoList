//
//  Task.swift
//  TodoList
//
//  Created by UxU on 2018/07/12.
//  Copyright © 2018年 UxU. All rights reserved.
//

import RealmSwift

class Task: Object {
    @objc dynamic var id = 0
    
    @objc dynamic var title = ""
    
    @objc dynamic var contents = ""
    
    @objc dynamic var date = Date()
    
    @objc dynamic var category = ""
    
    @objc dynamic var priority = ""
    
    /**
     id をプライマリーキーとして設定
     */
    override static func primaryKey() -> String? {
        return "id"
    }
}
