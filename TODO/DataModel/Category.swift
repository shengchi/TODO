//
//  Category.swift
//  TODO
//
//  Created by sc on 2020/3/21.
//  Copyright © 2020 Zetech. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name : String = ""
    @objc dynamic var colour : String = ""
    
    let items = List<Item>()
}
