//
//  Category.swift
//  TodoList
//
//  Created by UxU on 2018/07/16.
//  Copyright © 2018 UxU. All rights reserved.
//

import RealmSwift

class Category: Object {
    @objc dynamic var id = 0
    
    @objc dynamic var name = ""
    
    /**
     id をプライマリーキーとして設定
     */
    override static func primaryKey() -> String? {
        return "id"
    }
}
