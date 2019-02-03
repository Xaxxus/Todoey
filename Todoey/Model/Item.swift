//
//  Item.swift
//  Todoey
//
//  Created by Brent Mifsud on 2019-02-02.
//  Copyright © 2019 Brent Mifsud. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object{
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
