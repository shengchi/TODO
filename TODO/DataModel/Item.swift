//
//  Data.swift
//  TODO
//
//  Created by sc on 2020/3/19.
//  Copyright © 2020 Zetech. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date? //用于保存item对象的创建时间
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
